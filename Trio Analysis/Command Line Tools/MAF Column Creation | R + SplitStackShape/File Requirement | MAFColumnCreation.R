source("packages.R")
source("input.R")
  
dt <- data.table(
  "CHROM" = character(0),
  "POS" = numeric(0),
  "N_ALLELES" = numeric(0),
  "N_CHR" = numeric(0),
  "Ref" = character(0),
  "Ref_Frq" = numeric(0),
  "Alt" = character(0),
  "Alt_Frq" = numeric(0),
  "MAF" = numeric(0),
  "SNP" = character(0)
)

fp <- MAF_info_path

chr <- fread(fp, stringsAsFactors = FALSE, header = FALSE)
chr <- cSplit(chr, c('V5', 'V6'), sep = ":")
colnames(chr) <- c("CHROM", "POS", "N_ALLELES", "N_CHR", "Ref", "Ref_Frq", "Alt", "Alt_Frq")
chr[, 'MAF' := ifelse(Alt_Frq > 0.50, 1 - Alt_Frq, Alt_Frq)]
chr[, 'SNP' := paste0(CHROM, ":", POS, "_", Ref, "/", Alt)]
dt <- rbind(dt, chr)

dtMAF <- chr[, .(MAF)]

write.table(dtMAF, "dtMAF.txt", row.names = FALSE, col.names = FALSE, sep = "\t", quote = FALSE)
