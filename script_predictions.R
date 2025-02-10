
####################################################################
#  ATTENTION: This script must be run on a nix-shell environment.  #
#  It will probably not work on your regular RStudio environment.  #
####################################################################

## Packages
suppressMessages(library("tidyverse"))
suppressMessages(library("lubridate"))

# Custom prediction function inside 'OSSL_functions'
source("OSSL_functions.R")

## Change with your local directory containing the ossl models
dir.ossl.models <- paste0("~/projects/temp/ossl_models/")
export.dir <- "predictions/"

if(!dir.exists(export.dir)){dir.create(export.dir)}

cat("\nPredictions will be saved in folder '", export.dir, "'\n",
    "inside the project or working directory\n\n")

## Test data
new.data.path <- "sample_neospectra_data.csv"

## Prediciton combinations
## Following OSSL schema
soil.properties <- c("log..oc_usda.c729_w.pct",
                     "clay.tot_usda.a334_w.pct",
                     "ph.h2o_usda.a268_index")

spectra <- "nir.neospectra"
model <- "cubist"
subset <- "ossl"
geo <- "na"

prediction.combinations <- tibble(soil_property = soil.properties) %>%
  crossing(spectra_type = spectra) %>%
  crossing(model_type = model) %>%
  crossing(subset_type = subset) %>%
  crossing(geo_type = geo)

cat("Overview of prediction tasks...\n")

knitr::kable(prediction.combinations)

cat("\n\nExecuting predictions...\n\n")
# Iterating predictions and saving to disk

i=1
for(i in 1:nrow(prediction.combinations)) {
  
  itarget <- prediction.combinations[[i,"soil_property"]]
  iexport.name <- gsub("log..", "", itarget)
  ispectra.type <- prediction.combinations[[i,"spectra_type"]]
  imodel.type <- prediction.combinations[[i,"model_type"]]
  isubset.type <- prediction.combinations[[i,"subset_type"]]
  igeo.type <- prediction.combinations[[i,"geo_type"]]
  
  result <- predict.ossl(target = itarget,
                         spectra.file = new.data.path,
                         spectra.type = ispectra.type,
                         subset.type = isubset.type,
                         geo.type = igeo.type,
                         models.dir = dir.ossl.models)
  
  file.export <- paste0(export.dir, "pred_", iexport.name,
                        "..", ispectra.type, "_", imodel.type,
                        "_", isubset.type,
                        "_", igeo.type, "_v1.2.csv")
  
  if(file.exists(file.export)){file.remove(file.export)}
  
  write_csv(result, file.export)
  
  cat(paste0("Run ", i, "/", nrow(prediction.combinations), " at ", now(), "\n"))
  
}

cat("\n\nEnd!")