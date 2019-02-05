library(httr)
library(RCurl)

FILE_SIZE_LIMT <- 2097152

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
embed_image <- function(image = raw(),
                           model = "generic",
                           version = "default",
                           timeout = 5) {
  if (is.null(connection)) {
    stop("No basilica connection created. Call `basilica::connect` first.")
  }
  if (!is.raw(image)) {
    msg <- paste("The provided `image` is not of type `raw` (got `", typeof(image),"`)")
    stop(msg)
  }
  response <- embed_images(list(image),
                     model = model,
                     version = version,
                     timeout = timeout)
  result <- response[1,]
  return(result)
}

#' embed_images
#'
#' Get a vector of features for a list images
#' @param images List of 
#' @param model Name of the image model you wish to use. (Default: `generic`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_images <- function(images = list(),
                            model = "generic",
                            version = "default",
                            timeout = 5) {
  if (is.null(connection)) {
    stop("No basilica connection created. Call `basilica::connect` first.")
  }
  url <- paste(connection$server, "embed/images", model, version, sep = "/")
  if (!is.list(images)) {
      stop(paste("`images` must be a list raw vectors (got `", typeof(images),"`)"))
  }
  data = list()
  for (image in images) {
    if (!is.raw(image)) {
      msg <- paste("One of the values in `images` is not of type `raw` (got `", typeof(image),"`)")
      stop(msg)
    }
    if (length(image) > FILE_SIZE_LIMT) {
      stop(paste("The size of one of the values in `images` (",length(image),") exceeds the allowed limit (",FILE_SIZE_LIMT,")."))
    }
    b64_image <- RCurl::base64Encode(image)
    data <- append(data, list(list(img = b64_image[1])))
  }
  result <- embed(connection$auth_key, url, data, timeout)
  return(result)
}

#' embed_image_file
#'
#' Get a vector of features for an image
#' @param image Path to an image (JPEG or PNG)
#' @param model Name of the image model you wish to use. (Default: `generic`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_image_file <- function(image_path = character(),
                           model = "generic",
                           version = "default",
                           timeout = 5) {
  if (is.null(connection)) {
    stop("No basilica connection created. Call `basilica::connect` first.")
  }
  response <- embed_image_files(image_paths = list(image_path),
                     model = model,
                     version = version,
                     timeout = timeout)
  result <- response[1,]
  return(result)
}

#' embed_image_files
#'
#' Get a vector of features for a list images
#' @param image_paths List of file path to images (JPEG or PNG)
#' @param model Name of the image model you wish to use. (Default: `generic`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_image_files <- function(image_paths = list(),
                            model = "generic",
                            version = "default",
                            timeout = 5) {
  if (is.null(connection)) {
    stop("No basilica connection created. Call `basilica::connect` first.")
  }
  data <- list()
  for (image in image_paths) {
    if (!file.exists(image)) {
      stop(paste("The specified file path (",image,") doesn't exist."))
    }
    if (file.size(image) > FILE_SIZE_LIMT) {
      stop(paste("The size of the specified file (",image,"/",file.size(image),") exceeds the allowed limit (",FILE_SIZE_LIMT,")."))
    }
    f <- file(image, "rb")
    data <- append(data, list(readBin(f, "raw", file.info(image)[1, "size"])))
    close(f)
  }
  result <- embed_images(images = data,
                     model = model,
                     version = version,
                     timeout = timeout)
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
  result <- response[1,]
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
    httr::add_headers(Authorization = authorization),
    httr::timeout(5)
  )
  code <- httr::status_code(response)
  data <- httr::content(response)
  if (code != 200) {
    stop(paste("Error while making request: ", data$error))
  }
  r <- list()
  for (i in seq_along(data$embeddings)) {
    r[[i]] <- unlist(data$embeddings[[i]])
  }
  result <- do.call(rbind,r)
  return(result)
}
