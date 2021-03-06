## Redirect R error handling to stderr.
options(show.error.messages=F, error=function(){cat(geterrmessage(), file=stderr());q("no",1,F)})
## Avoid crashing Galaxy with a UTF8 error on German LC settings.
loc <- Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")

#print("Converting to sparse matrix and saving as RDS file...")
## Load required libraries without seeing messages
suppressPackageStartupMessages({

library(Matrix)
library(data.table)

})

## Read in salmon alevin matrix output

# save as sparse matrix
alevin_matrix <- as.matrix(read.csv("./alevin_output/alevin/quants_mat.csv", header = FALSE))
genes <- readLines("./alevin_output/alevin/quants_mat_cols.txt")
barcodes <- readLines("./alevin_output/alevin/quants_mat_rows.txt")

alevin_matrix <-  t(alevin_matrix[,1:ncol(alevin_matrix)-1])
alevin_matrix[is.na(alevin_matrix)] <- 0
alevin_matrix  <- Matrix(alevin_matrix, sparse = T )

## Print output and save according to seurat-script pipeline
## Copied directly from (https://github.com/ebi-gene-expression-group/r-seurat-scripts/blob/develop/seurat-read-10x.R)
# Use the default show method to print feedback

printSpMatrix2(alevin_matrix, note.dropping.colnames = FALSE, maxp = 500)

# Output files for matrix.mtx, genes and barcodes

writeMM(alevin_matrix, file = "matrix.mtx")
write.table(barcodes, file ="barcodes.tsv", col.names =FALSE, row.names = FALSE, quote = FALSE, sep="\t")
write.table(genes, file ="genes.tsv", col.names =FALSE, row.names = FALSE, quote = FALSE, sep="\t")


#saveRDS(alevin_matrix, file = "./salmon_alevin_matrix.RDS")

print("Done converting matrix!")
