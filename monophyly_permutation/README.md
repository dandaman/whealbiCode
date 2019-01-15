# Geographical components of the panel structure (Figure 2A)

Author: [Wandrille Duchemin](mailto:wandrille.duchemin@inra.fr)

![Figure2A](Figure/Figure2A.png)

Code and data for the permutation tests to test the grouping of three character : continent of origin, growth habit, and historical group.

## Basis for Figures and Tables
* Figure 2A

## Workflow
### 1. Extract clades 

script to list all clades in a tree
Code: 
 * [extract_all_clades.py](extract_all_clades.py) 

## input

 * hexaploid wheat phylogenetic tree ( eg. [this tree](../ancestral_region_simulations/hexaploids.allGenes.fa.treefile.ann) )

## output

prints to screen the list of clades in the unrooted tree.
One line per clade, leaf names separated by ";".

See `allHexaClades.txt`.


### 2. Determining the most structuring character, using proportion of monophyletic clades and permutation tests

Code:
 * [computeMonophyly.py](computeMonophyly.py)

Command example, 100 permutations for the Growth Habit character : 

`python computeMonophyly.py allHexaClades.txt Sup_487samples.csv "Growth habit" 100 allHexaClades.txt.Growth_habit.PermutsPmonophyletic.100`


## Results

 * Growth habit   : proportion of monophyletic :  0.31870669746
 * Group          : proportion of monophyletic :  0.322748267898
 * Continent      : proportion of monophyletic :  0.384526558891


We performed 10 000 000 permutations each for each character.

 * `allHexaClades.txt.Growth_habit.PermutsPmonophyletic.txt.10M`

	no permutation with a proportion > 0.31870669746  -> p-value < 10-7
 * `allHexaClades.txt.Group.PermutsPmonophyletic.txt.10M`

	no permutation with a proportion > 0.322748267898 -> p-value < 10-7
 * `allHexaClades.txt.Continent.PermutsPmonophyletic.txt.10M`

	no permutation with a proportion > 0.384526558891 -> p-value < 10-7


