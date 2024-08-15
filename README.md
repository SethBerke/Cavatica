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

### Tools

***Basic QC:*** Removing multi-allelic sites and indels, filtering sites with labels other than ‘PASS’, and removing variants and individual genotypes with low mean depth and low quality scores. The input is the multi-sample VCF file released by the sequencing center containing all complete trios. The cleaned output file is used in the subsequent calculation of other QC statistics and also as input for the gTDT analysis pipeline. 

-----

***PLINK File Creation:*** Creating binary PLINK files (.bed, .bim and .fam) to integrate the pedigree information into the QC steps for this family-based association study.

-----

***Summary Stats:*** Calculating variant statistics such as missing genotype calls per variant across all samples, and variant MAF and HWE. Variants that exhibit high genotype missingness, low MAF, or are significantly out of HWE are not included in the association analysis. Also calculating percent missing genotype calls for each sample. The output .lmiss and .imiss files contain the information to determine which samples are dropped due to their high genotype missingness.

-----

***Variant Filtering Creation:*** Generating updated PLINK files after removing trios with at least one sample showing high genotype missingness, and filtered on variant missingness, MAF and HWE. The input file "Drop High Missingness Samples.txt" was derived from the .lmiss and .imiss files.

-----

***Mendelian Error:*** Calculating the percentage of Mendelian errors in the trios (proband genotypes that are incompatible with parental genotypes under Mendelian inheritance, assuming no de novo events) and generating a list of trios to be dropped from the gTDT analysis due to high error rates.

-----

***LD Pruning Part 1:*** Deriving LD blocks of SNPs from the PLINK files, to be used in the following pruning step.

-----

***LD Pruning Part 2:*** Creating pruned binary PLINK files from LD block information for subsequent quality control.

-----

***PLINK File Merge:*** Merging together pruned single-chromosome PLINK files into a whole-genome PLINK file.

-----

***Heterozygosity:*** Calculating sample SNP heterozygosity rates to detect potential issues such as sample contamination.

-----

***IBS:*** Calculating identity-by-descent estimates between pairs of samples to verify relatedness as given in the pedigree files.

-----
### Workflows

***Quality Control:*** Cleaning gzVCFs and identifying samples to be dropped during trio analysis.

-----

## Trio:

### Tools

**Variant Level QC:*** Reading the VCFs generated after basic QC, removing the trios failing QC, updating variant statistics (missingness, MAF and HWE) after removing these trios, and removing variants based on these updated statistics.

-----

***gTDT:*** Executing the gTDT with a interaction as implemented in the trio Bioconductor package. For this sex-specific case-parent trio analysis, the tool also reads the sex and pedigree information available in the metadata. 

-----

***MAF Percentage:*** Extracting the MAF information for the output file.

-----

***Column Extraction:*** Extracting information using BCFTools for the final results output file, including chromosome, genomic position, rs number, REF and ALT alleles.

-----

***MAF Column Creation:*** Selecting either the REF or ALT allele as the minor allele based on observed allele frequencies, and creating the MAF column for the output file. 

-----

***Merge:*** Merging all pieces of information into the final results output file.

-----
### Workflows

***Trio Pipeline .vcf:*** Combining the above tools to yield GxE values for trio data.
