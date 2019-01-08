# Studying the Phylogeny and Reticulate Evolution of the Wheat Species Complex using Repeated Random Haplotype Sampling (RRHS) (Figure 4)

Author: [Daniel Lang](Daniel.Lang@helmholtz-muenchen.de)

## Figures and Tables
* Figure 4
* Figure S10
* Figure S11
* Figure S13

This directory comprises a set of jupyter notebooks, snakemake workflows and scripts that were utilized to perform the phylogenetic analyses underlying the model of ...

## Input
1. Unfiltered, unimputed SNPs in VCF split by chromosome
2. [Genotype Metadata](Whealbi_500samples_table.xlsx)

# Output

## Workflow
### 1. SNP filtering and export as multiple alignments
#### Code:
1. [FilterSNPsNGetAlignments.ipynb](FilterSNPsNGetAlignments.ipynb)

#### External software (beyond imported packages):

### 2. Phylogenetic inference of maximum likelihood trees for the 1000 RRHS samples
#### Code:
1. [FilterSNPsNGetAlignments.ipynb](FilterSNPsNGetAlignments.ipynb)

#### External software (beyond imported packages):
1. [RAxML](https://cme.h-its.org/exelixis/web/software/raxml/index.html)

