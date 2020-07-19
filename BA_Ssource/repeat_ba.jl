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
s=[]
flag=0
for i=1:k
	if flag==0
		s=[s' arr[i]]
		flag=1
	else
		s=[s arr[i]]
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

function compute_met(no,G,a,b,c,d,f,s1,s2,s3,s4,s5,p,delta,opt,x)#s1,s2,s3 denoted Vaccinated set for three metrics
V=vertices(M)
s11=reverse(sortperm(change2to1(s1,zeros(length(V)))))
s22=reverse(sortperm(change2to1(s2,zeros(length(V)))))
s33=reverse(sortperm(change2to1(s3,zeros(length(V)))))
s44=reverse(sortperm(change2to1(s4,zeros(length(V)))))
s55=reverse(sortperm(change2to1(s5,zeros(length(V)))))
f1=0
x1=[]
x2=[]
x3=[]
x4=[]
x5=[]
for i in x #Change vaccinated set sizes
	#Find top k nodes
	a1=topk(s11,i)
	a2=topk(s22,i)
	a3=topk(s33,i)
	a4=topk(s44,i)	
	a5=topk(s55,i)
	#repeat experiment number of times
   if opt==1
	if f1==0
		x1=repeat(no,G,a,a1,0.6,0.6,opt)
		x2=repeat(no,G,b,a2,0.6,0.6,opt)
		x3=repeat(no,G,c,a3,0.6,0.6,opt)
		x4=repeat(no,G,d,a4,0.6,0.6,opt)
		x5=repeat(no,G,f,a5,0.6,0.6,opt)
		f1=1
	else
		u=repeat(no,G,a,a1,0.6,0.6,opt)
		v=repeat(no,G,b,a2,0.6,0.6,opt)
		w=repeat(no,G,c,a3,0.6,0.6,opt)
		z=repeat(no,G,d,a4,0.6,0.6,opt)
		zz=repeat(no,G,f,a5,0.6,0.6,opt)
		x1=[x1 u]
		x2=[x2 v]
		x3=[x3 w]
		x4=[x4 z]
		x5=[x5 zz]
	end
    else
	if f1==0
		x1=repeat(no,G,a,a1,0.6,0.6,opt)
		x2=repeat(no,G,b',a2,0.6,0.6,opt)
		x3=repeat(no,G,c',a3,0.6,0.6,opt)
		x4=repeat(no,G,d',a4,0.6,0.6,opt)
		x5=repeat(no,G,f,a5,0.6,0.6,opt)
		f1=1
	else
		u=repeat(no,G,a,a1,0.6,0.6,opt)
		v=repeat(no,G,b',a2,0.6,0.6,opt)
		w=repeat(no,G,c',a3,0.6,0.6,opt)
		z=repeat(no,G,d',a4,0.6,0.6,opt)
		zz=repeat(no,G,f,a5,0.6,0.6,opt)
		x1=[x1 u]
		x2=[x2 v]
		x3=[x3 w]
		x4=[x4 z]
		x5=[x5 zz]
	end
     end
end
#Write ouput to CSV File
if opt==1
CSV.write("SIR.csv",DataFrame(x1), append=true)
CSV.write("SIR.csv",DataFrame(x2), append=true)
CSV.write("SIR.csv",DataFrame(x3), append=true)
CSV.write("SIR.csv",DataFrame(x4), append=true)
CSV.write("SIR.csv",DataFrame(x5), append=true)
else 
CSV.write("IC.csv",DataFrame(x1), append=true)
CSV.write("IC.csv",DataFrame(x2), append=true)
CSV.write("IC.csv",DataFrame(x3), append=true)
CSV.write("IC.csv",DataFrame(x4), append=true)
CSV.write("IC.csv",DataFrame(x5), append=true)
end
#Plot graphs
#x reprsents vaccinated set sizes
#Line plots
plot((x/length(V))*100,x1',labels="Random selection", linewidth=2,marker=:rect, margin=8Plots.mm)
plot!((x/length(V))*100,x2',labels="Top k degree", linewidth=2,marker=:hexagon, margin=8Plots.mm)
plot!((x/length(V))*100,x3',labels="Least k degree", linewidth=2,marker=:circle, margin=8Plots.mm)
plot!((x/length(V))*100,x4',labels="Top k PageRank", linewidth=2,marker=:diamond, margin=8Plots.mm)
plot!((x/length(V))*100,x5',labels="k-sized connected comp.", linewidth=2,marker=:star5, margin=8Plots.mm)
#Scatter plot
#Plots.scatter(x,x1',labels="Random walk measure")
#Plots.scatter!(x,x2',labels="Shortest path Baseline 1")
#Plots.scatter!(x,x3',labels="Shortest path Baseline 2")
#Plots.scatter!(x,x4',labels="PageRank centrality")
xlabel!("Total %ge of Vaccinated nodes")
ylabel!("Total %ge of Infected nodes")
end
