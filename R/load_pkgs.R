# Load packages for API queries and data analysis
# use `groundhog` package version management 
install.packages("groundhog")
library("groundhog")
meta.groundhog('2022-10-31') # Not working
groundhog.day <-'2022-03-10'

groundhog.library(
"library(readr)
library(jsonlite)
library(tidyr)
library(dplyr)
library(dataone)
library(job)
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
library(miniUI)", 
groundhog.day,
tolerate.R.version='4.1.3')

# install development version of scythe package with added xdd library
groundhog.library('github::dataoneorg/scythe/develop' , groundhog.day, tolerate.R.version='4.1.3')
#devtools::install_github("dataoneorg/scythe@develop")

# install dev version of rcrossref package with update API for `scythe::write_citation_pairs` dependency
groundhog.library('github::ropensci/rcrossref', '2022-08-11', tolerate.R.version='4.1.3')
