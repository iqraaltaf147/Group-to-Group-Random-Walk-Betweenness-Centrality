using Plots; #pyplot()#Pyplot backend
using CSV, DataFrames #For writing to a CSV file

function repeat(no,G,P,I,Vac,p,delta)#repeat infection spread model simulations
count=no
value=0
while count !=0
	value=value+SIR_p(G,P,I,Vac,p,delta)###Change model
	count=count-1
end
return value/no
end

function topk(arr,k)
pmt=reverse(sortperm(arr))
s=[]
flag=0
for i=1:k
	if flag==0
		s=[s' pmt[i]]
		flag=1
	else
		s=[s pmt[i]]
	end
end
return s
end

function topk_choose(arr,P,S,k)
x=setdiff(arr,P)#remove protected set
y=setdiff(x,S)#remove Source set
s=[]
flag=0
for i=1:k
	if flag==0
		s=[s' y[i]]
		flag=1
	else
		s=[s y[i]]
	end
end
return s
end

function change2to1(arr,rtn)#Change Array(Folat64,2) i.e., arr to Array(Float64,1) i.e., rtn
	n=length(arr)
	for i = 1:n
		rtn[i]=arr[i]
	end
return rtn
end

function compute_met_P(no,G,comb_S,P,p,delta,x,vp)#no denotes number of times simulations need to be rerun, G is the given graph, P denotes the set to be protceted, I denotes the infceted set, s1-s4 denotes the influential nodes for the given graphs for the chosen source-target sets based on our proposed random walk betweenness metric and other three baselines: shortest path baseline 1 and 2 and pagerank which will choose the infected set, p & delta denotes the infection and curing probability for the model respectively,and x is the possible sizes of source set
V=vertices(G)
f1=0
x1=[]
x2=[]
x3=[]
x4=[]
for i in x
	I=comb_S[1:i]
	CSV.write("SIR_p.csv",DataFrame(I'), append=true)
	###Karate.gml	###replace 2,3,5,7 by 4,7,10,14, similarly for other graphs
	if i==2
		s4=[1,34,4,5,7,17,6,33,3,2,23,11,14,8,32,9,13,31,24,20,30,28,18,22,29,25,26,10,15,16,19,21,27,12]
	elseif i==3
		s4=[1,34,33,2,4,3,5,7,28,17,6,22,27,23,30,14,24,11,32,9,8,31,25,20,13,26,29,18,10,15,16,19,21,12]
	elseif i==5
		s4=[34,1,33,32,24,3,2,28,4,26,5,7,30,6,17,25,27,23,22,14,9,11,8,31,29,20,13,15,16,19,21,10,18,12]
	else
		s4=[34,1,33,3,32,2,24,7,4,28,26,6,5,31,30,17,9,14,25,27,23,10,22,11,8,29,20,15,16,19,21,13,18,12]
	end
	###Lesmiserables
	#if i==8
#s4=[1,12,26,3,71,52,20,6,7,28,24,56,14,4,49,27,25,69,70,42,17,72,59,50,18,19,21,22,23,76,30,65,63,2,5,8,9,10,55,58,64,66,35,36,37,38,39,60,62,67,32,29,40,53,61,43,44,73,77,54,13,34,45,51,31,57,41,11,15,16,33,74,75,46,48,68,47]
#	elseif i==15
#s4=[12,1,56,26,52,49,65,28,71,62,3,37,59,24,27,29,20,53,63,25,6,7,42,64,66,69,70,46,30,58,60,50,72,4,14,67,17,35,36,38,39,61,40,76,18,19,21,22,23,55,77,45,32,2,5,8,9,10,44,73,43,54,34,57,13,51,31,11,15,16,33,74,75,41,48,68,47]
#	elseif i==23
#s4=[12,1,56,28,49,26,52,65,70,71,50,27,62,59,37,38,24,3,25,69,42,30,63,29,72,64,66,20,58,60,53,39,35,36,6,7,10,4,67,74,76,46,17,61,14,40,55,77,18,19,21,22,23,75,32,44,73,45,2,5,8,9,43,57,51,34,13,54,31,11,15,16,33,48,41,68,47]
#	else
#s4=[12,1,26,56,28,49,59,71,70,24,52,65,50,25,72,27,36,37,38,62,69,42,30,3,63,64,66,35,39,58,29,60,20,4,76,67,6,7,10,61,53,17,51,74,13,55,46,77,40,14,15,41,18,19,21,22,23,32,44,73,2,5,8,9,75,45,43,57,34,54,31,11,16,33,48,68,47]
#	end
	###Dolphins
if i==6
s4=[18,45,3,27,50,15,4,35,2,38,28,21,39,34,44,26,9,43,47,58,46,11,14,60,10,41,37,30,62,55,51,48,7,17,1,52,29,8,16,31,42,19,22,25,20,53,6,54,23,32,33,24,40,57,59,56,13,49,36,61,5,12]
	elseif i==12
s4=[18,58,21,14,34,10,2,6,45,15,27,7,3,28,38,55,50,35,39,23,32,4,26,42,49,44,13,9,37,46,41,43,51,17,48,8,29,30,60,11,52,47,1,19,31,57,20,33,16,62,22,25,53,40,54,24,61,59,56,36,5,12]
	elseif i==19
s4=[18,58,39,10,14,2,21,34,15,28,26,7,52,6,55,27,38,45,16,46,20,3,42,35,44,41,37,30,8,50,51,17,4,9,23,32,19,43,59,48,31,49,60,29,1,25,13,22,11,5,33,53,47,57,62,40,24,56,54,61,12,36]
	else
s4=[18,34,39,2,58,15,21,10,52,38,14,44,46,28,55,43,26,16,22,30,45,27,7,6,41,37,3,51,20,35,17,19,42,9,8,48,1,31,50,24,4,25,29,11,60,23,32,59,53,13,49,5,47,62,33,57,54,40,56,12,61,36]
	end
	###Football
#	if i==12
#s4=[4,89,27,50,13,32,53,16,78,102,34,91,44,54,6,35,85,74,15,115,39,19,84,75,68,111,86,47,62,3,73,41,33,99,80,56,20,103,14,2,59,90,82,52,100,72,55,12,8,70,9,1,36,101,40,108,7,31,30,48,26,69,83,22,110,95,112,79,61,38,23,46,11,25,107,104,51,24,106,105,109,81,29,65,49,37,93,17,5,18,43,28,10,113,42,45,92,87,71,94,63,64,98,67,58,21,66,76,88,96,77,60,114,97,57]
#	elseif i==23
#s4=[4,24,9,105,82,5,69,89,78,53,108,16,19,32,50,27,13,91,36,101,102,113,6,34,1,73,85,41,8,79,52,10,68,23,99,112,17,35,42,75,22,103,115,109,3,39,54,84,74,83,20,33,11,44,94,12,62,47,70,56,15,80,100,111,14,7,48,72,31,30,40,55,51,86,95,65,93,59,29,2,61,25,45,90,107,92,49,81,26,110,76,46,67,38,87,58,37,18,104,98,43,106,64,88,28,21,66,71,97,63,77,114,96,60,57]
#	elseif i==35
#s4=[105,24,4,9,5,8,42,19,2,94,69,82,75,78,16,13,89,38,53,27,36,14,108,101,32,45,34,50,1,102,21,91,37,113,63,6,10,41,17,43,73,68,23,35,79,85,112,20,44,83,52,22,3,99,46,103,109,74,39,62,54,90,30,33,115,31,80,7,110,11,56,84,26,70,81,111,40,92,15,106,59,47,12,65,100,93,48,104,18,58,72,61,95,55,107,76,28,49,88,86,67,71,87,51,25,77,66,29,64,96,97,114,57,98,60]
#	else
#s4=[105,24,10,9,8,42,2,41,5,4,68,112,90,69,94,38,89,78,26,16,82,75,19,45,34,56,33,36,14,53,92,108,1,50,101,113,32,13,102,76,27,21,91,17,63,6,64,37,23,46,22,52,79,73,20,110,43,54,109,83,85,99,3,74,30,35,65,7,103,44,106,115,31,80,93,104,47,84,81,58,111,49,62,107,40,70,39,67,59,48,87,11,95,100,61,28,12,18,15,55,88,66,77,72,25,71,86,51,29,97,96,57,98,114,60]
#	end
	#s44=[34,1,33,3,32,2,24,7,4,28,26,6,5,31,30,17,9,14,25,27,23,10,22,11,8,29,20,15,16,19,21,13,18,12]
	#target=choose_t(s44,I,17)#choose top 50% nodes
	#P=choose(target,7)
	CSV.write("SIR_p.csv",DataFrame(P'), append=true)
	s1=Lsolve_prot(G,length(vertices(G)),vertices(G),P,I,zeros(length(vertices(G))))
	s2= betweenness_centrality_prot(1,G,P,I)
	s3= betweenness_centrality_prot(2,G,P,I)
	s11=change2to1(s1,zeros(length(V)))
	a1=topk(s11,vp)
	a2=topk(s2,vp)
	a3=topk(s3,vp)
	a4=topk_choose(s4,P,I,vp)
	#repeat experiment number of times
	
	if f1==0
		x1=repeat(no,G,P,I,a1,0.6,0.6)
		x2=repeat(no,G,P,I,a2,0.6,0.6)
		x3=repeat(no,G,P,I,a3,0.6,0.6)
		x4=repeat(no,G,P,I,a4,0.6,0.6)
		f1=1
	else
		u=repeat(no,G,P,I,a1,0.6,0.6)
		v=repeat(no,G,P,I,a2,0.6,0.6)
		w=repeat(no,G,P,I,a3,0.6,0.6)
		z=repeat(no,G,P,I,a4,0.6,0.6)
		x1=[x1 u]
		x2=[x2 v]
		x3=[x3 w]
		x4=[x4 z]
	end
end
#Write ouput to CSV File
CSV.write("SIR_p.csv",DataFrame(x1), append=true)
CSV.write("SIR_p.csv",DataFrame(x2), append=true)
CSV.write("SIR_p.csv",DataFrame(x3), append=true)
CSV.write("SIR_p.csv",DataFrame(x4), append=true)
#Plot graphs
#x reprsents vaccinated set sizes and we compute it as %ge of nodes
#Line plots
plot((x/length(V))*100,x1',labels="G2G Random walk", linewidth=2,marker=:rect, margin=8Plots.mm)
plot!((x/length(V))*100,x2',labels="Shortest Path Baseline 1", linewidth=2,marker=:cross, margin=8Plots.mm)
plot!((x/length(V))*100,x3',labels="Shortest Path Baseline 2", linewidth=2,marker=:circle, margin=8Plots.mm)
plot!((x/length(V))*100,x4',labels="PageRank", linewidth=2,marker=:diamond, margin=8Plots.mm)
#Scatter plot
#Plots.scatter(x,x1',labels="Random walk measure")
#Plots.scatter!(x,x2',labels="Shortest path Baseline 1")
#Plots.scatter!(x,x3',labels="Shortest path Baseline 2")
#Plots.scatter!(x,x4',labels="PageRank centrality")
xlabel!("Total %ge of Source nodes")
ylabel!("Total %ge of Infected nodes in protected set")
savefig("Plot_SIR_p.pdf")
end
