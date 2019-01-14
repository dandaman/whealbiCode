/**

//
// Created by: Benoit Nabholz
//


To compile :
	g++ -std=c++14  -g seq_stat.cpp -o seq_stat  -I$HOME/local/bpp/dev/include/ -L$HOME/local/bpp/dev/lib/ -DVIRTUAL_COV=yes -Wall -lbpp-seq -lbpp-core -lbpp-popgen 
 
  This is used with Bio++ library ( http://biopp.univ-montp2.fr/). Please cite Guéguen et al. 2013 MBE) if you use this program )



  Copyright or © or Copr. Bio++ Development Team, (November 17, 2004)

  This software is a computer program whose purpose is to provide classes
  for sequences analysis.

  This software is governed by the CeCILL  license under French law and
  abiding by the rules of distribution of free software.  You can  use, 
  modify and/ or redistribute the software under the terms of the CeCILL
  license as circulated by CEA, CNRS and INRIA at the following URL
  "http://www.cecill.info". 

  As a counterpart to the access to the source code and  rights to copy,
  modify and redistribute granted by the license, users are provided only
  with a limited warranty  and the software's author,  the holder of the
  economic rights,  and the successive licensors  have only  limited
  liability. 

  In this respect, the user's attention is drawn to the risks associated
  with loading,  using,  modifying and/or developing or reproducing the
  software by the user in light of its specific status of free software,
  that may mean  that it is complicated to manipulate,  and  that  also
  therefore means  that it is reserved for developers  and  experienced
  professionals having in-depth computer knowledge. Users are therefore
  encouraged to load and test the software's suitability as regards their
  requirements in conditions enabling the security of their systems and/or 
  data to be ensured and,  more generally, to use and operate it in the 
  same conditions as regards security. 

  The fact that you are presently readAlignmenting this means that you have had
  knowledge of the CeCILL license and that you accept its terms.
*/



using namespace std;


#include <Bpp/Seq/Io/Fasta.h>
#include <Bpp/Seq/Io/Phylip.h>
#include <Bpp/Seq/Alphabet/Alphabet.h>
#include <Bpp/Seq/Alphabet/DNA.h>
#include <Bpp/Seq/Container/AlignedSequenceContainer.h>
#include <Bpp/Seq/Sequence.h>
#include <Bpp/Seq/CodonSiteTools.h>
#include <Bpp/Seq/Container/VectorSequenceContainer.h>
#include <Bpp/Seq/Io/Fasta.h>
#include <Bpp/Seq/Io/Phylip.h>
#include <Bpp/PopGen/SequenceStatistics.h>
#include <Bpp/PopGen/PolymorphismSequenceContainerTools.h>
#include <Bpp/PopGen/PolymorphismSequenceContainer.h>

#include <Bpp/Numeric/VectorTools.h>

#include <unistd.h>
#include <cstdlib>
#include <cmath>
#include <iostream>


using namespace std;
using namespace bpp;



/**************************************************************************************/

unsigned int totNumberSiteWhitoutGap(const PolymorphismSequenceContainer & psc) {
   unsigned int tnm = 0;
   CompleteSiteContainerIterator * si = new CompleteSiteContainerIterator(psc);
   while (si->hasMoreSites()) {
     tnm ++;
   }
   delete si;
   return tnm;
 }
/***********************************************************************************/
int main (int argc, char* argv[]){
try{
    
if (argc == 1 || argc < 7)
{
  cout << "seq_stat -seq [seq_name] -f [format : phylip or fasta] -o [out file]" << endl;
  
	cout << "### Statistics :" << endl;
	cout << "  Size : Size of the alignment (bp)" << endl;
	cout << "  S_Pop : Number of polymorphic site" << endl;
	cout << "  Pi_Pop : Tajima's estimator of nucleotides diversity" << endl;
	cout << "  W_Pop : Watterson's estimator of nucleotides diversity" << endl;
	cout << "  D_Pop : Tajima's D" << endl;
	cout << "  gc : GC content" << endl;
	cout << "####################\nPlease cite Bio++ ( http://biopp.univ-montp2.fr/ ;  Guéguen et al. 2013 MBE) if you use this program )\n" << endl;
	return 0;
}
string nomfic, format, outF;


int i = 1;
while (i < argc){
	string s = argv[i];
	if (s == "-seq")	{
		i++;
		if (i == argc) 	{
			cerr << "error in command: seq <listFile>\n";
			cerr << '\n';
			exit(1);
		}
		nomfic = argv[i];
	}
	if (s == "-f")	{
		i++;
		if (i == argc) 	{
			cerr << "error in command: -f <phylip or fasta>\n";
			cerr << '\n';
			exit(1);
		}
		format = argv[i];
	}
	if (s == "-o")	{
		i++;
		if (i == argc) 	{
			cerr << "error in command: -o <outFile>\n";
			cerr << '\n';
			exit(1);
		}
		outF = argv[i];
	}
	i++;
}

ifstream Filelist (nomfic.c_str(), ios::in);
ofstream Fileout (outF.c_str(), ios::out);

if(!FileTools::fileExists( nomfic )) {
  cerr << "ERROR!!! File " << nomfic << " does not exists." << endl;
  exit(-1);
}

const NucleicAlphabet * alpha = new DNA();

SequenceContainer * seqCont = NULL;

Phylip * PhySeq = new Phylip(true, true);
Fasta * FstSeq = new  Fasta;

if(format == "phylip"){
  seqCont = PhySeq->readAlignment(nomfic , alpha);
}
if(format == "fasta"){
  seqCont = FstSeq->readAlignment(nomfic , alpha);
}


VectorSiteContainer *sitec = new VectorSiteContainer(* seqCont );
PolymorphismSequenceContainer * psc = new PolymorphismSequenceContainer( *sitec);

double gc, S, Pi, W, TajimaD;
unsigned int Size;
gc = SequenceStatistics::gcContent(*psc);
Size = psc->getNumberOfSites();
S = SequenceStatistics::numberOfPolymorphicSites( *psc, false );
cout << "here" << endl;
Pi = SequenceStatistics::tajima83(*psc, false);
W = SequenceStatistics::watterson75(*psc, false );
		

if(S > 0)
	TajimaD =  SequenceStatistics::tajimaDss( *psc, false );
else
	TajimaD = -999.0;


Fileout << "name\tSize\tS_Pop\tPi_Pop\tW_Pop\tD_Pop\tgc" << endl;
Fileout << nomfic << "\t" << Size << "\t" << S << "\t" << Pi << "\t" << W  << "\t"<< TajimaD << "\t" << gc << endl;
	

delete alpha;
delete sitec;
delete seqCont;

}
catch(exception & e){
  cout << e.what() << endl;
    }
return 0;
}
