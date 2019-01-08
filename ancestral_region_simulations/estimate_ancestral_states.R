
library(ape)
library(phytools)

##
## made with the help of https://lukejharmon.github.io/ilhabela/instruction/2015/07/03/ancestral-states-2/
##


NSIM = 10000 ### VERY long

lbl = read.table("speciesOrigin.csv",header=TRUE,sep=";")
LAND = lbl$REGION
names(LAND) = lbl$SERIAL

#all non unkown origin
tree = read.tree("Taestivum.allGenes.noUNKorigin.nwk")
countryLabel = LAND[ tree$tip.label ]


lbl = read.table("../monophyly_permutation/Sup_487samples.csv",header=TRUE,sep="\t",comment.char="")
GROWTHHABIT = lbl$Growth.habit
names(GROWTHHABIT) = lbl$Whealbi.serial.number

CATEGORY = lbl$Group
names(CATEGORY) = lbl$Whealbi.serial.number

HabitLabel = GROWTHHABIT[ tree$tip.label ]
CategoryLabel = CATEGORY[ tree$tip.label ]



#Region simulation

mtrees<-make.simmap(tree,countryLabel,model="ER",nsim=NSIM)
pd<-describe.simmap(mtrees,plot=F)

saveRDS(pd, paste( "ancestral_simul.","Region.", toString(NSIM) ,".pd",".object" , sep="" ) )
saveRDS(mtrees, paste( "ancestral_simul.","Region.", toString(NSIM) ,".mtrees",".object" , sep="" ) )


### to plot the simulations:
##
##cols<-setNames(palette()[1:length(unique(countryLabel))],sort(unique(countryLabel)))
##
##plotSimmap(mtrees,cols,type="fan",fsize=0.8,ftype="i")
##
##tiplabels(pie=to.matrix(countryLabel,sort(unique(countryLabel))),piecol=cols,cex=0.3)
##
##add.simmap.legend(colors=cols,prompt=FALSE,x=0.9*par()$usr[1],
##    y=-max(nodeHeights(tree)),fsize=0.8)

