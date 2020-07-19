#In this we consider the infection control scenario where we have a randomly chosen source group and a randomly chosen target group. We need to find influential nodes using our proposed metric and other baselines such that given group is protected. We plot the timetaken to infect the protecetd group vs. the vaccinate dset size. Higher the time, better is the metric
###indicates change value according to graph###
#Compile scripts
using EzXML
include("/home/cse/phd/csz158491/Centrality/Infection_group_protection/Target_vary/repeat_target.jl")

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
#M = loadgraph("/home/cse/phd/csz158491/Centrality/Data_sets/karate.gml",GraphIO.GML.GMLFormat())###change graph file i.e., karate.gml###
M = loadgraph("/home/cse/phd/csz158491/Centrality/Data_sets/lesmiserables.gml",GraphIO.GML.GMLFormat())
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
#S=[ 9, 24, 30,  8,  7, 16, 19]
#S=[ 9, 24]
#CSV.write("SIR_p.csv",DataFrame(S'), append=true)
#s4=[34,33,1,24,3,30,9,7,2,8,16,19,32,4,31,28,6,14,26,27,5,29,25,20,17,11,15,21,23,10,13,18,22,12]
#target=choose_t(s4,S,17)#choose top 50% nodes
#x=[2,4,5,7,8,10]
#Compute functions. Repeat experiments 1000 times.
#@time compute_met_P(1000,M,S,s4,0.6,0.6,x,10)#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]### vary 10 - 60% of total nodes
###Lesmiserables
#S=[ 26,7,6,20,71,52,3,14,12,65,37,56,46,62,53]
S=[ 26,7,6,20]
CSV.write("SIR_p.csv",DataFrame(S'), append=true)
s4=[12,1,56,26,52,49,65,28,71,62,3,37,59,24,27,29,20,53,63,25,6,7,42,64,66,69,70,46,30,58,60,50,72,4,14,67,17,35,36,38,39,61,40,76,18,19,21,22,23,55,77,45,32,2,5,8,9,10,44,73,43,54,34,57,13,51,31,11,15,16,33,74,75,41,48,68,47]
target=choose_t(s4,S,39)#choose top 50% nodes
x=[4,8,11,15,19,23]
#Compute functions. Repeat experiments 1000 times.
compute_met_P(1000,M,S,s4,0.6,0.6,x,23)#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]### vary 10 - 60% of total nodes
###Dolphins
#S=[50,4,18,27,45,3,32,49,13,23,21,6]
#S=[50,4,18]
#CSV.write("SIR_p.csv",DataFrame(S'), append=true)
#s4=[18,58,21,14,34,10,2,6,45,15,27,7,3,28,38,55,50,35,39,23,32,4,26,42,49,44,13,9,37,46,41,43,51,17,48,8,29,30,60,11,52,47,1,19,31,57,20,33,16,62,22,25,53,40,54,24,61,59,56,36,5,12]
#target=choose_t(s4,S,31)#choose top 50% nodes
#x=[3,6,9,12,15,19]
#Compute functions. Repeat experiments 1000 times.
#compute_met_P(1000,M,S,s4,0.6,0.6,x,19)#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]### vary 10 - 60% of total nodes
###Football
#S=[78,27,91,53,13,89,102,16,4,34,32,50,108,19,69,24,113,105,9,36,101,82,5]
#CSV.write("SIR_p.csv",DataFrame(S'), append=true)
#s4=[4,24,9,105,82,5,69,89,78,53,108,16,19,32,50,27,13,91,36,101,102,113,6,34,1,73,85,41,8,79,52,10,68,23,99,112,17,35,42,75,22,103,115,109,3,39,54,84,74,83,20,33,11,44,94,12,62,47,70,56,15,80,100,111,14,7,48,72,31,30,40,55,51,86,95,65,93,59,29,2,61,25,45,90,107,92,49,81,26,110,76,46,67,38,87,58,37,18,104,98,43,106,64,88,28,21,66,71,97,63,77,114,96,60,57]
#target=choose_t(s4,S,58)#choose top 50% nodes
#x=[6,12,17,23,30,35]
#Compute functions. Repeat experiments 1000 times.
#compute_met_P(1000,M,S,s4,0.6,0.6,x,35)#SIR model ### Change Vaccinated set sizes according to graph i.e., [2,4,6,8,10]### vary 10 - 60% of total nodes


