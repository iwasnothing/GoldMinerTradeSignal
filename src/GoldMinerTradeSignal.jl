__precompile__()
module GoldMinerTradeSignal
using MarketData
using DataFrames
using TimeSeries
using Dates
using HTTP
using JSON
using CSV

function PriceToReturn(ta::TimeArray)
    cl = ta[:,:Close]
    return TimeSeries.rename(percentchange(cl),[:Return])
end
function buy_signal_proxy(x1,x2,c)
    #if x1 <= x2 - c && x1 < 0
    if x1 <= x2 - c 
        return 1
    else
        return 0
    end
end
function sell_signal_proxy(x1,x2,c)
    #if x1 >= x2 + c  && x1 > 0
    if x1 >= x2 + c 
        return 1
    else
        return 0
    end
end



function getSignal(parmfile)
    parms_df = DataFrame(CSV.File(parmfile))
    s1 = parms_df[1,1]
    s2 = parms_df[1,2]
    s3 = parms_df[1,3]
    a = parms_df[1,4]
    b1 = parms_df[1,5]
    b2 = parms_df[1,6]
    std_mnr = parms_df[1,7]


    t = Dates.now()
    yopt = YahooOpt(period1 = t - Day(2), period2 = t)
    gld = yahoo(s1,yopt)
    sp100 = yahoo(s2,yopt)
    miner = yahoo(s3,yopt)

    Rmnr = PriceToReturn(miner)
    Rmkt = PriceToReturn(sp100)
    Rgld = PriceToReturn(gld)

    data = TimeSeries.rename(TimeSeries.merge(TimeSeries.merge(Rmnr,Rmkt),Rgld), 
        [:Rmnr,:Rmkt,:Rgld])

    n,_ = size(miner)
    @show miner
    @show values(miner[n][:Close])
    buy_price = values(miner[n][:Close])[1]

    df = DataFrame(data)
    transform!(df, :, [:Rmkt,:Rgld] => (r1,r2) -> a .+ b1*(r1)+b2*(r2) )
    DataFrames.rename!(df,:Rmkt_Rgld_function => :proxy)
    transform!(df, :, [:Rmnr,:proxy] => (x1,x2) -> float(buy_signal_proxy.(x1,x2,std_mnr)) )
    DataFrames.rename!(df,:Rmnr_proxy_function => :buy_signal_proxy)
    transform!(df, :, [:Rmnr,:proxy] => (x1,x2) -> float(sell_signal_proxy.(x1,x2,std_mnr)) )
    DataFrames.rename!(df,:Rmnr_proxy_function => :sell_signal_proxy)

    if df[1,:buy_signal_proxy] == 1.0 && df[1,:sell_signal_proxy] == 0.0
        signal = "BUY"
    elseif df[1,:buy_signal_proxy] == 0.0 && df[1,:sell_signal_proxy] == 1.0
        signal = "SELL"
    else
        signal = "NONE"
    end
    return Dict("asset"=>s3,"signal"=>signal,"last_price"=>buy_price)
end

function formatMsg(s)
    return "<H1>Asset: "*s["asset"]*", Action: "*s["signal"]*", order price: "*string(s["last_price"])
end

export getSignal,formatMsg

end # module
Base.compilecache("GoldMinerTradeSignal")