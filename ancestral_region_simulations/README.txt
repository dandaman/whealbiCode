The results of these simulations have been used to build Figure 2B.

# cropping the tree to remove individuals of unknown origin and non T.aestivum.

python code:
"""

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


"""


#then, run estimate_ancestral_states.R
#the resulting simulation can be analysed and plotted with plotAncestralTree_and_Map.R
