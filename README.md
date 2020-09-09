
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BayesSPsurv

<!-- badges: start -->

[![R build
status](https://github.com/Nicolas-Schmidt/spatialSPsurv/workflows/R-CMD-check/badge.svg)](https://github.com/Nicolas-Schmidt/BayesSPsurv/actions)
[![Project Status: Active â€“ The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![](https://img.shields.io/badge/devel%20version-0.2.0-blue.svg)](https://github.com/Nicolas-Schmidt/BayesMFSurv)
<!-- badges: end -->

Bayesian parametric spatial split-populiation survival models for
clustered event processes. The models account for both structural and
spatial heterogeneity among “at risk” and “immune” populations, and
incorporates time-varying covariates. This package currently implements
Weibull, Exponential and Loglogistic forms for the duration component.
It allows for the creation of spatial weights matrix objects from point
patterns by distance and presents a series of diagnostic tests and plots
for easy visual diagnostics of convergence and spatial effects.

Manual
[**here**](https://github.com/Nicolas-Schmidt/spatialSPsurv/blob/master/man/figures/manual_BayesSPsurv.pdf).

## Installation

``` r
source("https://install-github.me/Nicolas-Schmidt/BayesSPsurv")
```

### Functions

| Function         | Description                                                                                                          |
| ---------------- | -------------------------------------------------------------------------------------------------------------------- |
| `exchangeSPsurv` | Markov Chain Monte Carlo (MCMC) to run Bayesian split population survival model with exchangeable frailties.         |
| `pooledSPsurv`   | Markov Chain Monte Carlo (MCMC) to run Bayesian split population survival model with no frailties                    |
| `spatialSPsurv`  | Markov Chain Monte Carlo (MCMC) to run time-varying Bayesian split population survival model with spatial frailties. |
| `summary`        | returns a summary of exchangeSPsurv, pooledSPsurv or spatialSPsurv object via `coda::summary.mcmc`.                  |
| `spatial_SA`     |                                                                                                                      |
| `SPstats`        | A function to calculate the deviance information criterion (DIC) and Log-likelihood for fitted model oupts.          |

### Example

``` r

library(BayesSPsurv)

## Data
walter <- spduration::add_duration(Walter_2015_JCR,"renewed_war", 
                                   unitID = "id", tID = "year", 
                                   freq = "year", ongoing = FALSE)
walter <- BayesSPsurv::spatial_SA(data = walter, var_ccode = "ccode", threshold = 800L)


set.seed(123456)

model <- 
    spatialSPsurv(
        duration = duration ~ fhcompor1 + lgdpl + comprehensive + victory + 
                              instabl + intensityln + ethfrac + unpko,
        immune   = cured ~ fhcompor1 + lgdpl + victory,
        Y0       = 't.0',
        LY       = 'lastyear',
        S        = 'sp_id' ,
        data     = walter[[1]],
        N        = 500,
        burn     = 10,
        thin     = 10,
        w        = c(1,1,1),
        m        = 10,
        form     = "Weibull",
        prop.var = 1e-05,
        A        = walter[[2]]
    )

print(model)
#> Call:
#> spatialSPsurv(duration = duration ~ fhcompor1 + lgdpl + comprehensive + 
#>     victory + instabl + intensityln + ethfrac + unpko, immune = cured ~ 
#>     fhcompor1 + lgdpl + victory, Y0 = "t.0", LY = "lastyear", 
#>     S = "sp_id", A = walter[[2]], data = walter[[1]], N = 500, 
#>     burn = 10, thin = 10, w = c(1, 1, 1), m = 10, form = "Weibull", 
#>     prop.var = 1e-05)
#> 
#> 
#> Iterations = 1:49
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 49 
#> 
#> Empirical mean and standard deviation for each variable,
#> plus standard error of the mean:
#> 
#> 
#> Duration equation: 
#>                      Mean        SD   Naive SE Time-series SE
#> (Intercept)    1.89866255 1.2509396 0.17870566     0.69851236
#> fhcompor1     -0.84446607 0.4951659 0.07073799     0.10104511
#> lgdpl         -0.05316238 0.1215603 0.01736575     0.05212821
#> comprehensive -0.70682520 0.3301436 0.04716337     0.04716337
#> victory        0.55708089 0.4137637 0.05910910     0.05910910
#> instabl        0.72133602 0.4690292 0.06700417     0.08781194
#> intensityln    0.12217226 0.1173725 0.01676750     0.04682825
#> ethfrac       -0.18496279 0.5341137 0.07630195     0.07630195
#> unpko          0.39261930 0.4932459 0.07046371     0.07046371
#> 
#> Inmune equation: 
#>                   Mean       SD  Naive SE Time-series SE
#> (Intercept)  0.1519895 2.578951 0.3684215      0.3684215
#> fhcompor1   -0.2427989 2.900525 0.4143607      0.6365760
#> lgdpl       -1.8897132 1.402490 0.2003557      0.2003557
#> victory     -2.0062225 4.957126 0.7081608      0.9911410

SPstats(model)
#> $DIC
#> [1] -29831.72
#> 
#> $Loglik
#> [1] 20960.79
```

## Map

``` r
spw   <- matrix(apply(model$W, 2, mean), ncol = 1, nrow = ncol(model$W))
ccode <- colnames(model$W)
ISO3  <- countrycode::countrycode(ccode,'gwn','iso3c')
spw   <- data.frame(ccode = ccode, ISO3 = ISO3, spw = spw) 
map   <- rworldmap::joinCountryData2Map(spw, joinCode = "ISO3", nameJoinColumn = "ISO3")
#> 46 codes from your data successfully matched countries in the map
#> 0 codes from your data failed to match with a country code in the map
#> 197 codes from the map weren't represented in your data
rworldmap::mapCountryData(map, nameColumnToPlot = 'spw')
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

``` r
# == == == == == == == == == == == == == == == == == == == == == =
str(model) # spatialSPsurv
#> List of 9
#>  $ betas  : num [1:49, 1:9] 0.766 0.529 1.359 2.058 3.187 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : NULL
#>   .. ..$ : chr [1:9] "(Intercept)" "fhcompor1" "lgdpl" "comprehensive" ...
#>  $ gammas : num [1:49, 1:4] -2.152 -1.5 -4.626 0.498 1.645 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : NULL
#>   .. ..$ : chr [1:4] "(Intercept)" "fhcompor1" "lgdpl" "victory"
#>  $ rho    : num [1:49] 0.0491 0.065 0.0528 0.1451 0.2021 ...
#>  $ lambda : num [1:49] 46.2 58.3 40.7 44.1 44.1 ...
#>  $ delta  : num [1:49] 0.372418 0.256355 0.000245 0.010237 0.004674 ...
#>  $ W      : num [1:49, 1:46] -0.00214 0.00276 -0.00207 0.00211 0.01125 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : NULL
#>   .. ..$ : chr [1:46] "42" "90" "92" "93" ...
#>  $ V      : num [1:49, 1:46] -0.00958 -0.01484 -0.03635 -0.03738 -0.05096 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : NULL
#>   .. ..$ : chr [1:46] "42" "90" "92" "93" ...
#>  $ spstats:List of 7
#>   ..$ X   : num [1:1237, 1:9] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:9] "(Intercept)" "fhcompor1" "lgdpl" "comprehensive" ...
#>   ..$ Z   : num [1:1237, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:4] "(Intercept)" "fhcompor1" "lgdpl" "victory"
#>   ..$ Y   : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0  : num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C   : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ S   : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ form: chr "Weibull"
#>  $ call   : language spatialSPsurv(duration = duration ~ fhcompor1 + lgdpl + comprehensive +      victory + instabl + intensityln + et| __truncated__ ...
#>  - attr(*, "class")= chr "spatialSPsurv"
#
#
#
str(exchangeSPsurv)
#> List of 9
#>  $ betas  : num [1:9, 1:9] 0.359 0.439 0.331 1.291 1.431 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : NULL
#>   .. ..$ : chr [1:9] "(Intercept)" "fhcompor1" "lgdpl" "comprehensive" ...
#>  $ gammas : num [1:9, 1:4] 0.52739 0.00888 -3.88677 1.63268 -1.1935 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : NULL
#>   .. ..$ : chr [1:4] "(Intercept)" "fhcompor1" "lgdpl" "victory"
#>  $ rho    : num [1:9] 0.0429 0.108 0.0309 0.0325 0.0656 ...
#>  $ lambda : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ delta  : num [1:9] 1.66e-11 1.70e-06 1.69e-13 5.12e-02 7.74e-13 ...
#>  $ W      : num [1:9, 1:46] -0.0227 -0.0268 -0.0345 -0.0485 -0.0454 ...
#>  $ V      : num [1:9, 1:46] 0.01277 0.01664 0.02473 0.02828 0.00763 ...
#>  $ spstats:List of 7
#>   ..$ X   : num [1:1237, 1:9] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:9] "(Intercept)" "fhcompor1" "lgdpl" "comprehensive" ...
#>   ..$ Z   : num [1:1237, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:4] "(Intercept)" "fhcompor1" "lgdpl" "victory"
#>   ..$ Y   : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0  : num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C   : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ S   : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ form: chr "Weibull"
#>  $ call   : language exchangeSPsurv(duration = duration ~ fhcompor1 + lgdpl + comprehensive +      victory + instabl + intensityln + e| __truncated__ ...
#>  - attr(*, "class")= chr "frailtySPsurv"
#
#
#
str(pooledSPsurv)
#> List of 6
#>  $ betas  : num [1:9, 1:9] 2.04 1.71 1.37 2.76 2.73 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : NULL
#>   .. ..$ : chr [1:9] "(Intercept)" "fhcompor1" "lgdpl" "comprehensive" ...
#>  $ gammas : num [1:9, 1:4] -0.697 0.659 -2.179 -2.811 0.151 ...
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : NULL
#>   .. ..$ : chr [1:4] "(Intercept)" "fhcompor1" "lgdpl" "victory"
#>  $ rho    : num [1:9] 0.0558 0.0598 0.05 0.0671 0.0136 ...
#>  $ delta  : num [1:9] 2.60e-03 1.74e-02 4.03e-03 1.69e-09 1.61e-07 ...
#>  $ spstats:List of 6
#>   ..$ X   : num [1:1237, 1:9] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:9] "(Intercept)" "fhcompor1" "lgdpl" "comprehensive" ...
#>   ..$ Z   : num [1:1237, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:4] "(Intercept)" "fhcompor1" "lgdpl" "victory"
#>   ..$ Y   : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0  : num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C   : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ form: chr "Weibull"
#>  $ call   : language pooledSPsurv(duration = duration ~ fhcompor1 + lgdpl + comprehensive +      victory + instabl + intensityln + eth| __truncated__ ...
#>  - attr(*, "class")= chr [1:2] "list" "SPsurv"
# == == == == == == == == == == == == == == == == == == == == == =
```
