using LightGraphs,GraphIO,ParserCombinator #to load graph
using Laplacians #for solver
using LinearAlgebra #for norm (if needed)

function generateb(dim,S,snk,b)
	for i = 1:dim
		if in(i,S)
			b[i]=1
		elseif i==snk
			b[i]=-length(S)
		else
  			b[i]=0
		end
	end
return b
end

function Lsolve(M,dim,V,S,y)# M is the graph, dim is no of vertices, V is vertex set, S is source set and y is to get solution set initialized to all zeros
	A=adjacency_matrix(M)
	for j in setdiff(V,S)
		b=generateb(dim,S,j,zeros(dim))
		f=KMPLapSolver(A); #Kyng, Sachedva fastest solver to return L^+
		x=f(b);#solve Lx=b
		z=minimum(x)
		x=x.-z # to change it to \eta form with no negative values
		y=hcat(y,x)
	end
w=(sum(y,dims=(2))).*degree(M)
C=w./(length(setdiff(V,S)))
btw=removesrc_vert(C,S)
return btw
#return C
end

function removesrc_vert(bt,S)#function to remove centrailty for source set
	for i in S
		bt[i]=-10
	end
return bt
end
