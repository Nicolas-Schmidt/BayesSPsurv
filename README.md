
<!-- README.md is generated from README.Rmd. Please edit that file -->

# spatialSPsurv

<!-- badges: start -->

[![R build
status](https://github.com/Nicolas-Schmidt/spatialSPsurv/workflows/R-CMD-check/badge.svg)](https://github.com/Nicolas-Schmidt/spatialSPsurv/actions)
[![Project Status: Active â€“ The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![](https://img.shields.io/badge/devel%20version-0.2.0-blue.svg)](https://github.com/Nicolas-Schmidt/BayesMFSurv)
<!-- badges: end -->

Bayesian Spatial Split Population Survival Model

Manual
[**here**](https://github.com/Nicolas-Schmidt/spatialSPsurv/blob/master/man/figures/manual_spatialSPsurv.pdf).

## Installation

``` r
source("https://install-github.me/Nicolas-Schmidt/spatialSPsurv")
```

``` r
## ---------------------
## LOCAL CHECK!
## ---------------------


net_str_f('spatialSPsurv')
#> Registered S3 method overwritten by 'pryr':
#>   method      from
#>   print.bytes Rcpp
#> # A tibble: 47 x 6
#>    ind        `func 1`       `func 2`       `func 3`    `func 4`    `func 5`    
#>    <fct>      <chr>          <chr>          <chr>       <chr>       <chr>       
#>  1 betas.post ""             ""             ""          ""          ""          
#>  2 betas.sli~ "univ.betas.s~ "univ.betas.s~ ""          ""          ""          
#>  3 gammas.po~ ""             ""             ""          ""          ""          
#>  4 gammas.po~ ""             ""             ""          ""          ""          
#>  5 gammas.sl~ "univ.gammas.~ "univ.gammas.~ ""          ""          ""          
#>  6 gammas.sl~ "univ.gammas.~ "univ.gammas.~ ""          ""          ""          
#>  7 mcmcfrail~ "betas.slice.~ "gammas.slice~ "rho.slice~ "V.F.MH.sa~ "W.F.MH.sam~
#>  8 mcmcSP     "betas.slice.~ "gammas.slice~ "rho.slice~ "betas.sli~ "gammas.sli~
#>  9 mcmcspati~ "betas.slice.~ "gammas.slice~ "rho.slice~ "V.MH.samp~ "W.MH.sampl~
#> 10 rho.post   ""             ""             ""          ""          ""          
#> # ... with 37 more rows
```
