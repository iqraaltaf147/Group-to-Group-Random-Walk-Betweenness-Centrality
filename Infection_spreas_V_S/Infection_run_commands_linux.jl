###indicates change value according to graph###
#Compile scripts
include("/home/cse/phd/csz158491/Centrality/Infection_spread/repeat.jl")

#Load graph
M = loadgraph("/home/cse/phd/csz158491/Centrality/Data_sets/routers.gml",GraphIO.GML.GMLFormat())###change graph file i.e., karate.gml###
#M = loadgraph("/home/iqraaltaf/Documents/Julia_dB/Data_sets/airlines.graphml",GraphIO.GraphML.GraphMLFormat())
#Generate infected set
using StatsBase;
S=StatsBase.sample(1:length(vertices(M)), 4593, replace=false);### Change proteceted set size i.e., 10 ###
CSV.write("SIR.csv",DataFrame(S'), append=true)
@time s1=Lsolve(M,length(vertices(M)),vertices(M),S,zeros(length(vertices(M))))
@time s2= betweenness_centrality_s(1,M,S)
@time s3= betweenness_centrality_s(2,M,S)
@time s4=removesrc_vert((pagerank(M)),S)
#Compute functions. Repeat experiments 1000 times.
#compute_met(1000,M,S,s1,s2,s3,s4,0.6,0.6,2,[494,988,1482,1976,2471,2965])#IC model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]###
#savefig("Plot_IC.pdf")
@time compute_met(1000,M,S,s1,s2,s3,s4,0.6,0.6,1,[494,988,1482,1976,2471,2965])#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]###
savefig("Plot_SIR.pdf")
