
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
        form     = "weibull",
        prop.var = 1e-05
    )

str(tch)
#> List of 7
#>  $ betas : num [1:9, 1:9] 2.289 0.232 1.423 2.894 0.471 ...
#>  $ gammas: num [1:9, 1:4] -1.37 -1.38 -1.54 -1.29 -1.22 ...
#>  $ rho   : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ lambda: num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ delta : num [1:9] 0.805 0.827 0.884 0.876 0.888 ...
#>  $ W     : num [1:9, 1:46] 0.013 0.0209 0.0119 0.0175 0.0275 ...
#>  $ V     : num [1:9, 1:46] -0.00228 -0.0096 -0.00237 -0.01511 -0.02977 ...
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
        form     = "weibull"
    )

str(tch2)
#> List of 4
#>  $ betas : num [1:9, 1:10] -15.2 -14.5 -17.4 -15.7 -16 ...
#>  $ gammas: num [1:9, 1:3] -1.0953 0.9355 -1.3253 0.0522 2.8179 ...
#>  $ rho   : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ delta : num [1:9] 1.10e-05 4.83e-04 2.92e-09 1.10e-04 1.85e-03 ...
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
        form     = "weibull",
        prop.var = 1e-05,
        A        = A
    )

str(tch3)
#> List of 7
#>  $ betas : num [1:9, 1:9] 1.18962 0.00801 -0.4171 0.20069 -0.10316 ...
#>  $ gammas: num [1:9, 1:4] 0.978 1.472 1.645 2.099 1.095 ...
#>  $ rho   : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ lambda: num [1:9] 56.6 37.7 39 48.4 34.8 ...
#>  $ delta : num [1:9] 0.853 0.883 0.862 0.901 0.882 ...
#>  $ W     : num [1:9, 1:46] 0.00268 0.01029 0.00498 -0.01074 -0.02172 ...
#>  $ V     : num [1:9, 1:46] 0.0158 0.0269 0.0298 0.0158 0.0156 ...
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
