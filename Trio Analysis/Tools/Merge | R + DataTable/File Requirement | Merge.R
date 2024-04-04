source("packages.R")
source("input.R")

# MERGE

cols <- fread(columns_path, stringsAsFactors=F)
MAFCol <- fread(MAF_path, stringsAsFactors=F)

cols[, V6 := MAFCol]
cols[, V7 := as.integer(sub("chr(\\d+).*","\\1",V1))]
cols[, V8 := paste0(V1,":",V2,"_",V4,"/",V5)]
cols[, SNP := ifelse(V3 == ".", V8, V3)]
colnames(cols) <- c("CHROM","POS","rsID", "REF", "ALT", "MAF", "CHR", "VAR", "SNP")

results <- fread(results_path, stringsAsFactors=F)
chr <- merge(cols, results, by='SNP')

# ORDER

chr[, CHROM := factor(CHROM, levels = paste0("chr", 1:22))]
sorted_DataTable <- chr[order(CHROM, POS)]

# DIVIDE

unique_chromosomes <- unique(sorted_DataTable$CHROM)

for (chromosome in unique_chromosomes) {
  chrom_data <- sorted_DataTable[sorted_DataTable$CHROM == chromosome, ]
  filename <- paste0(id_path, "-", chromosome, "-results.txt")
  fwrite(chrom_data, filename, sep = "\t", quote = FALSE)
}
