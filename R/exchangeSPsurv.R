#' @title exchangeSPsurv
#' @description Markov Chain Monte Carlo (MCMC) to run Bayesian split population survival model with exchangeable frailties.
#'
#' @param duration survival stage equation written in a formula of the form Y ~ X1 + X2 + ... where Y is duration until failure or censoring.
#' @param immune split stage equation written in a formula of the form C ~ Z1 + Z2 + ... where C is a binary indicator of immunity.
#' @param Y0 the elapsed time since inception until the beginning of time period (t-1).
#' @param LY last observation year (coded as 1; 0 otherwise) due to censoring or failure.
#' @param S spatial information (e.g. district ID) for each observation that matches the spatial matrix row/column information.
#' @param data data.frame.
#' @param N number of MCMC iterations.
#' @param burn burn-in to be discarded.
#' @param thin thinning to prevent from autocorrelation.
#' @param w size of the slice in the slice sampling for (betas, gammas, rho). Write it as a vector. E.g. c(1,1,1).
#' @param m limit on steps in the slice sampling. A vector of values for beta, gamma, rho.
#' @param ini.beta initial value for the parameter vector beta.  By default is 0.
#' @param ini.gamma initial value for the parameter vector gamma. By default is 0.
#' @param ini.W initial value for the parameter vector W. By default is 0.
#' @param ini.V initial value for the parameter vector V.  By default is 0. #' @param form type of parametric model (Weibull, Exponential, or Log-Logistic).
#' @param prop.varV proposed variance for V in Metropolis-Hastings.
#' @param prop.varW proposed variance for W in Metropolis-Hastings.
#' @param id_WV vector of type character that modifies the colnames of W and V in the model’s result. By default is \code{unique(data[,S])}.
#'
#'
#' @return exchangeSPsurv returns an object of class \code{"frailtySPsurv"}.
#'
#' An \code{"exchangeSPsurv"} object has the following elements:
#' \item{betas}{matrix, numeric values of the posterior for each variable in the duration equation .}
#' \item{gammas}{matrix, numeric values of the posterior for each variable in the immune equation.}
#' \item{rho}{vector, numeric values of rho.}
#' \item{lambda}{vector, numeric values of lambda.}
#' \item{delta}{vector, numeric values of delta.}
#' \item{W}{matrix, numeric values of the posterior for Ws.}
#' \item{V}{matrix, numeric values of the posterior for Vs.}
#' \item{X}{matrix of X's variables.}
#' \item{Z}{matrix of Z's variables.}
#' \item{Y}{vector of `Y'.}
#' \item{Y0}{vector of `Y0'.}
#' \item{C}{vector of `C'.}
#' \item{S}{vector of `S'.}
#' \item{ini.beta}{numeric initial values of beta.}
#' \item{ini.gamma}{numeric initial values of gamma.}
#' \item{ini.W}{numeric initial values of W.}
#' \item{ini.V}{numeric initial values of V.}
#' \item{form}{character, type of distribution.}
#' \item{call}{description for the model to be estimated.}
#'
#' @examples
#' \donttest{
#'
#'
#' ## 1
#'
#' walter <- spduration::add_duration(Walter_2015_JCR,"renewed_war",
#'                                    unitID = "ccode", tID = "year",
#'                                    freq = "year", ongoing = FALSE)
#'
#' # add S
#' walter <- spatial_SA(data = walter, var_ccode = "ccode", threshold = 800L)
#'
#' set.seed(123456)
#'
#' model <-
#'     exchangeSPsurv(
#'            duration  = duration ~ fhcompor1 + lgdpl + comprehensive + victory +
#'                        instabl + intensityln + ethfrac + unpko,
#'            immune    = cured ~ fhcompor1 + lgdpl + victory,
#'            Y0        = 't.0',
#'            LY        = 'lastyear',
#'            S         = 'sp_id' ,
#'            data      = walter[[1]],
#'            N         = 100,
#'            burn      = 10,
#'            thin      = 10,
#'            w         = c(1,1,1),
#'            m         = 10,
#'            form      = "Weibull",
#'            prop.varV = 1e-05,
#'            prop.varW = 1e-05,
#' )
#'
#' print(model)
#'
#' summary(model, parameter = "betas")
#'
#' # plot(model)
#'
#'
#' ## 2
#'
#' walter   <- spduration::add_duration(Walter_2015_JCR,"renewed_war",
#'                                    unitID = "ccode", tID = "year",
#'                                    freq = "year", ongoing = FALSE)
#'
#' walter$S <- rep(x = 1:length(unique(walter$ccode)), times = rle(walter$ccode)$lengths)
#' country  <- countrycode::countrycode(unique(walter$ccode),'gwn','iso3c')
#'
#' set.seed(123456)
#'
#' model <-
#'     exchangeSPsurv(
#'         duration  = duration ~ fhcompor1 + lgdpl + comprehensive + victory +
#'                     instabl + intensityln + ethfrac + unpko,
#'         immune    = cured ~ fhcompor1 + lgdpl + victory,
#'         Y0        = 't.0',
#'         LY        = 'lastyear',
#'         S         = 'S' ,
#'         data      = walter,
#'         N         = 100,
#'         burn      = 10,
#'         thin      = 10,
#'         w         = c(1,1,1),
#'         m         = 10,
#'         form      = "loglog",
#'         prop.varV = 1e-05,
#'         prop.varW = 1e-05,
#'         id_WV     = country
#'     )
#'
#' print(model)
#'}
#'
#' @export


exchangeSPsurv <- function(duration,
                          immune,
                          Y0,
                          LY,
                          S,
                          data,
                          N,
                          burn,
                          thin,
                          w = c(1, 1, 1),
                          m = 10,
                          ini.beta =  0,
                          ini.gamma = 0,
                          ini.W = 0,
                          ini.V= 0,
                          form = c('Weibull', 'exponential', 'loglog'),
                          prop.varV,
                          prop.varW,
                          id_WV = unique(data[,S]))
{

    dis <- match.arg(form)
    model <- 'frailtySPsurv'
    r   <- formcall(duration = duration, immune = immune, data = data, Y0 = Y0,
                  LY = LY, S = S, N = N, burn = burn, thin = thin, w = w, m = m,
                  ini.beta = ini.beta, ini.gamma = ini.gamma, ini.W = ini.W, ini.V = ini.V,
                  form = dis, prop.varV = prop.varV, prop.varW = prop.varW, model = model)

    if(form == 'loglog'){
        results <- mcmcfrailtySPlog(Y = r$Y, Y0 = r$Y0, C = r$C, LY = r$LY, X = r$X, Z = r$Z,
                                 S = r$S, N = r$N, burn = r$burn, thin = r$thin, w  = r$w,
                                 m  = r$m, ini.beta = r$ini.beta, ini.gamma = r$ini.gamma,
                                 ini.W = r$ini.W, ini.V = r$ini.V,
                                 form = r$form, prop.varV = r$prop.varV, prop.varW = r$prop.varW,
                                 id_WV = id_WV)
    } else {
        results <- mcmcfrailtySP(Y = r$Y, Y0 = r$Y0, C = r$C, LY = r$LY, X = r$X, Z = r$Z,
                             S = r$S, N = r$N, burn = r$burn, thin = r$thin, w  = r$w,
                             m  = r$m, ini.beta = r$ini.beta, ini.gamma = r$ini.gamma,
                             ini.W = r$ini.W, ini.V = r$ini.V,
                             form = r$form, prop.varV = r$prop.varV, prop.varW = r$prop.varW,
                             id_WV = id_WV)
    }

    results$call   <- match.call()
    class(results) <- c(model)
    results

}


#' @title summary.frailtySPsurv
#' @description Returns a summary of a exchangeSPsurv object via \code{\link[coda]{summary.mcmc}}.
#' @param object an object of class \code{frailtySPsurv}, the output of \code{\link{exchangeSPsurv}}.
#' @param parameter one of five parameters of the \code{\link{spatialSPsurv}} output. Indicate either "betas," "gammas," "rho", "lambda" or "delta".
#' @param ... additional parameter
#' @return list. Empirical mean, standard deviation and quantiles for each variable.
#' @rdname exchangeSPsurv
#' @export
#'
#'

summary.frailtySPsurv <- function(object, parameter = character(), ...){
    summary(coda::mcmc(object[[parameter]]), ...)
}


#' @title print.frailtySPsurv
#' @description Print method for a \code{\link{exchangeSPsurv}} x.
#' @param x an x of class \code{frailtySPsurv} (output of \code{\link{exchangeSPsurv}}).
#' @rdname exchangeSPsurv
#' @export

print.frailtySPsurv <- function(x, ...){

    cat('Call:\n')
    print(x$call)
    cat('\n')
    x2 <- summary(x, parameter = 'betas')
    cat("\n", "Iterations = ", x2$start, ":", x2$end, "\n", sep = "")     # coda::mcmc
    cat("Thinning interval =", x2$thin, "\n")                             # coda::mcmc
    cat("Number of chains =", x2$nchain, "\n")                            # coda::mcmc
    cat("Sample size per chain =", (x2$end - x2$start)/x2$thin + 1, "\n") # coda::mcmc
    cat("\nEmpirical mean and standard deviation for each variable,")     # coda::mcmc
    cat("\nplus standard error of the mean:\n\n")
    cat('\n')
    cat('Duration equation: \n')
    print(summary(x, parameter = 'betas')$statistics)
    cat('\n')
    cat('Inmune equation: \n')
    print(summary(x, parameter = 'gammas')$statistics)
    cat('\n')

}



#' @title plot.frailtySPsurv
#' @description Returns a plot of a exchangeSPsurv object via \code{\link[coda]{plot.mcmc}}.
#' @param x an object of class \code{frailtySPsurv}, the output of \code{\link{exchangeSPsurv}}.
#' @param parameter one of five parameters of the \code{\link{spatialSPsurv}} output. Indicate either "betas," "gammas," "rho", "lambda" or "delta".
#' @param ... additional parameter.
#' @return list. Empirical mean, standard deviation and quantiles for each variable.
#' @rdname exchangeSPsurv
#' @export
#'

plot.frailtySPsurv <- function(x,  parameter = character(), ...){
    plot((coda::mcmc(x[[parameter]])), ...)
}







