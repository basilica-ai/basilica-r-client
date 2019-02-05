# Basilica R Client

[Basilica](www.basilica.ai) allows you to easily augment your models with images and text. You send
us an image or a snippet of natural language text and we send you a vector of
features you can use to train or improve your models.

## Installation

You can install the released version of basilica from [CRAN](https://CRAN.R-project.org) with:

``` r
devtools::install_github("basilica-ai/basilica-r-client")
```

## Examples

This is a basic example which shows you how to solve a common problem:

### Creating a Connection

``` r
library('basilica')
# Create a connection
# You can use our `SLOW_DEMO_KEY` (it actually works) or create your own at basilica.ai
connect("SLOW_DEMO_KEY")
```

### Embedding a Sentence

```r
sentences = list(
    "This is a sentence!",
    "This is a similar sentence!",
    "I don't think this sentence is very similar at all..."
)

# Returns a data frame with 512 features for each of the 3 sentences
embeddings <- embed_sentences(sentences)
print(dim(embeddings)) # 3 512
print(embeddings) # [[0.8556405305862427, ...], ...]

print(cor(embeddings[1,], embeddings[2,])) # 0.8048559
print(dor(embeddings[1,], embeddings[3,])) # 0.6877435
```

### Embedding an Image

```r
embeddings <- embed_image("/tmp/image.jpg")
print(dim(embeddings)) # 1 2048
print(embeddings) # [[0.8556405305862427, ...], ...]
```
