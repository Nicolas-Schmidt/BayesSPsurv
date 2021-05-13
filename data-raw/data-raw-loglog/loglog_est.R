## Clear Memory
rm(list = ls())

## Load Required Libraries
library(BayesSPsurv)
library(spduration)
library(countrycode)

## Load Dataset
data(Walter_2015_JCR)

## Use 'spduration' to capture survival characteristics of data
walter <- add_duration(Walter_2015_JCR,"renewed_war", unitID = "id",
                       tID = "year", freq = "year", ongoing = FALSE)
str(walter)

walter <- spatial_SA(data = walter, var_ccode = "ccode", threshold = 800L)


## Run Bayesian Spatial SP Survival Model (loglog form)
set.seed(123456)

model <- spatialSPsurv(
  duration  = duration ~ victory + comprehensive + lgdpl + unpko,
  immune    = atrisk ~ lgdpl,
  Y0        = 't.0',
  LY        = 'lastyear',
  S         = 'sp_id' ,
  data      = walter[[1]],
  N         = 15000,
  burn      = 300,
  thin      = 15,
  w         = c(1,1,1),
  m         = 10,
  form      = "loglog",
  prop.varV = 1e-05,
  prop.varW = 1e-03,
  A         = walter[[2]]
)

## Print Results and Get Stats of 'model' 
print(model)
SPstats(model)


## Choropleth Map of Ws
spw   <- matrix(apply(model$W, 2, mean), ncol = 1, nrow = ncol(model$W))
ccode <- colnames(model$W)
ISO3  <- countrycode::countrycode(ccode,'gwn','iso3c')
spw   <- data.frame(ccode = ccode, ISO3 = ISO3, spw = spw) 
map   <- rworldmap::joinCountryData2Map(spw, joinCode = "ISO3", nameJoinColumn = "ISO3")

rworldmap::mapCountryData(map, nameColumnToPlot = 'spw')

## Run Exchangeable SP Survival Model 

country  <- countrycode(unique(walter[[1]]$ccode),'gwn','iso3c')
model1 <- exchangeSPsurv(duration = duration ~ comprehensive + victory + unpko,
                         immune = cured ~ lgdpl,
                         Y0 = 't.0',
                         LY = 'lastyear',
                         S = 'sp_id',
                         data = walter[[1]],
                         N = 15000,
                         burn = 3000,
                         thin = 15,
                         w = c(1,1,1),
                         m = 10,
                         form = "loglog",
                         prop.varW = 1e-05,
                         prop.varV = 1e-03,
                         id_WV = country)

print(model1)

## Run Pooled SP Survival Model 

model2 <- pooledSPsurv(duration = duration ~ comprehensive + victory + unpko,
                         immune = cured ~ lgdpl,
                         Y0 = 't.0',
                         LY = 'lastyear',
                         data = walter[[1]],
                         N = 15000,
                         burn = 3000,
                         thin = 15,
                         w = c(1,1,1),
                         m = 10,
                         form = "loglog")
print(model2)
