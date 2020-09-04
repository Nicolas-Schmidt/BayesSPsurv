
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

Bayesian parametric spatial split-populiation survival models for
clustered event processes. The models account for both structural and
spatial heterogeneity among “at risk” and “immune” populations, and
incorporates time-varying covariates. This package currently implements
Weibull, Exponential and Loglogistic forms for the duration component.
It allows for the creation of spatial weights matrix objects from point
patterns by distance and presents a series of diagnostic tests and plots
for easy visual diagnostics of convergence and spatial effects.

Manual
[**here**](https://github.com/Nicolas-Schmidt/spatialSPsurv/blob/master/man/figures/manual_spatialSPsurv.pdf).

## Installation

``` r
source("https://install-github.me/Nicolas-Schmidt/spatialSPsurv")
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

library(spatialSPsurv)

## Data
walter <- spduration::add_duration(Walter_2015_JCR,"renewed_war", 
                                   unitID = "id", tID = "year", 
                                   freq = "year", ongoing = FALSE)
#> Warning in attempt_date(data[, tID], freq): Converting to 'Date' class with
#> yyyy-06-30
walter <- spatialSPsurv::spatial_SA(data = walter, var_ccode = "ccode", threshold = 800L)


set.seed(782566)

tch <- 
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

print(tch)
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
#>                     Mean         SD    Naive SE Time-series SE
#> (Intercept)    1.5463805 0.82766390 0.118237700     0.27559357
#> fhcompor1     -0.7085419 0.43598722 0.062283888     0.07810104
#> lgdpl         -0.0775318 0.08339529 0.011913613     0.02298703
#> comprehensive -0.7879095 0.29557936 0.042225623     0.04222562
#> victory        0.3020210 0.43003924 0.061434177     0.06599743
#> instabl        0.6061754 0.43418382 0.062026260     0.06202626
#> intensityln    0.2241309 0.06531212 0.009330304     0.01594854
#> ethfrac       -0.3194989 0.61694154 0.088134505     0.11343036
#> unpko          0.5637305 0.55782828 0.079689755     0.07968975
#> 
#> Inmune equation: 
#>                   Mean        SD  Naive SE Time-series SE
#> (Intercept) -10.571952 15.156688 2.1652411       9.124592
#> fhcompor1     1.833617  3.995950 0.5708499       1.384355
#> lgdpl        -7.219672  8.557581 1.2225116       5.394051
#> victory      -2.867696  4.902532 0.7003617       1.744085

SPstats(tch)
#> $DIC
#> [1] -40494.5
#> 
#> $Loglik
#> [1] 0
```

## MAP

``` r
spw   <- matrix(apply(tch$W, 2, mean), ncol = 1, nrow = ncol(tch$W))
ccode <- colnames(tch$W)
ISO3  <- countrycode::countrycode(ccode,'gwn','iso3c')
spw   <- data.frame(ccode = ccode, ISO3 = ISO3, spw = spw) 
map   <- rworldmap::joinCountryData2Map(spw, joinCode = "ISO3", nameJoinColumn = "ISO3")
#> 46 codes from your data successfully matched countries in the map
#> 0 codes from your data failed to match with a country code in the map
#> 197 codes from the map weren't represented in your data
rworldmap::mapCountryData(map, nameColumnToPlot = 'spw')
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
