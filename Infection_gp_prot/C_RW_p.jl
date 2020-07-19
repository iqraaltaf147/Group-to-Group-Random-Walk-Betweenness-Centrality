#In this we compute random walk betweenness for a given graph M for source set S and target set P
using LightGraphs,GraphIO,ParserCombinator #to load graph
using Laplacians #for solver
using LinearAlgebra #for norm (if needed)
#using PyAMG

function generateb(dim,S,snk,b)#function to generate b vector
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

function Lsolve_prot(M,dim,V,P,S,y)# M is the graph, dim is no of vertices, V is vertex set, S is source set, P is the set to be protecetd and y is to get solution set initialized to all zeros
	A=adjacency_matrix(M)
	for j in P
		b=generateb(dim,S,j,zeros(dim))
		f=KMPLapSolver(A); #Kyng, Sachedva fastest solver to return L^+
		x=f(b);#solve Lx=b
		z=minimum(x)
		x=x.-z # to change it to \eta form with no negative values
		y=hcat(y,x)
	end
w=(sum(y,dims=(2))).*degree(M)
C=w./(length(P))
btw=removesrc_vert_p(C,P,S)
return btw
#return C
end

function removesrc_vert_p(btw,P,S)#function to remove centrailty for source and target set
	for i=1:length(btw)
		if in(i,S) || in(i,P)
			btw[i]=-100
		end
	end
return btw
end
