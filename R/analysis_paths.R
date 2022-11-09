# Create analysis directories and file paths

# create output directory
output_directory <- file.path("./output")
dir.create(path = output_directory, showWarnings = F)

# Set up result file paths
path_scopus <- file.path(output_directory, paste0("scythe_", date, "_scopus.csv"))
path_springer <- file.path(output_directory, paste0("scythe_", date, "_springer.csv"))
path_plos <- file.path(output_directory, paste0("scythe_", date, "_plos.csv"))
path_xdd <- file.path(output_directory, paste0("scythe_", date, "_xdd.csv"))

# path to write error re-run results
path_error <- file.path(output_directory, paste0("scythe_", date, "_"))

# path to all scythe results w/ errors removed
path_all <- file.path(output_directory, paste0("scythe_", date, "_all_analysis.csv"))

# path to source overlap
path_overlap <- file.path(output_directory, paste0("scythe_", date, "_prct_overlap.csv"))

# create data directory
data_dir <- file.path("./data")
dir.create(path = data_dir, showWarnings = F)