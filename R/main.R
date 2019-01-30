library(httr)
library(RCurl)

#' Basilica Connection
#'
#' Constructor for a Basilica connection. Connections are tied to a specific auth_key and other connection parameters.
#' @field auth_key Basilica API key
#' @field server Basilica server to point to (Default: `https://api.basilica.ai`)
#' @export
Connection <- setRefClass("Connection",
  fields = list(auth_key = "character", server="character", retries= "numeric", backoff_factor = "numeric"),

  methods = list(
    initialize = function(auth_key=character(), server=character(), retries=numeric(), backoff_factor=numeric()) {
      .self$auth_key = auth_key
      if (length(server) == 0) {
        .self$server = "https://api.basilica.ai"
      } else {
        .self$server = server
      }
      ## TODO: Add retires and backoff_factor
    },
    embed_image = function(image=character(), model="generic", version="default", timeout=5) {
      "Embed an image"
      response <- .self$embed_images(list(image), model=model, version=version, timeout=timeout)
      result <- response[[1]]
    },
    embed_images = function(images=character(), model="generic", version="default", timeout=5) {
      "Embed a list of images"
      url = paste(.self$server, "embed/images", model, version, sep="/")
      data = list()
      for (image in images){
        f = file(image, "rb")
        img = readBin(f, "raw", file.info(image)[1, "size"])
        b64_image <- RCurl::base64Encode(img)
        data <- append(data, list(list(img=b64_image[1])))
      }
      result <- .self$.embed(url, data, timeout)
    },
    embed_sentence = function(sentence=character(), model="english", version="default", timeout=5) {
      "Embed a single sentence"
      response <- .self$embed_sentences(list(sentence), model=model, version=version, timeout=timeout)
      result <- response[[1]]
    },
    embed_sentences = function(sentences=list(), model="english", version="default", timeout=5) {
      "Embed a list of sentences"
      url = paste(.self$server, "embed/text", model, version, sep="/")
      result <- .self$.embed(url, sentences, timeout)
    },
    .embed = function (url=character(), data=list(), timeout=5) {
      authorization = paste("Bearer", .self$auth_key)
      response <- httr::POST(url, body=list(data=data), encode="json", httr::add_headers(Authorization=authorization))
      data <- httr::content(response)
      r = list()
      for (i in seq_along(data$embeddings)) {
        r[[i]] = unlist(data$embeddings[[i]])
      }
      result <- data.frame(r)
    }
  )
)

#' createConnection
#'
#' Instantiates and returns a Basilica connection tied to a specific auth key and other connection parameters.
#' @param auth_key Basilica API key
#' @param server Basilica server to point to (Default: `https://api.basilica.ai`)
#' @export
createConnection <- function(auth_key=character(), server=character(), retries=numeric(), backoff_factor=numeric()) {
  result <- new("Connection", auth_key, server, retries, backoff_factor)
}
