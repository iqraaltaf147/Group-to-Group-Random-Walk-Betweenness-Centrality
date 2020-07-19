#In this we consider the infection control scenario where we have a randomly chosen source group and a randomly chosen target group. We need to find influential nodes using our proposed metric and other baselines such that given group is protected. We plot the timetaken to infect the protecetd group vs. the vaccinate dset size. Higher the time, better is the metric
###indicates change value according to graph###
#Compile scripts
using EzXML
include("/home/cse/phd/csz158491/Centrality/Infection_group_protection/Source_vary/repeat_source.jl")

#function to choose n random elements from an array
choose(a,n)=a[randperm(end)][1:n]

function choose_t(arr,S,k)
x=setdiff(arr,S)#remove source set
s=[]
flag=0
for i=1:k
	if flag==0
		s=[s' x[i]]
		flag=1
	else
		s=[s x[i]]
	end
end
return s
end
#Load graph
M = loadgraph("/home/cse/phd/csz158491/Centrality/Data_sets/karate.gml",GraphIO.GML.GMLFormat())###change graph file i.e., karate.gml###
#M = loadgraph("/home/cse/phd/csz158491/Centrality/Data_sets/lesmiserables.gml",GraphIO.GML.GMLFormat())
#M = loadgraph("/home/cse/phd/csz158491/Centrality/Data_sets/dolphins.gml",GraphIO.GML.GMLFormat())
#M = loadgraph("/home/cse/phd/csz158491/Centrality/Data_sets/football.gml",GraphIO.GML.GMLFormat())
#Generate infected set
using StatsBase;
###Random selection of source and target set
#Arr=StatsBase.sample(1:length(vertices(M)), 14, replace=false);#Generate a random array of numbers 20% of total nodes for infected set + 20% of total nodes for protected group
#S=Arr[1:7] ### Infected set size i.e., 10 ### Source or infected group
#CSV.write("SIR_p.csv",DataFrame(S'), append=true)
#P=Arr[8:14];### Protected set size i.e., 10 ### Target or protected group
#CSV.write("SIR_p.csv",DataFrame(P'), append=true)
###Selection of target set based on Pagerank
#pr=reverse(sortperm(pagerank(M)))
#target=choose(pr,17)#Choose top 50% of nodes as target vulnerability
#P=choose(target,7) #choose protected set to be 20% of total nodes randomly from target set (top 50% PR nodes)
#S=choose(setdiff(vertices(M),P),7)#Choose random source set from the remaining nodes

###Karate.gml
comb_S=[4,23,17,5,22,28,27,26,32,24,7,31,34,10]#Chosen randomly
s44=[34,1,33,3,32,2,24,7,4,28,26,6,5,31,30,17,9,14,25,27,23,10,22,11,8,29,20,15,16,19,21,13,18,12]
target=choose_t(s44,comb_S,17)#choose top 50% nodes
P=choose(target,7)
CSV.write("SIR_p.csv",DataFrame(P'), append=true)
#x=[4,7,10,14]
x=[2,3,5,7]
#Compute functions. Repeat experiments 1000 times.
compute_met_P(1000,M,comb_S,P,0.6,0.6,x,10)#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]### vary 10 - 60% of total nodes

###Lesmiserables
#comb_S=[26,7,6,20,71,52,3,14,12,65,37,56,46,62,53,50,28,34,27,38,74,70,10,72,15,59,1,13,41,51,36]#Chosen randomly
#s44=[12,1,26,56,28,49,59,71,70,24,52,65,50,25,72,27,36,37,38,62,69,42,30,3,63,64,66,35,39,58,29,60,20,4,76,67,6,7,10,61,53,17,51,74,13,55,46,77,40,14,15,41,18,19,21,22,23,32,44,73,2,5,8,9,75,45,43,57,34,54,31,11,16,33,48,68,47]
#target=choose_t(s44,comb_S,39)#choose top 50% nodes
#P=choose(target,15)
#CSV.write("SIR_p.csv",DataFrame(P'), append=true)
#x=[8,15,23,31]
#Compute functions. Repeat experiments 1000 times.
#compute_met_P(1000,M,comb_S,P,0.6,0.6,x,23)#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]### vary 10 - 60% of total nodes
###Dolphins
#comb_S=[50,4,18,27,45,3,32,49,13,23,21,6,10,26,59,20,39,5,16,34,2,43,24,22,44]#Chosen randomly
#s44=[18,34,39,2,58,15,21,10,52,38,14,44,46,28,55,43,26,16,22,30,45,27,7,6,41,37,3,51,20,35,17,19,42,9,8,48,1,31,50,24,4,25,29,11,60,23,32,59,53,13,49,5,47,62,33,57,54,40,56,12,61,36]
#target=choose_t(s44,comb_S,31)#choose top 50% nodes
#P=choose(target,12)
#CSV.write("SIR_p.csv",DataFrame(P'), append=true)
#x=[6,12,19,25]
#Compute functions. Repeat experiments 1000 times.
#compute_met_P(1000,M,comb_S,P,0.6,0.6,x,19)#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]### vary 10 - 60% of total nodes
###Football
#comb_S=[78,27,91,53,13,89,102,16,4,34,32,50,108,19,69,24,113,105,9,36,101,82,5,8,42,75,2,37,38,43,63,94,14,21,45,112,76,90,10,33,26,92,64,68,41,56]#Chosen randomly
#x=[12,23,35,46]
#Compute functions. Repeat experiments 1000 times.
#compute_met_P(1000,M,comb_S,0.6,0.6,x,35)#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]### vary 10 - 60% of total nodes



