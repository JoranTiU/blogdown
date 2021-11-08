library(rstan)
library(mvtnorm)
library(tidyverse)


HierAR <- stan_model("C:/Users/jongerli/Documents/HierarchicalAR1model.stan")

I <- 100
t <- 50
N <- I*t
individual <- rep(1:I, each = t)
time <- rep(1:t, I)

set.seed(31121)

# True values for data generation
sigma <- 1 # sd's of Y residuals 

alpha_hat <- 4 
alpha_scale <- 1 

alphas <- rnorm(I,alpha_hat, alpha_scale) 
mean(alphas)

beta_hat <- .4 
beta_scale <- .1 

betaGen <- rnorm(I,beta_hat, beta_scale)

for(i in 1:I){
  # The while loop avoids non-stationary AR processes
  # See Hamilton  pg. 259
  while(betaGen[i] <= -1 | betaGen[i] >= 1){
    betaGen[i] <- rnorm(1,beta_hat, beta_scale)
  }
}

betas <- betaGen

# Determine first observations for everyone. The variance for this first observation is different
# than for the subsequent ones and so it needs to be samples separatelty
IndT1 <- match(unique(individual), individual)

# Determine variance at first measurement for everyone (depends on their AR-parameter)

sigmaT1 <- rep(NA, I)

for(k in 1:I){
sigmaT1[k] <- sigma/(1-((betas[k])^2))
}

# First create storage matrices for non-centered and centered y-scores.
# We need centered values, because of we use person-cetered values as predictors, alpha will be
# equal to individual means instead of individual intercepts which are less informative.
Y <- rep(NA, N)
Yc <- rep(NA, N)


# Draw first observation for each individual first

for(l in 1:I){
  Y[IndT1[l]] <- rnorm(1, alphas[l], sigmaT1[l])
  Yc[IndT1[l]] <-  Y[IndT1[l]] - alphas[l]
}

 
# Draw subsequent observations

for(m in 1:N){
  
  # This if statement makes sure I dont try to predict a persons first observation which is impossible
  # there is no measurement before the first observation and so no predictor values for that observation
  if(time[m]>1){
    Y[m]<- rnorm(1, (alphas[individual[m]] + betas[individual[m]]*Yc[m-1]), sigma)
    Yc[m] <-  Y[m] - alphas[individual[m]]
  }
}



# Data send to STAN
mod_data <- list(
  individual = individual,
  time = time,
  T = t,
  I = I,
  N = N,
  y = Y
)
  
# Estimate the two models
estimated_ar_model <- sampling(HierAR, 
                               data = mod_data, 
                               iter = 2000,
                               chains=2)


# Check results for population parameters
print(estimated_ar_model, pars = c("alpha_hat_raw", "alpha_scale_raw", "beta_hat", "beta_scale", "sigma_raw"))


# Also check individual mean-estimates
Ind_Mean_Est <- summary(estimated_ar_model, pars = c("alphas_ind"))

# Correlation
cor(Ind_Mean_Est$summary[,1], alphas)

# Average absolute difference between estimated and true individual values
sqrt(mean((alphas - Ind_Mean_Est$summary[,1])^2))


# Finally check individual AR-parameters
Ind_AR_Est <- summary(estimated_ar_model, pars = c("beta"))

# Correlation
cor(Ind_AR_Est$summary[,1], betas)

# Average absolute difference between estimated and true individual values
sqrt(mean((betas - Ind_AR_Est$summary[,1])^2))

plot(betas, Ind_AR_Est$summary[,1])



