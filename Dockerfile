FROM rocker/r-ver:4.2.0
### rocker/r-base:4.2.0 OS is Debian 11 (ie. "debian-11" for remotes::system_requirements)
### above release is unstable
### rocker/r-ver:4.2.0 OS is Ubuntu 20.04" (is. "ubuntu-20.04")

### for Debian (rocker/r-base:4.2.0)
# RUN sed -i 's|http://deb.debian.org/debian|http://mirror.aarnet.edu.au/pub/debian|' /etc/apt/sources.list

### for Ubuntu (rocker/r-ver:4.2.0)
RUN sed -i 's|http://archive.ubuntu.com/ubuntu|http://mirror.aarnet.edu.au/pub/ubuntu/archive|' /etc/apt/sources.list

RUN apt-get update --allow-insecure-repositories \
	&& apt-get install -y --allow-unauthenticated \
		apt-utils

RUN apt-get update --allow-insecure-repositories \
	&& apt-get install -y --allow-unauthenticated \	
		dpkg-dev build-essential make libcurl4-openssl-dev libssl-dev make libgit2-dev zlib1g-dev pandoc libfreetype6-dev libjpeg-dev libpng-dev libtiff-dev libicu-dev libfontconfig1-dev libfribidi-dev libharfbuzz-dev libxml2-dev libzmq3-dev libnode-dev libglpk-dev libgmp3-dev
### all R packages for pipeRline: c("Biostrings","DECIPHER","ShortRead","bs4Dash","clustermq","dada2","dplyr","future","ggplot2","gridExtra","gt","magrittr","markdown","ngsReports","patchwork","phyloseq","pingr","purrr","readr","rlang","rstudioapi","savR","scales","shiny","shinyWidgets","shinybusy","stringr","tibble","tidyr","vegan","visNetwork")
### from pak::sysreqs: make libcurl4-openssl-dev libjpeg-dev libpng-dev libssl-dev zlib1g-dev libzmq3-dev libicu-dev libnode-dev pandoc libxml2-dev libglpk-dev libgmp3-dev
### including devtools: libcurl4-openssl-dev libssl-dev make libgit2-dev zlib1g-dev pandoc libfreetype6-dev libjpeg-dev libpng-dev libtiff-dev libicu-dev libfontconfig1-dev libfribidi-dev libharfbuzz-dev libxml2-dev libzmq3-dev libnode-dev libglpk-dev libgmp3-dev

RUN rm -rf /var/lib/apt/lists/*

### from here: https://rocker-project.org/images/versioned/r-ver.html
### this makes renv use pak for installation, should be faster
RUN echo 'options(renv.config.pak.enabled = TRUE)' >> "${R_HOME}/etc/Rprofile.site"

RUN install2.r --error \
	--repos http://mirror.aarnet.edu.au/pub/CRAN/ \
	pak \
	renv \
	remotes \
	devtools 

## renv.lock file has crew, nanonext and mirai packages removed
COPY renv.lock renv.lock

### from here, "approach one": https://rstudio.github.io/renv/articles/docker.html
ENV RENV_PATHS_LIBRARY renv/library

RUN R -e "renv::restore()"

### install taxreturn from Github 
# RUN R -e 'pak::pkg_install("alexpiper/taxreturn@e9dc03a")'
# RUN R -e 'pak::pkg_install("alexpiper/seqateurs")'

## RUN R -e "pak::pkg_system_requirements('colorspace')"

# # #RUN install2.r --error --deps TRUE \
# # #--repos http://cloud.r-project.org/ --repos getOption \
# # #ggExtra

# RUN mkdir -p /home/analysis

# COPY myscript.R /home/analysis/myscript.R

# CMD cd /home/analysis \
# 	&& R -e "source('/home/analysis/myscript.R')" \
# 	&& mv /home/analysis/test.png /mnt/c/Users/js7t/code/docker_test/results
