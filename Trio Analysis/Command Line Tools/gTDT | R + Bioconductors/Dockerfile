# Docker Inheritance
FROM bioconductor/bioconductor_docker:devel-amd64

# Install Required Packages
RUN R -e "install.packages('data.table')"
RUN R -e 'BiocManager::install("VariantAnnotation")'
RUN R -e 'BiocManager::install("trio")'
