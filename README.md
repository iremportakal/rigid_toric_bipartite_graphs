# rigid_toric_bipartite_graphs
Polymake and Singular scripts for investigating the rigidity of toric varieties using the tools mentioned in the authours paper [On the classification of rigid toric varieties arising from bipartite graphs](https://arxiv.org/abs/1905.02445).  

## Content:

### Code:

* **rigid_toric_graph.pl**:  This is a function which receives the dual edge cone and outputs the information about rigidity of the associated toric variety. It focuses also on the face structure of the edge cone. If it detects a non-simplicial three-dimensional face of the given edge cone, the function returns early on the terms of Theorem 4.15. Although this is only for edge cone inputs, the subsequent code works for any toric variety smooth in codimension two. Here, the function asks for a deformation degree R from lattice M (set up in Section 2.2) and gives the skeleton of the crosscut picture Q(R).

* **T1_toric_graph.pl**:  It interfaces Singular within Polymake via application Fulton in order to calculate the dimension of the vector space T1 of a toric variety.

### Executing examples:

* **executing_examples.md**: This provides an overview for the usage of both scripts with examples. It also explains precisely the idea and the subroutines of the script.
