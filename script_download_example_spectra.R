
library("tidyverse")
library("fs")

nir.example.file.url <- "https://github.com/soilspectroscopy/ossl-models/raw/main/sample-data/sample_neospectra_data.csv"

nir.example.file.path <- path(getwd(), "sample_neospectra_data.csv")

download.file(url = nir.example.file.url,
              destfile = nir.example.file.path,
              mode = "wb")

# Checking csv file
nir.spectra <- read_csv(nir.example.file.path)
nir.spectra
