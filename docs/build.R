library('knitr')
knit2pandoc("vignettes/image.Rmd", to="markdown", quiet=TRUE)
knit2pandoc("vignettes/text.Rmd", to="markdown", quiet=TRUE)
knit2pandoc("vignettes/logistic-regression.Rmd", to="markdown", quiet=TRUE)
