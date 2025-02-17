

<!-- Badges on top of the page -->

<a href="https://doi.org/10.1371/journal.pone.0296545">
<img src="https://journals.plos.org/resource/img/one/logo.png" style="background-color:white;height:45px;">

[![](https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white)](https://github.com/soilspectroscopy)

[![](https://zenodo.org/badge/doi/10.5281/zenodo.5759693.svg)](https://doi.org/10.5281/zenodo.5759693)

<!-- Content -->

Welcome to the Open Soil Spectral Library (OSSL)!

This repository contains a reproducible workflow for downloading the
OSSL pre-trained models and executing them on a containerized terminal
for getting local predictions, making sure all software dependencies are
met.

**This is required as many R packages are being updated and the legacy
files and models can only be executed using the same computing
conditions that was available during calibration (v1.2 was trained in
2023).**

The OSSL models v1.2 were trained using [**R software with the MLR3
framework**](https://docs.soilspectroscopy.org/prediction-models.html)
and they can be locally run using the `nix-shell` loaded in your
terminal after building the required computing environment.

Available models are described in
[**fitted_models_performance_v1.2.csv**](fitted_models_performance_v1.2.csv).

After local execution, the output `CSV` will contain the prediction
value for the soil property of interest with the lower and upper
uncertainty limits for one standard deviation (all back-transformed if
log1p transformation was used, so it can be asymmetrical), and a flag
for potentially underrepresented spectra given the OSSL calibration data
(calculated based on PCA and residual Q statistics).

We provided in this repository:  
1. A prediction function that preprocess and provide all prediction
outputs ([**OSSL_functions.R**](OSSL_functions.R)).  
2. An [**R script**](script_download_ossl_models.R) for downloading the
OSSL models and ancillary files from Google Cloud Storage.  
3. An [**R script**](script_download_example_spectra.R) for downloading
a few spectral measurements obtained with the the Neospectra NIR
scanner.  
4. An [**R script**](script_predictions.R) that encapsulates all user
requirements/needs for getting local predictions with the `nix-shell`
terminal.  
5. A build specification for Nix ([**default.nix**](default.nix)) that
makes sure you will have the same computation environment. Please don’t
change this file or overwrite it.

# Requirements

Download [**“Nix: the package manager”**](https://nixos.org/download/)
for reproducible computation. Follow the installation instructions
according to your operating system.

If you are an R user, you can learn more about Nix from the highly
recommended [**rix documentation**](https://docs.ropensci.org/rix/)
(also gives a great overview for non R users).

Also, make sure your spectral measurements are stored on a `CSV` file
with the first columns indicating the sample id, while all the remaining
columns represent the measure spectral range. For using the pre-trained
models, the spectra to be predicted must follow these range
specifications:  
- VisNIR: 400-2500 nm, in reflectance units.  
- NIR Neospectra: 1350-2550 nm, in reflectance units.  
- MIR: 600-4000 cm<sup>-1</sup>, in pseudo absorbance (i.e.,
log10(1/R)).

> The OSSL prediction function tolerates spectra with +-5 units of
> difference in the edges. Also, the spectra can be provided with
> headers in decreasing or increasing order. Lastly, the function will
> run an internal interpolation to match the 2 nm or cm<sup>-1</sup> of
> resolution required by the models. All spectra are preprocessed
> internally using Standard Normal Variate.

For example:

| sample_id | 2550     | 2540     | 2530     | 2520     | …   |
|-----------|----------|----------|----------|----------|-----|
| 1         | 22.06418 | 22.18103 | 22.30100 | 22.43992 | …   |
| 2         | 60.75213 | 60.46935 | 60.30870 | 60.27188 | …   |
| 3         | 51.53300 | 51.52111 | 51.56430 | 51.66204 | …   |
| 4         | 35.16751 | 35.25881 | 35.38252 | 35.58001 | …   |
| 5         | 48.95702 | 49.01610 | 49.13582 | 49.33497 | …   |
| …         | …        | …        | …        | …        | …   |

The prediction function ([**OSSL_functions.R**](OSSL_functions.R)) has
the following parameters:

- `target`: the soil property of interest. Log-transformed properties
  must have `log..` appended at the beginning of the name.  
- `spectra.file`: the path for the spectral measurements as a `csv`
  table (following the sample-data specifications).  
- `spectra.type`: the spectral range of interest. Either `visnir`,
  `nir.neospectra`, or `mir`.  
- `subset.type`: the subset of interest, either the whole `ossl` or the
  `kssl` alone.  
- `geo.type`: only available for `na`.  
- `models.dir`: the path for the `ossl_models` folder. Should follow the
  same structure and naming code as represented in
  [**ossl_models_directory_tree.csv**](file/ossl_models_directory_tree.csv).

Available models are described in
[**fitted_models_performance_v1.2.csv**](fitted_models_performance_v1.2.csv).

# Usage

1.  After installing Nix, navigate to this project folder in your
    terminal:  
    `cd projects/git/ossl-nix`  
2.  Build the Nix computing environment by running on the terminal (can
    take a while in the first time):  
    `nix-build`  
3.  Load the reproducile shell:  
    `nix-shell`  
4.  Execute the local predictions:  
    `Rscript script_predictions.R`

Make sure you have downloaded the OSSL models to your computer and have
indicated (inside [**script_predictions.R**](script_predictions.R)) the
directory with the ossl models, the folder where predictions will be
saved, and the prediction combinations. Please use and change this
script template.

# Additional info

For further reference, please visit the [OSSL
manual](https://docs.soilspectroscopy.org/) to learn more about the
database, models, and other resources.

The OSSL is a public and growing database that is compiled by the [Soil
Spectroscopy for Global Good](https://soilspectroscopy.org/) initiative.

A [peer-reviewed and open-access
publication](https://doi.org/10.1371/journal.pone.0296545) is available
for additional reference.

You can also visit other additional open-access repositories in our
[GitHub organization](https://github.com/soilspectroscopy).
