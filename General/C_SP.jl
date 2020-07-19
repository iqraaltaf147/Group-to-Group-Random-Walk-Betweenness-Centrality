using LightGraphs

function betweenness_centrality_s(option,g::AbstractGraph,
    src::AbstractVector=vertices(g),
    distmx::AbstractMatrix=LightGraphs.weights(g);
    normalize=true,
    endpoints=false)

    n_v = nv(g)
    k = length(src)
    isdir = is_directed(g)
    rst=setdiff(vertices(g),src)# set of targets
    betweenness = zeros(n_v)
    if option == 1 #Baseline 1: Shortest-path metric considering only the shortest path between set S (src) and V\S (rst or targets)
    	 state = dijkstra_shortest_paths(g, src, distmx; allpaths=true, trackvertices=true)
    	_accumulate_basic!(betweenness, state, g, src,rst)
    elseif option == 2 #Baseline 2: Shortest-path metric considering all shortest paths between all vertices of set S (src) and V\S (rst or targets)
   	for s in src
    		state = dijkstra_shortest_paths(g, s, distmx; allpaths=true, trackvertices=true)
    		_accumulate_basic!(betweenness, state, g, s,rst)
    	end
    end
    if option == 1
  	 _rescale!(betweenness,n_v-k,normalize,isdir,k)
    elseif option == 2
   	_rescale!(betweenness,k*(n_v-k),normalize,isdir,k)
    end
	btw=removesrc_vert(betweenness,src)
	return btw
#    return betweenness
end


function _accumulate_basic!(betweenness::Vector{Float64},
    state,
    g::AbstractGraph,
    src, rst::AbstractVector)

    n_v = length(state.parents) 
    δ = zeros(n_v)
    σ = state.pathcounts
    P = state.predecessors
    
    # make sure the source index has no parents.
    #P[si] = []
    # we need to order the source vertices by decreasing distance for this to work.
    S = reverse(state.closest_vertices) #Replaced sortperm with this
    for w in S
	for v in P[w]
		if in(w,rst)            
			δ[v] += (σ[v] / σ[w]) * (1.0 + δ[w])
		else
			δ[v] += δ[w] / length(P[w])
           	end
	end
        if !in(w,src)
            betweenness[w] += δ[w]
        end
    end
    return nothing
end


function _rescale!(betweenness::Vector{Float64}, n::Integer, normalize::Bool, directed::Bool, k::Integer)
    if normalize
        if n <= 2
            do_scale = false
        else
            do_scale = true
            scale = 1.0 / n
        end
    #else
     #   if !directed
      #      do_scale = true
       #     scale = 1.0 / 2.0
        #else
         #   do_scale = false
        #end
    end
    #if do_scale
     #   if k > 0
     #       scale = scale * n / k
      #  end
        betweenness .*= scale

   # end
    return nothing
end

function removesrc_vert(btw,S)#function to remove centrailty for source set
	for i=1:length(btw)
		if in(i,S)
			btw[i]=-10
		end
	end
return btw
end
