Author: [Michael Seidel](michael.seidel@helmholtz-muenchen.de)

## Basis for Figures and Tables
* Figure 4B
* Figure S12

## Usage

The script `angsd_sge.py` is designed to be executed in a grid scheduling environment (like SGE). A command line for submission is presented upon execution.
The script expects one mandatory parameter to choose the grouping by `chromosome`, `subgenome` or `both`.

Additional files are required by `angsd`, please refer to the documentation of [ANGSD](http://www.popgen.dk/angsd/index.php/Abbababa) for more details. Samples for both files are included in this repository for your reference.

* `bamfiles.list`
  A list of all samples that should be included in the analysis
* `sizeFile.size`
  The number of lines in the bamfile that form one group, e.g. lines 1-5 are group A, lines 6-10 group B and lines 11-20 group C, then the sizes are 5, 5 and 10.


