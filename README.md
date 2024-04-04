# Dr. Ruczinski Lab
## Johns Hopkins School of Public Health, Biostatistics Department

*A Custom Cloud Analysis to identify Sex-Specific differences in Genetic Loci correlated with Orofacial Clefts.*

*Here is a link to videos that outline key steps in Tool, Workflow, and Task Creation & Execution: *

 ---


### Lab Members

     Ingo Ruczinski (PI)
     Kanika Kanchan (Post-Doctoral Researcher)
     Seth Berke (Student)

-----
### i/o qc

     Input:
     - multi-sample, raw single chromosome with complete trios .vcf
     
     Output:
     - basic QC-ed .vcf
     - .imiss & .lmiss files
     - .imendel
     - .het
     - .genome

### i/o trio

     Input:
     - single chromosome .vcf
     - samples to be dropped .txt
     - pedigree.txt of the cohort, typically corresponds with a region
     - sex.txt of the sexes of the samples of the cohort
     - parent.txt with identifiers of the case's parents
     - drop.txt with samples needing to be dropped
     
     Output:
     - results-chr##.txt

-----

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

***gTDT:*** a tool that provides statistics on GxE interaction term for Trio Data.

-----


***MAF Percentage:*** a tool that derives allele information and frequency from vcf files.

-----

***MAF Column Creation:*** a tool that outputs the MAF for the parents in the cohort.

-----

***Merge:*** a tool that combines SNP information, MAF results, and gTDT findings.

-----

***Trio Pipeline .vcf:*** a workflow that combines the above apps to yield GxE values for trio data.
