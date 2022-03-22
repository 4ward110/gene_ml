library(KEGGprofile)
library(STRINGdb)
# read geneID file mapping with 108 gene name
x <- read.csv("C:\\Users\\vuduc\\Differential_Expression_gene\\i2rlab-rdea-40496506d299\\mart_export.csv", header = TRUE)

# Get ID column
x[,"ID"]

# Cvt to character
x <- as.character(x)

#find_enriched pathway
keeg_res <- find_enriched_pathway(x, species = 'hsa', returned_pvalue = 0.01, returned_adjpvalue = 0.05, returned_genenumber = 1, download_latest = TRUE)
keeg_res$stastic
keeg_res$detail[["04114"]]

#visualize pathway

# visualize DEG
# construct db for mapping gene from 108 deg with database GSE9606 
string_db <- STRINGdb$new(version="11.5", species=9606, score_threshold=200, input_directory="C:\\Users\\vuduc\\Differential_Expression_gene\\i2rlab-rdea-40496506d299")
# Note: before next step: construct a data.frame gene_diff_data contains 3 column pvalue,logFC,gene from 108 genes
head(gene_diff_data.df)

#using map func adds an addition column with STRING identifies to the dataframe that is passed as first parameter
example1_mapped <- string_db$map(gene_diff_data.df,"gene", removeUnmappedRows = TRUE)

# extract most significant 108 genes and produce image of network
hits <- example1_mapped$STRING_id[1:108]
string_db$plot_network( hits )