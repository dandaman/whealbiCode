# Genome-Wide Association Study (Figure 1)

Author: [Daniela Bustos Korts](mailto:daniela.bustoskorts@wur.nl)


## Basis for Figures and Tables
 * Figure 1
 * Figure S8
 * Figure S9
 * Table S4
 * Table S5

## Workflow

SNP scores were computed using the function "codeGeno" (with the options `impute.type='beagle'`, `label.heter="alleleCoding"` and `reference.allele="minor"`) of the [synbreed](https://cran.r-project.org/web/packages/synbreed/index.html) package [1].

Additionnaly, a chromosome-specific kinship matrix was calculated using 1,000 SNPs sampled at random from each chromosome, using the "realizedAB" option in the "kin" function of the Synbreed package.

The script [5_Multi-environment_GWAS_2019-01-14.R](5_Multi-environment_GWAS_2019-01-14.R) performs a multi-environment mixed model GWAS analysis (see the supplementary materials for more details).

## Usage

The script [5_Multi-environment_GWAS_2019-01-14.R](5_Multi-environment_GWAS_2019-01-14.R) requires the following data files:

*  [Phenotypes2017-10-27.csv](Phenotypes2017-10-27.csv) is the file with phenotypic data.
*  `PCKinship/KinshipChrXY.csv` are the Kinship principal components for chromosome X, subgenome Y e.g. [PCKinship/KinshipChr1A.csv](PCKinship/KinshipChr1A.csv).
*  `Scores/ScoresXYmaf05imputed.csv` are the SNP scores for chromosome X, subgenome Y (the SNP file, after imputation and removing SNPs with a MAF<0.05) e.g. [Scores/Scores1Amaf05imputed.csv](Scores/Scores1Amaf05imputed.csv)

## Code:
1. [5_Multi-environment_GWAS_2019-01-14.R](5_Multi-environment_GWAS_2019-01-14.R)

 
 

## References

[1] V. Wimmer, T. Albrecht, H.J. Auinger, C.C. Schön, synbreed: a framework for the analysis of genomic
prediction data using R. Bioinformatics. 28(15), 2086–2087 (2012). [doi: 10.1093/bioinformatics/bts335](https://doi.org/10.1093/bioinformatics/bts335).
