#In this we run SIR infection spread model
function SIR_p(G,P,I,Vac,p,delta) #G is graph, I is infected set, Vac is the vaccinated set, p is the probability of infection for SIR model and delta is the curing probability
A=adjacency_matrix(G)
V=vertices(G)
count_I=length(I) #size of initial infected set
count_P=length(P) #size of protecetd set
time=0
state=state_init_P(V,P,I,Vac)
while length(I)!=0 # Run till there are no infected nodes in the network
	time=time+1 # Variable time keeps track of no. of time steps for which the model runs
	flag=0 # to take transpose of I_temp only once
	I_temp=[ ] # to hold new infected set for next time step
	for i in I # Each infected node tries to infect its yet uninfected neighbors
		for j in V
			if (A[i,j]==1 && (state[j]=="S" || state[j]=="P" )) # to find uninfected or susceptible neighbors of i which can also be the protected set
				rand_no=rand(Float64)
				if rand_no <= p # infect neighbor with probability p
					count_I=count_I+1 # keep track of newly infected nodes during entire process
					if state[j]=="P" # if susceptible proteceted neighbor node was infecetd then decrement the size of protected nodes
						count_P=count_P-1
					end
					state[j]="I" # change state to infected
					if flag==0 # First time take transpose of I_temp to satisfy dimensions
						I_temp=[I_temp' j]
						flag=flag+1
					end
					I_temp=[I_temp j]
				end
			end
		end
		rand_no_r=rand(Float64)
		if rand_no_r <= delta # cure node with probability delta
			state[i]="R" # change state to recovered
		end
		if state[i]=="I" # check if node is still infected
			if flag==0 # First time take transpose of I_temp to satisfy dimensions
				I_temp=[I_temp' i] # add node to the infected set of next time step
				flag=flag+1
			end
			I_temp=[I_temp i]  # add node to the infected set of next time step
		end
	end	
	I=I_temp
end
#return count_I
return (((length(P)-count_P)/length(P))*100)
end

function state_init_P(V,P,I,Vac)
state=state_null_P(length(V))
	for i in V
		if i in P
			state[i]="P"#Protected set
		elseif i in I
			state[i]="I"#Infected set
		elseif i in Vac
			state[i]="V"#Vaccinated set
		else
			state[i]="S"
		end
	end
return state
end

function state_null_P(size)
state=[" "]
	for i=1:size-1
		state=[state " "]
	end
return state
end
