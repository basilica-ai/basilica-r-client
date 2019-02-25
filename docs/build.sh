Rscript ./build.R

rm image.md text.md logistic-regression.md
rm -rf _build
sphinx-build -b html . _build
