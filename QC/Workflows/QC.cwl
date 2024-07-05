{
    "class": "Workflow",
    "cwlVersion": "v1.2",
    "label": "Quality Control",
    "$namespaces": {
        "sbg": "https://sevenbridges.com"
    },
    "inputs": [
        {
            "id": "input_merge_list",
            "type": "File?",
            "label": "Merge List txt",
            "sbg:x": 953.3356323242188,
            "sbg:y": 81.5372314453125
        },
        {
            "id": "input_drop",
            "type": "File?",
            "label": "Drop High Missingness Samples txt",
            "sbg:x": 174.4319305419922,
            "sbg:y": 142.77590942382812
        },
        {
            "id": "input",
            "type": "File?",
            "label": "Raw vcf",
            "sbg:x": -382.3617858886719,
            "sbg:y": -75.47905731201172
        }
    ],
    "outputs": [
        {
            "id": "output_1",
            "outputSource": [
                "mendelian_error_plink/output"
            ],
            "type": "File?",
            "label": ".imendel",
            "sbg:x": 895.2452392578125,
            "sbg:y": -188.0072479248047
        },
        {
            "id": "output",
            "outputSource": [
                "summary_stats_plink/output"
            ],
            "type": "File?",
            "label": ".lmiss .imiss",
            "sbg:x": 572.7366333007812,
            "sbg:y": -290
        },
        {
            "id": "output_2",
            "outputSource": [
                "heterozygosity_plink/output"
            ],
            "type": "File?",
            "label": ".het",
            "sbg:x": 1579.2564697265625,
            "sbg:y": 195.52206420898438
        },
        {
            "id": "output_3",
            "outputSource": [
                "ibs_plink/output"
            ],
            "type": "File?",
            "label": ".genome",
            "sbg:x": 1581.8492431640625,
            "sbg:y": 398.03350830078125
        },
        {
            "id": "output_4",
            "outputSource": [
                "initial_vcf_filtering_vcftools/output"
            ],
            "type": "File?",
            "label": "Basic QC-ed vcf",
            "sbg:x": -47.40536117553711,
            "sbg:y": -282.7461242675781
        }
    ],
    "steps": [
        {
            "id": "plink_file_creation_plink",
            "in": [
                {
                    "id": "input",
                    "source": "initial_vcf_filtering_vcftools/output"
                }
            ],
            "out": [
                {
                    "id": "output_bed"
                },
                {
                    "id": "output_bim"
                },
                {
                    "id": "output_fam"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "sberke/qc-trio-analysis/plink-file-creation-plink/8",
                "baseCommand": [
                    "plink"
                ],
                "inputs": [
                    {
                        "id": "input",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--vcf",
                            "shellQuote": false,
                            "position": -3
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output_bed",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.bed"
                        }
                    },
                    {
                        "id": "output_bim",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.bim"
                        }
                    },
                    {
                        "id": "output_fam",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.fam"
                        }
                    }
                ],
                "label": "PLINK File Creation | PLINK",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "--make-bed"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "$(inputs.input.basename + \".plink\")"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/plink-1-90:0"
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
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "QC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696873852,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696874175,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696875254,
                        "sbg:revisionNotes": "added glob for different file types"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697215715,
                        "sbg:revisionNotes": "three outputs"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697216172,
                        "sbg:revisionNotes": "single glob expression"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697216178,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697757968,
                        "sbg:revisionNotes": "added helper files"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698092787,
                        "sbg:revisionNotes": "just trying to update sex for now"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698096656,
                        "sbg:revisionNotes": "no helper files"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/qc-trio-analysis/plink-file-creation-plink/8",
                "sbg:revision": 8,
                "sbg:revisionNotes": "no helper files",
                "sbg:modifiedOn": 1698096656,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1696873852,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/qc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 8,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a32ecde4833f0e6547fafa3dcbd808bf7cb2de8aa596b183b1bf13738b41e89d0",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "PLINK File Creation | PLINK",
            "sbg:x": 127.5058822631836,
            "sbg:y": -100.85502624511719
        },
        {
            "id": "mendelian_error_plink",
            "in": [
                {
                    "id": "input_bed",
                    "source": "variant_filtering_plink/output_bed"
                },
                {
                    "id": "input_bim",
                    "source": "variant_filtering_plink/output_bim"
                },
                {
                    "id": "input_fam",
                    "source": "variant_filtering_plink/output_fam"
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
                "id": "sberke/qc-trio-analysis/mendelian-error-plink/3",
                "baseCommand": [
                    "plink"
                ],
                "inputs": [
                    {
                        "id": "input_bed",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bed",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_bim",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bim",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_fam",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--fam",
                            "shellQuote": false,
                            "position": 0
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output",
                        "type": "File?",
                        "outputBinding": {
                            "glob": [
                                "*.mendel",
                                "*.imendel",
                                "*.fmendel",
                                "*.lmendel"
                            ]
                        }
                    }
                ],
                "label": "Mendelian Error | PLINK",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "--keep-allele-order"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 2,
                        "valueFrom": "--mendel"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 3,
                        "valueFrom": "$(inputs.input_bed.basename + \".mendel\")"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/plink-1-90:0"
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
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "QC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696880378,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696880544,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696949745,
                        "sbg:revisionNotes": "glob"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698775219,
                        "sbg:revisionNotes": "added proper globbing"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/qc-trio-analysis/mendelian-error-plink/3",
                "sbg:revision": 3,
                "sbg:revisionNotes": "added proper globbing",
                "sbg:modifiedOn": 1698775219,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1696880378,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/qc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 3,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "ade2ea658ef2a8ef872f38159b1f7eb7524dc27af10023a1a04cfa7ff0f2d785d",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "Mendelian Error | PLINK",
            "sbg:x": 712.0289916992188,
            "sbg:y": -169.5138397216797
        },
        {
            "id": "ld_pruning_plink",
            "in": [
                {
                    "id": "input_bed",
                    "source": "variant_filtering_plink/output_bed"
                },
                {
                    "id": "input_bim",
                    "source": "variant_filtering_plink/output_bim"
                },
                {
                    "id": "input_fam",
                    "source": "variant_filtering_plink/output_fam"
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
                "id": "sberke/qc-trio-analysis/ld-pruning-plink/6",
                "baseCommand": [
                    "plink"
                ],
                "inputs": [
                    {
                        "id": "input_bed",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bed",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_bim",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bim",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_fam",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--fam",
                            "shellQuote": false,
                            "position": 0
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output",
                        "type": "File?",
                        "outputBinding": {
                            "glob": [
                                "*.in",
                                "*.out"
                            ]
                        }
                    }
                ],
                "label": "LD Pruning Part 1 | PLINK",
                "arguments": [
                    {
                        "prefix": "--indep-pairphase",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "100 5 0.2"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 2,
                        "valueFrom": "$(inputs.input_bed.basename + \".LDPruned\")"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/plink-1-90:0"
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
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "QC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696951731,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696951953,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696951969,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698842546,
                        "sbg:revisionNotes": "globbing"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698842889,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698842930,
                        "sbg:revisionNotes": "fixed glob names"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698866251,
                        "sbg:revisionNotes": "return to original glob names"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/qc-trio-analysis/ld-pruning-plink/6",
                "sbg:revision": 6,
                "sbg:revisionNotes": "return to original glob names",
                "sbg:modifiedOn": 1698866251,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1696951731,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/qc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 6,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "ac7cdeb4820d64a89265055c78a001ee204e4d4322b6ebb6e2ad89d628145f711",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "LD Pruning Part 1 | PLINK",
            "sbg:x": 696.5151977539062,
            "sbg:y": 77.68972778320312
        },
        {
            "id": "ld_pruning_part_2_plink",
            "in": [
                {
                    "id": "input_prune",
                    "source": "ld_pruning_plink/output"
                }
            ],
            "out": [
                {
                    "id": "output_bed"
                },
                {
                    "id": "output_bim"
                },
                {
                    "id": "output_fam"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "sberke/qc-trio-analysis/ld-pruning-part-2-plink/2",
                "baseCommand": [
                    "plink"
                ],
                "inputs": [
                    {
                        "id": "input_bed",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bed",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_bim",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bim",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_fam",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--fam",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_prune",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--extract",
                            "shellQuote": false,
                            "position": 0
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output_bed",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.bed"
                        }
                    },
                    {
                        "id": "output_bim",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.bim"
                        }
                    },
                    {
                        "id": "output_fam",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.fam"
                        }
                    }
                ],
                "label": "LD Pruning Part 2 | PLINK",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "--make-bed"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 2,
                        "valueFrom": "$(inputs.input_bed.basename + \".extracted\")"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/plink-1-90:0"
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
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "QC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696951986,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696952187,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697216647,
                        "sbg:revisionNotes": "three outputs"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/qc-trio-analysis/ld-pruning-part-2-plink/2",
                "sbg:revision": 2,
                "sbg:revisionNotes": "three outputs",
                "sbg:modifiedOn": 1697216647,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1696951986,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/qc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 2,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a34f592ccac1b6882581f39bc449564c48af47781b7866bf10fd29a14af1dde9b",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "LD Pruning Part 2 | PLINK",
            "sbg:x": 702.9235229492188,
            "sbg:y": 278.68865966796875
        },
        {
            "id": "summary_stats_plink",
            "in": [
                {
                    "id": "input_bed",
                    "source": "plink_file_creation_plink/output_bed",
                    "pickValue": "first_non_null"
                },
                {
                    "id": "input_bim",
                    "source": "plink_file_creation_plink/output_bim"
                },
                {
                    "id": "input_fam",
                    "source": "plink_file_creation_plink/output_fam"
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
                "id": "sberke/qc-trio-analysis/summary-stats-plink/13",
                "baseCommand": [
                    "plink"
                ],
                "inputs": [
                    {
                        "id": "input_bed",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bed",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_bim",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bim",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_fam",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--fam",
                            "shellQuote": false,
                            "position": 0
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output",
                        "type": "File?",
                        "outputBinding": {
                            "glob": [
                                "*.nosex",
                                "*.frq",
                                "*.imiss",
                                "*.lmiss",
                                "*.hwe"
                            ]
                        }
                    }
                ],
                "label": "Summary Stats | PLINK",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "--keep-allele-order"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 2,
                        "valueFrom": "--missing"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 3,
                        "valueFrom": "--freq"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 4,
                        "valueFrom": "--hardy"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 5,
                        "valueFrom": "$(inputs.input_bed.basename + \".ext\")"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/plink-1-90:0"
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
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "QC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696865607,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696865895,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696866350,
                        "sbg:revisionNotes": "output added"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696875768,
                        "sbg:revisionNotes": "added support for all types of PLINK binary files"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696876118,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696876190,
                        "sbg:revisionNotes": "added all files to glob"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696968922,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696969230,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697125123,
                        "sbg:revisionNotes": "binary"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697125210,
                        "sbg:revisionNotes": "bed as file"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697127711,
                        "sbg:revisionNotes": "bfile trial"
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697128330,
                        "sbg:revisionNotes": "trial"
                    },
                    {
                        "sbg:revision": 12,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697214495,
                        "sbg:revisionNotes": "fixed the summary stats"
                    },
                    {
                        "sbg:revision": 13,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697216144,
                        "sbg:revisionNotes": "bringing back all the globs"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/qc-trio-analysis/summary-stats-plink/13",
                "sbg:revision": 13,
                "sbg:revisionNotes": "bringing back all the globs",
                "sbg:modifiedOn": 1697216144,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1696865607,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/qc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 13,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "adf5ae8d9b1eeaaac41ae1cf7b8fa86791082f0c1d90496c0299d6a907f1e0db2",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "Summary Stats | PLINK",
            "sbg:x": 342.4910888671875,
            "sbg:y": -268.55029296875
        },
        {
            "id": "merge_chrom_files_plink",
            "in": [
                {
                    "id": "input_bed",
                    "source": "ld_pruning_part_2_plink/output_bed"
                },
                {
                    "id": "input_bim",
                    "source": "ld_pruning_part_2_plink/output_bim"
                },
                {
                    "id": "input_fam",
                    "source": "ld_pruning_part_2_plink/output_fam"
                },
                {
                    "id": "input_merge_list",
                    "source": "input_merge_list"
                }
            ],
            "out": [
                {
                    "id": "output_bed"
                },
                {
                    "id": "output_bim"
                },
                {
                    "id": "output_fam"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "sberke/qc-trio-analysis/merge-chrom-files-plink/11",
                "baseCommand": [
                    "plink"
                ],
                "inputs": [
                    {
                        "id": "input_bed",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bed",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_bim",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bim",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_fam",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--fam",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_merge_list",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--merge-list",
                            "shellQuote": false,
                            "position": 0
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output_bed",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.bed"
                        }
                    },
                    {
                        "id": "output_bim",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.bim"
                        }
                    },
                    {
                        "id": "output_fam",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.fam"
                        }
                    }
                ],
                "label": "PLINK File Merge | PLINK",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "--make-bed"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "\"PhilippinesLDPruned.merged\""
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/plink-1-90:0"
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
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "QC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696952208,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696952505,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697125055,
                        "sbg:revisionNotes": "renamed"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697216696,
                        "sbg:revisionNotes": "three outputs"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698885546,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698885601,
                        "sbg:revisionNotes": "testing bfile for merge functionality"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698885759,
                        "sbg:revisionNotes": "array"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698886189,
                        "sbg:revisionNotes": "all binary files separated and array"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698887043,
                        "sbg:revisionNotes": "file requirements"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698887216,
                        "sbg:revisionNotes": "totally new approach"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698887478,
                        "sbg:revisionNotes": "got rid of file requirements"
                    },
                    {
                        "sbg:revision": 11,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1699726510,
                        "sbg:revisionNotes": "added all binary files for pipeline"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/qc-trio-analysis/merge-chrom-files-plink/11",
                "sbg:revision": 11,
                "sbg:revisionNotes": "added all binary files for pipeline",
                "sbg:modifiedOn": 1699726510,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1696952208,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/qc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 11,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a34e53087df287a199ee61681353f56f960a03c33103b87087645c64ae8f4b6ef",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "PLINK File Merge | PLINK",
            "sbg:x": 1073.198974609375,
            "sbg:y": 287.6077575683594
        },
        {
            "id": "heterozygosity_plink",
            "in": [
                {
                    "id": "input_bed",
                    "source": "merge_chrom_files_plink/output_bed"
                },
                {
                    "id": "input_bim",
                    "source": "merge_chrom_files_plink/output_bim"
                },
                {
                    "id": "input_fam",
                    "source": "merge_chrom_files_plink/output_fam"
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
                "id": "sberke/qc-trio-analysis/heterozygosity-plink/2",
                "baseCommand": [
                    "plink"
                ],
                "inputs": [
                    {
                        "id": "input_bed",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bed",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_bim",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bim",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_fam",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--fam",
                            "shellQuote": false,
                            "position": 0
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output",
                        "type": "File?",
                        "outputBinding": {
                            "glob": [
                                "*.het"
                            ]
                        }
                    }
                ],
                "label": "Heterozygosity | PLINK",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "--het"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 2,
                        "valueFrom": "$(inputs.input_bed.basename)"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/plink-1-90:0"
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
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "QC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696952531,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696952665,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1699038649,
                        "sbg:revisionNotes": ""
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/qc-trio-analysis/heterozygosity-plink/2",
                "sbg:revision": 2,
                "sbg:revisionNotes": "",
                "sbg:modifiedOn": 1699038649,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1696952531,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/qc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 2,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a9f5bfc4d7f00618a44c944b445405c42b2f8747b54e64df8420b3c532aa59c94",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "Heterozygosity | PLINK",
            "sbg:x": 1367.548583984375,
            "sbg:y": 193.9468994140625
        },
        {
            "id": "ibs_plink",
            "in": [
                {
                    "id": "input_bed",
                    "source": "merge_chrom_files_plink/output_bed"
                },
                {
                    "id": "input_bim",
                    "source": "merge_chrom_files_plink/output_bim"
                },
                {
                    "id": "input_fam",
                    "source": "merge_chrom_files_plink/output_fam"
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
                "id": "sberke/qc-trio-analysis/ibs-plink/7",
                "baseCommand": [
                    "plink"
                ],
                "inputs": [
                    {
                        "id": "input_bed",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bed",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_bim",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bim",
                            "shellQuote": false,
                            "position": 0
                        }
                    },
                    {
                        "id": "input_fam",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--fam",
                            "shellQuote": false,
                            "position": 0
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output",
                        "type": "File?",
                        "outputBinding": {
                            "glob": [
                                "*.genome"
                            ]
                        }
                    }
                ],
                "label": "IBS | PLINK",
                "arguments": [
                    {
                        "prefix": "--threads",
                        "shellQuote": false,
                        "position": 2,
                        "valueFrom": "1"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 2,
                        "valueFrom": "$(inputs.input_bed.basename + \".ibs\")"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "--genome"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/plink-1-90:0"
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
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "QC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696952741,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696952836,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1699038731,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1699039790,
                        "sbg:revisionNotes": "added the command"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1699040007,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1699040079,
                        "sbg:revisionNotes": "fixed the globbing"
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1699493819,
                        "sbg:revisionNotes": "added genome flag"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1699494172,
                        "sbg:revisionNotes": "fixed the globbing"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/qc-trio-analysis/ibs-plink/7",
                "sbg:revision": 7,
                "sbg:revisionNotes": "fixed the globbing",
                "sbg:modifiedOn": 1699494172,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1696952741,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/qc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 7,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a83f132820cb6cfc375f95b40e17b2085152689749950c1449c1d81ffb578f123",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "IBS | PLINK",
            "sbg:x": 1368.703125,
            "sbg:y": 400.5383605957031
        },
        {
            "id": "variant_filtering_plink",
            "in": [
                {
                    "id": "input_bed",
                    "source": "plink_file_creation_plink/output_bed"
                },
                {
                    "id": "input_bim",
                    "source": "plink_file_creation_plink/output_bim"
                },
                {
                    "id": "input_fam",
                    "source": "plink_file_creation_plink/output_fam"
                },
                {
                    "id": "input_drop",
                    "source": "input_drop"
                }
            ],
            "out": [
                {
                    "id": "output_bed"
                },
                {
                    "id": "output_bim"
                },
                {
                    "id": "output_fam"
                }
            ],
            "run": {
                "class": "CommandLineTool",
                "cwlVersion": "v1.2",
                "$namespaces": {
                    "sbg": "https://sevenbridges.com"
                },
                "id": "sberke/qc-trio-analysis/variant-filtering-plink/10",
                "baseCommand": [
                    "plink"
                ],
                "inputs": [
                    {
                        "id": "input_bed",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bed",
                            "shellQuote": false,
                            "position": -3
                        }
                    },
                    {
                        "id": "input_bim",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--bim",
                            "shellQuote": false,
                            "position": -2
                        }
                    },
                    {
                        "id": "input_fam",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--fam",
                            "shellQuote": false,
                            "position": -1
                        }
                    },
                    {
                        "id": "input_drop",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--remove",
                            "shellQuote": false,
                            "position": 0
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output_bed",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.bed"
                        }
                    },
                    {
                        "id": "output_bim",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.bim"
                        }
                    },
                    {
                        "id": "output_fam",
                        "type": "File?",
                        "outputBinding": {
                            "glob": "*.fam"
                        }
                    }
                ],
                "label": "Variant Filtering | PLINK",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "--keep-allele-order"
                    },
                    {
                        "prefix": "--geno",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "0.2"
                    },
                    {
                        "prefix": "--maf",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "0.05"
                    },
                    {
                        "prefix": "--hwe",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "0.000001"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 1,
                        "valueFrom": "--make-bed"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 2,
                        "valueFrom": "$(inputs.input_bed.basename + \".VarFilter\")"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "images.sbgenomics.com/aleksandar_danicic/plink-1-90:0"
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
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "QC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696865926,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696866404,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696876400,
                        "sbg:revisionNotes": "updates"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696881525,
                        "sbg:revisionNotes": "glob"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696882044,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696882082,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696949054,
                        "sbg:revisionNotes": "glob change to all binary file outputs"
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697123869,
                        "sbg:revisionNotes": "renamed"
                    },
                    {
                        "sbg:revision": 8,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697124052,
                        "sbg:revisionNotes": "revised with maf 0.05 and remove file"
                    },
                    {
                        "sbg:revision": 9,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697216510,
                        "sbg:revisionNotes": "three outputs"
                    },
                    {
                        "sbg:revision": 10,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1698768824,
                        "sbg:revisionNotes": "renamed"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/qc-trio-analysis/variant-filtering-plink/10",
                "sbg:revision": 10,
                "sbg:revisionNotes": "renamed",
                "sbg:modifiedOn": 1698768824,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1696865926,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/qc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 10,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "aabc4b47b8b600cc8746c53b35688355936dc41194a846252f800600e4e5a7569",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "Variant Filtering | PLINK",
            "sbg:x": 437.9415283203125,
            "sbg:y": -15.469305992126465
        },
        {
            "id": "initial_vcf_filtering_vcftools",
            "in": [
                {
                    "id": "input",
                    "source": "input"
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
                "id": "sberke/qc-trio-analysis/initial-vcf-filtering-vcftools/7",
                "baseCommand": [
                    "vcftools"
                ],
                "inputs": [
                    {
                        "id": "input",
                        "type": "File?",
                        "inputBinding": {
                            "prefix": "--gzvcf",
                            "shellQuote": false,
                            "position": -1
                        }
                    }
                ],
                "outputs": [
                    {
                        "id": "output",
                        "type": "File?",
                        "outputBinding": {
                            "glob": [
                                "*.vcf"
                            ]
                        }
                    }
                ],
                "label": "Basic QC | VCFTools",
                "arguments": [
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "--remove-indels"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "--remove-filtered-all"
                    },
                    {
                        "prefix": "--min-alleles",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "2"
                    },
                    {
                        "prefix": "--max-alleles",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "2"
                    },
                    {
                        "prefix": "--min-meanDP",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "10"
                    },
                    {
                        "prefix": "--minQ",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "20"
                    },
                    {
                        "prefix": "--minGQ",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "20"
                    },
                    {
                        "prefix": "--minDP",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "10"
                    },
                    {
                        "prefix": "",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "--recode"
                    },
                    {
                        "prefix": "--out",
                        "shellQuote": false,
                        "position": 0,
                        "valueFrom": "$(inputs.input.basename)"
                    }
                ],
                "requirements": [
                    {
                        "class": "ShellCommandRequirement"
                    },
                    {
                        "class": "DockerRequirement",
                        "dockerPull": "pgc-images.sbgenomics.com/sberke/hts"
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
                    }
                ],
                "stdout": "stdout.out",
                "stderr": "stderr.err",
                "sbg:projectName": "QC Trio Analysis",
                "sbg:revisionsInfo": [
                    {
                        "sbg:revision": 0,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696873419,
                        "sbg:revisionNotes": null
                    },
                    {
                        "sbg:revision": 1,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696873708,
                        "sbg:revisionNotes": "initial framework"
                    },
                    {
                        "sbg:revision": 2,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696873995,
                        "sbg:revisionNotes": "glob attempt"
                    },
                    {
                        "sbg:revision": 3,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1696874406,
                        "sbg:revisionNotes": "name change quick"
                    },
                    {
                        "sbg:revision": 4,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1697128628,
                        "sbg:revisionNotes": "more basic name"
                    },
                    {
                        "sbg:revision": 5,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1699674101,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 6,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1711931433,
                        "sbg:revisionNotes": ""
                    },
                    {
                        "sbg:revision": 7,
                        "sbg:modifiedBy": "sberke",
                        "sbg:modifiedOn": 1711931466,
                        "sbg:revisionNotes": "renamed"
                    }
                ],
                "sbg:image_url": null,
                "sbg:appVersion": [
                    "v1.2"
                ],
                "sbg:id": "sberke/qc-trio-analysis/initial-vcf-filtering-vcftools/7",
                "sbg:revision": 7,
                "sbg:revisionNotes": "renamed",
                "sbg:modifiedOn": 1711931466,
                "sbg:modifiedBy": "sberke",
                "sbg:createdOn": 1696873419,
                "sbg:createdBy": "sberke",
                "sbg:project": "sberke/qc-trio-analysis",
                "sbg:sbgMaintained": false,
                "sbg:validationErrors": [],
                "sbg:contributors": [
                    "sberke"
                ],
                "sbg:latestRevision": 7,
                "sbg:publisher": "sbg",
                "sbg:content_hash": "a6dfd47174748888fb107a5fe7dde888010454561be0a125312170c80612624c0",
                "sbg:workflowLanguage": "CWL"
            },
            "label": "Basic QC | VCFTools",
            "sbg:x": -201.4114990234375,
            "sbg:y": -80.81109619140625
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
    "sbg:projectName": "QC Trio Analysis",
    "sbg:revisionsInfo": [
        {
            "sbg:revision": 0,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1696967908,
            "sbg:revisionNotes": null
        },
        {
            "sbg:revision": 1,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1696970731,
            "sbg:revisionNotes": "initial framework"
        },
        {
            "sbg:revision": 2,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1697124664,
            "sbg:revisionNotes": "rev 2"
        },
        {
            "sbg:revision": 3,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1697125413,
            "sbg:revisionNotes": "fixed"
        },
        {
            "sbg:revision": 4,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1697125563,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 5,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1697128958,
            "sbg:revisionNotes": "output"
        },
        {
            "sbg:revision": 6,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1697214628,
            "sbg:revisionNotes": "updated summary stats"
        },
        {
            "sbg:revision": 7,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1697216598,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 8,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1697216762,
            "sbg:revisionNotes": "updated for three outputs for everything"
        },
        {
            "sbg:revision": 9,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1697217494,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 10,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1698685657,
            "sbg:revisionNotes": "kept what was only necessary for the remainder of the analysis"
        },
        {
            "sbg:revision": 11,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1699726078,
            "sbg:revisionNotes": "for the visual"
        },
        {
            "sbg:revision": 12,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1699726830,
            "sbg:revisionNotes": "optics continued"
        },
        {
            "sbg:revision": 13,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1699727077,
            "sbg:revisionNotes": "for the QC ppt presentation"
        },
        {
            "sbg:revision": 14,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1711932145,
            "sbg:revisionNotes": "renamed several apps"
        },
        {
            "sbg:revision": 15,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1711932271,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 16,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1711932279,
            "sbg:revisionNotes": ""
        },
        {
            "sbg:revision": 17,
            "sbg:modifiedBy": "sberke",
            "sbg:modifiedOn": 1711932326,
            "sbg:revisionNotes": "renamed again"
        }
    ],
    "sbg:image_url": "https://cavatica.sbgenomics.com/ns/brood/images/sberke/qc-trio-analysis/quality-control/17.png",
    "sbg:appVersion": [
        "v1.2"
    ],
    "id": "https://cavatica-api.sbgenomics.com/v2/apps/sberke/qc-trio-analysis/quality-control/17/raw/",
    "sbg:id": "sberke/qc-trio-analysis/quality-control/17",
    "sbg:revision": 17,
    "sbg:revisionNotes": "renamed again",
    "sbg:modifiedOn": 1711932326,
    "sbg:modifiedBy": "sberke",
    "sbg:createdOn": 1696967908,
    "sbg:createdBy": "sberke",
    "sbg:project": "sberke/qc-trio-analysis",
    "sbg:sbgMaintained": false,
    "sbg:validationErrors": [],
    "sbg:contributors": [
        "sberke"
    ],
    "sbg:latestRevision": 17,
    "sbg:publisher": "sbg",
    "sbg:content_hash": "a83cc853f75ef0bce8d0093b57521ab697e5f6336c77bb7df19a7591a7e188e3f",
    "sbg:workflowLanguage": "CWL"
}
