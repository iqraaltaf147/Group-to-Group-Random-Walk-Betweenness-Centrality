###indicates change value according to graph###
#Compile scripts
using EzXML
include("/home/cse/phd/csz158491/Centrality/Different_graph_types/repeat_diff_g.jl")

#Load graph
M= barabasi_albert(50,8,3, complete=true, seed=-1) # Generate a Barabasi-ALbert graph with 50 nodes and 125 edges
N=watts_strogatz(50,5,0.2)
O=erdos_renyi(50,0.3)
#Generate infected set
using StatsBase;
S=StatsBase.sample(1:length(vertices(M)), 10, replace=false);#Generate random set ### Change set size i.e., x ###
CSV.write("SIR.csv",DataFrame(S'), append=true)

@time s1=Lsolve(M,length(vertices(M)),vertices(M),S,zeros(length(vertices(M))))
@time s2=Lsolve(N,length(vertices(N)),vertices(N),S,zeros(length(vertices(N))))
@time s3=Lsolve(O,length(vertices(O)),vertices(O),S,zeros(length(vertices(O))))

#Compute functions. Repeat experiments 1000 times.
compute_met(1000,M,N,O,S,s1,s2,s3,0.6,0.6,1,[5,10,15,20,25,30])#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]###
savefig("Plot_SIR.pdf")

