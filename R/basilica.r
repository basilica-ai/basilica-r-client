library(httr)
library(RCurl)

FILE_SIZE_LIMT <- 2097152
USER_AGENT <- paste("Basilica R Client (", packageVersion("basilica") ,")")

basilica_connection <- new.env()
basilica_connection$name <- "basilica-env"

#' connect
#'
#' Instantiates and returns a Basilica connection tied to a specific auth key and server. It also populates a global `basilica_connection` that is a copy of the returned connection. If a `conn` argument is not passed to an `embed_*` function, this global connection will be used.
#' @param auth_key Basilica API key
#' @param server Basilica server to point to (Default: `https://api.basilica.ai`)
#' @return environment
#' @export
#' @examples
#' conn <- connect("SLOW_DEMO_KEY") # Create a connection to pass to functions
#' embeddings <- embed_sentences(c("hello world"), conn=conn)
#'
#' connect("SLOW_DEMO_KEY") # Populate the global connection
#' embeddings <- embed_sentences(c("hello world"))
#' embeddings <- embed_sentences(c("hello world")) # Will both use the same global connection
connect <- function(auth_key = character(),
                    server = character()) {
  if (length(auth_key) == 0 || nchar(auth_key) == 0) {
    stop("An `auth_key` must be provided.")
  }
  basilica_connection$auth_key <- auth_key
  if (length(server) == 0 || nchar(server) == 0) {
    basilica_connection$server <- "https://api.basilica.ai"
  } else {
    basilica_connection$server <- server
  }
  result <- as.environment(as.list(basilica_connection, all.names=TRUE))
  return(result)
}

get_connection <- function(conn = environment()) {
  if (is.environment(conn) && !is.null(conn$auth_key)) {
    return(conn)
  }
  if (!exists("auth_key", envir = basilica_connection)) {
    stop("No basilica connection created or invalid connection passed. Be sure to create a connection with `basilica::connect`.")
    return()
  }
  return(basilica_connection)
}

#' embed_sentence
#'
#' Get a vector of features for a sentence
#' @param sentence Sentence or string
#' @param model Name of the image model you wish to use. (Default: `english`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param conn Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_sentence <- function(sentence = character(),
                           model = "english",
                           version = "default",
                           conn = environment(),
                           timeout = 5) {
  response <- embed_sentences(
    list(sentence),
    model = model,
    version = version,
    conn = conn,
    timeout = timeout
  )
  result <- response[1, ]
  return(result)
}

#' embed_sentences
#'
#' Get a vector of features for a list of sentences
#' @param sentences List of sentences or strings
#' @param model Name of the image model you wish to use. (Default: `english`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param conn Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_sentences = function(sentences = list(),
                           model = "english",
                           version = "default",
                           conn = environment(),
                           timeout = 5) {
  conn <- get_connection(conn)
  url <-
    paste(conn$server, "embed/text", model, version, sep = "/")
  result <- embed(conn$auth_key, url, sentences, timeout)
  return(result)
}



#' embed_image
#'
#' Get a vector of features for an image
#' @param image Raw vector read from image file (JPEG or PNG)
#' @param model Name of the image model you wish to use. (Default: `generic`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param conn Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_image <- function(image = raw(),
                        model = "generic",
                        version = "default",
                        conn = environment(),
                        timeout = 5) {
  if (!is.raw(image)) {
    msg <-
      paste("The provided `image` is not of type `raw` (got `",
            typeof(image),
            "`)")
    stop(msg)
  }
  response <- embed_images(list(image),
                           model = model,
                           version = version,
                           conn = conn,
                           timeout = timeout)
  result <- response[1, ]
  return(result)
}

#' embed_images
#'
#' Get a vector of features for a list images
#' @param images List of raw vectors read from image files (JPEG or PNG)
#' @param model Name of the image model you wish to use. (Default: `generic`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param conn Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_images <- function(images = list(),
                         model = "generic",
                         version = "default",
                         conn = environment(),
                         timeout = 5) {
  conn <- get_connection(conn)
  url <-
    paste(conn$server, "embed/images", model, version, sep = "/")
  if (!is.list(images)) {
    stop(paste(
      "`images` must be a list raw vectors (got `",
      typeof(images),
      "`)"
    ))
  }
  data <- list()
  for (image in images) {
    if (!is.raw(image)) {
      msg <-
        paste("One of the values in `images` is not of type `raw` (got `",
              typeof(image),
              "`)")
      stop(msg)
    }
    if (length(image) > FILE_SIZE_LIMT) {
      stop(
        paste(
          "The size of one of the values in `images` (",
          length(image),
          ") exceeds the allowed limit (",
          FILE_SIZE_LIMT,
          ")."
        )
      )
    }
    b64_image <- RCurl::base64Encode(image)
    data <- append(data, list(list(img = b64_image[1])))
  }
  result <- embed(conn$auth_key, url, data, timeout)
  return(result)
}

#' embed_image_file
#'
#' Get a vector of features for an image
#' @param image_path Path to an image (JPEG or PNG)
#' @param model Name of the image model you wish to use. (Default: `generic`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param conn Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_image_file <- function(image_path = character(),
                             model = "generic",
                             version = "default",
                             conn = environment(),
                             timeout = 5) {
  get_connection(conn)
  response <- embed_image_files(
    image_paths = list(image_path),
    model = model,
    version = version,
    conn = conn,
    timeout = timeout
  )
  result <- response[1, ]
  return(result)
}

#' embed_image_files
#'
#' Get a vector of features for a list images
#' @param image_paths List of file path to images (JPEG or PNG)
#' @param model Name of the image model you wish to use. (Default: `generic`)
#' @param version Version of the image model you wish to use. (Default: `default`)
#' @param conn Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
#' @param timeout Time (in seconds) before requests times out. (Default `5`)
#' @return matrix
#' @export
embed_image_files <- function(image_paths = list(),
                              model = "generic",
                              version = "default",
                              conn = environment(),
                              timeout = 5) {
  conn <- get_connection(conn)
  data <- list()
  for (image in image_paths) {
    if (!file.exists(image)) {
      stop(paste("The specified file path (", image, ") doesn't exist."))
    }
    if (file.size(image) > FILE_SIZE_LIMT) {
      stop(
        paste(
          "The size of the specified file (",
          image,
          "/",
          file.size(image),
          ") exceeds the allowed limit (",
          FILE_SIZE_LIMT,
          ")."
        )
      )
    }
    f <- file(image, "rb")
    data <-
      append(data, list(readBin(f, "raw", file.info(image)[1, "size"])))
    close(f)
  }
  result <- embed_images(
    images = data,
    model = model,
    version = version,
    conn = conn,
    timeout = timeout
  )
  return(result)
}

embed <- function(auth_key = character(),
                  url = character(),
                  data = list(),
                  timeout = 5) {
  if (nchar(auth_key) == 0) {
    stop("The provided connection does not have an `auth_key`.")
  }
  authorization <- paste("Bearer", auth_key)
  response <- httr::POST(
    url,
    body = list(data = as.list(data)),
    encode = "json",
    httr::add_headers(Authorization = authorization, "User-Agent" = USER_AGENT),
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
  result <- do.call(rbind, r)
  return(result)
}

#' Basilica
#'
#' @section Creating an API key:
#'
#' You can use basilica with our "SLOW_DEMO_KEY", which is an evaluation key with
#' a limit of 5,000 requests per week per IP address. You can create an API key
#' for free at www.basilica.ai, which will give you more requests.
#'
#' @section How many data points do I need?:
#'
#' For training your own models with embeddings provided by Basilica, you should
#' have around 1,000 data points. The more data points the better though. Some
#' models might have good results with less data, while others might need more.
#'
#' @section What do these features mean?:
#'
#' The features provided by Basilica are points in high-dimensional space where
#' two points that are considered similar. These embeddings are trained through
#' deep neural networks trained on a variety of tasks with millions of data
#' points. Go to https://www.basilica.ai/available-embeddings/ to read more about
#' our different embeddings.
#' @examples
#' library(basilica)
#' conn <- connect("SLOW_DEMO_KEY")
#'
#' sentences <- c(
#'    "This is a sentence!",
#'    "This is a similar sentence!",
#'    "I don't think this sentence is very similar at all..."
#' )
#'
#' embeddings <- embed_sentences(sentences, conn=conn)
#' print(dim(embeddings)) # 3 512
#' print(embeddings) # [[0.8556405305862427, ...], ...]
#'
#' print(cor(embeddings[1,], embeddings[2,])) # 0.8048559
#' print(cor(embeddings[1,], embeddings[3,])) # 0.6877435
#'
#' @docType package
#' @name basilica
"_PACKAGE"
