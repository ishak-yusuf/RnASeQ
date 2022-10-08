# load libraries
library(DESeq2)
library(tidyverse)

# load the file
featurecount <- read.csv(snakemake@input[[1]], header = TRUE, row.names = 1)

metadata <- read.csv(snakemake@input[[2]], header = TRUE, row.names = 1)

dds <- DESeqDataSetFromMatrix(countData = featurecount,
                                    colData = metadata,
                                    design = ~ condition)

keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

dds$condition <- relevel(dds$condition, ref = "control")

dds <- DESeq(dds)
output <- results(dds,
               contrast = c("condition", "case", "control"),
               alpha = 0.05)

#clean data
outputdf <- data.frame(output)
thresholdf <- data.frame(outputdf) %>% mutate(threshold = padj < 0.05)

thresholdf$regulation <- ifelse(thresholdf$threshold == 'FALSE', 'FALSE', ifelse(thresholdf$threshold == 'TRUE' & thresholdf$stat > 0 , 'Upregulation', 'Downregulation'))

thresholdf$threshold <- c()

write.csv(thresholdf,snakemake@output,row.names = FALSE)