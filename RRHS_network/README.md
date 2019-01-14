# Studying the Phylogeny and Reticulate Evolution of the Wheat Species Complex using Repeated Random Haplotype Sampling (RRHS) (Figure 4)

Author: [Daniel Lang](mailto:Daniel.Lang@helmholtz-muenchen.de)

## Basis for Figures and Tables
* Figure 4
* Figure S10
* Figure S11
* Figure S13

This directory comprises a set of jupyter notebooks, snakemake workflows and scripts that were utilized to perform the phylogenetic analyses underlying the model of ...

## Input
1. Unimputed variant calls in VCF split by chromosome (e.g. `full_vcfs/chr1A.minocc10.maf1pc.vcf`)
2. [Genotype Metadata](Whealbi_500samples_table.xlsx)

# Output
1. Variant call data structures in [HDF5](https://de.wikipedia.org/wiki/Hierarchical_Data_Format)
2. Multiple sequence alignments with heterozygous sites as [IUPAC ambiguity symbols](https://en.wikipedia.org/wiki/Nucleic_acid_notation#IUPAC_notation) ([FASTA](https://en.wikipedia.org/wiki/FASTA_format))
	1. 3 subgenomes (B, A, D)
	2. 3 x 7 chromosomes (1B-7B, 1A-7A, 1D-7D)
3. 1000 Multiple sequence alignments with heterozygous sites randomly selected by RRHS ([FASTA](https://en.wikipedia.org/wiki/FASTA_format))
4. Filtered VCF files ([VCF](https://en.wikipedia.org/wiki/Variant_Call_Format))
5. Diverse exploratory plots ([PDF](https://en.wikipedia.org/wiki/PDF))

## Workflow
### 1. SNP filtering and export as multiple alignments using IUPAC ambiguity and RRHS for heterozygous sites
#### Applied filtering criteria (in order of application):
1. Only SNPs
2. Maximally missing in 10% of the genotypes
3. Biallelic
4. Alternative allele must be present in >1 genotype
5. LD Pruning ([scikit.allele.locate_unlinked](https://scikit-allel.readthedocs.io/en/latest/stats/ld.html)): 
	* `allele.locate_unlinked(gn, size=window_size, step=step_size, threshold=threshold)`
	* window size = 500bp
	* step size = 200bp
	* threshold = 0.1
6. Polymorphic sites

#### Code:
1. [FilterSNPsNGetAlignments.ipynb](FilterSNPsNGetAlignments.ipynb)

### 2. Phylogenetic inference of maximum likelihood trees for the 1000 RRHS samples
#### Code:
1. [FilterSNPsNGetAlignments.ipynb](FilterSNPsNGetAlignments.ipynb)

#### External software (beyond imported packages):
1. [RAxML](https://cme.h-its.org/exelixis/web/software/raxml/index.html)

