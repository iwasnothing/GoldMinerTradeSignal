
using GoldMinerTradeSignal
function main()

    parmfile = "https://iwasnothing.github.io/GoldMinerTradeSignal/GDX_parm.csv"
    
    msg = formatMsg(getSignal(parmfile))
    @show msg
    open("signal.html", "w") do io
        write(io, "<H1>" * msg)
    end;
end

main()

