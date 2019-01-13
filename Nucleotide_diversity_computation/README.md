# Computation of nucleotide diversity π (Figure 3)

Author: [Thibault Leroy](mailto:thibault.leroy@umontpellier.fr)


## Basis for Figures and Tables

* Figure 3
* Figure S7


This directory comprises the code for seq-stat, a software used to compute several metrics, including
[nucleotide diversity π](https://en.wikipedia.org/wiki/Nucleotide_diversity) and [Tajima’s D](https://en.wikipedia.org/wiki/Tajima%27s_D) over non-overlapping sliding windows, more informations of seq-stat can be found on a recent publication about [avian sex chromosome evolution](https://www.biorxiv.org/content/early/2018/12/26/505610.full.pdf+html) [1].
<!--- As put in the issue - I cannot find Tajima's pi anywhere. Wandrille please double check whether this is pi or D or theta? -->

Tajima’s π was used to compute reduction of diversity (ROD) metricswhich helped identify regions bearing traces of recent selection by breeders.
<!--- As put in the issue - I cannot find Tajima's pi anywhere. Wandrille please double check whether this is pi or D or theta? -->


## Installation

To work properly, seq-stat requires the installation of the  [Bio++ library](http://biopp.univ-montp2.fr/) [2].

To compile seq-stat, use the command:

```bash 
g++ -std=c++14  -g seq_stat.cpp -o seq_stat  -I$HOME/local/bpp/dev/include/ -L$HOME/local/bpp/dev/lib/ -DVIRTUAL_COV=yes -Wall -lbpp-seq -lbpp-core -lbpp-popgen
```

## Input

Phylip or fasta file containing the sequence of interest.


## Output

File containing information about the alignments diversity, including Tajima's estimator of nucleotides diversity, Watterson's estimator of nucleotides diversity and Tajima's D.
<!--- As put in the issue - I cannot find Tajima's pi anywhere. Wandrille please double check whether this is pi or D or theta? -->



## References
[1] [Leroy T., et al; A bird's white-eye shot: looking down on a new avian sex chromosome evolution, bioRxviv, doi: 10.1101/505610](https://doi.org/10.1101/505610)

[2] [Guéguen L., et al ; Bio++: Efficient Extensible Libraries and Tools for Computational Molecular Evolution, Molecular Biology and Evolution, Volume 30, Issue 8, 1 August 2013, Pages 1745–1750](https://doi.org/10.1093/molbev/mst097)
