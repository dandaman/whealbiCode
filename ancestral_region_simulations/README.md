# Geographical components of the panel structure (Figure 2B)
Code and data to simulate hexaploid wheat ancestral region of origin .

The results of these simulations have been used to build Figure 2B.

Author: [Wandrille Duchemin](mailto:wandrille.duchemin@inra.fr)


## Basis for Figures and Tables
* Figure 2B

## Workflow

### 1. Cropping the tree to remove individuals of unknown origin and non T.aestivum.

Python code:
```
#UNK + spelta + shaerococcum
toPrune = ["WW040","WW066","WW105","WW159","WW170","WW171","WW246","WW248","WW259","WW266","WW240","WW241"]

from ete3 import Tree

tree = Tree("hexaploids.allGenes.fa.treefile.ann")

L = tree.get_leaf_names()
toKeep = [ n for n in L if not n in toPrune ]

tree.prune(toKeep)

OUT=open("Taestivum.allGenes.noUNKorigin.nwk","w")
OUT.write( tree.write() + "\n" )
OUT.close()

```

### 2. Inference of Ancestral States

* Code: [estimate_ancestral_states.R](estimate_ancestral_states.R)

### 3. Analysis and Plots
The resulting simulation can be analysed and plotted with 
* Code: [plotAncestralTree_and_Map.R](plotAncestralTree_and_Map.R)
