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

function compute_met_P(no,G,P,I,s1,s2,s3,s4,p,delta,x)#no denotes number of times simulations need to be rerun, G is the given graph, P denotes the set to be protceted, I denotes the infceted set, s1-s4 denotes the influential nodes for the given graphs for the chosen source-target sets based on our proposed random walk betweenness metric and other three baselines: shortest path baseline 1 and 2 and pagerank which will choose the infected set, p & delta denotes the infection and curing probability for the model respectively,and x is the possible sizes of vaccinated set
V=vertices(G)
s11=change2to1(s1,zeros(length(V)))
f1=0
x1=[]
x2=[]
x3=[]
x4=[]
for i in x #Change vaccinated set sizes
	#Find top k nodes
	a1=topk(s11,i)
	a2=topk(s2,i)
	a3=topk(s3,i)
	a4=topk_choose(s4,P,I,i)
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
xlabel!("Total %ge of Vaccinated nodes")
ylabel!("Total %ge of Infected nodes in protected set")
end
