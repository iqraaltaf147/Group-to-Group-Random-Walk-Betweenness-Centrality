# Group-to-Group Random Walk Betweenness Centrality
This repository contains the implementation of proposed Group-to-group random walk betweenness centrality, which is a generalization of random walk betweenness proposed by Newman (2005). Using this new centrality, we study a setting where a source group of nodes is infected and we wish to vaccinate or quarantine a limited number of uninfected nodes in such a way that the target group of nodes is protected and the infection is controlled. Empirical evaluation on most real-world networks establishes that the proposed group-to-group centrality metric is more effective at controlling infection than the natural baseline methods for this problem.

## Proposed Centrality
Given solution &eta; to the [one-sink Laplacian][one-sink] system, the group-to-group random walk betweenness centrality of node v &isin; V with respect to the source and target groups S,T respectively can be written as C<sub>RW</sub><sup>G2G</sup>(v,S,T)=&sum; <sub>t&isin;T</sub> &eta;<sub>v</sub><sup>S,t</sup> / |T|. 

## Steps to Compute the Centrality
We use the general [Laplacian solvers][laplacians.jl] solving x<sup>T</sup>L=b<sup>T</sup> for our proposed metric computation. For this, we can set different values of vector b based on the source set S and the chosen target node t in the metric definition to get the corresponding &eta;<sup>S,t</sup> vector. In particular, to compute this vector for a given source set and target node, following steps need to be followed: 
<ul>
  <li> First set vector b as b<sub>v</sub>=1 for nodes v&isin; S, b<sub>t</sub>=-|S| and 0 for all other nodes.
  <li> Then, using general solver find solution vector x.
  <li> Finally, get the desired non-negative solution &eta; by doing the required scaling, i.e., for a given node i, we have &eta;<sub>i</sub>=x<sub>i</sub> - min<sub>i</sub> x<sub>i</sub>d<sub>i</sub>. 
</ul>
 
## Instructions for running the code
The files in General folder are used in common for different experiments. For each experiment, go to the respective folder and run the main file (without 'repeat' keyword).

---
[one-sink]: https://arxiv.org/abs/1905.04989
[laplacians.jl]: https://danspielman.github.io/Laplacians.jl/stable/
