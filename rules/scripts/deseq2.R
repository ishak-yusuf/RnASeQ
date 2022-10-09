# load libraries
library(DESeq2)
library(tidyverse)

# load the file
featurecount <- read.csv(snakemake@input[['featureCount']], header = TRUE, row.names = 1, sep= '\t')

metadata <- read.csv(snakemake@input[['metadata']], header = TRUE, row.names = 1)

fc <- select(featurecount, c(rownames(metadata)))



dds <- DESeqDataSetFromMatrix(countData = fc,
                                    colData = metadata,
                                    design = ~ condition)

keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

dds <- DESeq(dds)


output <- results(dds,
               contrast = c("condition", "case", "control"),
               alpha = 0.05)

#clean data
outputdf <- data.frame(output)
thresholdf <- data.frame(outputdf) %>% mutate(threshold = padj < 0.05)

thresholdf$regulation <- ifelse(thresholdf$threshold == 'FALSE', 'FALSE', ifelse(thresholdf$threshold == 'TRUE' & thresholdf$stat > 0 , 'Upregulation', 'Downregulation'))

thresholdf$threshold <- c()

write.csv(thresholdf, paste(snakemake@output))
