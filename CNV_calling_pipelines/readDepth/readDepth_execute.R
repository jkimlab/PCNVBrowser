library("readDepth")

setwd("./tmp")

rdo1 = new("rdObject")
rdo2 = readDepth(rdo1)
rdo3 = rd.mapCorrect(rdo2)
rdo4 = rd.gcCorrect(rdo3)

##drop the last window from each chr
##convert rd to log2 score, make a big list
segs = rd.cnSegments(rdo3, minWidth=3)
writeSegs(segs)
writeAlts(segs,rdo3)
writeThresholds(rdo3)
