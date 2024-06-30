# Ruczinski Lab
## Johns Hopkins School of Public Health, Biostatistics Department

*A custom cloud analysis to identify sex-specific effects in genetic loci underlying orofacial cleft risk.*

*Here is a link to videos that outline the key fundamentals for Docker, Tools, Workflows, and Tasks: https://biostat.jhsph.edu/~iruczins/cavatica/*

 ---


### Lab Members

     Ingo Ruczinski (PI)
     Kanika Kanchan (Post-Doctoral Researcher)
     Seth Berke (Research Assistant)

### Apps:

<table>
<tr><td>

Command Line Tools | Workflows
--|--
16 | 2 

</td></tr> 
</table>

-----
## QC:

***Basic QC:*** a tool that filters based on proper number of alleles and depth reading.

-----

***PLINK File Creation:*** a tool that creates binary PLINK files from a vcf file.

-----

***Summary Stats:*** a tool that outputs summary statistics important for assessing high missingness in samples

-----

***Variant Filtering Creation:*** a tool that filters on the variant level for missingness, minor allele frequency, and Hardy-Weinberg Equilibrium.

-----

***Mendelian Error:*** a tool that filters outputs mendelian error statistics.

-----

***LD Pruning Part 1:*** a tool that prunes LD blocks.

-----

***LD Pruning Part 2:*** a tool that creates PLINK files based on pruned files.

-----

***PLINK File Merge:*** a tool that merges pruned files.

-----

***Heterozygosity:*** a tool that creates a .het file.

-----

***IBS:*** a tool that creates a .genome file to check for relatedness.

-----

***Quality Control:*** a workflow that identifiers samples to be dropped during trio analysis.

-----

## Trio:

***QC Filters:*** a tool that filters SNPs based on minor alleles, missingness, and HWE.

-----

***Column Extraction:*** a tool that extracts the first five columns of a vcf file (%CHROM %POS %ID %REF %ALT).

-----

***gTDT:*** a tool that provides statistics on GxE interaction term for trio data.

-----


***MAF Percentage:*** a tool that derives allele information and frequencies from vcf files.

-----

***MAF Column Creation:*** a tool that outputs the MAF for the SNPs.

-----

***Merge:*** a tool that combines SNP information and gTDT results.

-----

***Trio Pipeline .vcf:*** a workflow that combines the above tools to yield GxE values for trio data.
