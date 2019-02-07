
## The script **rigid_toric_graph.pl**: 

- **A non-rigid bipartite graph**: Let us consider the complete bipartite graph K_{4,4} where we remove two edges from the first vertex.

```
polytope > $c = new Cone(INPUT_RAYS=>[[1,0,0,0,0,0,1,0],[1,0,0,0,0,0,0,1],[0,1,0,0,1,0,0,0],
[0,1,0,0,0,1,0,0],[0,1,0,0,0,0,1,0],[0,1,0,0,0,0,0,1],[0,0,1,0,1,0,0,0],
[0,0,1,0,0,1,0,0],[0,0,1,0,0,0,1,0],[0,0,1,0,0,0,0,1],[0,0,0,1,1,0,0,0],
[0,0,0,1,0,1,0,0],[0,0,0,1,0,0,1,0],[0,0,0,1,0,0,0,1]]);

polytope > is_tv_graph_rigid($c);

a_0 = 1 0 0 0 0 0 0 0
a_1 = 0 0 0 0 0 0 1 0
a_2 = 0 1 1 1 -1 -1 0 0
a_3 = 1 1 1 1 -1 -1 -1 0
a_4 = 0 0 0 0 1 0 0 0
a_5 = 0 1 0 0 0 0 0 0
a_6 = 0 0 0 0 0 1 0 0
a_7 = 0 0 1 0 0 0 0 0
a_8 = 0 0 0 1 0 0 0 0

There exist non-simplicial 3-faces: {0 1 2 3}
TV(G) is not rigid.
```

The numbers in the set {0,1,2,3} present the extremal rays {a_0, a_1, a_2, a_3} printed in the beginning.
We have shown in Theorem 4.15 that if the edge cone admits a non-simplicial three-dimensional face, then TV(G) is rigid. 
The function ```is_tv_graph_rigid()``` utilizes this fact. In the case where the edge cone does not admit any non-simplicial face, 
the function asks for a deformation degree R from the lattice M and determines if the homogeneous piece T1(-R) is equal to zero. 
This part of the function works for any toric variety in codimension two, not just for the ones associated to bipartite graphs.

- **A bipartite graph with only simplicial 3-faces**: Let us consider the complete bipartite graph K_{4,4} with one edge removal. 
Since its edge cone does not have any non-simplicial three-dimensional face, the function asks for a deformation degree from M.
One has to keep in mind the chosen lattice M while inputting the deformation degree.

```
polytope > $c = new Cone(INPUT_RAYS=>[[1,0,0,0,0,1,0,0],[1,0,0,0,0,0,1,0],[1,0,0,0,0,0,0,1],
[0,1,0,0,1,0,0,0],[0,1,0,0,0,1,0,0],[0,1,0,0,0,0,1,0],
[0,1,0,0,0,0,0,1],[0,0,1,0,1,0,0,0],[0,0,1,0,0,1,0,0],
[0,0,1,0,0,0,1,0],[0,0,1,0,0,0,0,1],[0,0,0,1,1,0,0,0],
[0,0,0,1,0,1,0,0],[0,0,0,1,0,0,1,0],[0,0,0,1,0,0,0,1]]);  

polytope > is_tv_graph_rigid($c);
a_0 = 0 0 0 0 0 1 0 0
a_1 = 1 0 0 0 0 0 0 0
a_2 = 0 1 1 1 -1 0 0 0
a_3 = 0 0 0 0 0 0 1 0
a_4 = 1 1 1 1 -1 -1 -1 0
a_5 = 0 0 0 0 1 0 0 0
a_6 = 0 1 0 0 0 0 0 0
a_7 = 0 0 1 0 0 0 0 0
a_8 = 0 0 0 1 0 0 0 0

Enter 8 coordinates of a deformation degree R 
1
0
0
0
-1
1
1
0
T1(-[1 0 0 0 -1 1 1 0]) is equal to zero

```
The idea here is to create a new graph, say G(R), for the given deformation degree R.
For this, we first eliminate the extremal rays in [R<0]. 
The vertices of G(R) are identified with two-dimensional faces of Q(R) and compact edges in Q(R) which are not contained in any of these two-dimensional faces. 
These elements are collected with the function ```crosscut_skeleton()```. 
We add an edge to G(R), if two 2-faces are connected to each other by a common compact edge. 
In the other cases, we look at the vertex in Q(R) which is connecting two faces.
We add an edge to G(R), if this vertex is a non-lattice vertex in Q(R). 
The new graph G(R) is produced by the function ```crosscut_graph()```. 
In the end, if the new graph G(R) is connected, the function ```is_tv_graph_rigid()``` returns that T1(-R) = 0. 
An interactive and representative picture of Q(R) is produced by the function ```crosscut_picture()``` by using the application "topaz" within Polymake. 

```
polytope > $cdual = new Cone(INPUT_RAYS=>$c->FACETS);
 
polytope > $hasse = $cdual->HASSE_DIAGRAM;

polytope > $def_degree = new Vector<Rational>(1,0,1,0,-2,1,0,3);

polytope > print crosscut_skeleton($cdual,$hasse,$def_degree);
{0 1 4}{0 1 7}{0 2 4}{0 2 7}{0 4 7}{1 4 7}{2 4 7}

polytope > print crosscut_graph($cdual,$hasse,$def_degree)->EDGES;
{0 1}
{0 2}
{1 3}
{2 3}
{0 4}
{1 4}
{2 4}
{3 4}
{0 5}
{1 5}
{2 5}
{4 5}
{0 6}
{2 6}
{3 6}
{4 6}
{5 6}

polytope > application "topaz";

topaz > crosscut_picture($cdual,$hasse,$def_degree);
```

## The script **T1_toric_graph.pl**: 

* **Cone over a Segre embedding**: Let us consider the first rigid example, i.e. the cone over the Segre embedding of 
P1 x P2 in P5. Equivalently, this is the toric variety TV(K_{2,3}). We calculate the rigidity as follows.

```
polytope > application "fulton";

fulton > $c = new Cone(INPUT_RAYS=>[[1,0,1,0,0],[1,0,0,1,0],
[1,0,0,0,1],[0,1,1,0,0],[0,1,0,1,0],[0,1,0,0,1]]);

fulton > T1_module($c);

Edge ideal generators related to G

toric_ideal[1]=-x_0*x_2+x_1*x_5
toric_ideal[2]=-x_0*x_3+x_1*x_4
toric_ideal[3]=-x_2*x_4+x_3*x_5

Generators of the module of infinitisimal deformations of TV(G)

M[1]=gen(6)
M[2]=gen(5)
M[3]=gen(4)
M[4]=gen(3)
M[5]=gen(2)
M[6]=gen(1)

The dimension of M as a module 

-1

The dimension of M as a vector space

0
```


