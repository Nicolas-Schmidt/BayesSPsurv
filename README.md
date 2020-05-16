
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
[![](https://img.shields.io/badge/devel%20version-1.4.0-blue.svg)](https://github.com/Nicolas-Schmidt/IntRo)
<!-- badges: end -->

Bayesian Spatial Split Population Survival Model.

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
#> # A tibble: 24 x 6
#>    ind          `func 1`        `func 2`      `func 3`     `func 4`   `func 5`  
#>    <fct>        <chr>           <chr>         <chr>        <chr>      <chr>     
#>  1 betas.post   ""              ""            ""           ""         ""        
#>  2 betas.slice~ "univ.betas.sl~ ""            ""           ""         ""        
#>  3 gammas.post  ""              ""            ""           ""         ""        
#>  4 gammas.post2 ""              ""            ""           ""         ""        
#>  5 gammas.slic~ "univ.gammas.s~ ""            ""           ""         ""        
#>  6 gammas.slic~ "univ.gammas.s~ ""            ""           ""         ""        
#>  7 mcmcfrailty~ "betas.slice.s~ "gammas.slic~ "rho.slice.~ "V.F.MH.s~ "W.F.MH.s~
#>  8 mcmcSP       "betas.slice.s~ "gammas.slic~ "rho.slice.~ ""         ""        
#>  9 mcmcspatial~ "betas.slice.s~ "gammas.slic~ "rho.slice.~ "V.MH.sam~ "W.MH.sam~
#> 10 rho.post     ""              ""            ""           ""         ""        
#> 11 rho.slice.s~ "rho.post"      ""            ""           ""         ""        
#> 12 univ.betas.~ "betas.post"    ""            ""           ""         ""        
#> 13 univ.gammas~ "gammas.post"   ""            ""           ""         ""        
#> 14 univ.gammas~ "gammas.post2"  ""            ""           ""         ""        
#> 15 V.F.MH.samp~ "V.F.post"      ""            ""           ""         ""        
#> 16 V.F.post     ""              ""            ""           ""         ""        
#> 17 V.MH.sampli~ "V.post"        ""            ""           ""         ""        
#> 18 V.post       ""              ""            ""           ""         ""        
#> 19 W.F.MH.samp~ ""              ""            ""           ""         ""        
#> 20 W.MH.sampli~ "W.post"        ""            ""           ""         ""        
#> 21 W.post       ""              ""            ""           ""         ""        
#> 22 frailtySPsu~ "mcmcfrailtySP" ""            ""           ""         ""        
#> 23 spatialSPsu~ "mcmcspatialSP" ""            ""           ""         ""        
#> 24 SPsurv       "mcmcSP"        ""            ""           ""         ""
```
