source("packages.R")
source("input.R")

    fullchr <- data.table("SNP"=character(0),"Coef_GxE"=numeric(0),	"RR_GxE"=numeric(0),	"Lower_GxE"=numeric(0),	"Upper_GxE"=numeric(0), "SE_GxE"=numeric(0),	"Stat_GxE"=numeric(0),	"pval_GxE"=numeric(0),	"Trios0"=numeric(0), "Trios1"=numeric(0),	"Coef_G"=numeric(0),	"RR_G"=numeric(0),	"Lower_G"=numeric(0),	"Upper_G"=numeric(0),	"SE_G"=numeric(0),	"Stat_G"=numeric(0),	"pval_G"=numeric(0),	"RR_G&E"=numeric(0),	"Lower_G&E"=numeric(0),	"Upper_G&E"=numeric(0),	"Stat_LRT2df"=numeric(0),	"pval_LRT2df"=numeric(0),	"Stat_Wald2df"=numeric(0),	"pval_Wald2df"=numeric(0),	"Stat_LRT1df"=numeric(0),	"pval_LRT1df"=numeric(0))
    
    param <- ScanVcfParam(geno = "GT")
    
    vcf <- readVcf(vcf_path, "hg38", param = param)
    
    ped <- fread(ped_path)
    
    trio <- vcf2geno(vcf,ped, none = "0/0", one = "0/1", both = "1/1", na.string = "./.", use.rownames = FALSE, allowDifference = FALSE, removeMonomorphic = TRUE, removeNonBiallelic = TRUE, changeMinor = FALSE)
    
    sex <- fread(sex_path)
    
    sex <- sex[,2]
    
    sex <- as.numeric(unlist(sex))-1
    
    gxe.out <- colGxE(trio, sex)
    
    df <- getGxEstats(gxe.out, top=NA)

    dt <- setDT(df, keep.rownames = T)

    colnames(dt) <- c("SNP", "Coef_GxE", "RR_GxE", "Lower_GxE", "Upper_GxE", "SE_GxE", "Stat_GxE", "pval_GxE", "Trios0", "Trios1", "Coef_G", "RR_G", "Lower_G", "Upper_G", "SE_G", "Stat_G", "pval_G", "RR_G&E", "Lower_G&E", "Upper_G&E", "Stat_LRT2df", "pval_LRT2df", "Stat_Wald2df", "pval_Wald2df", "Stat_LRT1df", "pval_LRT1df")

    fullchr <- rbind(fullchr, dt)

    write.table(fullchr, paste0("gTDTresults",".txt",sep=""), row.names=F, col.names = T, sep="\t", quote=F)
    
q(save="no")
