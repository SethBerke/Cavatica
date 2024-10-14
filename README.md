# Ruczinski Lab
## Johns Hopkins School of Public Health, Biostatistics Department

*A custom cloud analysis to identify sex-specific effects in genetic loci underlying orofacial cleft risk.*

*Here is a link to videos that outline the key CAVATICA fundamentals for Project Spaces, Docker, Tools, Workflows, and Tasks: https://biostat.jhsph.edu/~iruczins/cavatica/*

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
19 | 2 

</td></tr> 
</table>

-----
## QC:

### Tools

***Basic QC:*** Removing multi-allelic sites and indels, filtering sites with labels other than ‘PASS’, and removing variants and individual genotypes with low mean depth and low quality scores. The input is the multi-sample VCF file released by the sequencing center containing all complete trios. The cleaned output file is used in the subsequent calculation of other QC statistics and also as input for the gTDT analysis pipeline. 

-----

***PLINK File Creation:*** Creating binary PLINK files (.bed, .bim and .fam) for the QC steps for this family-based association study.

-----

***Summary Stats:*** Calculating variant statistics such as missing genotype calls per variant across all samples, and variant MAF and HWE. Variants that exhibit high genotype missingness, low MAF, or are significantly out of HWE are not included in the association analysis. Also calculating percent missing genotype calls for each sample. The output .lmiss and .imiss files contain the information to determine which samples are dropped due to their high genotype missingness.

-----

***Variant Filtering:*** Generating updated PLINK files filtered on variant missingness, MAF and HWE. 

-----

***Update IIDs:*** Updating binary PLINK files with the correct individual IDs for each participant.

-----

***Update Pedigree Information:*** Updating binary PLINK files with the correct famlial relationships and genders.

-----

***Drop Samples:*** dropping trios that have participants with high missigness values.

-----

***Mendelian Error:*** Calculating the percentage of Mendelian errors in the trios (proband genotypes that are incompatible with parental genotypes under Mendelian inheritance, assuming no de novo events) and generating a list of trios to be dropped from the gTDT analysis due to high error rates.

-----

***LD Pruning Part 1:*** Deriving a list of variants from the PLINK files to be kept based on LD Structure.

-----

***LD Pruning Part 2:*** Creating pruned binary PLINK files from LD block information for subsequent quality control.

-----

***Update SNP IDs:*** Updating '.' SNPs with new IDs based on chr and position for proper downstream merging.

-----

***PLINK File Merge:*** Merging together pruned single-chromosome PLINK files into a whole-genome merged file.

-----

***Heterozygosity:*** Calculating sample SNP heterozygosity rates to detect potential issues such as sample contamination.

-----

***IBS:*** Calculating identity-by-state estimates between pairs of samples to verify relatedness as given in the pedigree files.

-----
### Workflows

***Quality Control:*** Basic variant filtering for gzVCFs and identifying samples to be dropped during the gTDT case-parent trio analysis.

-----

## Trio:

### Tools

***Variant Level QC:*** Reading the VCFs generated after basic QC, removing the trios failing QC, updating variant statistics (missingness, MAF and HWE) after removing these trios, and removing variants based on these updated statistics.

-----

***gTDT:*** Executing the gTDT with an interaction term as implemented in the trio Bioconductor package. For this sex-specific case-parent trio analysis, the tool also reads the sex and pedigree information available in the provided metadata helper files. 

-----

***MAF Percentage:*** Deducing the minor allele frequencies from parental genotypes.

-----

***Column Extraction:*** Extracting SNP information using BCFTools for the final results output file, including chromosome, genomic position, rs number, REF and ALT alleles.

-----

***MAF Column Creation:*** Selecting either the REF or ALT allele as the minor allele based on observed allele frequencies, and creating the MAF column for the output file. 

-----

***Merge:*** Merging all pieces of information into the final results output file.

-----
### Workflows

***Trio Pipeline .vcf:*** Combining the above tools to yield GxE values for case-parent trio data.
