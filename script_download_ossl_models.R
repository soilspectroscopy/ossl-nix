
# Libraries
library("tidyverse")
library("fs")

options(timeout = 10000)

# Target folder for storing the local models
# The last folder must be named 'ossl_models'
target.folder <- "~/projects/temp/ossl_models"

# Making sure it exists
if(!fs::dir_exists(target.folder)){fs::dir_create(target.folder)}

# Checking local directory tree
fs::dir_tree(target.folder)

# Repository tree and structure need for running local models
ossl.files <- read_csv("files/ossl_models_directory_tree.csv")

# Specify your spectral range of interest
# Or omit this step if interested in all spectral ranges
visnir.range <- "visnir"
mir.range <- "mir"
nir.range <- "neospectra"

# Selecting only neospectra models
ossl.files <- ossl.files %>%
  filter(grepl(nir.range, file_path))

# Selecting the PCA folder, and only a few soil properties, for example
soil.properties <- c("pca.ossl",
                     "log..oc_usda.c729_w.pct", # SOC
                     "clay.tot_usda.a334_w.pct", # Clay
                     "ph.h2o_usda.a268_index") # pH H2O

ossl.files <- ossl.files %>%
  filter(grepl(paste(soil.properties, collapse = "|"), file_path))

# Creating subfolders recursevely for storing the models and ancillary files
subfolders <- unique(dirname(ossl.files$file_path))

for(i in 1:length(subfolders)){
  isubfolder <- subfolders[i]
  subfolder.path <- paste(target.folder, isubfolder, sep = "/")
  if(!fs::dir_exists(subfolder.path)){fs::dir_create(subfolder.path)} else next
}

# Downloading models and ancillary files
i=1
for(i in 1:nrow(ossl.files)) {
  
  ifile <- ossl.files[[i,"file_path"]]
  iremote.folder <- ossl.files[[i,"public_path"]]
  
  remote.file <- paste(iremote.folder, ifile, sep = "/")
  local.file <- paste(target.folder, ifile, sep = "/")
  
  if(fs::file_exists(local.file)){fs::file_delete(local.file)}
  
  tryCatch(
    expr = {download.file(remote.file, local.file, mode = "wb")},
    error = function(e){"Retry again"})
  
}

# Checking local directory tree
fs::dir_tree(target.folder)
