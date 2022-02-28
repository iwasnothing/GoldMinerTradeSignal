
push!(LOAD_PATH, abspath(normpath(joinpath(@__DIR__, "../src/"))))
using GoldMinerTradeSignal

parmfile = "https://iwasnothing.github.io/GoldMinerTradeSignal/GDX_parm.csv"
@show parmfile
m1 = formatMsg(getSignal(parmfile))
parmfile = "https://iwasnothing.github.io/GoldMinerTradeSignal/NVDA_parm.csv"
@show parmfile
m2 = formatMsg(getSignal(parmfile))

open("results.html", "w") do io
    write(io, m1)
    write(io, m2)
end

ENV["RESULTS"] = m
ENV["RESULTS_FILE"] = "results.html"


