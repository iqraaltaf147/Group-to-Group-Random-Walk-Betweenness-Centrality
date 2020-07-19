using Plots; #pyplot()#Pyplot backend
using CSV, DataFrames #For writing to a CSV file

function repeat(no,G,I,Vac,p,delta,opt)
count=no
value=0
while count !=0
	if opt==1
	value=value+SIR(G,I,Vac,p,delta)###Change model
	else
	value=value+independent_cascade(G,I',Vac,p)
	end
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

function change2to1(arr,rtn)#Change Array(Folat64,2) i.e., arr to Array(Float64,1) i.e., rtn
	n=length(arr)
	for i = 1:n
		rtn[i]=arr[i]
	end
return rtn
end

function compute_met(no,G,E,F,I,s1,s2,s3,p,delta,opt,x)#s1,s2,s3 denoted Vaccinated set for three metrics
V1=vertices(G)
V2=vertices(E)
V3=vertices(F)
s11=change2to1(s1,zeros(length(V1)))
s22=change2to1(s1,zeros(length(V2)))
s33=change2to1(s1,zeros(length(V3)))
f1=0
x1=[]
x2=[]
x3=[]
for i in x #Change vaccinated set sizes
	#Find top k nodes
	a1=topk(s11,i)
	a2=topk(s22,i)
	a3=topk(s33,i)
	#repeat experiment number of times
	
	if f1==0
		x1=repeat(no,G,I,a1,0.6,0.6,opt)
		x2=repeat(no,E,I,a2,0.6,0.6,opt)
		x3=repeat(no,F,I,a3,0.6,0.6,opt)
		f1=1
	else
		u=repeat(no,G,I,a1,0.6,0.6,opt)
		v=repeat(no,E,I,a2,0.6,0.6,opt)
		w=repeat(no,F,I,a3,0.6,0.6,opt)
		x1=[x1 u]
		x2=[x2 v]
		x3=[x3 w]
	end
end
#Write ouput to CSV File
if opt==1
CSV.write("SIR.csv",DataFrame(x1), append=true)
CSV.write("SIR.csv",DataFrame(x2), append=true)
CSV.write("SIR.csv",DataFrame(x3), append=true)
else 
CSV.write("IC.csv",DataFrame(x1), append=true)
CSV.write("IC.csv",DataFrame(x2), append=true)
CSV.write("IC.csv",DataFrame(x3), append=true)
end
#Plot graphs
#x reprsents vaccinated set sizes
#Line plots
plot((x/length(V1))*100,x1',labels="BA Network", linewidth=2,marker=:rect, margin=8Plots.mm)
plot!((x/length(V2))*100,x2',labels="SW Network", linewidth=2,marker=:cross, margin=8Plots.mm)
plot!((x/length(V3))*100,x3',labels="ER Network", linewidth=2,marker=:circle, margin=8Plots.mm)
#Scatter plot
#Plots.scatter(x,x1',labels="Random walk measure")
#Plots.scatter!(x,x2',labels="Shortest path Baseline 1")
#Plots.scatter!(x,x3',labels="Shortest path Baseline 2")
#Plots.scatter!(x,x4',labels="PageRank centrality")
xlabel!("Total %ge of Vaccinated nodes")
ylabel!("Total %ge of Infected nodes")
end
