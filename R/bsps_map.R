#' @title bsps_map
#' @description Implement the \code{\link[rworldmap]{mapCountryData}} function in a short and fast version.
#' @param data data.
#' @param mapTitle title to add to the map, any string or 'columnName' to set it to the name of the data column.
#'
#' @examples
#' \donttest{
#' library(BayesSPsurv)
#'
#' walter <- spduration::add_duration(Walter_2015_JCR,"renewed_war",
#'                                    unitID = "id", tID = "year",
#'                                    freq = "year", ongoing = FALSE)
#'
#' walter <- BayesSPsurv::spatial_SA(data = walter, var_ccode = "ccode", threshold = 800L)
#'
#' set.seed(123456)
#'
#' model <- spatialSPsurv(
#'    duration  = duration ~ victory + comprehensive + lgdpl + unpko,
#'    immune    = atrisk ~ lgdpl,
#'    Y0        = 't.0',
#'    LY        = 'lastyear',
#'    S         = 'sp_id' ,
#'    data      = walter[[1]],
#'    N         = 1500,
#'    burn      = 300,
#'    thin      = 15,
#'    w         = c(1,1,1),
#'    m         = 10,
#'    form      = "Weibull",
#'    prop.varV = 1e-05,
#'    prop.varW = 1e-03,
#'    A         = walter[[2]]
#' )
#'
#' bsps_map(data = model$W)
#'
#' }
#' @export

bsps_map <- function(data, mapTitle = "columnName"){

    sp <- data.frame(ccode = colnames(data),
                     ISO3 = countrycode::countrycode(colnames(data) ,'gwn','iso3c'),
                     sp = matrix(apply(data, 2, mean), ncol = 1, nrow = ncol(data)))
    map <- rworldmap::joinCountryData2Map(sp, joinCode = "ISO3", nameJoinColumn = "ISO3")
    rworldmap::mapCountryData(mapToPlot = map,
                              nameColumnToPlot = 'sp',
                              mapTitle = mapTitle)

}



