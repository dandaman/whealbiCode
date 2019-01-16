# Raw data processing and variant calling

Author: [Michael Seidel](mailto:michael.seidel@helmholtz-muenchen.de)

## Basis for Basis for Figures and Tables

## Workflow

* [1. Mapping and variant calling](#1-mapping-and-variant-calling)
* [2. Filtering](#2-filtering)
* [3. Imputation](#3-imputation)

### 1. Mapping and variant calling

The input sequences were mapped to the Chinese Spring wheat reference sequences
using `bwa mem` and initial mapping were post-processed using `picard` to mark
duplicates, fix mates and sort the output.

The resulting `bam` files were the used to jointly call variants per-chromosome
using `samtools mpileup` (version 1.3) with parameters `--min-MQ 20`,
`--excl-flags UNMAP,SECONDARY,QCFAIL,DUP` (samtools) and `bcftools call`
(version 1.3) with parameters`-vcO z -f GQ`.

### 2. Filtering

The VCF file was filtered by `DP ≥ 3` and `GQ ≥ 10` based on the agreement of
in-silico calls compared to publicly available genotype array results (iSelect
and Affymetrix 80k). In addition, sites were initially filtered for a minor
allele frequency `MAF ≥ 1%`.

### 3. Imputation

Removing all 'unreliable' GT calls in the previous step left a sparse VCF with
missing GT across all positions. Those gaps were filled using `beagle` with
default parameters for imputation. Post-imputation, the `MAF` filtering was
repeated with `MAF ≥ 4%` and genotype probability `GP` was filtered at `0.6`.
