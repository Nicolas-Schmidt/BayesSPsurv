#include <RcppArmadillo.h>
#include <cmath>
//[[Rcpp::depends(RcppArmadillo)]]
using std::log;
using std::exp;
using std::max;
using std::abs;
using std::sqrt;
using std::pow;

using namespace Rcpp; 




// **********************************************************//
//     	           Likelihood function            //
// **********************************************************//
// [[Rcpp::export]]
double llikLoglog (arma::vec Y,
                       arma::vec eXB, 
                       arma::vec delta,
                       arma::vec C,
                       double rho) {
  
  double r = rho;
  
  arma::vec lambda = eXB;
  arma::uvec ids1 = find(lambda == 0);
  lambda.elem(ids1).fill(exp(-740));
  arma::uvec ids2 = find(lambda == arma::datum::inf);
  lambda.elem(ids2).fill(exp(700));
  
  arma::vec eXBY = eXB % Y;
  arma::uvec ids3 = find(eXBY == arma::datum::inf);
  eXBY.elem(ids3).fill(exp(700));
  arma::uvec ids4 = find(eXBY == 0);
  eXBY.elem(ids4).fill(exp(-740));
  
  arma::vec eXBYr = pow(eXBY, r);
  arma::uvec ids5 = find(eXBYr == arma::datum::inf);
  eXBYr.elem(ids5).fill(exp(700));
  arma::uvec ids19 = find(eXBYr == 0);
  eXBYr.elem(ids19).fill(exp(-740));
  
  arma::vec st = 1/(1 + eXBYr);
  arma::uvec ids18 = find(eXBYr == arma::datum::inf);
  eXBYr.elem(ids18).fill(exp(700)); 
  
  arma::vec S = st; 
  
  arma::vec f = log(r) + r * log(lambda) + (r - 1) * log(Y) - (2 * log(1+eXBYr));
  arma::uvec ids12 = find(f == arma::datum::inf);
  f.elem(ids12).fill(exp(700)); 
  arma::uvec ids13 = find(f == -arma::datum::inf);
  f.elem(ids13).fill(-740);
  
  arma::vec ldelta = log(1 - delta);
  arma::uvec ids14 = find(ldelta == -arma::datum::inf);
  ldelta.elem(ids14).fill(-740);
  arma::uvec ids15 = find(ldelta == arma::datum::inf);
  ldelta.elem(ids15).fill(exp(700)); ; 
  
  arma::vec sdelta = (1 - delta) % S;
  arma::uvec ids17 = find(sdelta == 0);
  sdelta.elem(ids17).fill(exp(-740));
  
  arma::vec cens(lambda.size());
  for(unsigned int i=0; i<cens.size(); ++i) {
    if (C[i]==0 ) {
      cens[i] = log(delta[i] + sdelta[i]);
    } else {
      cens[i] = 0;
    }
  }
  
  arma::vec nocens(lambda.size());
  for(unsigned int i=0; i<nocens.size(); ++i) {
    if ( C[i]==1 ) {
      nocens[i] = ldelta[i] + f[i];
      arma::uvec ids16 = find(nocens == arma::datum::inf);
      nocens.elem(ids16).fill(exp(700)); 
    } else {
      nocens[i] = 0;
    }
  }
  
  //arma::vec cens = (1-C) % (log(delta + sdelta));
  
  //arma::vec dexp = (ldelta + f);
  
  //arma::uvec ids16 = find(dexp == arma::datum::inf);
  //dexp.elem(ids16).fill(exp(700));
  
  //arma::vec nocens = C % dexp;
  
  arma::vec llik = nocens + cens;
  
  return sum(llik);
}
