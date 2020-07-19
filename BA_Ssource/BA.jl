###indicates change value according to graph###
#Compile scripts
using EzXML
include("/home/iqraaltaf/Documents/Julia_dB/Barabasi-Albert/repeat_ba.jl")

#Load graph
M= barabasi_albert(50,8,3, complete=true, seed=-1) # Generate a Barabasi-ALbert graph with 50 nodes and 125 edges
#Generate infected set
using StatsBase;
a=StatsBase.sample(1:length(vertices(M)), 10, replace=false);#Generate random set ### Change set size i.e., x ###
CSV.write("SIR.csv",DataFrame(a'), append=true)
b=topk(reverse(sortperm(degree_centrality(M))),10) #Top k degree
CSV.write("SIR.csv",DataFrame(b), append=true)
c=topk(sortperm(degree_centrality(M)),10) #Least k degree
CSV.write("SIR.csv",DataFrame(c), append=true)
d=topk(reverse(sortperm(pagerank(M))),10) #top k PageRank
CSV.write("SIR.csv",DataFrame(d), append=true)
no=rand(1:length(vertices(M)))
f=self_avoiding_walk(M,no,10) #k-sized connected component from max.degree node
CSV.write("SIR.csv",DataFrame(f'), append=true)

@time s1=Lsolve(M,length(vertices(M)),vertices(M),a,zeros(length(vertices(M))))
@time s2=Lsolve(M,length(vertices(M)),vertices(M),b,zeros(length(vertices(M))))
@time s3=Lsolve(M,length(vertices(M)),vertices(M),c,zeros(length(vertices(M))))
@time s4=Lsolve(M,length(vertices(M)),vertices(M),d,zeros(length(vertices(M))))
@time s5=Lsolve(M,length(vertices(M)),vertices(M),f,zeros(length(vertices(M))))

#Compute functions. Repeat experiments 1000 times.
compute_met(1000,M,a,b,c,d,f,s1,s2,s3,s4,s5,0.6,0.6,1,[5,10,15,20,25,30])#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]###
savefig("Plot_SIR.pdf")
compute_met(1000,M,a,b,c,d,f,s1,s2,s3,s4,s5,0.6,0.6,2,[5,10,15,20,25,30])#IC model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]###
savefig("Plot_IC.pdf")
