library(httr)
library(RCurl)
library(data.table)

#' connect
#'
#' Instantiates and returns a Basilica connection tied to a specific auth key and other connection parameters.
#' @param auth_key Basilica API key
#' @param server Basilica server to point to (Default: `https://api.basilica.ai`)
#' @param retries Number of retries for any given request
#' @param backoff_factor How much to backoff
#' @export
connect <- function(auth_key = character(),
                             server = character(),
                             retries = numeric(),
                             backoff_factor = numeric()) {
  c<- list()
  c$auth_key <- auth_key
  if (length(server) == 0) {
    c$server <- "https://api.basilica.ai"
  } else {
    c$server <- server
  }
  ## TODO: Add retires and backoff_factor
  c$retries <- retries
  c$backoff_factor <- backoff_factor
  connection <<- c
}

#' embed_image
#'
#' Get a vector of features for an image
#' @param image Path to an image (JPEG or PNG)
#' @param model Name of the image model you wish to use. (Default: `generic`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_image <- function(image = character(),
                           model = "generic",
                           version = "default",
                           timeout = 5) {
  if (is.null(connection)) {
    stop("No basilica connection created. Call `basilica::connect` first.")
  }
  response <- embed_images(list(image),
                     model = model,
                     version = version,
                     timeout = timeout)
  result <- response[[1]]
  return(result)
}

#' embed_images
#'
#' Get a vector of features for a list images
#' @param images List of file path to images (JPEG or PNG)
#' @param model Name of the image model you wish to use. (Default: `generic`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_images <- function(images = character(),
                            model = "generic",
                            version = "default",
                            timeout = 5) {
  if (is.null(connection)) {
    stop("No basilica connection created. Call `basilica::connect` first.")
  }
  url <- paste(connection$server, "embed/images", model, version, sep = "/")
  data <- list()
  for (image in images) {
    f <- file(image, "rb")
    img <- readBin(f, "raw", file.info(image)[1, "size"])
    b64_image <- RCurl::base64Encode(img)
    data <- append(data, list(list(img = b64_image[1])))
  }
  result <- embed(connection$auth_key, url, data, timeout)
  return(result)
}

#' embed_sentence
#'
#' Get a vector of features for a sentence
#' @param sentence Sentence or string
#' @param model Name of the image model you wish to use. (Default: `english`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_sentence <- function(sentence = character(),
                              model = "english",
                              version = "default",
                              timeout = 5) {
  if (is.null(connection)) {
    stop("No basilica connection created. Call `basilica::connect` first.")
  }
  response <- embed_sentences(
      list(sentence),
    model = model,
    version = version,
    timeout = timeout
  )
  result <- response[[1]]
  return(result)
}

#' embed_sentences
#'
#' Get a vector of features for a list of sentences
#' @param sentences List of sentences or strings
#' @param model Name of the image model you wish to use. (Default: `english`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_sentences = function(sentences = list(),
                               model = "english",
                               version = "default",
                               timeout = 5) {
  if (is.null(connection)) {
    stop("No basilica connection created. Call `basilica::connect` first.")
  }
  url <- paste(connection$server, "embed/text", model, version, sep = "/")
  result <- embed(connection$auth_key, url, sentences, timeout)
  return(result)
}

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
  result <- do.call(rbind,r)
  return(result)
}
