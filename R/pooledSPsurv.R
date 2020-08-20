#' @title SPsurv
#' @description Markov Chain Monte Carlo (MCMC) to run Bayesian split population survival model with no frailties
#'
#' @param duration survival stage equation written in a formula of the form Y ~ X1 + X2 + ... where Y is duration until failure or censoring
#' @param immune split stage equation written in a formula of the form C ~ Z1 + Z2 + ... where C is a binary indicator of immunity
#' @param Y0 the elapsed time since inception until the beginning of time period (t-1)
#' @param LY last observation year (coded as 1; 0 otherwise) due to censoring or failure
#' @param data dataframe
#' @param N number of MCMC iterations
#' @param burn burn-in to be discarded
#' @param thin thinning to prevent from autocorrelation
#' @param w size of the slice in the slice sampling for (betas, gammas, rho). Write it as a vector. E.g. c(1,1,1)
#' @param m limit on steps in the slice sampling. A vector of values for beta, gamma, rho.
#' @param form type of parametric model (Exponential, Weibull or Log-Logistic)
#'
#' @return chain of the variables of interest
#'
#' @export

pooledSPsurv <- function(duration,
                  immune,
                  Y0,
                  LY,
                  data,
                  N,
                  burn,
                  thin,
                  w = c(1, 1, 1),
                  m = 10,
                  form = c('Weibull', 'exponential', 'loglog'))
{

    cll <- match.call()
    dis <- match.arg(form)
    model <- 'SPsurv'
    r   <- formcall(duration = duration, immune = immune, data = data, Y0 = Y0,
                    LY = LY, N = N, burn = burn, thin = thin, w = w,
                    m = m, form = dis, model = model)

    if(form == 'loglog') {
        results <- mcmcSPlog(Y = r$Y, Y0 = r$Y0, C = r$C, LY = r$LY, X = r$X, Z = r$Z,
                          N = r$N, burn = r$burn, thin = r$thin, w  = r$w, m  = r$m,
                          form = r$form)
    } else {
        results <- mcmcSP(Y = r$Y, Y0 = r$Y0, C = r$C, LY = r$LY, X = r$X, Z = r$Z,
                      N = r$N, burn = r$burn, thin = r$thin, w  = r$w, m  = r$m,
                      form = r$form)
    }

    class(results) <- c(class(results), model)
    results

}


#' @title summary.SPsurv
#' @description Returns a summary of a SPsurv object via \code{\link[coda]{summary.mcmc}}.
#' @param object an object of class \code{SPsurv}, the output of \code{\link{pooledSPsurv}}.
#' @param parameter one of three parameters of the pooledSPsurv output. Indicate either "betas", "gammas" or "lambda".
#' @param ... additional parameter
#' @return list. Empirical mean, standard deviation and quantiles for each variable.
#' @rdname pooledSPsurv
#' @export
#'
#'

summary.SPsurv <- function(object, parameter = c("betas", "gammas", "lambda"), ...){

    if (parameter == "betas")  sum <- summary(mcmc(object$betas),  ...)
    if (parameter == "gammas") sum <- summary(mcmc(object$gammas), ...)
    if (parameter == "lambda") sum <- summary(mcmc(object$lambda), ...)
    sum
}













