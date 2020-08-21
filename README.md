
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

summary(tch, parameter = 'betas')
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>          Mean      SD Naive SE Time-series SE
#>  [1,]  0.8758 0.48395  0.16132        0.31032
#>  [2,] -0.9048 0.51359  0.17120        0.14001
#>  [3,]  0.1127 0.04766  0.01589        0.01589
#>  [4,] -0.6483 0.26599  0.08866        0.08866
#>  [5,]  0.3980 0.34520  0.11507        0.11507
#>  [6,]  0.6219 0.17494  0.05831        0.05831
#>  [7,]  0.0944 0.06109  0.02036        0.03646
#>  [8,] -0.3124 0.61862  0.20621        0.14250
#>  [9,]  0.1607 0.42516  0.14172        0.14172
#> 
#> 2. Quantiles for each variable:
#> 
#>           2.5%      25%      50%     75%   97.5%
#> var1  0.336840  0.43877  0.75507  1.3576  1.4238
#> var2 -1.672967 -1.14096 -0.91476 -0.6310 -0.1372
#> var3  0.061453  0.08372  0.09148  0.1433  0.1909
#> var4 -0.948800 -0.77307 -0.68803 -0.5759 -0.1355
#> var5 -0.154085  0.25268  0.45572  0.5545  0.9240
#> var6  0.366075  0.53061  0.57892  0.8093  0.8221
#> var7 -0.008357  0.09833  0.10550  0.1404  0.1568
#> var8 -0.984960 -0.95241 -0.26043  0.1259  0.4998
#> var9 -0.486518 -0.06530  0.24375  0.3606  0.8204


SPstats(tch)
#> $DIC
#> [1] -49028.11
#> 
#> $Loglik
#> [1] 25580.83
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

summary(tch3, parameter = 'betas')
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>          Mean      SD Naive SE Time-series SE
#>  [1,]  1.6044 1.13145  0.37715        0.84171
#>  [2,] -0.5587 0.33699  0.11233        0.11233
#>  [3,] -0.0292 0.12317  0.04106        0.08718
#>  [4,] -0.9840 0.15572  0.05191        0.05191
#>  [5,]  0.2679 0.49944  0.16648        0.10515
#>  [6,]  0.8813 0.49950  0.16650        0.16650
#>  [7,]  0.2016 0.07132  0.02377        0.02170
#>  [8,] -0.5009 0.67301  0.22434        0.22434
#>  [9,]  0.7548 0.66777  0.22259        0.22259
#> 
#> 2. Quantiles for each variable:
#> 
#>         2.5%      25%      50%      75%   97.5%
#> var1 -0.2213  1.17305  1.72589  2.63033  2.7302
#> var2 -1.1923 -0.58381 -0.51698 -0.35510 -0.1862
#> var3 -0.1629 -0.11760 -0.08422  0.03694  0.1917
#> var4 -1.1951 -1.10045 -0.95651 -0.92168 -0.7245
#> var5 -0.3986  0.03701  0.15666  0.51625  1.1314
#> var6  0.2344  0.41620  1.00282  1.30328  1.4744
#> var7  0.1155  0.16180  0.19295  0.23038  0.3328
#> var8 -1.5323 -0.59677 -0.40156 -0.29580  0.4168
#> var9 -0.1959  0.27252  0.92698  1.34895  1.5827
```
