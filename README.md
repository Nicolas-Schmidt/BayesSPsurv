
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
#>    ind         `func 1`       `func 2`       `func 3`    `func 4`    `func 5`   
#>    <fct>       <chr>          <chr>          <chr>       <chr>       <chr>      
#>  1 betas.post  ""             ""             ""          ""          ""         
#>  2 betas.slic~ "univ.betas.s~ "univ.betas.s~ ""          ""          ""         
#>  3 gammas.post ""             ""             ""          ""          ""         
#>  4 gammas.pos~ ""             ""             ""          ""          ""         
#>  5 gammas.sli~ "univ.gammas.~ "univ.gammas.~ ""          ""          ""         
#>  6 gammas.sli~ "univ.gammas.~ "univ.gammas.~ ""          ""          ""         
#>  7 mcmcfrailt~ "betas.slice.~ "gammas.slice~ "rho.slice~ "V.F.MH.sa~ "W.F.MH.sa~
#>  8 mcmcSP      "betas.slice.~ "gammas.slice~ "rho.slice~ "betas.sli~ "gammas.sl~
#>  9 mcmcspatia~ "betas.slice.~ "gammas.slice~ "rho.slice~ "V.MH.samp~ "W.MH.samp~
#> 10 rho.post    ""             ""             ""          ""          ""         
#> 11 rho.slice.~ "rho.post"     "rho.post"     ""          ""          ""         
#> 12 univ.betas~ "betas.post"   "betas.post"   ""          ""          ""         
#> 13 univ.gamma~ "gammas.post"  "gammas.post"  ""          ""          ""         
#> 14 univ.gamma~ "gammas.post2" "gammas.post2" ""          ""          ""         
#> 15 V.F.MH.sam~ "V.F.post"     "V.F.post"     ""          ""          ""         
#> 16 V.F.post    ""             ""             ""          ""          ""         
#> 17 V.MH.sampl~ "V.post"       "V.post"       ""          ""          ""         
#> 18 V.post      ""             ""             ""          ""          ""         
#> 19 W.F.MH.sam~ "W.F.post"     ""             ""          ""          ""         
#> 20 W.MH.sampl~ "W.post"       "W.post"       ""          ""          ""         
#> 21 W.post      ""             ""             ""          ""          ""         
#> 22 betas.post  ""             ""             ""          ""          ""         
#> 23 betas.slic~ "univ.betas.s~ "univ.betas.s~ ""          ""          ""         
#> 24 frailtySPs~ "mcmcfrailtyS~ "mcmcfrailtyS~ ""          ""          ""         
#> 25 gammas.post ""             ""             ""          ""          ""         
#> 26 gammas.pos~ ""             ""             ""          ""          ""         
#> 27 gammas.sli~ "univ.gammas.~ "univ.gammas.~ ""          ""          ""         
#> 28 gammas.sli~ "univ.gammas.~ "univ.gammas.~ ""          ""          ""         
#> 29 lambda.gib~ ""             ""             ""          ""          ""         
#> 30 mcmcfrailt~ "betas.slice.~ "gammas.slice~ "rho.slice~ "V.F.MH.sa~ "W.F.MH.sa~
#> 31 mcmcSP      "betas.slice.~ "gammas.slice~ "rho.slice~ "betas.sli~ "gammas.sl~
#> 32 mcmcspatia~ "betas.slice.~ "gammas.slice~ "rho.slice~ "V.MH.samp~ "W.MH.samp~
#> 33 rho.post    ""             ""             ""          ""          ""         
#> 34 rho.slice.~ "rho.post"     "rho.post"     ""          ""          ""         
#> 35 spatialSPs~ "mcmcspatialS~ "mcmcspatialS~ ""          ""          ""         
#> 36 SPsurv      "mcmcSP"       "mcmcSP"       ""          ""          ""         
#> 37 univ.betas~ "betas.post"   "betas.post"   ""          ""          ""         
#> 38 univ.gamma~ "gammas.post"  "gammas.post"  ""          ""          ""         
#> 39 univ.gamma~ "gammas.post2" "gammas.post2" ""          ""          ""         
#> 40 V.F.MH.sam~ "V.F.post"     "V.F.post"     ""          ""          ""         
#> 41 V.F.post    ""             ""             ""          ""          ""         
#> 42 V.MH.sampl~ "V.post"       "V.post"       ""          ""          ""         
#> 43 V.post      ""             ""             ""          ""          ""         
#> 44 W.F.MH.sam~ "W.F.post"     ""             ""          ""          ""         
#> 45 W.F.post    ""             ""             ""          ""          ""         
#> 46 W.MH.sampl~ "W.post"       "W.post"       ""          ""          ""         
#> 47 W.post      ""             ""             ""          ""          ""
```

``` r

# ADD

.onUnload <- function (libpath) {
  library.dynam.unload("spatialSPsurv", libpath)
}

# ATT

> checking Rd \usage sections ... WARNING
  Undocumented arguments in documentation object 'V.F.MH.sampling'
    'Sigma.v'
  
  Undocumented arguments in documentation object 'V.F.post'
    'Sigma.v'
  
  Undocumented arguments in documentation object 'W.F.MH.sampling'
    'Sigma.w'
  
  Undocumented arguments in documentation object 'W.F.post'
    'Sigma.w'
  
  Undocumented arguments in documentation object 'mcmcSP'
    'LY'
  
  Documented arguments not in \usage in documentation object 'mcmcfrailtySP':
    'A'
  
  Functions with \usage entries need to have the appropriate \alias
  entries, and all their arguments documented.
  The \usage entries must correspond to syntactically valid R code.
  See chapter 'Writing R documentation files' in the 'Writing R
  Extensions' manual.

> checking R code for possible problems ... NOTE
  SPsurv: no visible binding for global variable 'S'
  Undefined global functions or variables:
```
