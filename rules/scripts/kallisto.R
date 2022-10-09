# packages
library(tidyverse)
library(tximport)
library(edgeR)
library(limma)
library(matrixStats)

targets <- read.csv(snakemake@input[['metadata']], header = TRUE, row.names = 1)

path <- file.path(row.names(targets), "abundance.tsv") # set file paths to your mapped data

Txi_gene <- tximport(path,
                     type = "kallisto",
                     txOut = T, #determines whether your data represented at transcript or gene level
                     countsFromAbundance = "lengthScaledTPM",
                     ignoreTxVersion = TRUE)

#Log2 Counts per Million (CPM), unfiltered, non-normalized
sampleLabels <- row.names(targets)
myDGEList <- DGEList(Txi_gene$counts)
log2.cpm <- cpm(myDGEList, log=TRUE)
log2.cpm.df <- as_tibble(log2.cpm, rownames = "geneID")

#Log2 Counts per Million (CPM), filtered, non-normalized
cpm <- cpm(myDGEList)
keepers <- rowSums(cpm>1)>= count(targets$condition == 'case') #user defined
myDGEList.filtered <- myDGEList[keepers,]
log2.cpm.filtered <- cpm(myDGEList.filtered, log=TRUE)
log2.cpm.filtered.df <- as_tibble(log2.cpm.filtered, rownames = "geneID")

#Log2 Counts per Million (CPM), filtered, TMM normalized
myDGEList.filtered.norm <- calcNormFactors(myDGEList.filtered, method = "TMM")
log2.cpm.filtered.norm <- cpm(myDGEList.filtered.norm, log=TRUE)
log2.cpm.filtered.norm.df <- as_tibble(log2.cpm.filtered.norm, rownames = "geneID")
colnames(log2.cpm.filtered.norm.df) <- c("geneID", sampleLabels)

group <- factor(targets$condition)
design <- model.matrix(~0 + group)
colnames(design) <- levels(group)

v.DEGList.filtered.norm <- voom(myDGEList.filtered.norm, design, plot = F)
fit <- lmFit(v.DEGList.filtered.norm, design)
contrast.matrix <- makeContrasts(infection = case - control,
                                 levels=design)

fits <- contrasts.fit(fit, contrast.matrix)
ebFit <- eBayes(fits)
myTopHits <- topTable(ebFit, adjust ="BH", coef=1, number= 999999999, sort.by="logFC")
myTopHits.df <- myTopHits %>%
  as_tibble(rownames = "geneID")

thresholdf <- data.frame(myTopHits.df) %>% mutate(threshold = adj.P.Val < 0.05)

thresholdf$regulation <- ifelse(thresholdf$threshold == 'FALSE', 'FALSE', ifelse(thresholdf$threshold == 'TRUE' & thresholdf$logFC > 0 , 'Upregulation', 'Downregulation'))

thresholdf$threshold <- c()

write.csv(thresholdf, paste(snakemake@output))
