
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

#### `spatialSPsurv`

``` r


## ~~~~~~~~~~~~~~~
## Weibull
## ~~~~~~~~~~~~~~~

set.seed(782566)

tch <- 
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
#>                  Mean      SD Naive SE Time-series SE
#> (Intercept)    1.6044 1.13145  0.37715        0.84171
#> fhcompor1     -0.5587 0.33699  0.11233        0.11233
#> lgdpl         -0.0292 0.12317  0.04106        0.08718
#> comprehensive -0.9840 0.15572  0.05191        0.05191
#> victory        0.2679 0.49944  0.16648        0.10515
#> instabl        0.8813 0.49950  0.16650        0.16650
#> intensityln    0.2016 0.07132  0.02377        0.02170
#> ethfrac       -0.5009 0.67301  0.22434        0.22434
#> unpko          0.7548 0.66777  0.22259        0.22259
#> 
#> 2. Quantiles for each variable:
#> 
#>                  2.5%      25%      50%      75%   97.5%
#> (Intercept)   -0.2213  1.17305  1.72589  2.63033  2.7302
#> fhcompor1     -1.1923 -0.58381 -0.51698 -0.35510 -0.1862
#> lgdpl         -0.1629 -0.11760 -0.08422  0.03694  0.1917
#> comprehensive -1.1951 -1.10045 -0.95651 -0.92168 -0.7245
#> victory       -0.3986  0.03701  0.15666  0.51625  1.1314
#> instabl        0.2344  0.41620  1.00282  1.30328  1.4744
#> intensityln    0.1155  0.16180  0.19295  0.23038  0.3328
#> ethfrac       -1.5323 -0.59677 -0.40156 -0.29580  0.4168
#> unpko         -0.1959  0.27252  0.92698  1.34895  1.5827

summary(tch, parameter = 'gammas')
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>                Mean     SD Naive SE Time-series SE
#> (Intercept) -27.958  8.777   2.9257         5.5637
#> fhcompor1     7.316  3.499   1.1665         2.1345
#> lgdpl       -14.575 10.214   3.4046         7.8422
#> victory      -6.283  2.446   0.8155         0.8155
#> 
#> 2. Quantiles for each variable:
#> 
#>                2.5%     25%     50%     75%   97.5%
#> (Intercept) -40.088 -32.381 -29.274 -19.407 -16.724
#> fhcompor1     1.526   4.951   7.800   9.809  11.130
#> lgdpl       -31.863 -17.937 -11.966  -6.870  -4.812
#> victory      -9.096  -7.586  -6.875  -5.429  -1.862

SPstats(tch)
#> $DIC
#> [1] 0
#> 
#> $Loglik
#> [1] 0

## ~~~~~~~~~~~~~~~
## loglog
## ~~~~~~~~~~~~~~~


set.seed(782566)

tchll <- 
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
#>                  Mean     SD Naive SE Time-series SE
#> (Intercept)    0.9978 1.0149   0.3383         0.7407
#> fhcompor1     -4.0951 1.8803   0.6268         1.2766
#> lgdpl         -1.9909 1.0394   0.3465         0.8131
#> comprehensive -9.3394 4.1228   1.3743         2.9403
#> victory        0.3753 0.6356   0.2119         0.1313
#> instabl        1.5198 0.6755   0.2252         0.2252
#> intensityln    0.9864 0.4919   0.1640         0.3482
#> ethfrac        1.2304 0.7936   0.2645         0.2645
#> unpko          3.6146 1.9527   0.6509         1.1303
#> 
#> 2. Quantiles for each variable:
#> 
#>                    2.5%       25%      50%     75%   97.5%
#> (Intercept)    -0.18389   0.06547   1.2954  1.6824  2.3334
#> fhcompor1      -6.64971  -5.43311  -3.8534 -2.9842 -1.1993
#> lgdpl          -3.70941  -2.42676  -1.6402 -1.1902 -0.9037
#> comprehensive -13.85590 -12.10579 -10.4624 -7.3451 -2.5241
#> victory        -0.57764   0.07917   0.2469  0.8927  1.2393
#> instabl         0.47572   1.03511   1.6726  1.9030  2.3717
#> intensityln     0.55220   0.62912   0.7100  1.2758  1.7747
#> ethfrac         0.01502   0.94962   1.0960  1.7605  2.4447
#> unpko           0.91661   2.44076   3.8508  4.5397  6.7167

summary(tchll, parameter = 'gammas')
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>                Mean     SD Naive SE Time-series SE
#> (Intercept)  0.9036 1.3467   0.4489         0.8289
#> fhcompor1    0.2620 0.5662   0.1887         0.1887
#> lgdpl       -3.8527 0.5478   0.1826         0.1826
#> victory     -0.9416 0.8616   0.2872         0.6859
#> 
#> 2. Quantiles for each variable:
#> 
#>                2.5%      25%     50%     75%   97.5%
#> (Intercept) -0.4147 -0.32856  0.2533  1.8032  2.8961
#> fhcompor1   -0.5504 -0.04577  0.2996  0.5489  1.0235
#> lgdpl       -4.8512 -3.97738 -3.5040 -3.4724 -3.4036
#> victory     -2.1480 -1.54557 -1.2112 -0.3395  0.3749

SPstats(tchll)
#> $DIC
#> [1] -2977.48
#> 
#> $Loglik
#> [1] 17200
```

#### `exchangeSPsurv`

``` r
## ~~~~~~~~~~~~~~~
## Weibull
## ~~~~~~~~~~~~~~~

set.seed(782566)
tch1 <- 
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

tch1
#> Call:
#> exchangeSPsurv(duration = duration ~ fhcompor1 + lgdpl + comprehensive + 
#>     victory + instabl + intensityln + ethfrac + unpko, immune = cured ~ 
#>     fhcompor1 + lgdpl + victory, Y0 = "t.0", LY = "lastyear", 
#>     S = "sp_id", data = walter[[1]], N = 100, burn = 10, thin = 10, 
#>     w = c(1, 1, 1), m = 10, form = "Weibull", prop.var = 1e-05)
#> 
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> Empirical mean and standard deviation for each variable,
#> plus standard error of the mean:
#> 
#> 
#> Duration equation: 
#>                      Mean         SD   Naive SE Time-series SE
#> (Intercept)    0.87579434 0.48394958 0.16131653     0.31032008
#> fhcompor1     -0.90480541 0.51358784 0.17119595     0.14000853
#> lgdpl          0.11274546 0.04765930 0.01588643     0.01588643
#> comprehensive -0.64829301 0.26599359 0.08866453     0.08866453
#> victory        0.39796089 0.34520180 0.11506727     0.11506727
#> instabl        0.62194670 0.17493675 0.05831225     0.05831225
#> intensityln    0.09439582 0.06109327 0.02036442     0.03645641
#> ethfrac       -0.31243011 0.61862030 0.20620677     0.14249965
#> unpko          0.16069329 0.42515578 0.14171859     0.14171859
#> 
#> Inmune equation: 
#>                   Mean       SD  Naive SE Time-series SE
#> (Intercept) -0.7987628 1.560920 0.5203068      0.3202784
#> fhcompor1    1.2492989 2.147772 0.7159239      0.3947657
#> lgdpl       -2.2302276 1.189085 0.3963618      0.3963618
#> victory     -0.3072006 1.447433 0.4824778      0.4824778

SPstats(tch1)
#> $DIC
#> [1] -48940.28
#> 
#> $Loglik
#> [1] 25584.5


## ~~~~~~~~~~~~~~~
## loglog
## ~~~~~~~~~~~~~~~

set.seed(782566)
tchll1 <- 
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

tchll1
#> Call:
#> exchangeSPsurv(duration = duration ~ fhcompor1 + lgdpl + comprehensive + 
#>     victory + instabl + intensityln + ethfrac + unpko, immune = cured ~ 
#>     fhcompor1 + lgdpl + victory, Y0 = "t.0", LY = "lastyear", 
#>     S = "sp_id", data = walter[[1]], N = 100, burn = 10, thin = 10, 
#>     w = c(1, 1, 1), m = 10, form = "loglog", prop.var = 1e-05)
#> 
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> Empirical mean and standard deviation for each variable,
#> plus standard error of the mean:
#> 
#> 
#> Duration equation: 
#>                     Mean        SD  Naive SE Time-series SE
#> (Intercept)    1.4998773 0.9001035 0.3000345      0.3000345
#> fhcompor1      0.5559016 1.1297885 0.3765962      0.3765962
#> lgdpl         -5.8421503 2.9264300 0.9754767      2.4633292
#> comprehensive -1.8697152 2.3460962 0.7820321      1.6769531
#> victory       -3.1098076 2.7434201 0.9144734      1.8980999
#> instabl       -3.1831150 1.3679548 0.4559849      0.4559849
#> intensityln   -5.0530350 0.8327241 0.2775747      0.2775747
#> ethfrac        1.7066805 0.8988828 0.2996276      0.2996276
#> unpko         -2.1157316 1.5529595 0.5176532      0.5176532
#> 
#> Inmune equation: 
#>                  Mean        SD  Naive SE Time-series SE
#> (Intercept) -1.510808 2.1240376 0.7080125      1.6098136
#> fhcompor1   -2.833182 0.9554854 0.3184951      0.3184951
#> lgdpl        1.334424 1.6739737 0.5579912      1.2635753
#> victory      2.381123 0.9427260 0.3142420      0.3142420


SPstats(tchll1)
#> $DIC
#> [1] 239864.5
#> 
#> $Loglik
#> [1] -96935.59
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
#>                    Mean      SD Naive SE Time-series SE
#> (Intercept)    2.489440 0.62190  0.20730        0.42128
#> fhcompor1     -0.597934 0.36806  0.12269        0.12269
#> lgdpl          0.013546 0.10442  0.03481        0.06774
#> comprehensive -0.492016 0.32215  0.10738        0.10738
#> victory        0.268117 0.40824  0.13608        0.13608
#> instabl        0.687520 0.59738  0.19913        0.19913
#> intensityln   -0.007687 0.08438  0.02813        0.06935
#> ethfrac       -0.061082 0.53558  0.17853        0.17853
#> unpko          0.239877 0.37293  0.12431        0.12431
#> 
#> 2. Quantiles for each variable:
#> 
#>                   2.5%      25%       50%      75%     97.5%
#> (Intercept)    1.43806  2.03834  2.764482  2.89216  3.100226
#> fhcompor1     -1.17074 -0.87703 -0.445767 -0.27121 -0.248611
#> lgdpl         -0.08859 -0.07043 -0.008628  0.09546  0.181898
#> comprehensive -1.04237 -0.55289 -0.512932 -0.32584 -0.008427
#> victory       -0.20028  0.04245  0.149198  0.38671  1.033309
#> instabl        0.04971  0.43757  0.523568  0.91086  1.813543
#> intensityln   -0.12892 -0.05982  0.001288  0.05853  0.109548
#> ethfrac       -0.58581 -0.51108 -0.204406  0.22143  0.886120
#> unpko         -0.18513 -0.04776  0.180875  0.42709  0.830139

summary(tch2, parameter = 'gammas')
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>                 Mean     SD Naive SE Time-series SE
#> (Intercept) -0.03561 2.4981   0.8327         0.8327
#> fhcompor1    1.19780 2.7875   0.9292         0.9292
#> lgdpl       -1.28903 0.9153   0.3051         0.3051
#> victory      2.04164 1.8597   0.6199         0.6199
#> 
#> 2. Quantiles for each variable:
#> 
#>               2.5%    25%     50%     75%   97.5%
#> (Intercept) -2.685 -1.622 -0.6973  0.6587  4.6702
#> fhcompor1   -2.001 -1.113  0.9736  3.0979  5.6147
#> lgdpl       -2.641 -2.080 -1.0719 -0.5985 -0.2577
#> victory     -1.228  1.520  2.6347  3.4391  3.6867

SPstats(tch2)
#> $DIC
#> [1] -33714.57
#> 
#> $Loglik
#> [1] 16326.24

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
#>                   Mean     SD Naive SE Time-series SE
#> (Intercept)    0.10265 1.0373   0.3458         0.5988
#> fhcompor1     -2.43718 0.9590   0.3197         0.3197
#> lgdpl         -1.77984 0.7117   0.2372         0.2372
#> comprehensive -6.82669 2.2122   0.7374         1.4716
#> victory       -0.01214 1.1196   0.3732         0.3732
#> instabl        4.81092 1.5225   0.5075         1.1147
#> intensityln    0.77653 0.4870   0.1623         0.1623
#> ethfrac        0.74044 0.9338   0.3113         0.3113
#> unpko          3.47928 1.9088   0.6363         1.2913
#> 
#> 2. Quantiles for each variable:
#> 
#>                  2.5%     25%     50%     75%   97.5%
#> (Intercept)   -1.4658 -0.2439  0.2416  0.5344  1.7691
#> fhcompor1     -3.7948 -2.8772 -2.5393 -1.9350 -1.1658
#> lgdpl         -2.7321 -1.9095 -1.8229 -1.5371 -0.5511
#> comprehensive -9.6864 -8.1355 -7.6307 -5.0705 -3.5159
#> victory       -1.9510 -0.4891  0.5130  0.8435  0.9667
#> instabl        2.3701  3.7307  5.1329  5.9989  6.6154
#> intensityln    0.1138  0.5082  0.7131  1.1239  1.4364
#> ethfrac       -0.7793  0.2935  1.0553  1.4639  1.7611
#> unpko          1.6751  2.0230  2.6863  4.1729  6.8723

summary(tchll2, parameter = 'gammas')
#> 
#> Iterations = 1:9
#> Thinning interval = 1 
#> Number of chains = 1 
#> Sample size per chain = 9 
#> 
#> 1. Empirical mean and standard deviation for each variable,
#>    plus standard error of the mean:
#> 
#>                 Mean    SD Naive SE Time-series SE
#> (Intercept) -2.46066 2.402   0.8006         0.8006
#> fhcompor1   -0.05036 2.561   0.8537         1.6046
#> lgdpl       -1.43625 1.552   0.5175         0.5175
#> victory      0.33619 1.208   0.4026         0.1830
#> 
#> 2. Quantiles for each variable:
#> 
#>               2.5%     25%     50%     75%  97.5%
#> (Intercept) -5.377 -4.4322 -2.6293 -1.2094 1.2982
#> fhcompor1   -4.273 -1.2062  0.6207  1.8223 2.7788
#> lgdpl       -3.982 -1.7861 -0.9466 -0.3840 0.2621
#> victory     -1.706 -0.1631  0.4431  0.9325 2.1190

SPstats(tchll2)
#> $DIC
#> [1] 39285.51
#> 
#> $Loglik
#> [1] -6598.982
```
