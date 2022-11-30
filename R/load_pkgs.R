# Load packages for API queries and data analysis

# use `groundhog` package version management 
#require("groundhog")
#meta.groundhog('2022-10-31') # maintain consistent groundhog version
#groundhog.day <-'2022-07-14'
# Not working for now

library(readr)
library(jsonlite)
library(tidyr)
library(dplyr)
library(job)
library(dataone)
library(magrittr)
library(readr)
library(stringr)
library(purrr)
library(ggplot2)
library(htmltools)
library(eulerr)
library(dataone)
library(scales)
library(viridis)
library(curl)
library(miniUI)
library(ggraph)
library(igraph)
library(viridis)
library(kableExtra)


# install development version of scythe package with added xdd library
#groundhog.library('github::dataoneorg/scythe' , groundhog.day, tolerate.R.version='4.1.3') # does not work with git branch
#devtools::install_github("dataoneorg/scythe@develop")
devtools::load_all('~/scythe/R')

# install dev version of rcrossref package with update API for `scythe::write_citation_pairs` dependency
#groundhog.library('github::ropensci/rcrossref', '2022-08-11', tolerate.R.version='4.1.3')
devtools::install_github("ropensci/rcrossref")
