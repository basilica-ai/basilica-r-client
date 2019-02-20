# Basilica R Client: Deep Feature Extraction for Images and Text

## [Word2Vec For Anything](https://www.basilica.ai)

[Basilica](https://www.basilica.ai) allows you to easily augment your models with images and text. You send
us an image or a snippet of natural language text and we send you a vector of
features you can use to train or improve your models.

## Installation

You can install the released version of this package from Google cloud:

```r
install.packages("https://storage.googleapis.com/basilica-r-client/basilica_0.0.1.tar.gz", repos=NULL)
```

or from Github (requires the `devtools` package):

``` r
devtools::install_github("basilica-ai/basilica-r-client")
```

(CRAN submission approval in progress)

## Examples

This is a basic example which shows you how to solve a common problem:

### Creating a Connection

Before embedding an image or text (getting a vector of features), you must first
connect to the API with a demo key. `SLOW_DEMO_KEY` is a key you can use for
testing with a low per-week limit, but you can create API keys for free at [www.basilica.ai](https://www.basilica.ai/accounts/register/).

``` r
library('basilica')
# Create a connection
# You can use our `SLOW_DEMO_KEY` (it actually works) or create your own at basilica.ai
conn <- connect("SLOW_DEMO_KEY")
```

### Embedding Text

Getting a vector of features for text:

```r
sentences = c(
    "This is a sentence!",
    "This is a similar sentence!",
    "I don't think this sentence is very similar at all..."
)

# Returns a data frame with 512 features for each of the 3 sentences
embeddings <- embed_sentences(sentences, conn=conn)
print(dim(embeddings)) # 3 512
print(embeddings) # [[0.8556405305862427, ...], ...]

print(cor(embeddings[1,], embeddings[2,])) # 0.8048559
print(cor(embeddings[1,], embeddings[3,])) # 0.6877435
```

#### Differences from Word2Vec

It's important to know that the embedding you get for a sentence is completely
different from an embedding you would get with Word2Vec. Word2Vec returns a
word-level embedding, while basilica is trained on longer snippets of natural
language text (phrases, sentences, paragraphs). For that reason, results on models
where the context of the sentence matter (like sentiment analysis) will get much
better results with a sentence-level embedding than with a word embedding.

### Embedding an Image

Getting a vector of features for images:

```r
embeddings <- embed_image("/tmp/image.jpg", conn=conn)
print(dim(embeddings)) # 1 2048
print(embeddings) # [[0.8556405305862427, ...], ...]
```

## Development

If you want to contribute to this client, here's are some of the libraries and
commands you will need:

### Setup

```
brew install qpdf
```

```r
install.packages("devtools")
install.packages("usethis")
install.packages("testthat")
```

### Building

When on a branch, make sure all these commands work and pass.

```
devtools::test()
devtools::document()
devtools::build_vignettes()
devtools::check()
```
