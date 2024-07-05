{
    "class": "Workflow",
    "cwlVersion": "v1.2",
    "doc": "To investigate trio data GxE.",
    "label": "Trio Pipeline .vcf",
    "$namespaces": {
        "sbg": "https://sevenbridges.com"
    },
    "inputs": [
        {
            "id": "input_sex",
            "type": "File?",
            "label": "Sex txt",
            "doc": "In conjunction with pedigree file for Proper Analysis",
            "sbg:x": -100,
            "sbg:y": -77.80435180664062
        },
        {
            "id": "input_ped",
            "type": "File?",
            "label": "Ped txt",
            "doc": "From the region of interest",
            "sbg:x": -150.44544982910156,
            "sbg:y": 31.25554084777832
        },
        {
            "id": "input_parents",
            "type": "File?",
            "label": "Parents txt",
            "doc": "A file with all parent IDs such that we can ignore cases while analyzing MAF.",
            "sbg:x": -128.31036376953125,
            "sbg:y": 188.5104217529297
        },
        {
            "id": "input_id",
            "type": "string?",
            "label": "Identification Output txt",
            "doc": "So that users can input the identification that goes along with their analysis. This could be the region. A metadata extension for file outputting",
            "sbg:exposed": true
        },
        {
            "id": "input_vcf_1",
            "type": "File?",
            "label": "Basic QC-ed vcf",
            "doc": "The most upstream file in our process, should be QCed and ready for MAF Filtering.",
            "sbg:x": -715.87548828125,
            "sbg:y": 110.20732116699219
        },
        {
            "id": "input_drop_1",
            "type": "File?",
            "label": "Samples to Drop txt",
            "sbg:x": -715.6985473632812,
            "sbg:y": 244
        }
    ],
    "outputs": [
        {
            "id": "output",
            "outputSource": [
                "merge/output"
            ],
            "sbg:fileTypes": "txt",
            "type": "File?",
            "label": "Results",
            "doc": "To be further processed in a Meta-Analysis",
            "sbg:x": 948.7595825195312,
            "sbg:y": 165.68186950683594
        }
    ],
    "steps": [
        {
            "id": "merge",
            "in": [
                {
                    "id": "input_columns",
                    "source": "vcf_column_extraction/output_columns"
                },
                {
                    "id": "input_results",
                    "source": "gtdt_1/output_results"
                },
                {
                    "id": "input_id",
                    "source": "input_id"
                },
                {
                    "id": "input_MAF",
                    "source": "maf_column_creation_r_bioconductors/output_MAF_column"
                }
            ],
            "out": [
                {
                    "id": "output"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "sberke/ingo-lab-ofc-trio-analysis/merge/49",
                "baseCommand": [
                    "Rscript",
                    "./Merge.R"
                ],
                "inputs": [
                    {
                        "id": "input_columns",
                        "type": "File?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_results",
                        "type": "File?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_id",
                        "type": "string?",
                        "label": "Identification Output txt",
                        "doc": "So that users can input the identification that goes along with their analysis. This could be the region. A metadata extension for file outputting"
                    },
                    {
                        "id": "input_MAF",
                        "type": "File?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output",
                        "doc": "To be further processed in a Meta-Analysis",
                        "label": "Results",
                        "type": "File?",
                        "outputBinding": {
                            "glob": [
                                "*.txt"
                            ]
                        },
                        "sbg:fileTypes": "txt"
                    }
                ],
                "doc": "To merge info and results.",
                "label": "Merge | R",
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "pgc-images.sbgenomics.com/sberke/rtable"
                    },
                    {
                        "class": "InitialWorkDirRequirement",
                        "listing": [
                            {
                                "entryname": "Merge.R",
                                "entry": "source(\"packages.R\")\nsource(\"input.R\")\n\n# MERGE\n\ncols <- fread(columns_path, stringsAsFactors=F)\nMAFCol <- fread(MAF_path, stringsAsFactors=F)\n\ncols[, V6 := MAFCol]\ncols[, V7 := as.integer(sub(\"chr(\\\\d+).*\",\"\\\\1\",V1))]\ncols[, V8 := paste0(V1,\":\",V2,\"_\",V4,\"/\",V5)]\ncols[, SNP := ifelse(V3 == \".\", V8, V3)]\ncolnames(cols) <- c(\"CHROM\",\"POS\",\"rsID\", \"REF\", \"ALT\", \"MAF\", \"CHR\", \"VAR\", \"SNP\")\n\nresults <- fread(results_path, stringsAsFactors=F)\nchr <- merge(cols, results, by='SNP')\n\n# ORDER\n\nchr[, CHROM := factor(CHROM, levels = paste0(\"chr\", 1:22))]\nsorted_DataTable <- chr[order(CHROM, POS)]\n\n# DIVIDE\n\nunique_chromosomes <- unique(sorted_DataTable$CHROM)\n\nfor (chromosome in unique_chromosomes) {\n  chrom_data <- sorted_DataTable[sorted_DataTable$CHROM == chromosome, ]\n  filename <- paste0(id_path, \"-\", chromosome, \"-results.txt\")\n  fwrite(chrom_data, filename, sep = \"\\t\", quote = FALSE)\n}",
                                "writable": false
                            },
                            {
                                "entryname": "input.R",
                                "entry": "columns_path=\"$(inputs.input_columns.path)\"\nresults_path=\"$(inputs.input_results.path)\"\nid_path =\"$(inputs.input_id)\"\nMAF_path = \"$(inputs.input_MAF.path)\"\n\n",
                                "writable": false
                            },
                            {
                                "entryname": "packages.R",
                                "entry": "library(data.table)\n\n\n",
                                "writable": false
                            }
                        ]
                    },
                    {
                        "class": "InlineJavascriptRequirement"
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stdout.out"
                    },
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stderr.err"
                    },
                    {
                        "class": "sbg:SaveLogs",
                        "value": "*.R"
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "Ingo Lab OFC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684879300,
                        "sbg:revisionNotes": "Copy of sberke/fix/merge/1"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684883023,
                        "sbg:revisionNotes": "edited merge to be dynamic"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684887882,
                        "sbg:revisionNotes": "output results dynamic"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684888128,
                        "sbg:revisionNotes": "dynamic syntax error"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684949561,
                        "sbg:revisionNotes": "updated name of output file"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686073113,
                        "sbg:revisionNotes": "renamed file attempt"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686087193,
                        "sbg:revisionNotes": "modifiable name of results file"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686246670,
                        "sbg:revisionNotes": "refinement"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686246836,
                        "sbg:revisionNotes": "updated input label"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686247004,
                        "sbg:revisionNotes": "label"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686753027,
                        "sbg:revisionNotes": "attempt at regulating which files run through merge"
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686753969,
                        "sbg:revisionNotes": "bug fix at gTDT read in"
                    },
                    {
                        "sbg:revision": 12,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686754644,
                        "sbg:revisionNotes": "so execution does not halt"
                    },
                    {
                        "sbg:revision": 13,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1687954056,
                        "sbg:revisionNotes": "renamed for accuracy"
                    },
                    {
                        "sbg:revision": 14,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1687960688,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 15,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1687960700,
                        "sbg:revisionNotes": "name change to just merge"
                    },
                    {
                        "sbg:revision": 16,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688060981,
                        "sbg:revisionNotes": "attempt at full merge here"
                    },
                    {
                        "sbg:revision": 17,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688061437,
                        "sbg:revisionNotes": "position of MAF column changed"
                    },
                    {
                        "sbg:revision": 18,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688061778,
                        "sbg:revisionNotes": "bug fix col"
                    },
                    {
                        "sbg:revision": 19,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688062102,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 20,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688062473,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 21,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688062646,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 22,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688063465,
                        "sbg:revisionNotes": "revision"
                    },
                    {
                        "sbg:revision": 23,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688063473,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 24,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688064509,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 25,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688064579,
                        "sbg:revisionNotes": "reorder"
                    },
                    {
                        "sbg:revision": 26,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688068893,
                        "sbg:revisionNotes": "docker and name"
                    },
                    {
                        "sbg:revision": 27,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688080758,
                        "sbg:revisionNotes": "hopefully a big fix on chr"
                    },
                    {
                        "sbg:revision": 28,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688081199,
                        "sbg:revisionNotes": "for each row"
                    },
                    {
                        "sbg:revision": 29,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688081747,
                        "sbg:revisionNotes": "CHROM trial time"
                    },
                    {
                        "sbg:revision": 30,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688083010,
                        "sbg:revisionNotes": "testing yet again"
                    },
                    {
                        "sbg:revision": 31,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688084096,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 32,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688086897,
                        "sbg:revisionNotes": "switch"
                    },
                    {
                        "sbg:revision": 33,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688087414,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 34,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688087734,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 35,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688087970,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 36,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688088371,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 37,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688088380,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 38,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688088702,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 39,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688089463,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 40,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688089539,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 41,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688089793,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 42,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688090425,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 43,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688090640,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 44,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688090888,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 45,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688090904,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 46,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689948860,
                        "sbg:revisionNotes": "added in order"
                    },
                    {
                        "sbg:revision": 47,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689949560,
                        "sbg:revisionNotes": "adding in divide trial run"
                    },
                    {
                        "sbg:revision": 48,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689950570,
                        "sbg:revisionNotes": "fwrite"
                    },
                    {
                        "sbg:revision": 49,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1709818876,
                        "sbg:revisionNotes": "for github"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/ingo-lab-ofc-trio-analysis/merge/49",
                "sbg:revision": 49,
                "sbg:revisionNotes": "for github",
                "sbg:modifiedOn": 1709818876,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1684879300,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/ingo-lab-ofc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 49,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "ab5cab3240a0e63402fed6b4a925bb9e59042d702bb0cab2d4fe4239e7ffea6db",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "Merge | R + Bioconductors",
            "sbg:x": 694.990234375,
            "sbg:y": 168.26559448242188
        },
        {
            "id": "gtdt_1",
            "in": [
                {
                    "id": "input_vcf",
                    "source": "maf_filter_1/output_vcf_filtered"
                },
                {
                    "id": "input_ped",
                    "source": "input_ped"
                },
                {
                    "id": "input_sex",
                    "source": "input_sex"
                }
            ],
            "out": [
                {
                    "id": "output_results"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "sberke/ingo-lab-ofc-trio-analysis/gtdt/50",
                "baseCommand": [
                    "Rscript",
                    "./gTDT.R"
                ],
                "inputs": [
                    {
                        "id": "input_vcf",
                        "type": "File?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "MAF Filtered VCF",
                        "doc": "The output of the MAF Filtering Step will be the input here"
                    },
                    {
                        "id": "input_ped",
                        "type": "File?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "Ped txt",
                        "doc": "From the region of interest"
                    },
                    {
                        "id": "input_sex",
                        "type": "File?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "Sex txt",
                        "doc": "In conjunction with pedigree file for Proper Analysis"
                    }
                ],
                "outputs": [
                    {
                        "id": "output_results",
                        "doc": "Contains necessary information for Meta-Analysis. To be combined with VCF extracted columns for further processing in the meta-analysis.",
                        "label": "gTDT Results",
                        "type": "File?",
                        "outputBinding": {
                            "glob": [
                                "*.txt"
                            ]
                        },
                        "sbg:fileTypes": "txt"
                    }
                ],
                "doc": "To identify SNPs of interest.",
                "label": "gTDT | R + Bioconductors",
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "pgc-images.sbgenomics.com/sberke/trio"
                    },
                    {
                        "class": "InitialWorkDirRequirement",
                        "listing": [
                            {
                                "entryname": "gTDT.R",
                                "entry": "source(\"packages.R\")\nsource(\"input.R\")\n\n    fullchr <- data.table(\"SNP\"=character(0),\"Coef_GxE\"=numeric(0),\t\"RR_GxE\"=numeric(0),\t\"Lower_GxE\"=numeric(0),\t\"Upper_GxE\"=numeric(0), \"SE_GxE\"=numeric(0),\t\"Stat_GxE\"=numeric(0),\t\"pval_GxE\"=numeric(0),\t\"Trios0\"=numeric(0), \"Trios1\"=numeric(0),\t\"Coef_G\"=numeric(0),\t\"RR_G\"=numeric(0),\t\"Lower_G\"=numeric(0),\t\"Upper_G\"=numeric(0),\t\"SE_G\"=numeric(0),\t\"Stat_G\"=numeric(0),\t\"pval_G\"=numeric(0),\t\"RR_G&E\"=numeric(0),\t\"Lower_G&E\"=numeric(0),\t\"Upper_G&E\"=numeric(0),\t\"Stat_LRT2df\"=numeric(0),\t\"pval_LRT2df\"=numeric(0),\t\"Stat_Wald2df\"=numeric(0),\t\"pval_Wald2df\"=numeric(0),\t\"Stat_LRT1df\"=numeric(0),\t\"pval_LRT1df\"=numeric(0))\n    \n    param <- ScanVcfParam(geno = \"GT\")\n    \n    vcf <- readVcf(vcf_path, \"hg38\", param = param)\n    \n    ped <- fread(ped_path)\n    \n    trio <- vcf2geno(vcf,ped, none = \"0/0\", one = \"0/1\", both = \"1/1\", na.string = \"./.\", use.rownames = FALSE, allowDifference = FALSE, removeMonomorphic = TRUE, removeNonBiallelic = TRUE, changeMinor = FALSE)\n    \n    sex <- fread(sex_path)\n    \n    sex <- sex[,2]\n    \n    sex <- as.numeric(unlist(sex))-1\n    \n    gxe.out <- colGxE(trio, sex)\n    \n    df <- getGxEstats(gxe.out, top=NA)\n    dt <- setDT(df, keep.rownames = T)\n    colnames(dt) <- c(\"SNP\", \"Coef_GxE\", \"RR_GxE\", \"Lower_GxE\", \"Upper_GxE\", \"SE_GxE\", \"Stat_GxE\", \"pval_GxE\", \"Trios0\", \"Trios1\", \"Coef_G\", \"RR_G\", \"Lower_G\", \"Upper_G\", \"SE_G\", \"Stat_G\", \"pval_G\", \"RR_G&E\", \"Lower_G&E\", \"Upper_G&E\", \"Stat_LRT2df\", \"pval_LRT2df\", \"Stat_Wald2df\", \"pval_Wald2df\", \"Stat_LRT1df\", \"pval_LRT1df\")\n\n    fullchr <- rbind(fullchr, dt)\n    \n    #chromosome <- fullchr[2,1]\n    #num <- regmatches(chromosome, regexpr(\"\\\\d+(?=:)\", chromosome, perl = TRUE))\n\n    write.table(fullchr, paste0(\"gTDTresults\",\".txt\",sep=\"\"), row.names=F, col.names = T, sep=\"\\t\", quote=F)\n    \nq(save=\"no\")",
                                "writable": false
                            },
                            {
                                "entryname": "input.R",
                                "entry": "vcf_path=\"$(inputs.input_vcf.path)\"\nped_path=\"$(inputs.input_ped.path)\"\nsex_path=\"$(inputs.input_sex.path)\"\n\n",
                                "writable": false
                            },
                            {
                                "entryname": "packages.R",
                                "entry": "library(data.table)\nlibrary(VariantAnnotation)\nlibrary(trio)\n\n",
                                "writable": false
                            }
                        ]
                    },
                    {
                        "class": "InlineJavascriptRequirement"
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stdout.out"
                    },
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stderr.err"
                    },
                    {
                        "class": "sbg:SaveLogs",
                        "value": "*.R"
                    },
                    {
                        "class": "sbg:AWSInstanceType",
                        "value": "c5.4xlarge;ebs-gp2;1024"
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "Ingo Lab OFC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684879269,
                        "sbg:revisionNotes": "Copy of sberke/workflowfinalization/gtdt/6"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684949394,
                        "sbg:revisionNotes": "edited the output file name"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684949530,
                        "sbg:revisionNotes": "updated name of output file"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684953500,
                        "sbg:revisionNotes": "output file redone"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684962126,
                        "sbg:revisionNotes": "updated the output text again"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684964618,
                        "sbg:revisionNotes": "more bug fixes"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684967454,
                        "sbg:revisionNotes": "another bug fix"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686346258,
                        "sbg:revisionNotes": "testing new instance type load"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686347943,
                        "sbg:revisionNotes": "cpu run test"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686673180,
                        "sbg:revisionNotes": "new instance type"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688083114,
                        "sbg:revisionNotes": "little more efficient"
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689085630,
                        "sbg:revisionNotes": "dynamic memory allocation"
                    },
                    {
                        "sbg:revision": 12,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689086298,
                        "sbg:revisionNotes": "optimized javascript for memory allocation"
                    },
                    {
                        "sbg:revision": 13,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689096835,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 14,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689197449,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 15,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689197794,
                        "sbg:revisionNotes": "r5.4xlarge instance type"
                    },
                    {
                        "sbg:revision": 16,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689202221,
                        "sbg:revisionNotes": "no instance types"
                    },
                    {
                        "sbg:revision": 17,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689203002,
                        "sbg:revisionNotes": "trial of increased attached storage"
                    },
                    {
                        "sbg:revision": 18,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689377290,
                        "sbg:revisionNotes": "scan conversion time"
                    },
                    {
                        "sbg:revision": 19,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689377809,
                        "sbg:revisionNotes": "bug fix compress"
                    },
                    {
                        "sbg:revision": 20,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689378253,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 21,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689379291,
                        "sbg:revisionNotes": "10000 yield size"
                    },
                    {
                        "sbg:revision": 22,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689379493,
                        "sbg:revisionNotes": "500 yield size"
                    },
                    {
                        "sbg:revision": 23,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689380068,
                        "sbg:revisionNotes": "loop approach to reading in large vcf"
                    },
                    {
                        "sbg:revision": 24,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689380652,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 25,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689380691,
                        "sbg:revisionNotes": "bug fix attempt"
                    },
                    {
                        "sbg:revision": 26,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689382290,
                        "sbg:revisionNotes": "another bug fix"
                    },
                    {
                        "sbg:revision": 27,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689382681,
                        "sbg:revisionNotes": "no tabix file"
                    },
                    {
                        "sbg:revision": 28,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689383145,
                        "sbg:revisionNotes": "Vcf not VCF"
                    },
                    {
                        "sbg:revision": 29,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689383551,
                        "sbg:revisionNotes": "fixed path read in attribute"
                    },
                    {
                        "sbg:revision": 30,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689384665,
                        "sbg:revisionNotes": "attempt at removing unneeded objects"
                    },
                    {
                        "sbg:revision": 31,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689385823,
                        "sbg:revisionNotes": "garbage collector added"
                    },
                    {
                        "sbg:revision": 32,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689386388,
                        "sbg:revisionNotes": "attempt at creating a function"
                    },
                    {
                        "sbg:revision": 33,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689386509,
                        "sbg:revisionNotes": "<<-"
                    },
                    {
                        "sbg:revision": 34,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689619514,
                        "sbg:revisionNotes": "returning to the original gTDT test"
                    },
                    {
                        "sbg:revision": 35,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689619529,
                        "sbg:revisionNotes": "with a more optimized instance"
                    },
                    {
                        "sbg:revision": 36,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689702196,
                        "sbg:revisionNotes": "trial run of chunking modality"
                    },
                    {
                        "sbg:revision": 37,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689703315,
                        "sbg:revisionNotes": "writes directly to the output"
                    },
                    {
                        "sbg:revision": 38,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689703454,
                        "sbg:revisionNotes": "clearing disk space for calculation strategy"
                    },
                    {
                        "sbg:revision": 39,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689703595,
                        "sbg:revisionNotes": "proper instance group"
                    },
                    {
                        "sbg:revision": 40,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689719009,
                        "sbg:revisionNotes": "ScanVcfParam"
                    },
                    {
                        "sbg:revision": 41,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689720437,
                        "sbg:revisionNotes": "optimal instance for new method"
                    },
                    {
                        "sbg:revision": 42,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689721211,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 43,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689721225,
                        "sbg:revisionNotes": "optimal instance type"
                    },
                    {
                        "sbg:revision": 44,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689859778,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 45,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689859791,
                        "sbg:revisionNotes": "c54"
                    },
                    {
                        "sbg:revision": 46,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1706832941,
                        "sbg:revisionNotes": "trial run of 'trio' Docker Image for Publication"
                    },
                    {
                        "sbg:revision": 47,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1706842266,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 48,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1706847717,
                        "sbg:revisionNotes": "docker image revised"
                    },
                    {
                        "sbg:revision": 49,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1706885145,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 50,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1706893393,
                        "sbg:revisionNotes": ""
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/ingo-lab-ofc-trio-analysis/gtdt/50",
                "sbg:revision": 50,
                "sbg:revisionNotes": "",
                "sbg:modifiedOn": 1706893393,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1684879269,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/ingo-lab-ofc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 50,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "ac508d502e0fb4936ea570a7883fc56f0dc43bb584c44a115301da5d76eb1c5e0",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "gTDT | R + Bioconductors",
            "sbg:x": 89.14146423339844,
            "sbg:y": -172.3260955810547
        },
        {
            "id": "maf_percentage_vcftools",
            "in": [
                {
                    "id": "input_vcf",
                    "source": "maf_filter_1/output_vcf_filtered"
                },
                {
                    "id": "input_parents",
                    "source": "input_parents"
                }
            ],
            "out": [
                {
                    "id": "output_vcf_mafpct"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "sberke/ingo-lab-ofc-trio-analysis/maf-percentage-vcftools/10",
                "baseCommand": [
                    "vcftools"
                ],
                "inputs": [
                    {
                        "id": "input_vcf",
                        "type": "File?"
                    },
                    {
                        "id": "input_parents",
                        "type": "File?",
                        "label": "Parents txt",
                        "doc": "A file with all parent IDs such that we can ignore cases while analyzing MAF."
                    }
                ],
                "outputs": [
                    {
                        "id": "output_vcf_mafpct",
                        "type": "File?",
                        "outputBinding": {
                            "glob": [
                                "*.mafpct",
                                "*.frq",
                                "*.vcf"
                            ]
                        }
                    }
                ],
                "doc": "To obtain MAF from parents.",
                "label": "MAF Percentage | VCFTools",
                "arguments": [
                    {
                        "prefix": "--vcf",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "$(inputs.input_vcf.path)"
                    },
                    {
                        "prefix": "--keep",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "$(inputs.input_parents.path)"
                    },
                    {
                        "prefix": "--freq --out",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "$(inputs.input_vcf.basename + \".mafpct\")"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "pgc-images.sbgenomics.com/sberke/vcf"
                    },
                    {
                        "class": "InlineJavascriptRequirement"
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stdout.out"
                    },
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stderr.err"
                    },
                    {
                        "class": "sbg:AWSInstanceType",
                        "value": "c4.2xlarge;ebs-gp2;1024"
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "Ingo Lab OFC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688048449,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688048802,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688048954,
                        "sbg:revisionNotes": "ordered"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688048981,
                        "sbg:revisionNotes": "description has been added in"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688050904,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688050915,
                        "sbg:revisionNotes": "new file extension name for globbing"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688051596,
                        "sbg:revisionNotes": "more file types"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688069189,
                        "sbg:revisionNotes": "optics"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689193364,
                        "sbg:revisionNotes": "c4.2xlarge instance type"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1709818341,
                        "sbg:revisionNotes": "for github"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1709819781,
                        "sbg:revisionNotes": ""
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/ingo-lab-ofc-trio-analysis/maf-percentage-vcftools/10",
                "sbg:revision": 10,
                "sbg:revisionNotes": "",
                "sbg:modifiedOn": 1709819781,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1688048449,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/ingo-lab-ofc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 10,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a5d789dfd4b239061d4d4bb307252cded4576b8832a500c4f948a50908a854e5a",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "MAF Percentage | VCFTools",
            "sbg:x": 77.52067565917969,
            "sbg:y": 151.3708953857422
        },
        {
            "id": "maf_column_creation_r_bioconductors",
            "in": [
                {
                    "id": "input_MAF_info",
                    "source": "maf_percentage_vcftools/output_vcf_mafpct"
                }
            ],
            "out": [
                {
                    "id": "output_MAF_column"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "sberke/ingo-lab-ofc-trio-analysis/maf-column-creation-r-bioconductors/10",
                "baseCommand": [
                    "Rscript",
                    "./MAFColumnCreation.R"
                ],
                "inputs": [
                    {
                        "id": "input_MAF_info",
                        "type": "File?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output_MAF_column",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.txt"
                        }
                    }
                ],
                "doc": "To extract MAF allele information.",
                "label": "MAF Column Creation | R + SplitStackShape",
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "pgc-images.sbgenomics.com/sberke/mafcolumn.dependencies"
                    },
                    {
                        "class": "InitialWorkDirRequirement",
                        "listing": [
                            {
                                "entryname": "MAFColumnCreation.R",
                                "entry": "source(\"packages.R\")\nsource(\"input.R\")\n  \ndt <- data.table(\n  \"CHROM\" = character(0),\n  \"POS\" = numeric(0),\n  \"N_ALLELES\" = numeric(0),\n  \"N_CHR\" = numeric(0),\n  \"Ref\" = character(0),\n  \"Ref_Frq\" = numeric(0),\n  \"Alt\" = character(0),\n  \"Alt_Frq\" = numeric(0),\n  \"MAF\" = numeric(0),\n  \"SNP\" = character(0)\n)\n\nfp <- MAF_info_path\n\nchr <- fread(fp, stringsAsFactors = FALSE, header = FALSE)\nchr <- cSplit(chr, c('V5', 'V6'), sep = \":\")\ncolnames(chr) <- c(\"CHROM\", \"POS\", \"N_ALLELES\", \"N_CHR\", \"Ref\", \"Ref_Frq\", \"Alt\", \"Alt_Frq\")\nchr[, 'MAF' := ifelse(Alt_Frq > 0.50, 1 - Alt_Frq, Alt_Frq)]\nchr[, 'SNP' := paste0(CHROM, \":\", POS, \"_\", Ref, \"/\", Alt)]\ndt <- rbind(dt, chr)\n\n#write.table(dt, \"TESTING.txt\", row.names = FALSE, col.names = TRUE, sep = \"\\t\", quote = FALSE)\n\ndtMAF <- chr[, .(MAF)]\n\nwrite.table(dtMAF, \"dtMAF.txt\", row.names = FALSE, col.names = FALSE, sep = \"\\t\", quote = FALSE)\n",
                                "writable": false
                            },
                            {
                                "entryname": "input.R",
                                "entry": "MAF_info_path=\"$(inputs.input_MAF_info.path)\"\nMAFName = \"$(inputs.input_MAF_info.basename)\"\nMAFClass = \"$(inputs.input_MAF_info.class)\"\n\n",
                                "writable": false
                            },
                            {
                                "entryname": "packages.R",
                                "entry": "library(data.table)\nlibrary(splitstackshape)\n\n",
                                "writable": false
                            }
                        ]
                    },
                    {
                        "class": "InlineJavascriptRequirement"
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stdout.out"
                    },
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stderr.err"
                    },
                    {
                        "class": "sbg:SaveLogs",
                        "value": "*.R"
                    },
                    {
                        "class": "sbg:AWSInstanceType",
                        "value": "c4.2xlarge;ebs-gp2;1024"
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "Ingo Lab OFC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688049391,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688050147,
                        "sbg:revisionNotes": "initial framework col"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688054851,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688054888,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688058295,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688058309,
                        "sbg:revisionNotes": "specific docker added"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688059117,
                        "sbg:revisionNotes": "fixed a few things around"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688059179,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688062572,
                        "sbg:revisionNotes": "name!"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1688069384,
                        "sbg:revisionNotes": "aligned"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689193330,
                        "sbg:revisionNotes": "c4.2xlarge instance type"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/ingo-lab-ofc-trio-analysis/maf-column-creation-r-bioconductors/10",
                "sbg:revision": 10,
                "sbg:revisionNotes": "c4.2xlarge instance type",
                "sbg:modifiedOn": 1689193330,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1688049391,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/ingo-lab-ofc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 10,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "af778a155b619560bedf3b46f3ad98d39bb38b6bc6924806edd99c9d0edba5db8",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "MAF Column Creation | R + SplitStackShape",
            "sbg:x": 329.4891357421875,
            "sbg:y": 139.70652770996094
        },
        {
            "id": "vcf_column_extraction",
            "in": [
                {
                    "id": "input_vcf_filtered",
                    "source": "maf_filter_1/output_vcf_filtered"
                }
            ],
            "out": [
                {
                    "id": "output_columns"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "sberke/ingo-lab-ofc-trio-analysis/vcf-column-extraction/7",
                "baseCommand": [
                    "bcftools"
                ],
                "inputs": [
                    {
                        "id": "input_vcf_filtered",
                        "type": "File?",
                        "inputBinding": {
                            "shellQuote": false,
                            "position": 0
                        },
                        "label": "MAF Filtered VCF",
                        "doc": "Filtered for 1% Minor Allele Frequency"
                    }
                ],
                "outputs": [
                    {
                        "id": "output_columns",
                        "doc": "The first five columns for all the rows: \n\n%CHROM %POS %ID %REF %ALT",
                        "label": "Columns txt",
                        "type": "File?",
                        "outputBinding": {
                            "loadContents": true,
                            "glob": [
                                "*.txt"
                            ]
                        },
                        "sbg:fileTypes": "txt"
                    }
                ],
                "doc": "To extract info of loci.",
                "label": "Column Extraction | BCFTools",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "query -f '%CHROM %POS %ID %REF %ALT\\n'"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "$(inputs.input_vcf_filtered.basename + \".columns.txt\")"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "pgc-images.sbgenomics.com/sberke/bcf"
                    },
                    {
                        "class": "InlineJavascriptRequirement"
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stdout.out"
                    },
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stderr.err"
                    },
                    {
                        "class": "sbg:AWSInstanceType",
                        "value": "c4.2xlarge;ebs-gp2;1024"
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "Ingo Lab OFC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684879280,
                        "sbg:revisionNotes": "Copy of sberke/workflowfinalization/vcf-column-extraction/0"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686671307,
                        "sbg:revisionNotes": "updated input and output for file array functionality"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686672306,
                        "sbg:revisionNotes": "return"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686703782,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689193285,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689193302,
                        "sbg:revisionNotes": "c4.2xlarge instance type"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1709818963,
                        "sbg:revisionNotes": "for github"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1709819767,
                        "sbg:revisionNotes": ""
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/ingo-lab-ofc-trio-analysis/vcf-column-extraction/7",
                "sbg:revision": 7,
                "sbg:revisionNotes": "",
                "sbg:modifiedOn": 1709819767,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1684879280,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/ingo-lab-ofc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 7,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a629b30d7e22644cb96991e90d6f9f7a8048a9953954f973ec9efbd76b5052405",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "Column Extraction | BCFTools",
            "sbg:x": 85.40376281738281,
            "sbg:y": 491.3708801269531
        },
        {
            "id": "maf_filter_1",
            "in": [
                {
                    "id": "input_vcf",
                    "source": "input_vcf_1"
                },
                {
                    "id": "input_drop",
                    "source": "input_drop_1"
                }
            ],
            "out": [
                {
                    "id": "output_vcf_filtered"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "sberke/ingo-lab-ofc-trio-analysis/maf-filter/37",
                "baseCommand": [
                    "vcftools",
                    "--recode",
                    "--recode-INFO-all"
                ],
                "inputs": [
                    {
                        "id": "input_vcf",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--gzvcf",
                            "shellQuote": false,
                            "position": -2
                        },
                        "label": "Initial vcf",
                        "doc": "The most upstream file in our process, should be QCed and ready for MAF Filtering."
                    },
                    {
                        "id": "input_id",
                        "type": "string?",
                        "label": "Identification for MAF Filtered vcf",
                        "doc": "Metadata type information such that the output file is recognizable and accessible for furthering downstream processing."
                    },
                    {
                        "id": "input_drop",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--remove",
                            "shellQuote": false,
                            "position": -1
                        },
                        "label": "Input Drop txt"
                    }
                ],
                "outputs": [
                    {
                        "id": "output_vcf_filtered",
                        "doc": "This has been filtered based on MAF, now it can have it's columns extracted and also be put into the gTDT process.",
                        "label": "MAF Filtered VCF",
                        "type": "File?",
                        "outputBinding": {
                            "glob": [
                                "*.vcf",
                                "*.vcf.gz"
                            ]
                        },
                        "sbg:fileTypes": "VCF, VCF.GZ"
                    }
                ],
                "doc": "To filter minor alleles out.",
                "label": "Variant Level QC | VCFTools",
                "arguments": [
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "$(inputs.input_id + \".\" + inputs.input_vcf.basename + \".cleanFiles\")"
                    },
                    {
                        "prefix": "--maf",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "0.01"
                    },
                    {
                        "prefix": "--max-missing",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "0.80"
                    },
                    {
                        "prefix": "--hwe",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "0.000001"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "pgc-images.sbgenomics.com/sberke/vcf"
                    },
                    {
                        "class": "InlineJavascriptRequirement"
                    }
                ],
                "hints": [
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stdout.out"
                    },
                    {
                        "class": "sbg:SaveLogs",
                        "value": "stderr.err"
                    },
                    {
                        "class": "sbg:AWSInstanceType",
                        "value": "c5.4xlarge;ebs-gp2;1024"
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "Ingo Lab OFC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1684879256,
                        "sbg:revisionNotes": "Copy of sberke/workflowfinalization/maf-filter/0"
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686089644,
                        "sbg:revisionNotes": "dynamic naming of maf file"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686246571,
                        "sbg:revisionNotes": "input id"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686246579,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686246856,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686246886,
                        "sbg:revisionNotes": "ID label added"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686667912,
                        "sbg:revisionNotes": "array of files as input port"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686671230,
                        "sbg:revisionNotes": "updated to output file array"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686671508,
                        "sbg:revisionNotes": "changing back to file only"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686698410,
                        "sbg:revisionNotes": "increased instance type"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1686706835,
                        "sbg:revisionNotes": "lesser instance type"
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689107617,
                        "sbg:revisionNotes": "optimized instance type"
                    },
                    {
                        "sbg:revision": 12,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689108184,
                        "sbg:revisionNotes": "deleted instance hint"
                    },
                    {
                        "sbg:revision": 13,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689169700,
                        "sbg:revisionNotes": "attempt at optimized vCPU numbers"
                    },
                    {
                        "sbg:revision": 14,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689169706,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 15,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689169711,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 16,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689170093,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 17,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689171198,
                        "sbg:revisionNotes": "standardized instance type"
                    },
                    {
                        "sbg:revision": 18,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689173594,
                        "sbg:revisionNotes": "dynamic memory allocation based on user input"
                    },
                    {
                        "sbg:revision": 19,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689173686,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 20,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689173768,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 21,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689173878,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 22,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689174646,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 23,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689175260,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 24,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689176331,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 25,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689176400,
                        "sbg:revisionNotes": "c5.4xlarge instance type"
                    },
                    {
                        "sbg:revision": 26,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689192360,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 27,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689595916,
                        "sbg:revisionNotes": "trial at different docker image"
                    },
                    {
                        "sbg:revision": 28,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689725571,
                        "sbg:revisionNotes": "trial with threads"
                    },
                    {
                        "sbg:revision": 29,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1689725983,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 30,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697126044,
                        "sbg:revisionNotes": "revised for all QC steps"
                    },
                    {
                        "sbg:revision": 31,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697214979,
                        "sbg:revisionNotes": "renamed drop input"
                    },
                    {
                        "sbg:revision": 32,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1699637208,
                        "sbg:revisionNotes": "rearrange"
                    },
                    {
                        "sbg:revision": 33,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1709818282,
                        "sbg:revisionNotes": "for github"
                    },
                    {
                        "sbg:revision": 34,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1709819809,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 35,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1711930676,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 36,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1711930680,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 37,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1711930707,
                        "sbg:revisionNotes": "rename"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/ingo-lab-ofc-trio-analysis/maf-filter/37",
                "sbg:revision": 37,
                "sbg:revisionNotes": "rename",
                "sbg:modifiedOn": 1711930707,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1684879256,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/ingo-lab-ofc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 37,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a2a1f2a1ced07f1f976a39b28fd8a611647d7f4a97ec6db54f23894757b467513",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "Variant Level QC | VCFTools",
            "sbg:x": -487.3236389160156,
            "sbg:y": 156.30686950683594
        }
    ],
    "hints": [
        {
            "class": "sbg:maxNumberOfParallelInstances"
        }
    ],
    "requirements": [
        {
            "class": "InlineJavascriptRequirement"
        },
        {
            "class": "StepInputExpressionRequirement"
        }
    ],
    "sbg:projectName": "Ruczinski Lab OFC Trio Analysis",
    "sbg:revisionsInfo": [
        {
            "sbg:revision": 0,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684879405,
            "sbg:revisionNotes": "Copy of sberke/workflowfinalization/triopipeline/3"
        },
        {
            "sbg:revision": 1,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684879576,
            "sbg:revisionNotes": "revised to include fixed merge"
        },
        {
            "sbg:revision": 2,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684887515,
            "sbg:revisionNotes": "updated merge"
        },
        {
            "sbg:revision": 3,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684887914,
            "sbg:revisionNotes": "updated merge dynamically"
        },
        {
            "sbg:revision": 4,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684888180,
            "sbg:revisionNotes": "merge"
        },
        {
            "sbg:revision": 5,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684888283,
            "sbg:revisionNotes": "renamed"
        },
        {
            "sbg:revision": 6,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684947797,
            "sbg:revisionNotes": "outputs MAF vcf"
        },
        {
            "sbg:revision": 7,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684948567,
            "sbg:revisionNotes": "testing parallelization"
        },
        {
            "sbg:revision": 8,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684949489,
            "sbg:revisionNotes": "updated gTDT"
        },
        {
            "sbg:revision": 9,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684949616,
            "sbg:revisionNotes": "updated apps for standardized text"
        },
        {
            "sbg:revision": 10,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684953526,
            "sbg:revisionNotes": "gTDT updated for the output"
        },
        {
            "sbg:revision": 11,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684962152,
            "sbg:revisionNotes": "updated gTDT again"
        },
        {
            "sbg:revision": 12,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684964671,
            "sbg:revisionNotes": "updated"
        },
        {
            "sbg:revision": 13,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684967485,
            "sbg:revisionNotes": "gTDT again"
        },
        {
            "sbg:revision": 14,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1684967501,
            "sbg:revisionNotes": "."
        },
        {
            "sbg:revision": 15,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1685632329,
            "sbg:revisionNotes": "changed the name"
        },
        {
            "sbg:revision": 16,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686087226,
            "sbg:revisionNotes": "merge updated for dynamic file naming"
        },
        {
            "sbg:revision": 17,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686087263,
            "sbg:revisionNotes": "exposed"
        },
        {
            "sbg:revision": 18,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686089778,
            "sbg:revisionNotes": "new maf filter"
        },
        {
            "sbg:revision": 19,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686246622,
            "sbg:revisionNotes": "updated for external input parameter"
        },
        {
            "sbg:revision": 20,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686246692,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 21,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686246912,
            "sbg:revisionNotes": "labels again"
        },
        {
            "sbg:revision": 22,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686247021,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 23,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686247031,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 24,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686326067,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 25,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686326090,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 26,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686344946,
            "sbg:revisionNotes": "renamed"
        },
        {
            "sbg:revision": 27,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686345647,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 28,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1686345738,
            "sbg:revisionNotes": "description"
        },
        {
            "sbg:revision": 29,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1688075501,
            "sbg:revisionNotes": "added MAF functionality"
        },
        {
            "sbg:revision": 30,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1688079122,
            "sbg:revisionNotes": "added ordered results"
        },
        {
            "sbg:revision": 31,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1688084379,
            "sbg:revisionNotes": "CHR fix quick"
        },
        {
            "sbg:revision": 32,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1688091365,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 33,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1688137258,
            "sbg:revisionNotes": "updated order results"
        },
        {
            "sbg:revision": 34,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1688137266,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 35,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1688137273,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 36,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1689193467,
            "sbg:revisionNotes": "optimized instance types for trial run"
        },
        {
            "sbg:revision": 37,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1689720471,
            "sbg:revisionNotes": "optimizations"
        },
        {
            "sbg:revision": 38,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1689721261,
            "sbg:revisionNotes": "optimized instance type for gTDT r5.4"
        },
        {
            "sbg:revision": 39,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1689952469,
            "sbg:revisionNotes": "merge and optics"
        },
        {
            "sbg:revision": 40,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1689973947,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 41,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1689974044,
            "sbg:revisionNotes": "rebranded"
        },
        {
            "sbg:revision": 42,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1697126138,
            "sbg:revisionNotes": "QC Filtered"
        },
        {
            "sbg:revision": 43,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1697215099,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 44,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1699723965,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 45,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1699723982,
            "sbg:revisionNotes": "updated QC Filter"
        },
        {
            "sbg:revision": 46,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1706832960,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 47,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1706842324,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 48,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1706847735,
            "sbg:revisionNotes": "docker image revised"
        },
        {
            "sbg:revision": 49,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1706885161,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 50,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1706893409,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 51,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1709818989,
            "sbg:revisionNotes": "for github"
        },
        {
            "sbg:revision": 52,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1709819020,
            "sbg:revisionNotes": "description"
        },
        {
            "sbg:revision": 53,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1709819830,
            "sbg:revisionNotes": "for github"
        },
        {
            "sbg:revision": 54,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1709819872,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 55,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1711930655,
            "sbg:revisionNotes": "renamed p1"
        },
        {
            "sbg:revision": 56,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1711931321,
            "sbg:revisionNotes": "movement"
        },
        {
            "sbg:revision": 57,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1711932485,
            "sbg:revisionNotes": "renamed drop txt"
        }
    ],
    "sbg:image_url": "https://cavatica.sbgenomics.com/ns/brood/images/sberke/ingo-lab-ofc-trio-analysis/triopipeline/57.png",
    "sbg:toolAuthor": "Seth Berke",
    "sbg:appVersion": [
        "v1.2"
    ],
    "id": "https://cavatica-api.sbgenomics.com/v2/apps/sberke/ingo-lab-ofc-trio-analysis/triopipeline/57/raw/",
    "sbg:id": "sberke/ingo-lab-ofc-trio-analysis/triopipeline/57",
    "sbg:revision": 57,
    "sbg:revisionNotes": "renamed drop txt",
    "sbg:modifiedOn": 1711932485,
    "sbg:modifiedBy": "sberke",
    "sbg:createdOn": 1684879405,
    "sbg:createdBy": "sberke",
    "sbg:project": "sberke/ingo-lab-ofc-trio-analysis",
    "sbg:sbgMaintained": false,
    "sbg:validationErrors": [],
    "sbg:contributors": [
        "sberke"
    ],
    "sbg:latestRevision": 57,
    "sbg:publisher": "sbg",
    "sbg:content_hash": "adbfdd88bbb2398f0616b8a025b7e3bd4ac04d1969625289514eaef334a2a1515",
    "sbg:workflowLanguage": "CWL"
}
