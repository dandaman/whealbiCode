# Geographical components of the panel structure (Figure 2A)
Code and data for the permutation tests to test the grouping of three character : continent of origin, growth habit, and historical group.

Author: [Wandrille Duchemin](wandrille.duchemin@inra.fr)

## Basis for Figures and Tables
* Figure 2A

## Workflow
### 1. Extract clades 
script to list all clades in a tree
Code: [extract_all_clades.py](extract_all_clades.py) 


### 2. Determining the most structuring character, using proportion of monophyletic clades and permutation tests

Growth habit   : proportion of monophyletic :  0.31870669746
Group          : proportion of monophyletic :  0.322748267898
Continent      : proportion of monophyletic :  0.384526558891


performed 10 000 000 permutations each for each character.

command example, 100 permutations for the Growth Habit character : 
`python computeMonophyly.py allHexaClades.txt Sup_487samples.csv "Growth habit" 100 allHexaClades.txt.Growth_habit.PermutsPmonophyletic.100`


allHexaClades.txt.Growth_habit.PermutsPmonophyletic.txt.10M
	no permutation with a proportion > 0.31870669746  -> p-value < 10-7
allHexaClades.txt.Group.PermutsPmonophyletic.txt.10M
	no permutation with a proportion > 0.322748267898 -> p-value < 10-7
allHexaClades.txt.Continent.PermutsPmonophyletic.txt.10M
	no permutation with a proportion > 0.384526558891 -> p-value < 10-7


