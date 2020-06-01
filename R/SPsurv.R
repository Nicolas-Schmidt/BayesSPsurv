#' @title SPsurv
#' @description Markov Chain Monte Carlo (MCMC) to run Bayesian split population survival model with no frailties
#'
#' @param Y0 the elapsed time since inception until the beginning of time period (t-1)
#' @param duration ...
#' @param LY last observation year
#' @param immune ...
#' @param data ...
#' @param N number of MCMC iterations
#' @param S ...
#' @param burn burn-in to be discarded
#' @param thin thinning to prevent from autocorrelation
#' @param w size of the slice in the slice sampling for (betas, gammas, rho). Write it as a vector. E.g. c(1,1,1)
#' @param m limit on steps in the slice sampling. A vector of values for beta, gamma, rho.
#' @param form type of parametric model (Exponential or Weibull)
#'
#' @return chain of the variables of interest
#'
#' @export

SPsurv<- function(duration,
                  immune,
                  Y0,
                  LY,
                  data,
                  N,
                  burn,
                  thin,
                  w = c(1, 1, 1),
                  m = 10,
                  form = c('weibull', 'exponential', 'loglog'))
{

    cll <- match.call()
    dis <- match.arg(form)
    r   <- formcall(duration = duration, immune = immune, data = data, Y0 = Y0,
                    C = C, LY = LY, X = X, Z = Z, N = N, burn = burn, thin = thin,
                    w = w, m = m, form = dis, prop.var = prop.var, model = 'SPsurv')

    results <- mcmcSP(Y = r$Y, Y0 = r$Y0, C = r$C, LY = r$LY, X = r$X, Z = r$Z,
                      N = r$N, burn = r$burn, thin = r$thin, w  = r$w, m  = r$m,
                      form = r$form)

    results

}
