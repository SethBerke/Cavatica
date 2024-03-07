# Dr. Ruczinski Lab
## Johns Hopkins School of Public Health, Biostatistics Department
*We seek to analyze data from Family Trios to identify Sex-Specific Effects of Genetic Variants on conditions of interest.*

 ---


### Lab Members

     Ingo Ruczinski (PI)
     Kanika Kanchan (Post-Doctoral Researcher)
     Seth Berke (Student)

-----

### i/o

     Input:
     - single chromosome .vcf
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
6 | 1 

</td></tr> 
</table>

-----

***QC Filters:*** a CLT that filters SNPs based on minor alleles, missingness, and HWE.

-----

***Column Extraction:*** a CLT that extracts the first five columns of a vcf file (%CHROM %POS %ID %REF %ALT).

-----

***gTDT:*** a CLT that provides statistics on GxE interaction term for Trio Data.

-----


***MAF Percentage:*** a CLT that derives allele information and frequency from vcf files.

-----

***MAF Column Creation:*** a CLT that outputs the MAF for the parents in the cohort.

-----

***Merge:*** a CLT that combines SNP information, MAF results, and gTDT findings.

-----

***Trio Pipeline .vcf:*** a Workflow that combines the above apps to yield GxE values for trio data.
