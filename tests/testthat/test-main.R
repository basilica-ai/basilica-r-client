context("test-main")

AUTH_KEY <- '28c4dab5-27f1-52a7-508e-527dd234224c'
SERVER <- "http://api.localhost:8000"

CAT_PATH <- system.file("extdata", "cat.jpg", package="basilica")
CAT2_PATH <- system.file("extdata", "cat2.jpg", package="basilica")
DOG_PATH <- system.file("extdata", "dog.jpg", package="basilica")
# CAT_PATH_TOO_BIG <- '../../inst/extdata/cat-over-size-limit.jpg'

open_file <- function (path) {
  f <- file(path, 'rb')
  result <- readBin(path, "raw", file.info(path)[1, "size"])
  close(f)
  return(result)
}

describe("connect()", {
  it("should save the auth_key and server", {
      auth_key <- "WOW_KEY"
      server <- "http://api.localhost:8000"
      basilica::connect(auth_key, server)
      expect_equivalent(connection$auth_key, auth_key)
      expect_equivalent(connection$server, server)
  })
})

describe("embed_sentence", {
  describe("With Connection", {
    it("should stop if there is no connection", {
        rm("auth_key", envir = connection)
        expect_error(basilica::embed_sentence("hello"), "No basilica connection created. Call `basilica::connect` first.")
    })
  })

  describe("With Connection", {
    setup(basilica::connect(AUTH_KEY, SERVER))

    it("should return back a vector", {
        result <- basilica::embed_sentence("hello")
        expect_equal(typeof(result), "double")
        expect_equal(is.vector(result), TRUE)
        expect_equal(length(result), 512)
    })
  })
})

describe("embed_sentences", {
  describe("With Connection", {
    it("should stop if there is no connection", {
      rm("auth_key", envir = connection)
        expect_error(basilica::embed_sentences(c("hello")), "No basilica connection created. Call `basilica::connect` first.")
    })
  })

  describe("With Connection", {
    setup(basilica::connect(AUTH_KEY, SERVER), env = parent.frame())

    it("should return back a matrix when provided a c", {
        result <- basilica::embed_sentences(c("hello", "wow", "great"))
        expect_equal(typeof(result), "double")
        expect_equal(is.matrix(result), TRUE)
        expect_equal(dim(result), as.integer(c(3, 512)))
    })

    it("should return back a matrix when provided a list", {
        result <- basilica::embed_sentences(list("hello", "wow", "great"))
        expect_equal(typeof(result), "double")
        expect_equal(is.matrix(result), TRUE)
        expect_equal(dim(result), as.integer(c(3, 512)))
    })

    it("should return correct results", {
        sentences = list(
            "This is a sentence!",
            "This is a similar sentence!",
            "I don't think this sentence is very similar at all..."
        )
        result <- basilica::embed_sentences(sentences)
        expect_equal(typeof(result), "double")
        expect_equal(is.matrix(result), TRUE)
        expect_equal(dim(result), as.integer(c(3, 512)))
        c1 = cor(result[1,], result[2,])
        c2 = cor(result[1,], result[3,])
        expect_gt(c1, c2)
    })
  })
})

describe("embed_image_file", {
  describe("With Connection", {
    it("should stop if there is no connection", {
      rm("auth_key", envir = connection)
        expect_error(basilica::embed_image_file(CAT_PATH), "No basilica connection created. Call `basilica::connect` first.")
    })
  })

  describe("With Connection", {
    setup(basilica::connect(AUTH_KEY, SERVER), env = parent.frame())

    it("should return back a vector", {
        result <- basilica::embed_image_file(CAT_PATH)
        expect_equal(typeof(result), "double")
        expect_equal(is.vector(result), TRUE)
        expect_equal(length(result), 2048)
    })

    it("should throw an error if an non existent path is provided", {
        expect_error(basilica::embed_image_file("../../inst/extdata/image-doesnt-exist.jpg"), "*The specified file path*")
    })

    # it("should throw an error if the image is too big", {
        # expect_error(basilica::embed_image_file(CAT_PATH_TOO_BIG), "*The size of the specified file*")
    # })

    it("should return accurate results" ,{
        cat1 <- basilica::embed_image_file(CAT_PATH)
        cat2 <- basilica::embed_image_file(CAT2_PATH)
        dog <- basilica::embed_image_file(DOG_PATH)
        c1 = cor(cat1, cat2)
        c2 = cor(cat1, dog)
        expect_gt(c1, c2)
    })
  })
})

describe("embed_image_files", {
  describe("With Connection", {
    it("should stop if there is no connection", {
      rm("auth_key", envir = connection)
        expect_error(basilica::embed_image_files(CAT_PATH), "No basilica connection created. Call `basilica::connect` first.")
    })
  })

  describe("With Connection", {
    setup(basilica::connect(AUTH_KEY, SERVER), env = parent.frame())

    it("should return back a vector", {
        result <- basilica::embed_image_files(c(CAT_PATH, CAT2_PATH))
        expect_equal(typeof(result), "double")
        expect_equal(is.matrix(result), TRUE)
        expect_equal(is.vector(result[1,]), TRUE)
        expect_equal(dim(result), as.integer(c(2, 2048)))
    })

    it("should throw an error if a non existent path is provided", {
        expect_error(basilica::embed_image_files(c(CAT_PATH, "../../data/image-doesnt-exist.jpg")), "*The specified file path*")
    })

    # it("should throw an error if the image is too big", {
        # expect_error(basilica::embed_image_files(c(CAT2_PATH, CAT_PATH_TOO_BIG)), "*The size of the specified file*")
    # })

    it("should return accurate results" ,{
        result <- basilica::embed_image_files(c(CAT_PATH, CAT2_PATH, DOG_PATH))
        c1 = cor(result[1,], result[2,])
        c2 = cor(result[1,], result[3,])
        expect_gt(c1, c2)
    })
  })
})

describe("embed_image", {
  describe("With Connection", {
    it("should stop if there is no connection", {
      rm("auth_key", envir = connection)
      expect_error(basilica::embed_image(open_file(CAT_PATH)), "No basilica connection created. Call `basilica::connect` first.")
    })
  })

  describe("With Connection", {
    setup(basilica::connect(AUTH_KEY, SERVER), env = parent.frame())

    it("should return back a vector", {
        result <- basilica::embed_image(open_file(CAT_PATH))
        expect_equal(typeof(result), "double")
        expect_equal(is.vector(result), TRUE)
        expect_equal(length(result), 2048)
    })

    it("should throw an error if a value that is not of type `raw` is passed", {
        expect_error(basilica::embed_image("asdfasdfsd"), "*The provided `image` is not of type `raw`*")
    })

    # it("should throw an error if the image is too big", {
        # expect_error(basilica::embed_image(open_file(CAT_PATH_TOO_BIG)), "*The size of one of the values in `images`*")
    # })

    it("should return accurate results" ,{
        cat1 <- basilica::embed_image(open_file(CAT_PATH))
        cat2 <- basilica::embed_image(open_file(CAT2_PATH))
        dog <- basilica::embed_image(open_file(DOG_PATH))
        c1 = cor(cat1, cat2)
        c2 = cor(cat1, dog)
        expect_gt(c1, c2)
    })
  })
})

describe("embed_images", {
  describe("With Connection", {
    it("should stop if there is no connection", {
      rm("auth_key", envir = connection)
      expect_error(basilica::embed_images(open_file(CAT_PATH)), "No basilica connection created. Call `basilica::connect` first.")
    })
  })

  describe("With Connection", {
    setup(basilica::connect(AUTH_KEY, SERVER), env = parent.frame())

    it("should return back a vector", {
        result <- basilica::embed_images(list(open_file(CAT_PATH), open_file(CAT2_PATH)))
        expect_equal(typeof(result), "double")
        expect_equal(is.matrix(result), TRUE)
        expect_equal(is.vector(result[1,]), TRUE)
        expect_equal(dim(result), as.integer(c(2, 2048)))
    })

    it("should throw an error if a value that is not of type `raw` is passed", {
        expect_error(basilica::embed_images(list(open_file(CAT_PATH), "asdfasdfsd")), "*One of the values in `images` is not of type `raw`*")
    })

    # it("should throw an error if the image is too big", {
        # files = list(open_file(CAT2_PATH), open_file(CAT_PATH_TOO_BIG))
        # expect_error(basilica::embed_images(files), "*The size of one of the values in `images`*")
    # })

    it("should return accurate results" ,{
        result <- basilica::embed_images(list(open_file(CAT_PATH), open_file(CAT2_PATH), open_file(DOG_PATH)))
        c1 = cor(result[1,], result[2,])
        c2 = cor(result[1,], result[3,])
        expect_gt(c1, c2)
    })
  })
})
