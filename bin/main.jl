
push!(LOAD_PATH, abspath(normpath(joinpath(@__DIR__, "../src/"))))
using GoldMinerTradeSignal

parmfile = "https://iwasnothing.github.io/GoldMinerTradeSignal/GDX_parm.csv"
@show parmfile
m1 = formatMsg(getSignal(parmfile))
parmfile = "https://iwasnothing.github.io/GoldMinerTradeSignal/NVDA_parm.csv"
@show parmfile
m2 = formatMsg(getSignal(parmfile))
msg = m1*m2
@show msg
open("results.html", "w") do io
    write(io, msg)
end

commitcmd = `git commit -am "new result"`
run(commitcmd)
pushcmd = `git push origin master`
run(pushcmd)
