#' @title exchangeSPsurv
#' @description Markov Chain Monte Carlo (MCMC) to run Bayesian split population survival model with exchangeable frailties
#'
#' @param duration survival stage equation written in a formula of the form Y ~ X1 + X2 + ... where Y is duration until failure or censoring
#' @param immune split stage equation written in a formula of the form C ~ Z1 + Z2 + ... where C is a binary indicator of immunity
#' @param Y0 the elapsed time since inception until the beginning of time period (t-1)
#' @param LY last observation year (coded as 1; 0 otherwise) due to censoring or failure
#' @param S spatial information (e.g. district ID) for each observation that matches the spatial matrix row/column information
#' @param data dataframe
#' @param N number of MCMC iterations
#' @param burn burn-in to be discarded
#' @param thin thinning to prevent from autocorrelation
#' @param w size of the slice in the slice sampling for (betas, gammas, rho). Write it as a vector. E.g. c(1,1,1)
#' @param m limit on steps in the slice sampling. A vector of values for beta, gamma, rho.
#' @param form type of parametric model (Weibull, Exponential or Log-Logistic)
#' @param prop.var Proposed variance for Metropolis-Hastings
#'
#' @return chain of the variables of interest
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
                          form = c('Weibull', 'exponential', 'loglog'),
                          prop.var)
{

    cll <- match.call()
    dis <- match.arg(form)
    model <- 'frailtySPsurv'
    r   <- formcall(duration = duration, immune = immune, data = data, Y0 = Y0,
                  LY = LY, S = S, N = N, burn = burn, thin = thin, w = w, m = m,
                  form = dis, prop.var = prop.var, model = model)

    if(form == 'loglog'){
        results <- mcmcfrailtySPlog(Y = r$Y, Y0 = r$Y0, C = r$C, LY = r$LY, X = r$X, Z = r$Z,
                                 S = r$S, N = r$N, burn = r$burn, thin = r$thin, w  = r$w,
                                 m  = r$m, form = r$form, prop.var = r$prop.var)
    } else {
        results <- mcmcfrailtySP(Y = r$Y, Y0 = r$Y0, C = r$C, LY = r$LY, X = r$X, Z = r$Z,
                             S = r$S, N = r$N, burn = r$burn, thin = r$thin, w  = r$w,
                             m  = r$m, form = r$form, prop.var = r$prop.var)
    }

    class(results) <- c(class(results), model)
    results

}


#' @title summary.frailtySPsurv
#' @description Returns a summary of a exchangeSPsurv object via \code{\link[coda]{summary.mcmc}}.
#' @param object an object of class \code{frailtySPsurv}, the output of \code{\link{exchangeSPsurv}}.
#' @param parameter one of three parameters of the pooledSPsurv output. Indicate either "betas", "gammas" or "lambda".
#' @param ... additional parameter
#' @return list. Empirical mean, standard deviation and quantiles for each variable.
#' @rdname exchangeSPsurv
#' @export
#'
#'

summary.frailtySPsurv <- function(object, parameter = c("betas", "gammas", "lambda"), ...){

    if (parameter == "betas")  sum <- summary(mcmc(object$betas),  ...)
    if (parameter == "gammas") sum <- summary(mcmc(object$gammas), ...)
    if (parameter == "lambda") sum <- summary(mcmc(object$lambda), ...)
    sum
}


