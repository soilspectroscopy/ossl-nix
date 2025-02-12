# This file was generated by the {rix} R package v0.14.3 on 2025-02-07
# with following call:
# >rix(date = "2023-12-30",
#  > r_pkgs = c("tidyverse",
#  > "mlr3",
#  > "qs",
#  > "matrixStats",
#  > "prospectr",
#  > "Cubist",
#  > "checkmate",
#  > "mlr3misc",
#  > "mlr3viz",
#  > "paradox"),
#  > system_pkgs = NULL,
#  > git_pkgs = list(package_name = "mlr3extralearners",
#  > repo_url = "https://github.com/mlr-org/mlr3extralearners/",
#  > commit = "6e2af9ef9ecd420d2be44e9aa2488772bb9f7080"),
#  > ide = "code",
#  > project_path = path_default_nix,
#  > overwrite = TRUE,
#  > print = TRUE,
#  > r_ver = "4.3.2")
# It uses the `rstats-on-nix` fork of `nixpkgs` which provides improved
# compatibility with older R versions and R packages for Linux/WSL and
# Apple Silicon computers.
# Report any issues to https://github.com/ropensci/rix
let
 pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/2023-12-30.tar.gz") {};
 
  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages) 
      checkmate
      Cubist
      languageserver
      matrixStats
      mlr3
      mlr3misc
      paradox
      prospectr
      qs
      tidyverse;
  };
 
    CoxBoost = (pkgs.rPackages.buildRPackage {
      name = "CoxBoost";
      src = pkgs.fetchgit {
        url = "https://github.com/binderh/CoxBoost";
        rev = "1dc47d7051f660b28520670b34d031143f9eadfd";
        sha256 = "sha256-5Ck0idCpn6oU3RBULqcz7bEtOnYxzKH29aHVzOUWGsQ=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          survival
          Matrix
          prodlim;
      };
    });


    set6 = (pkgs.rPackages.buildRPackage {
      name = "set6";
      src = pkgs.fetchgit {
        url = "https://github.com/xoopR/set6";
        rev = "a901255c26614a0ece317dc849621420f9393d42";
        sha256 = "sha256-3iDxFyGqSp4msc2BzIFx62nQtO0OsWI8gYhyod4un4A=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          checkmate
          ooplah
          Rcpp
          R6;
      };
    });

    param6 = (pkgs.rPackages.buildRPackage {
      name = "param6";
      src = pkgs.fetchgit {
        url = "https://github.com/xoopR/param6";
        rev = "0fa35771276fc05efe007a71bda466ced1e4c5eb";
        sha256 = "sha256-6mfOzx0DPGnKyXJPFm1V1qhsLCIHC26XW8q5jZ2gpAg=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          checkmate
          data_table
          dictionar6
          R6;
      } ++ [ set6 ];
    });

    distr6 = (pkgs.rPackages.buildRPackage {
      name = "distr6";
      src = pkgs.fetchgit {
        url = "https://github.com/xoopR/distr6";
        rev = "255a666dfe9119ceb78c769069eacc223c95b066";
        sha256 = "sha256-sKSY4hunJFjhB9sA3r2sy95EYatkuH/9ZBodrbQVOYs=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          checkmate
          data_table
          ooplah
          R6
          Rcpp;
      } ++ [ set6 param6 ];
    });

    mlr3proba = (pkgs.rPackages.buildRPackage {
      name = "mlr3proba";
      src = pkgs.fetchgit {
        url = "https://github.com/mlr-org/mlr3proba";
        rev = "5a929427466e994ca0165e4c3f4f6580a5d214eb";
        sha256 = "sha256-N/iM0io1HjMN+0IralTSignhuuH+kXkeW+Lonut87Ow=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          mlr3
          checkmate
          data_table
          ggplot2
          mlr3misc
          mlr3viz
          paradox
          R6
          Rcpp
          survival;
      } ++ [ distr6 param6 set6 survivalmodels ];
    });

    survivalmodels = (pkgs.rPackages.buildRPackage {
      name = "survivalmodels";
      src = pkgs.fetchgit {
        url = "https://github.com/RaphaelS1/survivalmodels";
        rev = "9d59b0c93780a71ae8a6c9904eed72a360a1c2d6";
        sha256 = "sha256-LvrT6425UU3gMY3xpXCz/iE9I1GH7gsWxTKOO8KMpVU=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          Rcpp;
      } ++ [ distr6 param6 set6 ];
    });

    mlr3extralearners = (pkgs.rPackages.buildRPackage {
      name = "mlr3extralearners";
      src = pkgs.fetchgit {
        url = "https://github.com/mlr-org/mlr3extralearners/";
        rev = "6e2af9ef9ecd420d2be44e9aa2488772bb9f7080";
        sha256 = "sha256-zdoZUSdL90uZcUF/5nxrNhZ9JdVRb6arstW1SjAACX8=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          checkmate
          data_table
          mlr3
          mlr3misc
          paradox
          R6;
      } ++ [ distr6 CoxBoost mlr3proba survivalmodels param6 set6 ];
    });
    
  system_packages = builtins.attrValues {
    inherit (pkgs) 
      glibcLocales
      nix
      R;
  };
  
in

pkgs.mkShell {
  LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
  LANG = "en_US.UTF-8";
   LC_ALL = "en_US.UTF-8";
   LC_TIME = "en_US.UTF-8";
   LC_MONETARY = "en_US.UTF-8";
   LC_PAPER = "en_US.UTF-8";
   LC_MEASUREMENT = "en_US.UTF-8";

  buildInputs = [ mlr3extralearners rpkgs  system_packages   ];
  
}
