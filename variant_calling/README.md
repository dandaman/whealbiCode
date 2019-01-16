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

#### Input:
1. Paired-end Illumina data in [FASTQ format](https://en.wikipedia.org/wiki/FASTQ_format) 
2. _Triticum aestivum_ [IWGSC RefSeq V1.0](https://urgi.versailles.inra.fr/download/iwgsc/IWGSC_RefSeq_Assemblies/v1.0/) chromosomal sequences split up at [breakpoints](breakpoints.bed) 
<!--INSERT add chromosomal breakpoints bed/gff here, @realtkd -->

#### Output:
1. Paired-end read alignments in [BAM format](http://samtools.github.io/hts-specs/)
2. Preliminarily filtered variant calls in [VCF format](http://samtools.github.io/hts-specs/)
#### Code:
1. _your Snakefile etc here_
<!-- INSERT -->

#### External software (beyond imported packages):
1. [bwa mem](https://github.com/lh3/bwa)
2. [picard](https://github.com/broadinstitute/picard)
3. [samtools](https://github.com/samtools/samtools)

#### Additional syntax:
```Bash
#cluster submission
```
<!--INSERT-->


### 2. Filtering

The VCF file was filtered by `DP ≥ 3` and `GQ ≥ 10` based on the agreement of
in-silico calls compared to publicly available genotype array results (iSelect
and Affymetrix 80k). In addition, sites were initially filtered for a minor
allele frequency `MAF ≥ 1%`.
#### Input:
1. Preliminarily filtered variant calls in [VCF format](http://samtools.github.io/hts-specs/)
#### Output:
1. Filtered variant calls in [VCF format](http://samtools.github.io/hts-specs/)
#### Code:
1. _your Snakefile etc here_
<!-- INSERT -->

#### External software (beyond imported packages):
<!-- INSERT or DELETE-->

#### Additional syntax:
```Bash
#cluster submission
```
<!--INSERT-->

### 3. Imputation

Removing all 'unreliable' GT calls in the previous step left a sparse VCF with
missing GT across all positions. Those gaps were filled using `beagle` with
default parameters for imputation. Post-imputation, the `MAF` filtering was
repeated with `MAF ≥ 4%` and genotype probability `GP` was filtered at `0.6`.
#### Input:
1. Filtered variant calls in [VCF format](http://samtools.github.io/hts-specs/)
#### Output:
1. Final, imputed, refiltered variant calls in [VCF format](http://samtools.github.io/hts-specs/)
#### Code:
1. _your Snakefile etc here_
<!-- INSERT -->

#### External software (beyond imported packages):
<!-- INSERT or DELETE-->

#### Additional syntax:
```Bash
#cluster submission
```
<!--INSERT-->
