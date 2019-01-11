# Computation of nulceotide diversity (Tajima's π) (Figure 3)

Author: [Thibault Leroy](thibault.leroy@umontpellier.fr)


## Basis for Figures and Tables

* Figure 3
* Figure S7


This directory comprises the code for seq-stat, a software used to compute several metrics, including
Tajima’s π and D over non-overlapping sliding windows, more informations of seq-stat can be found on a recent publication about [avian sex chromosome evolution](https://www.biorxiv.org/content/early/2018/12/26/505610.full.pdf+html).
Tajima’s π was used to compute reduction of diversity (ROD) metricswhich helped identify regions bearing traces of recent selection by breeders.



## Installation

To work properly, seq-stat requires the installation of the  [Bio++ library](http://biopp.univ-montp2.fr/) [1].

To compile seq-stat, use the command:
g++ -std=c++14  -g seq_stat.cpp -o seq_stat  -I$HOME/local/bpp/dev/include/ -L$HOME/local/bpp/dev/lib/ -DVIRTUAL_COV=yes -Wall -lbpp-seq -lbpp-core -lbpp-popgen 


## Input

Phylip or fasta file containing the sequence of interest.


## Output

File containing information about the alignments diversity, including Tajima's estimator of nucleotides diversity, Watterson's estimator of nucleotides diversity and Tajima's D.



## References

[1] Guéguen L., et al ; Bio++: Efficient Extensible Libraries and Tools for Computational Molecular Evolution, Molecular Biology and Evolution, Volume 30, Issue 8, 1 August 2013, Pages 1745–1750
