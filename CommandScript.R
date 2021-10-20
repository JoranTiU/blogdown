library(blogdown)
new_site(theme = "wowchemy/starter-academic")

file.edit(".gitignore")

blogdown::check_gitignore()

blogdown::config_netlify()

blogdown::check_hugo()

blogdown::config_Rprofile()

blogdown::new_post(
  title = "STAN Code for Analyzing Intensive Longitudinal Data: Part I - Autogeressive Models",
  date = '2021-10-20',
  slug = 'STAN-AR',
  tags = c("Bayesian", "STAN", "AR", "ILD", "R","tutorial")
)