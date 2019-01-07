import sys
from ete3 import Tree

def RootedCladeSet( N , clades ):
    if N.is_leaf():
        #clades.append( set([N.name]) )
        return set([N.name])

    currentClade = set()

    for i,c in enumerate(N.children):
        childClade = RootedCladeSet( c , clades  )
        currentClade.update(childClade)

        if N.is_root() and i == 1:
            continue ## add only 1 of the root's children

        clades.append( childClade )

    return currentClade

def completeCladeSet( clades , full ):
    Updated = []
    for c in clades:
        Updated.append(c)
        Updated.append( full.difference(c) )
    return Updated



if __name__ == "__main__":

    help = """
    Takes:
    * file containing a tree

    prints to screen the list of clades in the unrooted tree.
    One line per clade, leaf names separated by ";".
    """

    if len(sys.argv)<2 or "-h" in sys.argv or "--help" in sys.argv:
        print help
        exit(0)


    t = Tree(sys.argv[1])

    C = []
    X = RootedCladeSet(t , C)
    C = completeCladeSet( C , X )
    
    for c in C:
        print ";".join(c)
