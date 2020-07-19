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

function compute_met(no,G,I,s1,s2,s3,s4,p,delta,opt,x)#s1,s2,s3 denoted Vaccinated set for three metrics
V=vertices(M)
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
	a4=topk(s4,i)
	#repeat experiment number of times
	
	if f1==0
		x1=repeat(no,G,I,a1,0.6,0.6,opt)
		x2=repeat(no,G,I,a2,0.6,0.6,opt)
		x3=repeat(no,G,I,a3,0.6,0.6,opt)
		x4=repeat(no,G,I,a4,0.6,0.6,opt)
		f1=1
	else
		u=repeat(no,G,I,a1,0.6,0.6,opt)
		v=repeat(no,G,I,a2,0.6,0.6,opt)
		w=repeat(no,G,I,a3,0.6,0.6,opt)
		z=repeat(no,G,I,a4,0.6,0.6,opt)
		x1=[x1 u]
		x2=[x2 v]
		x3=[x3 w]
		x4=[x4 z]
	end
end
#Write ouput to CSV File
if opt==1
CSV.write("SIR.csv",DataFrame(x1), append=true)
CSV.write("SIR.csv",DataFrame(x2), append=true)
CSV.write("SIR.csv",DataFrame(x3), append=true)
CSV.write("SIR.csv",DataFrame(x4), append=true)
else 
CSV.write("IC.csv",DataFrame(x1), append=true)
CSV.write("IC.csv",DataFrame(x2), append=true)
CSV.write("IC.csv",DataFrame(x3), append=true)
CSV.write("IC.csv",DataFrame(x4), append=true)
end
#Plot graphs
#x reprsents vaccinated set sizes
#Line plots
plot(x,x1',labels="G2G Random walk", linewidth=2,marker=:rect, margin=8Plots.mm)
plot!(x,x2',labels="Shortest Path Baseline 1", linewidth=2,marker=:cross, margin=8Plots.mm)
plot!(x,x3',labels="Shortest Path Baseline 2", linewidth=2,marker=:circle, margin=8Plots.mm)
plot!(x,x4',labels="PageRank", linewidth=2,marker=:diamond, margin=8Plots.mm)
#Scatter plot
#Plots.scatter(x,x1',labels="Random walk measure")
#Plots.scatter!(x,x2',labels="Shortest path Baseline 1")
#Plots.scatter!(x,x3',labels="Shortest path Baseline 2")
#Plots.scatter!(x,x4',labels="PageRank centrality")
xlabel!("Size of Vaccinated set")
ylabel!("Total %ge of Infected nodes")
end
