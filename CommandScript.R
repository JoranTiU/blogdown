library(blogdown)
new_site(theme = "wowchemy/starter-academic")

file.edit(".gitignore")

blogdown::check_gitignore()

blogdown::config_netlify()

blogdown::check_hugo()

blogdown::config_Rprofile()

blogdown::new_post(
  title = "STAN Code for Analyzing Intensive Longitudinal Data: Part IIa - Hierarchical Autoregressive Models",
  date = '2021-11-02',
  slug = 'STAN-Hierarchical-AR',
  tags = c("Bayesian", "STAN", "AR", "ILD", "R","tutorial")
)


blogdown::new_post(
  title = "STAN Code for Analyzing Intensive Longitudinal Data: Part IIb - Hierarchical Autoregressive Models with Missing Data",
  date = '2021-11-09',
  slug = 'STAN-Hierarchical-AR-Miss',
  tags = c("Bayesian", "STAN", "AR", "ILD", "R","tutorial")
)