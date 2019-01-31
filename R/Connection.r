# Connection.r

library(httr)
library(RCurl)
library(methods)
library(data.table)

#' Connection
#'
#' Instantiates and returns a Basilica connection tied to a specific auth key and other connection parameters.
#' @param auth_key Basilica API key
#' @param server Basilica server to point to (Default: `https://api.basilica.ai`)
#' @param retries Number of retries for any given request
#' @param backoff_factor How much to backoff
#' @export
Connection <- function(auth_key = character(),
                             server = character(),
                             retries = numeric(),
                             backoff_factor = numeric()) {
  result <- ConnectionRefClass$new(auth_key, server, retries, backoff_factor)
  return(result)
}

#' Basilica Connection
#'
#' Constructor for a Basilica connection. Connections are tied to a specific auth_key and other connection parameters.
#' @field auth_key Basilica API key
#' @field server Basilica server to point to (Default: `https://api.basilica.ai`)
#' @field retries Number of retries for any given request
#' @field backoff_factor How much to backoff
#' @name Connection_embed_sentence
#' @param sentence character blah blah blah
#' @param model character blah blah blah
#' @param version character blah blah blah
#' @param timeout numberic blah blah blah
#' @return data.table
ConnectionRefClass <- setRefClass(
  "ConnectionRefClass",
  fields = list(
    auth_key = "character",
    server = "character",
    retries = "numeric",
    backoff_factor = "numeric"
  ),
  methods = list(
    initialize = function(auth_key = character(),
                          server = character(),
                          retries = numeric(),
                          backoff_factor = numeric()) {
      .self$auth_key <- auth_key
      if (length(server) == 0) {
        .self$server <- "https://api.basilica.ai"
      } else {
        .self$server <- server
      }
      ## TODO: Add retires and backoff_factor
    },
    embed_image = function(image = character(),
                           model = "generic",
                           version = "default",
                           timeout = 5) {
      "Embed an image"
      response <-
        .self$embed_images(list(image),
                           model = model,
                           version = version,
                           timeout = timeout)
      result <- response[[1]]
    },
    embed_images = function(images = character(),
                            model = "generic",
                            version = "default",
                            timeout = 5) {
      "Embed a list of images"
      url <-
        paste(.self$server, "embed/images", model, version, sep = "/")
      data <- list()
      for (image in images) {
        f <- file(image, "rb")
        img <- readBin(f, "raw", file.info(image)[1, "size"])
        b64_image <- RCurl::base64Encode(img)
        data <- append(data, list(list(img = b64_image[1])))
      }
      result <- embed(auth_key, url, data, timeout)
    },
    embed_sentence = function(sentence = character(),
                              model = "english",
                              version = "default",
                              timeout = 5) {
      "Embed a single sentence"
      response <- .self$embed_sentences(
        list(sentence),
        model = model,
        version = version,
        timeout = timeout
      )
      result <- response[[1]]
    },
    embed_sentences = function(sentences = list(),
                               model = "english",
                               version = "default",
                               timeout = 5) {
      "Embed a list of sentences"
      url <-
        paste(.self$server, "embed/text", model, version, sep = "/")
      result <- embed(auth_key, url, sentences, timeout)
    }
  )
)

#' Find the indices of particles labeled as identified
#'
#' @name Connection_which_labeled
#' @param label one or more labels to search for
#' @return zero or more indices of labeled items
NULL
ConnectionRefClass$methods(
  which_labeled = function(label = 'none'){
    print(label)
    return(label)
  }
)

embed <- function(auth_key = character(),
                  url = character(),
                  data = list(),
                  timeout = 5) {
  authorization <- paste("Bearer", auth_key)
  response <- httr::POST(
    url,
    body = list(data = data),
    encode = "json",
    httr::add_headers(Authorization = authorization)
  )
  data <- httr::content(response)
  r <- list()
  for (i in seq_along(data$embeddings)) {
    r[[i]] <- unlist(data$embeddings[[i]])
  }
  result <- data.table::setDT(r)
  return(result)
}
