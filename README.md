
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

| Function         | Description                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `exchangeSPsurv` | Markov Chain Monte Carlo (MCMC) to run Bayesian split population survival model with exchangeable frailties.                                                                                                                                                                                                                                                                                                                                   |
| `pooledSPsurv`   | Markov Chain Monte Carlo (MCMC) to run Bayesian split population survival model with no frailties                                                                                                                                                                                                                                                                                                                                              |
| `spatialSPsurv`  | Markov Chain Monte Carlo (MCMC) to run time-varying Bayesian split population survival model with spatial frailties.                                                                                                                                                                                                                                                                                                                           |
| `summary`        | returns a summary of aexchangeSPsurv, pooledSPsurv or spatialSPsurv object via `coda::summary.mcmc`.                                                                                                                                                                                                                                                                                                                                           |
| `spatial_SA`     |                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `SPstats`        | A function to calculate the deviance information criterion (DIC) and Log-likelihood for fitted model oupts of pooled, exchangeable, and spatial Split Population survival models for which a log-likelihood can be obtained, according to the formula `DIC = -2 * (L - P)`, where `L` is the log likelihood of the data given the posterior means of the parameter and `P` is the estimate of the effective number of parameters in the model. |

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

### Example

#### Data

``` r
library(spatialSPsurv)

walter <- spduration::add_duration(Walter_2015_JCR,"renewed_war", 
                                   unitID = "id", tID = "year", 
                                   freq = "year", ongoing = FALSE)
walter <- spatialSPsurv::spatial_SA(data = walter, var_ccode = "ccode", threshold = 800L)
```

#### `exchangeSPsurv`

``` r
## ~~~~~~~~~~~~~~~
## Weibull
## ~~~~~~~~~~~~~~~

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


## ~~~~~~~~~~~~~~~
## loglog
## ~~~~~~~~~~~~~~~

set.seed(782566)
tchll <- 
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
        form     = "loglog",
        prop.var = 1e-05
    )

summary(tchll, parameter = 'betas')
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>          Mean     SD Naive SE Time-series SE
#>  [1,]  1.4999 0.9001   0.3000         0.3000
#>  [2,]  0.5559 1.1298   0.3766         0.3766
#>  [3,] -5.8422 2.9264   0.9755         2.4633
#>  [4,] -1.8697 2.3461   0.7820         1.6770
#>  [5,] -3.1098 2.7434   0.9145         1.8981
#>  [6,] -3.1831 1.3680   0.4560         0.4560
#>  [7,] -5.0530 0.8327   0.2776         0.2776
#>  [8,]  1.7067 0.8989   0.2996         0.2996
#>  [9,] -2.1157 1.5530   0.5177         0.5177
#> 
#> 2. Quantiles for each variable:
#> 
#>          2.5%     25%     50%     75%   97.5%
#> var1  0.07721  1.1036  1.5510  2.3520  2.4959
#> var2 -0.79491 -0.2574  0.5039  1.0811  2.5726
#> var3 -9.72957 -8.5017 -5.2135 -3.7653 -2.0812
#> var4 -4.44965 -3.8574 -2.4058 -0.2003  1.6950
#> var5 -7.00491 -4.6375 -2.9053 -2.1140  0.8307
#> var6 -4.84136 -4.0936 -3.4438 -2.4374 -1.1369
#> var7 -6.49586 -5.5276 -4.8353 -4.6782 -3.9489
#> var8  0.16972  1.4844  2.0950  2.2457  2.6278
#> var9 -4.45054 -2.7112 -2.2761 -1.0324  0.1700

SPstats(tchll)
#> $DIC
#> [1] 239856.7
#> 
#> $Loglik
#> [1] -96931.16
```

#### `pooledSPsurv`

``` r

## ~~~~~~~~~~~~~~~
## Weibull
## ~~~~~~~~~~~~~~~

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

## ~~~~~~~~~~~~~~~
## loglog
## ~~~~~~~~~~~~~~~

set.seed(782566)

tchll2 <- 
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
        form     = "loglog"
    )



summary(tchll2, parameter = 'betas')
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>           Mean     SD Naive SE Time-series SE
#>  [1,] -11.6249 3.6426   1.2142         2.4079
#>  [2,]  -0.6143 1.1622   0.3874         0.3874
#>  [3,]  -1.6773 1.4480   0.4827         0.8427
#>  [4,]  -3.7047 2.0706   0.6902         1.6593
#>  [5,]  -2.8794 1.1608   0.3869         0.3869
#>  [6,]   6.0637 1.6001   0.5334         0.5334
#>  [7,]   4.1333 2.5187   0.8396         1.8903
#>  [8,]   0.3184 0.6982   0.2327         0.1305
#>  [9,]   5.5183 2.1958   0.7319         1.7093
#> [10,]   3.7195 2.3394   0.7798         1.7639
#> 
#> 2. Quantiles for each variable:
#> 
#>           2.5%      25%      50%     75%   97.5%
#> var1  -16.3716 -13.7863 -12.3474 -9.1716 -5.9555
#> var2   -2.1622  -1.3398  -0.8206  0.4841  1.0142
#> var3   -3.6950  -2.6456  -1.6090 -0.5459  0.4046
#> var4   -6.5035  -4.8808  -3.6916 -2.9836 -0.6197
#> var5   -4.6020  -3.5791  -3.0807 -1.9252 -1.4050
#> var6    3.4021   5.4641   5.5308  7.4524  8.0014
#> var7    1.6262   2.2469   3.0047  6.1237  8.2656
#> var8   -0.7511  -0.1037   0.3682  0.6752  1.4159
#> var9    2.1223   3.3819   6.5907  6.8747  7.5226
#> var10   0.2116   1.5568   3.8004  5.6092  6.4169

SPstats(tchll2)
#> $DIC
#> [1] 313923.1
#> 
#> $Loglik
#> [1] -128299.2
```

#### `spatialSPsurv`

``` r


## ~~~~~~~~~~~~~~~
## Weibull
## ~~~~~~~~~~~~~~~

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

SPstats(tch3)
#> $DIC
#> [1] 0
#> 
#> $Loglik
#> [1] 0

## ~~~~~~~~~~~~~~~
## loglog
## ~~~~~~~~~~~~~~~


set.seed(782566)

tchll3 <- 
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
        form     = "loglog",
        prop.var = 1e-05,
        A        = walter[[2]]
    )

summary(tchll3, parameter = 'betas')
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>          Mean     SD Naive SE Time-series SE
#>  [1,]  0.9978 1.0149   0.3383         0.7407
#>  [2,] -4.0951 1.8803   0.6268         1.2766
#>  [3,] -1.9909 1.0394   0.3465         0.8131
#>  [4,] -9.3394 4.1228   1.3743         2.9403
#>  [5,]  0.3753 0.6356   0.2119         0.1313
#>  [6,]  1.5198 0.6755   0.2252         0.2252
#>  [7,]  0.9864 0.4919   0.1640         0.3482
#>  [8,]  1.2304 0.7936   0.2645         0.2645
#>  [9,]  3.6146 1.9527   0.6509         1.1303
#> 
#> 2. Quantiles for each variable:
#> 
#>           2.5%       25%      50%     75%   97.5%
#> var1  -0.18389   0.06547   1.2954  1.6824  2.3334
#> var2  -6.64971  -5.43311  -3.8534 -2.9842 -1.1993
#> var3  -3.70941  -2.42676  -1.6402 -1.1902 -0.9037
#> var4 -13.85590 -12.10579 -10.4624 -7.3451 -2.5241
#> var5  -0.57764   0.07917   0.2469  0.8927  1.2393
#> var6   0.47572   1.03511   1.6726  1.9030  2.3717
#> var7   0.55220   0.62912   0.7100  1.2758  1.7747
#> var8   0.01502   0.94962   1.0960  1.7605  2.4447
#> var9   0.91661   2.44076   3.8508  4.5397  6.7167

SPstats(tchll3)
#> $DIC
#> [1] -2977.48
#> 
#> $Loglik
#> [1] 17200
```
