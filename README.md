
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

### Data

``` r
str(walter2015)
#> 'data.frame':    1237 obs. of  41 variables:
#>  $ ccode        : int  42 42 42 42 42 42 42 42 42 42 ...
#>  $ id           : int  93 93 93 93 93 93 93 93 93 93 ...
#>  $ countryf     : chr  "Dominican Republic" "Dominican Republic" "Dominican Republic" "Dominican Republic" ...
#>  $ X_st         : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ X_d          : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ X_t          : int  1 2 3 4 5 6 7 8 9 10 ...
#>  $ h0           : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ lastyear     : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ year         : int  1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 ...
#>  $ lmtnest      : num  2.86 2.86 2.86 2.86 2.86 ...
#>  $ ncontig      : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ relfrac      : num  0.095 0.095 0.095 0.095 0.095 ...
#>  $ ethfrac      : num  0.037 0.037 0.037 0.037 0.037 ...
#>  $ lpopl        : num  8.92 8.94 8.96 8.98 8.99 ...
#>  $ lgdpl        : num  8.56 8.62 8.64 8.66 8.71 ...
#>  $ unpko        : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ writconst    : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ comprehensive: int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ terr         : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ victory      : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ intensityln  : num  8.3 8.3 8.3 8.3 8.3 ...
#>  $ renewed_war  : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ democpolityl : int  1 1 0 0 0 0 9 8 8 8 ...
#>  $ autocpolityl : int  4 4 5 5 5 5 4 0 0 0 ...
#>  $ instabl      : int  0 0 0 0 0 0 0 1 1 1 ...
#>  $ writconstl   : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ idmultiple   : int  93 93 93 93 93 93 93 93 93 93 ...
#>  $ yearspeace   : int  1 2 3 4 5 6 7 8 9 10 ...
#>  $ freepressfhlr: int  -38 -27 -27 -35 -38 -32 -30 -30 -30 -30 ...
#>  $ vhpartl1     : num  0.265 0.265 0.26 0.26 0.354 ...
#>  $ fhcompor1    : num  -0.667 -0.75 -0.75 -0.667 -0.667 ...
#>  $ X_t0         : int  0 1 2 3 4 5 6 7 8 9 ...
#>  $ failure      : int  0 0 0 0 0 0 0 0 0 0 ...
#>  $ ongoing      : num  0 0 0 0 0 0 0 0 0 0 ...
#>  $ end.spell    : num  0 0 0 0 0 0 0 0 0 0 ...
#>  $ cured        : num  1 1 1 1 1 1 1 1 1 1 ...
#>  $ atrisk       : num  0 0 0 0 0 0 0 0 0 0 ...
#>  $ censor       : num  0 0 0 0 0 0 0 0 0 0 ...
#>  $ duration     : num  1 2 3 4 5 6 7 8 9 10 ...
#>  $ t.0          : num  0 1 2 3 4 5 6 7 8 9 ...
#>  $ sp_id        : int  1 1 1 1 1 1 1 1 1 1 ...
```

### Example

#### `frailtySPsurv`

``` r
library(spatialSPsurv)

set.seed(782566)
tch <- 
    frailtySPsurv(
        duration = duration ~ fhcompor1 + lgdpl + comprehensive + victory + instabl + intensityln + ethfrac + unpko,
        immune   = cured ~ fhcompor1 + lgdpl + victory,
        Y0       = 't.0',
        LY       = 'lastyear',
        S        = 'sp_id' ,
        data     = walter2015,
        N        = 100,
        burn     = 10,
        thin     = 10,
        w        = c(1,1,1),
        m        = 10,
        form     = "Weibull",
        prop.var = 1e-05
    )

str(tch)
#> List of 7
#>  $ betas : num [1:9, 1:9] 0.359 0.439 0.331 1.291 1.431 ...
#>  $ gammas: num [1:9, 1:4] 0.52739 0.00888 -3.88677 1.63268 -1.1935 ...
#>  $ rho   : num [1:9] 0.0429 0.108 0.0309 0.0325 0.0656 ...
#>  $ lambda: num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ delta : num [1:9] 1.66e-11 1.70e-06 1.69e-13 5.12e-02 7.74e-13 ...
#>  $ W     : num [1:9, 1:46] -0.0227 -0.0268 -0.0345 -0.0485 -0.0454 ...
#>  $ V     : num [1:9, 1:46] 0.01277 0.01664 0.02473 0.02828 0.00763 ...
```

#### `SPsurv`

``` r
set.seed(782566)

tch2 <- 
    SPsurv(
        duration = duration ~ fhcompor1 + lgdpl + comprehensive + victory + instabl + intensityln + ethfrac + unpko,
        immune   = cured ~ fhcompor1 + lgdpl + victory,
        Y0       = 't.0',
        LY       = 'lastyear',
        data     = walter2015,
        N        = 100,
        burn     = 10,
        thin     = 10,
        w        = c(1,1,1),
        m        = 10,
        form     = "Weibull"
    )

str(tch2)
#> List of 4
#>  $ betas : num [1:9, 1:10] -5.07 -5.23 -5.32 -5.75 -5.97 ...
#>  $ gammas: num [1:9, 1:3] 1.97 1.21 3.95 -2.1 4.55 ...
#>  $ rho   : num [1:9] 0.0299 0.0414 0.1106 0.0518 0.0101 ...
#>  $ delta : num [1:9] 4.47e-04 1.66e-05 5.22e-10 3.08e-04 3.49e-14 ...
```

#### `spatialSPsurv`

``` r
set.seed(782566)

tch3 <- 
    spatialSPsurv(
        duration = duration ~ fhcompor1 + lgdpl + comprehensive + victory + instabl + intensityln + ethfrac + unpko,
        immune   = cured ~ fhcompor1 + lgdpl + victory,
        Y0       = 't.0',
        LY       = 'lastyear',
        S        = 'sp_id' ,
        data     = walter2015,
        N        = 100,
        burn     = 10,
        thin     = 10,
        w        = c(1,1,1),
        m        = 10,
        form     = "Weibull",
        prop.var = 1e-05,
        A        = A
    )

str(tch3)
#> List of 7
#>  $ betas : num [1:9, 1:9] 2.75 2.63 2.63 2.35 1.42 ...
#>  $ gammas: num [1:9, 1:4] -16.1 -19.4 -19.4 -24.4 -30.9 ...
#>  $ rho   : num [1:9] 0.0358 0.0349 0.0507 0.0876 0.0271 ...
#>  $ lambda: num [1:9] 47.1 50.5 37.4 39 49.8 ...
#>  $ delta : num [1:9] 3.52e-27 1.20e-30 6.40e-28 1.91e-28 1.13e-46 ...
#>  $ W     : num [1:9, 1:46] -0.0308 -0.0428 -0.0424 -0.0572 -0.0465 ...
#>  $ V     : num [1:9, 1:46] -0.0166 -0.01837 -0.01302 0.00908 0.00152 ...
```

### Internal check (omit)

``` r
## ---------------------
## LOCAL CHECK!
## ---------------------


net_str_f('spatialSPsurv')
#> Registered S3 method overwritten by 'pryr':
#>   method      from
#>   print.bytes Rcpp
#> # A tibble: 25 x 6
#>    ind         `func 1`        `func 2`       `func 3`     `func 4`   `func 5`  
#>    <fct>       <chr>           <chr>          <chr>        <chr>      <chr>     
#>  1 betas.post  ""              ""             ""           ""         ""        
#>  2 betas.slic~ "univ.betas.sl~ ""             ""           ""         ""        
#>  3 formcall    ""              ""             ""           ""         ""        
#>  4 gammas.post ""              ""             ""           ""         ""        
#>  5 gammas.pos~ ""              ""             ""           ""         ""        
#>  6 gammas.sli~ "univ.gammas.s~ ""             ""           ""         ""        
#>  7 lambda.gib~ ""              ""             ""           ""         ""        
#>  8 mcmcfrailt~ "betas.slice.s~ "rho.slice.sa~ "V.F.MH.sam~ ""         ""        
#>  9 mcmcSP      "betas.slice.s~ "gammas.slice~ "rho.slice.~ ""         ""        
#> 10 mcmcspatia~ "betas.slice.s~ "lambda.gibbs~ "rho.slice.~ "V.MH.sam~ "W.MH.sam~
#> # ... with 15 more rows
```
