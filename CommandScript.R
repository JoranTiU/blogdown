library(blogdown)
new_site(theme = "wowchemy/starter-academic")

file.edit(".gitignore")

blogdown::check_gitignore()

blogdown::config_netlify()

blogdown::check_hugo()

blogdown::config_Rprofile()
