import subprocess
import itertools as it
import os
import sys
import csv

# Use the following command to execute ANGSD but split across non overlapping regions to allow distributed computation on SGE
# /nfs/pgsb/commons/apps/angsd/angsd/angsd -doAbbababa2 1 -bam bamfiles.list -sizeFile sizeFile.size -doCounts 1 -out bam.Angsd -useLast 1 -minQ 20 -minMapQ 30 -P 10

ANGSD = "/nfs/pgsb/commons/apps/angsd/angsd/angsd"

def main(parts):
    if not isinstance(parts, list):
        parts = [parts]
    
    with open(os.path.join(os.getenv('TMPDIR'), "regions.txt"), 'wt') as out:
        for part in parts:
            out.write(f"{part}:\n")

    cmd = [ANGSD, '-doAbbababa2', '1',
           '-bam', 'bamfiles.list',
           '-sizeFile', 'sizeFile.size',
           '-doCounts', '1',
           '-out', f"bam.Angsd.{part}",
           '-rf', out.name,
           '-useLast', '1',
           '-minQ', '20',
           '-minMapQ', '30',
           '-P', '10']
    ps = subprocess.call(cmd)

if __name__ == '__main__':
    
    analysis = sys.argv[1] if len(sys.argv) > 1 else None

    if analysis == 'chromosome':
        # join AB across chromosomes
        i = it.groupby([f"chr{num}{sg}_part{part}" for num in range(1,8) for sg in "AB" for part in [1,2]], lambda x: x[3])
        parts = {int(k) - 1: list(v) for k, v in i}

    elif analysis == 'both':
        # per chromosome and subgenome
        i = it.groupby([f"chr{num}{sg}_part{part}" for num in range(1,8) for sg in "AB" for part in [1,2]], lambda x: x[3:5])
        parts = dict(enumerate((list(v) for k, v in i)))

    elif analysis == 'subgenome':
        # per subgenome
        i = it.groupby([f"chr{num}{sg}_part{part}" for sg in 'AB' for num in range(1,8) for part in [1,2]], lambda x: x[4:5])
        parts = dict(enumerate((list(v) for k, v in i)))

    else:
         raise ValueError("Please define type of analysis: chromosome, subgenome or both")

    if os.getenv('SGE_TASK_ID') is None:
        print(f"qsub -q plant2,plant_wheat -l job_mem=20g -N abbababa -t 1-{len(parts)} -pe serial 10 -cwd -o sgelog/ -e sgelog/ -b y ~/.virtualenvs/python37/bin/python {__file__} {analysis}")
    else:
        tid = int(os.getenv('SGE_TASK_ID')) 
        main(parts[tid-1])
