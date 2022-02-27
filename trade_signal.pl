
using GoldMinerTradeSignal

parmfile = "https://iwasnothing.github.io/GoldMinerTradeSignal/GDX_parm.csv"

m = formatMsg(getSignal(parmfile))


open("results.html", "w") do io
    write(io, m)
end

ENV["RESULTS"] = m
ENV["RESULTS_FILE"] = "results.html"


