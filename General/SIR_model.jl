function SIR(G,I,Vac,p,delta) #G is graph, I is infected set, Vac is the vaccinated set, p is the probability of infection for SIR model and delta is the curing probability
diameter=46
A=adjacency_matrix(G)
V=vertices(G)
count_I=length(I) #size of initial infected set
time=0
counter=0 #for keeping track of time-steps (SIR rounds) for which there has been no/slight change in Infected sets
cs=0
state=state_init(I,V,Vac)
while length(I)!=0 # Run till there are no infected nodes in the network
	time=time+1 # Variable time keeps track of no. of time steps for which the model runs
	flag=0 # to take transpose of I_temp only once
	I_temp=[ ] # to hold new infected set for next time step
	for i in I # Each infected node tries to infect its yet uninfected neighbors
		for j in neighbors(G,i)
			if state[j]=="S" # to find uninfected or susceptible neighbors of i
				rand_no=rand(Float64)
				if rand_no <= p # infect neighbor with probability p
					count_I=count_I+1 # keep track of newly infected nodes during entire process
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
	##I_diff=setdiff(I_temp,I)
	##if length(I_diff) <= ceil((1/100)*length(I))#Within 1% size of previous round
	##	counter=counter+1
		#cs=1
	#else
		#cs=0
	##end
	#if (cs==1) && (counter>=diameter)
	#	I=[] #Exit from simulation
	#elseif (cs==0)
	#	counter=0 #reset counter
	##if counter>=diameter/2
	##	I=[] #Exit from simulation
	##else
		I=I_temp
	##end
end
#return count_I
#println("time: ", time)
#println("")
return ((count_I/length(V))*100) #return the total %ge of infected nodes till the model terminates
end

function state_init(I,V,Vac)
state=state_null(length(V))
	for i in V
		if i in I
			state[i]="I"
		elseif i in Vac
			state[i]="V"
		else
			state[i]="S"
		end
	end
return state
end

function state_null(size)
state=[" "]
	for i=1:size-1
		state=[state " "]
	end
return state
end