library(cn.mops)
library(GenomeInfoDb)

args = commandArgs(trailingOnly=TRUE)
bamFile_dir <- args[1]
output_path <- args[2]
sex <- args[3]
winSize <-args[4]
winSize <- as.numeric(winSize)

bamName <- list.files(bamFile_dir,pattern = '*.bam$')
bamFile <- file.path(bamFile_dir,bamName)


chrs= c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22")
sex_chr=""
CN=""

if(sex == "female"){
	sex_chr = 'chrX'
	CN=c(0.025,0.5,1,1.5,2,2.5,3,3.5,4)
}else if(sex == "male"){
	sex_chr = c('chrX','chrY')
	CN=c(0.025, 1, 2, 3, 4, 5, 6, 7, 8)
}else{
	print('sex flag entered incorrectly')
	exit
}

bamDataRanges <- getReadCountsFromBAM(bamFile,refSeqNames=chrs,parallel=3,WL=winSize)
str(bamDataRanges)
res <- cn.mops(bamDataRanges,returnPosterior=TRUE)
resCNMOPS <- calcIntegerCopyNumbers(res)
CNVs <- as.data.frame(cnvs(resCNMOPS))

X.bamDataRanges <- getReadCountsFromBAM(bamFile,refSeqNames=sex_chr,parallel=3,WL=winSize)
str(X.bamDataRanges)
X.res <- cn.mops(X.bamDataRanges,returnPosterior=TRUE,I=CN)
X.resCNMOPS <- calcIntegerCopyNumbers(X.res)
X.CNVs <- as.data.frame(cnvs(X.resCNMOPS))

combine.CNVs<- rbind(CNVs,X.CNVs)
write.table(combine.CNVs,file=output_path,quote=FALSE,sep="\t",row.names = FALSE)
