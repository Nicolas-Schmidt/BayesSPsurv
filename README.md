
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

### Functions

| argument   | `spatialSPsurv()`    | `exchangeSPsurv()`   | `pooledSPsurv()`     |
| ---------- | -------------------- | -------------------- | -------------------- |
| `duration` | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `immune`   | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `Y0`       | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `LY`       | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `data`     | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `N`        | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `burn`     | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `thin`     | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `w`        | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `m`        | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `form`     | :heavy\_check\_mark: | :heavy\_check\_mark: | :heavy\_check\_mark: |
| `prop.var` | :heavy\_check\_mark: | :heavy\_check\_mark: | :x:                  |
| `S`        | :heavy\_check\_mark: | :heavy\_check\_mark: | :x:                  |
| `A`        | :heavy\_check\_mark: | :x:                  | :x:                  |

### Data

``` r
library(spatialSPsurv)

walter <- spduration::add_duration(Walter_2015_JCR,"renewed_war", unitID = "id", tID = "year", freq = "year", ongoing = FALSE)
walter <- spatialSPsurv::spatial_SA(data = walter, var_ccode = "ccode", threshold = 800L)
```

### Example

#### `exchangeSPsurv`

``` r

set.seed(782566)
tch <- 
    exchangeSPsurv(
        duration = duration ~ fhcompor1 + lgdpl + comprehensive + victory + instabl + intensityln + ethfrac + unpko,
        immune   = cured ~ fhcompor1 + lgdpl + victory,
        Y0       = 't.0',
        LY       = 'lastyear',
        S        = 'sp_id' ,
        data     = walter[[1]],
        N        = 100,
        burn     = 10,
        thin     = 10,
        w        = c(1,1,1),
        m        = 10,
        form     = "Weibull",
        prop.var = 1e-05
    )

str(tch)
#> List of 8
#>  $ betas  : num [1:9, 1:9] 0.359 0.439 0.331 1.291 1.431 ...
#>  $ gammas : num [1:9, 1:4] 0.52739 0.00888 -3.88677 1.63268 -1.1935 ...
#>  $ rho    : num [1:9] 0.0429 0.108 0.0309 0.0325 0.0656 ...
#>  $ lambda : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ delta  : num [1:9] 1.66e-11 1.70e-06 1.69e-13 5.12e-02 7.74e-13 ...
#>  $ W      : num [1:9, 1:46] -0.0227 -0.0268 -0.0345 -0.0485 -0.0454 ...
#>  $ V      : num [1:9, 1:46] 0.01277 0.01664 0.02473 0.02828 0.00763 ...
#>  $ spstats:List of 6
#>   ..$ X : num [1:1237, 1:9] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:9] "X.Intercept." "fhcompor1" "lgdpl" "comprehensive" ...
#>   ..$ Z : num [1:1237, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:4] "X.Intercept..1" "fhcompor1.1" "lgdpl.1" "victory.1"
#>   ..$ Y : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0: num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ S : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...


SPstats(tch)
#> $DIC
#> [1] -48940.28
#> 
#> $Loglik
#> [1] 25584.5
```

#### `pooledSPsurv`

``` r
set.seed(782566)

tch2 <- 
    pooledSPsurv(
        duration = duration ~ fhcompor1 + lgdpl + comprehensive + victory + instabl + intensityln + ethfrac + unpko,
        immune   = cured ~ fhcompor1 + lgdpl + victory,
        Y0       = 't.0',
        LY       = 'lastyear',
        data     = walter[[1]],
        N        = 100,
        burn     = 10,
        thin     = 10,
        w        = c(1,1,1),
        m        = 10,
        form     = "Weibull"
    )

str(tch2)
#> List of 5
#>  $ betas  : num [1:9, 1:10] -5.07 -5.23 -5.32 -5.75 -5.97 ...
#>  $ gammas : num [1:9, 1:3] 1.97 1.21 3.95 -2.1 4.55 ...
#>  $ rho    : num [1:9] 0.0299 0.0414 0.1106 0.0518 0.0101 ...
#>  $ delta  : num [1:9] 4.47e-04 1.66e-05 5.22e-10 3.08e-04 3.49e-14 ...
#>  $ spstats:List of 5
#>   ..$ X : num [1:1237, 1:10] 0 0 0 0 0 0 0 0 0 0 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:10] "LY" "X.Intercept." "fhcompor1" "lgdpl" ...
#>   ..$ Z : num [1:1237, 1:3] -0.667 -0.75 -0.75 -0.667 -0.667 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:3] "fhcompor1.1" "lgdpl.1" "victory.1"
#>   ..$ Y : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0: num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>  - attr(*, "class")= chr [1:2] "list" "SPsurv"


summary(tch2, parameter = 'betas')
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>           Mean      SD Naive SE Time-series SE
#>  [1,] -5.55300 0.30750  0.10250        0.18132
#>  [2,]  4.30035 1.36934  0.45645        0.97417
#>  [3,] -0.84681 0.30404  0.10135        0.10135
#>  [4,]  0.02091 0.09655  0.03218        0.06791
#>  [5,]  0.02514 0.12165  0.04055        0.02456
#>  [6,]  0.31890 0.35118  0.11706        0.11706
#>  [7,]  0.26231 0.44073  0.14691        0.07230
#>  [8,]  0.05122 0.05308  0.01769        0.01769
#>  [9,]  0.25033 0.54500  0.18167        0.18167
#> [10,]  0.58727 0.88845  0.29615        0.29615
#> 
#> 2. Quantiles for each variable:
#> 
#>          2.5%      25%       50%      75%   97.5%
#> var1  -5.9383 -5.75368 -5.690074 -5.32065 -5.1032
#> var2   1.9615  3.69887  4.673396  5.34252  5.7368
#> var3  -1.2162 -1.05956 -0.811309 -0.76649 -0.3075
#> var4  -0.1039 -0.05567  0.031214  0.10096  0.1372
#> var5  -0.1048 -0.02988  0.004841  0.03642  0.2570
#> var6  -0.2004  0.10968  0.348896  0.53757  0.8364
#> var7  -0.3186 -0.15793  0.241965  0.64252  0.8464
#> var8  -0.0360  0.01795  0.063541  0.07674  0.1275
#> var9  -0.5346 -0.09968  0.240612  0.64984  1.0848
#> var10 -0.3278  0.11562  0.493585  0.72870  2.3084


SPstats(tch2)
#> $DIC
#> [1] -34438.21
#> 
#> $Loglik
#> [1] 22929.24
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
        data     = walter[[1]],
        N        = 100,
        burn     = 10,
        thin     = 10,
        w        = c(1,1,1),
        m        = 10,
        form     = "Weibull",
        prop.var = 1e-05,
        A        = walter[[2]]
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

## check form

``` r

duration <- duration ~ fhcompor1 + lgdpl + comprehensive + victory + instabl + intensityln + ethfrac + unpko
immune   <- cured ~ fhcompor1 + lgdpl + victory
Y0       <- 't.0'
LY       <- 'lastyear'
S        <- 'sp_id' 
data     <- walter[[1]]
N        <- 100
burn     <- 10
thin     <- 10
w        <- c(1,1,1)
m        <- 10
prop.var <- 1e-05
A        <- walter[[2]]

## ~~~~~~~~~~~~~
## exchangeSPsurv
## ~~~~~~~~~~~~~

set.seed(782566)
str(exchangeSPsurv(duration = duration, immune = immune, Y0 = Y0, LY = LY, S = S, 
                  data = data, N = N, burn = burn, thin = thin, w = w, m = m, 
                  prop.var = prop.var, form = 'Weibull'))
#> List of 8
#>  $ betas  : num [1:9, 1:9] 0.359 0.439 0.331 1.291 1.431 ...
#>  $ gammas : num [1:9, 1:4] 0.52739 0.00888 -3.88677 1.63268 -1.1935 ...
#>  $ rho    : num [1:9] 0.0429 0.108 0.0309 0.0325 0.0656 ...
#>  $ lambda : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ delta  : num [1:9] 1.66e-11 1.70e-06 1.69e-13 5.12e-02 7.74e-13 ...
#>  $ W      : num [1:9, 1:46] -0.0227 -0.0268 -0.0345 -0.0485 -0.0454 ...
#>  $ V      : num [1:9, 1:46] 0.01277 0.01664 0.02473 0.02828 0.00763 ...
#>  $ spstats:List of 6
#>   ..$ X : num [1:1237, 1:9] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:9] "X.Intercept." "fhcompor1" "lgdpl" "comprehensive" ...
#>   ..$ Z : num [1:1237, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:4] "X.Intercept..1" "fhcompor1.1" "lgdpl.1" "victory.1"
#>   ..$ Y : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0: num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ S : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
set.seed(782566)
str(exchangeSPsurv(duration = duration, immune = immune, Y0 = Y0, LY = LY, S = S, 
                  data = data, N = N, burn = burn, thin = thin, w = w, m = m, 
                  prop.var = prop.var, form = 'exponential'))
#> List of 8
#>  $ betas  : num [1:9, 1:9] 2.289 0.232 1.423 2.894 0.471 ...
#>  $ gammas : num [1:9, 1:4] -1.37 -1.38 -1.54 -1.29 -1.22 ...
#>  $ rho    : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ lambda : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ delta  : num [1:9] 0.805 0.827 0.884 0.876 0.888 ...
#>  $ W      : num [1:9, 1:46] 0.013 0.0209 0.0119 0.0175 0.0275 ...
#>  $ V      : num [1:9, 1:46] -0.00228 -0.0096 -0.00237 -0.01511 -0.02977 ...
#>  $ spstats:List of 6
#>   ..$ X : num [1:1237, 1:9] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:9] "X.Intercept." "fhcompor1" "lgdpl" "comprehensive" ...
#>   ..$ Z : num [1:1237, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:4] "X.Intercept..1" "fhcompor1.1" "lgdpl.1" "victory.1"
#>   ..$ Y : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0: num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ S : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...

set.seed(782566)
str(exchangeSPsurv(duration = duration, immune = immune, Y0 = Y0, LY = LY, S = S, 
                  data = data, N = N, burn = burn, thin = thin, w = w, m = m, 
                  prop.var = prop.var, form = 'loglog'))
#> List of 8
#>  $ betas  : num [1:9, 1:9] 0.456 2.352 2.401 2.52 1.153 ...
#>  $ gammas : num [1:9, 1:4] -0.81 1.399 0.888 -0.693 -1.605 ...
#>  $ rho    : num [1:9] 0.348 0.2 0.25 0.333 0.628 ...
#>  $ lambda : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ delta  : num [1:9] 1 1 1 1 1 ...
#>  $ W      : num [1:9, 1:46] -0.00134 -0.0061 -0.00087 0.00472 0.00258 ...
#>  $ V      : num [1:9, 1:46] 0.009624 0.012213 0.000256 -0.010916 -0.021529 ...
#>  $ spstats:List of 6
#>   ..$ X : num [1:1237, 1:9] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:9] "X.Intercept." "fhcompor1" "lgdpl" "comprehensive" ...
#>   ..$ Z : num [1:1237, 1:4] 1 1 1 1 1 1 1 1 1 1 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:4] "X.Intercept..1" "fhcompor1.1" "lgdpl.1" "victory.1"
#>   ..$ Y : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0: num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ S : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...


## ~~~~~~~~~~~~~
## spatialSPsurv
## ~~~~~~~~~~~~~

set.seed(782566)
str(spatialSPsurv(duration = duration, immune = immune, Y0 = Y0, LY = LY, S = S, 
                  data = data, N = N, burn = burn, thin = thin, w = w, m = m, 
                  prop.var = prop.var, A = A, form = 'Weibull'))
#> List of 7
#>  $ betas : num [1:9, 1:9] 2.75 2.63 2.63 2.35 1.42 ...
#>  $ gammas: num [1:9, 1:4] -16.1 -19.4 -19.4 -24.4 -30.9 ...
#>  $ rho   : num [1:9] 0.0358 0.0349 0.0507 0.0876 0.0271 ...
#>  $ lambda: num [1:9] 47.1 50.5 37.4 39 49.8 ...
#>  $ delta : num [1:9] 3.52e-27 1.20e-30 6.40e-28 1.91e-28 1.13e-46 ...
#>  $ W     : num [1:9, 1:46] -0.0308 -0.0428 -0.0424 -0.0572 -0.0465 ...
#>  $ V     : num [1:9, 1:46] -0.0166 -0.01837 -0.01302 0.00908 0.00152 ...
set.seed(782566)
str(spatialSPsurv(duration = duration, immune = immune, Y0 = Y0, LY = LY, S = S, 
                  data = data, N = N, burn = burn, thin = thin, w = w, m = m, 
                  prop.var = prop.var, A = A, form = 'exponential'))
#> List of 7
#>  $ betas : num [1:9, 1:9] 1.18962 0.00801 -0.4171 0.20069 -0.10316 ...
#>  $ gammas: num [1:9, 1:4] 0.978 1.472 1.645 2.099 1.095 ...
#>  $ rho   : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ lambda: num [1:9] 56.6 37.7 39 48.4 34.8 ...
#>  $ delta : num [1:9] 0.853 0.883 0.862 0.901 0.882 ...
#>  $ W     : num [1:9, 1:46] 0.00268 0.01029 0.00498 -0.01074 -0.02172 ...
#>  $ V     : num [1:9, 1:46] 0.0158 0.0269 0.0298 0.0158 0.0156 ...

set.seed(782566)
str(spatialSPsurv(duration = duration, immune = immune, Y0 = Y0, LY = LY, S = S, 
                  data = data, N = N, burn = burn, thin = thin, w = w, m = m, 
                  prop.var = prop.var, A = A, form = 'loglog'))
#> List of 7
#>  $ betas : num [1:9, 1:9] 0.2122 -0.1349 0.0655 -0.1961 1.2954 ...
#>  $ gammas: num [1:9, 1:4] 0.155 -0.329 -0.423 1.356 -0.382 ...
#>  $ rho   : num [1:9] 0.0858 0.8035 1.1173 0.8042 1.5708 ...
#>  $ delta : num [1:9] 1.04e-10 1.05e-13 4.83e-11 3.35e-14 1.01e-12 ...
#>  $ lambda: num [1:9] 44.7 52.2 46.2 39.5 45.6 ...
#>  $ W     : num [1:9, 1:46] -0.01196 -0.00269 -0.00941 -0.01518 -0.01088 ...
#>  $ V     : num [1:9, 1:46] -0.03 -0.0389 -0.0491 -0.0562 -0.0582 ...
## ~~~~~~~~~~~~~
## SPsurv
## ~~~~~~~~~~~~~

set.seed(782566)
str(pooledSPsurv(duration = duration, immune = immune, Y0 = Y0, LY = LY, data = data, 
           N = N, burn = burn, thin = thin, w = w, m = m, form = 'Weibull'))
#> List of 5
#>  $ betas  : num [1:9, 1:10] -5.07 -5.23 -5.32 -5.75 -5.97 ...
#>  $ gammas : num [1:9, 1:3] 1.97 1.21 3.95 -2.1 4.55 ...
#>  $ rho    : num [1:9] 0.0299 0.0414 0.1106 0.0518 0.0101 ...
#>  $ delta  : num [1:9] 4.47e-04 1.66e-05 5.22e-10 3.08e-04 3.49e-14 ...
#>  $ spstats:List of 5
#>   ..$ X : num [1:1237, 1:10] 0 0 0 0 0 0 0 0 0 0 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:10] "LY" "X.Intercept." "fhcompor1" "lgdpl" ...
#>   ..$ Z : num [1:1237, 1:3] -0.667 -0.75 -0.75 -0.667 -0.667 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:3] "fhcompor1.1" "lgdpl.1" "victory.1"
#>   ..$ Y : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0: num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>  - attr(*, "class")= chr [1:2] "list" "SPsurv"

set.seed(782566)
str(pooledSPsurv(duration = duration, immune = immune, Y0 = Y0, LY = LY, data = data, 
           N = N, burn = burn, thin = thin, w = w, m = m, form = 'exponential'))
#> List of 5
#>  $ betas  : num [1:9, 1:10] -15.2 -14.5 -17.4 -15.7 -16 ...
#>  $ gammas : num [1:9, 1:3] -1.0953 0.9355 -1.3253 0.0522 2.8179 ...
#>  $ rho    : num [1:9] 1 1 1 1 1 1 1 1 1
#>  $ delta  : num [1:9] 1.10e-05 4.83e-04 2.92e-09 1.10e-04 1.85e-03 ...
#>  $ spstats:List of 5
#>   ..$ X : num [1:1237, 1:10] 0 0 0 0 0 0 0 0 0 0 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:10] "LY" "X.Intercept." "fhcompor1" "lgdpl" ...
#>   ..$ Z : num [1:1237, 1:3] -0.667 -0.75 -0.75 -0.667 -0.667 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:3] "fhcompor1.1" "lgdpl.1" "victory.1"
#>   ..$ Y : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0: num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>  - attr(*, "class")= chr [1:2] "list" "SPsurv"

set.seed(782566)
str(pooledSPsurv(duration = duration, immune = immune, Y0 = Y0, LY = LY, data = data, 
           N = N, burn = burn, thin = thin, w = w, m = m, form = 'loglog'))
#> List of 4
#>  $ betas  : num [1:9, 1:10] -5.2 -8.99 -9.17 -9.64 -12.35 ...
#>  $ gammas : num [1:9, 1:3] 0.656 -0.207 3.246 4.207 9.06 ...
#>  $ rho    : num [1:9] 1.46 2.3 2.83 2.94 3.16 ...
#>  $ spstats:List of 5
#>   ..$ X : num [1:1237, 1:10] 0 0 0 0 0 0 0 0 0 0 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:10] "LY" "X.Intercept." "fhcompor1" "lgdpl" ...
#>   ..$ Z : num [1:1237, 1:3] -0.667 -0.75 -0.75 -0.667 -0.667 ...
#>   .. ..- attr(*, "dimnames")=List of 2
#>   .. .. ..$ : chr [1:1237] "1" "2" "3" "4" ...
#>   .. .. ..$ : chr [1:3] "fhcompor1.1" "lgdpl.1" "victory.1"
#>   ..$ Y : num [1:1237, 1] 1 2 3 4 5 6 7 8 9 10 ...
#>   ..$ Y0: num [1:1237, 1] 0 1 2 3 4 5 6 7 8 9 ...
#>   ..$ C : num [1:1237, 1] 1 1 1 1 1 1 1 1 1 1 ...
#>  - attr(*, "class")= chr [1:2] "list" "SPsurv"
```

-----

### Internal check (omit)

``` r
## ---------------------
## LOCAL CHECK!
## ---------------------


#net_str_f('spatialSPsurv')
```
