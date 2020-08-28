
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

plot(tch)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" /><img src="man/figures/README-unnamed-chunk-4-2.png" width="100%" /><img src="man/figures/README-unnamed-chunk-4-3.png" width="100%" />

``` r

## ~~~~~~~~~~~~~~~
## loglog
## ~~~~~~~~~~~~~~~


set.seed(782566)

tchll <- 
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
        form     = "loglog",
        prop.var = 1e-05,
        A        = walter[[2]]
    )

print(tchll)
#> Call:
#> spatialSPsurv(duration = duration ~ fhcompor1 + lgdpl + comprehensive + 
#>     victory + instabl + intensityln + ethfrac + unpko, immune = cured ~ 
#>     fhcompor1 + lgdpl + victory, Y0 = "t.0", LY = "lastyear", 
#>     S = "sp_id", A = walter[[2]], data = walter[[1]], N = 500, 
#>     burn = 10, thin = 10, w = c(1, 1, 1), m = 10, form = "loglog", 
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
#>                     Mean       SD  Naive SE Time-series SE
#> (Intercept)     0.366719 2.288175 0.3268821      1.3615709
#> fhcompor1      -6.164064 2.484757 0.3549652      1.0883163
#> lgdpl          -7.065474 3.347268 0.4781812      2.2677624
#> comprehensive -18.894019 6.575919 0.9394170      4.1424634
#> victory        -1.697208 2.065578 0.2950826      0.9950245
#> instabl         3.192351 2.224242 0.3177488      0.8147801
#> intensityln     2.827479 1.332139 0.1903055      0.5087400
#> ethfrac         1.031417 1.085811 0.1551158      0.3136554
#> unpko          10.612899 4.179155 0.5970221      2.6226135
#> 
#> Inmune equation: 
#>                   Mean       SD  Naive SE Time-series SE
#> (Intercept)  8.9685897 4.405826 0.6294037      3.2149975
#> fhcompor1   -0.7415713 4.350933 0.6215619      3.6932354
#> lgdpl       -3.7276698 1.306414 0.1866306      0.3863354
#> victory     -3.5637919 2.492473 0.3560675      1.4399093

SPstats(tchll)
#> $DIC
#> [1] 343542.6
#> 
#> $Loglik
#> [1] -157358.9

plot(tchll)
```

<img src="man/figures/README-unnamed-chunk-4-4.png" width="100%" /><img src="man/figures/README-unnamed-chunk-4-5.png" width="100%" /><img src="man/figures/README-unnamed-chunk-4-6.png" width="100%" />

#### `exchangeSPsurv`

``` r
## ~~~~~~~~~~~~~~~
## Weibull
## ~~~~~~~~~~~~~~~

set.seed(782566)
tch1 <- 
    exchangeSPsurv(
        duration = duration ~ fhcompor1 + lgdpl + comprehensive + victory + 
                              instabl + intensityln + ethfrac + unpko,
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
        duration = duration ~ fhcompor1 + lgdpl + comprehensive + victory + 
                              instabl + intensityln + ethfrac + unpko,
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
        duration = duration ~ fhcompor1 + lgdpl + comprehensive + victory + 
                              instabl + intensityln + ethfrac + unpko,
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


tch2
#> Call:
#> pooledSPsurv(duration = duration ~ fhcompor1 + lgdpl + comprehensive + 
#>     victory + instabl + intensityln + ethfrac + unpko, immune = cured ~ 
#>     fhcompor1 + lgdpl + victory, Y0 = "t.0", LY = "lastyear", 
#>     data = walter[[1]], N = 100, burn = 10, thin = 10, w = c(1, 
#>         1, 1), m = 10, form = "Weibull")
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
#>                       Mean         SD   Naive SE Time-series SE
#> (Intercept)    2.489440157 0.62190234 0.20730078     0.42128103
#> fhcompor1     -0.597934379 0.36805918 0.12268639     0.12268639
#> lgdpl          0.013546499 0.10442005 0.03480668     0.06773969
#> comprehensive -0.492015838 0.32215044 0.10738348     0.10738348
#> victory        0.268116965 0.40824326 0.13608109     0.13608109
#> instabl        0.687519536 0.59738236 0.19912745     0.19912745
#> intensityln   -0.007686875 0.08437511 0.02812504     0.06935242
#> ethfrac       -0.061081574 0.53557532 0.17852511     0.17852511
#> unpko          0.239877353 0.37292958 0.12430986     0.12430986
#> 
#> Inmune equation: 
#>                    Mean        SD  Naive SE Time-series SE
#> (Intercept) -0.03561465 2.4980613 0.8326871      0.8326871
#> fhcompor1    1.19779508 2.7875406 0.9291802      0.9291802
#> lgdpl       -1.28902905 0.9153009 0.3051003      0.3051003
#> victory      2.04164008 1.8597496 0.6199165      0.6199165

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
        duration = duration ~ fhcompor1 + lgdpl + comprehensive + victory + 
                              instabl + intensityln + ethfrac + unpko,
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

tchll2
#> Call:
#> pooledSPsurv(duration = duration ~ fhcompor1 + lgdpl + comprehensive + 
#>     victory + instabl + intensityln + ethfrac + unpko, immune = cured ~ 
#>     fhcompor1 + lgdpl + victory, Y0 = "t.0", LY = "lastyear", 
#>     data = walter[[1]], N = 100, burn = 10, thin = 10, w = c(1, 
#>         1, 1), m = 10, form = "loglog")
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
#>                      Mean        SD  Naive SE Time-series SE
#> (Intercept)    0.10265409 1.0373415 0.3457805      0.5988271
#> fhcompor1     -2.43718224 0.9589779 0.3196593      0.3196593
#> lgdpl         -1.77984355 0.7116881 0.2372294      0.2372294
#> comprehensive -6.82669019 2.2121766 0.7373922      1.4716176
#> victory       -0.01214126 1.1196299 0.3732100      0.3732100
#> instabl        4.81092148 1.5225472 0.5075157      1.1146849
#> intensityln    0.77653369 0.4869978 0.1623326      0.1623326
#> ethfrac        0.74044034 0.9338153 0.3112718      0.3112718
#> unpko          3.47928279 1.9087975 0.6362658      1.2913057
#> 
#> Inmune equation: 
#>                    Mean       SD  Naive SE Time-series SE
#> (Intercept) -2.46065952 2.401730 0.8005767      0.8005767
#> fhcompor1   -0.05035564 2.560962 0.8536538      1.6046418
#> lgdpl       -1.43625289 1.552470 0.5174900      0.5174900
#> victory      0.33619189 1.207807 0.4026025      0.1829544

SPstats(tchll2)
#> $DIC
#> [1] 39285.51
#> 
#> $Loglik
#> [1] -6598.982
```
