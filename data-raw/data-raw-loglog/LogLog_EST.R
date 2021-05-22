#install.packages('BayesSPsurv')
library(BayesSPsurv)
library(coda)
#SPatial Weibull
data(Walter_2015_JCR)
walter <- spduration::add_duration(Walter_2015_JCR,"renewed_war", 
                                   unitID = "id", tID = "year", 
                                   freq = "year", ongoing = FALSE)
walter <-spatial_SA(data = walter, var_ccode = "ccode", threshold = 800L)

set.seed(123456)

set.seed(123456)

model <- spatialSPsurv(
  duration  = duration ~ victory + comprehensive + lgdpl + unpko,
  immune    = atrisk ~ lgdpl,
  Y0        = 't.0',
  LY        = 'lastyear',
  S         = 'sp_id' ,
  data      = walter[[1]],
  N         = 10000,
  burn      = 2000,
  thin      = 20,
  w         = c(1,1,1),
  m         = 10,
  ini.beta =  0,
  ini.gamma = 0,
  ini.W = 0,
  ini.V= 0,
  form      = "loglog",
  prop.varV = 1e-05,
  prop.varW = 1e-05,
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

country  <- countrycode::countrycode(unique(walter[[1]]$ccode),'gwn','iso3c')

set.seed(123456)

model1 <- exchangeSPsurv(duration = duration ~ victory + comprehensive + lgdpl + unpko,
                            immune = atrisk ~ lgdpl,
                            Y0 ='t.0',LY ='lastyear',
                            S ='sp_id',data = walter[[1]],
                            N         = 10000,
                            burn      = 2000,
                            thin      = 20,
                            w = c(1,1,1),
                            m = 10,ini.beta =  0,ini.gamma = 0,ini.W = 0,ini.V= 0,
                            form = "loglog",
                            prop.varV = 1e-05,prop.varW = 1e-05,id_WV=country)

set.seed(123456)

model2 <- pooledSPsurv(duration = duration ~ victory + comprehensive + lgdpl + unpko,
                         immune = atrisk ~ lgdpl,Y0 ='t.0',LY ='lastyear',data = walter[[1]],
                         N         = 10000,
                         burn      = 2000,
                         thin      = 20,
                         w = c(1,1,1),m = 10,ini.beta =  0,ini.gamma = 0,form = "loglog")