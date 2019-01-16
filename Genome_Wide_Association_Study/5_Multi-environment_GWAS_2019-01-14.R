
#Set working directory
setwd('.')
rm(list = ls())


#Create a function to run chromosomes in parallel (6 cores)
parKinsh <- function(i, int) {
  #Set working directory inside each core
  setwd('.')
  
  #Load ASREML
    library(asreml)
  
  #Set minor allele frequency filter
    maf2<-'05'

  #import PCs for population structure (a different Kinship for each chromosome)
    kin<-read.table(paste0('PCKinship/Kinship',int$ch[i],int$part[i],'.csv'), head=T, sep=',')
    head(kin)
    
  #Import genotypic data (SNP)
    haplo<-read.table(paste0('Scores/Scores',int$ch[i],int$part[i], 'maf',maf2,'imputed.csv'), 
                      head=T, sep=',', row.names=1)
    haplo<-t(as.matrix(haplo))
    nH<-ncol(haplo)
    
    #------------------------------------------------------------------
    #			GWAS
    #------------------------------------------------------------------
    
    #Define the vector of traits to be analyzed
    traits<-c('Height')
    
    #Create an empty data frame to store results
    pval<-data.frame(snp=colnames(haplo),
                     Heading=rep(NA, ncol(haplo)),Height=rep(NA, ncol(haplo)),
                     WaldHeading=rep(NA, ncol(haplo)),WaldHeight=rep(NA, ncol(haplo)), 
                     log10Heading=rep(NA, ncol(haplo)),log10Height=rep(NA, ncol(haplo)),
                     df=rep(NA, ncol(haplo)))

    #Loop over the traits
    for (t in traits) {
      #import phenotypes 
      phenot<-read.csv('Phenotypes2017-10-27.csv', 
                       head=T, sep=',')

      #select phenotypes
      phenot<-subset(phenot,trait==t)
      phenot$Env<-factor(phenot$Env)
      nE<-length(levels(phenot$Env))

      #append marker scores to match the lenght of the phenotypes
      haplo2<-do.call("rbind", replicate(nE, haplo, simplify = FALSE))
      
      #append the PC scores to match the lenght of the phenotypes
      k<-do.call("rbind", replicate(nE, kin, simplify = FALSE))

      #single QTL-multi-env model
      p<-data.frame(Env=phenot$Env,geno=phenot$geno,K1=k$PC1,K2=k$PC2,K3=k$PC3,
                    K4=k$PC4, pheno=phenot$pheno)

      haplo2<-as.data.frame(haplo2)
      rownames(haplo2) <- c()
      data.df<-cbind(p,haplo2)

      #Fit the model to each SNP
      for (s in c(8:ncol(data.df))) {
        #start.time <- Sys.time()
        gwas <- asreml(fixed=pheno~Env+K1+K2+K3+K4+
                Env:K1+Env:K2+Env:K3+Env:K4+Env:K1+data.df[,s]:Env, random=~geno,
                data=data.df, rcov=~at(Env):units,maxit=30, workspace=2e+08)

        #Store the p-values
        pval[s-7,t]<-wald(gwas)[11,4]
        pval[s-7,paste0('Wald',t)]<-wald(gwas)[11,3]
        pval[s-7,'df']<-wald(gwas)[11,1]
        pval[s-7,paste0('log10',t)]<-log10(wald(gwas)[11,4])*-1
        
        # end.time <- Sys.time()
        # time.taken <- end.time - start.time
        # time.taken
      }
    }
    
    #Export pvalues
    write.table(pval,paste0('Pvalues',int$ch[i],int$p[i], 'maf',maf2,'imputedwaldKspecific.csv'),
                sep=',', row.names=F)
}


#Create a data frame with chromosome names
int<-data.frame(ch=rep(c(1:4),3),part=c(rep('A',4),rep("B",4),rep("D",4)) )
int


#Run in parallel
library(snowfall)
sfInit(parallel = TRUE, cpus = 6)

a <- sfLapply(
  seq(length = nrow(int)), 
  parKinsh, int)
sfStop()




