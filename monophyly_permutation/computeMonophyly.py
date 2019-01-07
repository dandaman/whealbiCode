import sys
import matplotlib.pyplot as plt
from random import shuffle

def checkNbLbl( clade , Ltolbl ):
    labels = { Ltolbl[ l ] for l in clade }
    labels.discard("NA")
    labels.discard("na")
    labels.discard("UNK")
    return len(labels)

def permuteLbl( LtoLbl ):
    newDic = {}

    newLbls = [l for l in  LtoLbl.values()]
    shuffle( newLbls )
    for i,k in enumerate( LtoLbl.keys() ):
        newDic[ k ] = newLbls[i]
    return newDic

def computePropMonophyly( cladeList , LtoLbl ):
    Nmono = 0.
    for c in cladeList:
        n = checkNbLbl( c , LtoLbl )
        if n == 1:
            Nmono += 1.
    return Nmono / len(cladeList)

def makePermutation( cladeList , LtoLbl ):
    permutedLbls = permuteLbl( LtoLbl )
    return computePropMonophyly( cladeList , permutedLbls )




if __name__ == "__main__":

    help = """
    Takes:
    * file containing clades
    * file associating leaf names to characters
    * name of the column to use for label in the second file
    [* number of permutations to perform (default is 0]
    [* output file name ]
    Will write clades number of different characters
    in a file called <clade T>.<column name>.nbCat.txt
    """
    if len(sys.argv) < 4:
        print help
        exit(1)


    nbPermut = 0
    if len(sys.argv)>4 :
        nbPermut = int(sys.argv[4])


    IN = open(sys.argv[1],"r")
    C = []
    l = IN.readline()
    while l !="":
        sl = l.strip().split(";")
        C.append(sl)
        l = IN.readline()
    IN.close()


    IN = open(sys.argv[2],"r")
    l = IN.readline()
    sep = "\t"
    if l.count(sep) < l.count(";"):
        sep = ";"


    header = l.strip().split(sep)

    Cname = sys.argv[3]
    Cindex = -1
    for i,e in enumerate(header):
        #print e,Cname
        if e == Cname:
            Cindex = i
            break
    if Cindex == -1:
        print "Error : column", Cname , "not found."
        print "Header :",header
        exit(1)

    Ltolbl = {}

    l = IN.readline()
    while l !="":
        sl = l.strip().split(sep)
        Ltolbl[ sl[0] ] = sl[ Cindex ]
        l = IN.readline()

    IN.close()


    if nbPermut == 0:
        OUT = open( sys.argv[1] + "." + Cname.replace(" ","_") + ".nbCat.txt","w")
    
        L = []
    
        for c in C:
            n = checkNbLbl( c , Ltolbl )
            L.append(n)
            OUT.write( str(n) + "\n" )
        OUT.close()


        #plt.hist(L, bins = range(10))
        #plt.show()

    if nbPermut>0:

        Pmono = computePropMonophyly( C , Ltolbl )
        print "proportion of monophyletic : " , Pmono
        
        OF = sys.argv[1] + "." + Cname.replace(" ","_") + ".PermutsPmonophyletic.txt"
        if len(sys.argv)>5:
            OF = sys.argv[5]

        OUT = open( OF ,"w")       
    
        Permuts = []
        nbUnder = 0.
        while len(Permuts) < nbPermut:
    
            x = makePermutation( C , Ltolbl )
            Permuts.append(x)
            if x < Pmono:
                nbUnder += 1.
    
            OUT.write(str(x) + "\n")

        print "original data shows more monophyletic clades than", nbUnder, "(",nbUnder/nbPermut,")","permutations."

        #plt.hist(Permuts,bins=[i/50. for i in range(50)], color='c', edgecolor='k', alpha=0.65)
        #plt.axvline(Pmono, color='k', linestyle='dashed', linewidth=1)
        #plt.show()

