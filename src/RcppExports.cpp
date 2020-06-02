// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// llikWeibull
double llikWeibull(arma::vec Y, arma::vec Y0, arma::vec eXB, arma::vec delta, arma::vec C, arma::vec LY, double rho);
RcppExport SEXP _spatialSPsurv_llikWeibull(SEXP YSEXP, SEXP Y0SEXP, SEXP eXBSEXP, SEXP deltaSEXP, SEXP CSEXP, SEXP LYSEXP, SEXP rhoSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::vec >::type Y(YSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type Y0(Y0SEXP);
    Rcpp::traits::input_parameter< arma::vec >::type eXB(eXBSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type delta(deltaSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type C(CSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type LY(LYSEXP);
    Rcpp::traits::input_parameter< double >::type rho(rhoSEXP);
    rcpp_result_gen = Rcpp::wrap(llikWeibull(Y, Y0, eXB, delta, C, LY, rho));
    return rcpp_result_gen;
END_RCPP
}
// llikLoglog
double llikLoglog(arma::vec Y, arma::vec eXB, arma::vec delta, arma::vec C, double rho);
RcppExport SEXP _spatialSPsurv_llikLoglog(SEXP YSEXP, SEXP eXBSEXP, SEXP deltaSEXP, SEXP CSEXP, SEXP rhoSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::vec >::type Y(YSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type eXB(eXBSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type delta(deltaSEXP);
    Rcpp::traits::input_parameter< arma::vec >::type C(CSEXP);
    Rcpp::traits::input_parameter< double >::type rho(rhoSEXP);
    rcpp_result_gen = Rcpp::wrap(llikLoglog(Y, eXB, delta, C, rho));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_spatialSPsurv_llikWeibull", (DL_FUNC) &_spatialSPsurv_llikWeibull, 7},
    {"_spatialSPsurv_llikLoglog", (DL_FUNC) &_spatialSPsurv_llikLoglog, 5},
    {NULL, NULL, 0}
};

RcppExport void R_init_spatialSPsurv(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
