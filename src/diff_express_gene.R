#Limma for differentially expressed genes with Benjamin Hochberg method
library(limma)
library(edgeR)
library(ggrepel)
#read phenotype data
p <- read.csv("C:\\Users\\vuduc\\Differential_Expression_gene\\i2rlab-rdea-40496506d299\\p.csv",header = TRUE)

# add design matrix
design <- model.matrix(~er, data = p)

#test design matrix
head(design,2)
dim(design)
colSums(design)
table(p[,"er"])

# Construct limma pipeline

#read expression data
x <- read.csv("C:\\Users\\vuduc\\Differential_Expression_gene\\i2rlab-rdea-40496506d299\\x.csv", header = TRUE)

# fit to linear model
fit <- lmFit(x, design)

# calculate the t-statistics
fit <- eBayes(fit)

# Summarize results
result <- decideTests(fit[,"er"])

#Note: up-regulate gene is gene with expression of non-survival higher than expression of these gene in suvival sample

#export 108 differential expression gene
kq <- topTable(fit,coef = NULL,number = 109, genelist = fit$genes, adjust.method = "BH", sort.by = "M", p.value=0.05, lfc=log2(1.5))
kq 
write.csv(kq,"C:\\Users\\vuduc\\Differential_Expression_gene\\i2rlab-rdea-40496506d299\\gene_diff_data.csv")

