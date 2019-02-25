def connect(auth_key, server):
    """Instantiates and returns a Basilica connection tied to a specific auth key and server. It also populates a global `basilica_connection` that is a copy of the returned connection. If a `conn` argument is not passed to an `embed_*` function, this global connection will be used.

    :param auth_key: Basilica API key.  You can view your auth keys at https://basilica.ai/auth_keys.
    :type auth_key: str
    :param server: Basilica server to point to (Default: `https://api.basilica.ai`)
    :type server: str

    >>> conn <- connect("SLOW_DEMO_KEY") # Create a connection to pass to functions
    embeddings <- embed_sentences(c("hello world"), conn=conn)

    >>> connect("SLOW_DEMO_KEY") # Populate the global connection
    embeddings <- embed_sentences(c("hello world"))
    embeddings <- embed_sentences(c("hello world")) # Will both use the sameglobal connection
    """
    pass


def embed_sentence(sentence, model, version, conn, timeout):
    """Get a vector of features for a sentence

    :param sentence: Sentence or string
    :type server: character()
    :param model: Name of the image model you wish to use. (Default: `english`)
    :type model: character()
    :param version: Version of the image model you wish to use. (Default: `default`)
    :type version: character()
    :param conn: Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
    :type conn: environment()
    :param timeout: Time (in seconds) before requests times out. (Default `5`)
    :type timeout: number()
    :returns: An embedding.
    :rtype: Matrix
    """
    pass

def embed_sentences(sentences, model, version, conn, timeout):
    """Get a vector of features for a list of sentences

    :param sentence: Sentence or string
    :type server: list()
    :param model: Name of the image model you wish to use. (Default: `english`)
    :type model: character()
    :param version: Version of the image model you wish to use. (Default: `default`)
    :type version: character()
    :param conn: Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
    :type conn: environment()
    :param timeout: Time (in seconds) before requests times out. (Default `5`)
    :type timeout: number()
    :returns: An embedding.
    :rtype: Matrix
    """
    pass

def embed_image(image, model, version, conn, timeout):
    """Get a vector of features for an image

    :param image: Raw vector read from image file (JPEG or PNG)
    :type image: raw()
    :param model: Name of the image model you wish to use. (Default: `generic`)
    :type model: character()
    :param version: Version of the image model you wish to use. (Default: `default`)
    :type version: character()
    :param conn: Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
    :type conn: environment()
    :param timeout: Time (in seconds) before requests times out. (Default `5`)
    :type timeout: number()
    :returns: An embedding.
    :rtype: Matrix
    """
    pass

def embed_images(images, model, version, conn, timeout):
    """Get a vector of features for a list images

    :param images: List of raw vectors read from image files (JPEG or PNG)
    :type images: list()
    :param model: Name of the image model you wish to use. (Default: `generic`)
    :type model: character()
    :param version: Version of the image model you wish to use. (Default: `default`)
    :type version: character()
    :param conn: Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
    :type conn: environment()
    :param timeout: Time (in seconds) before requests times out. (Default `5`)
    :type timeout: number()
    :returns: An embedding.
    :rtype: Matrix
    """
    pass

def embed_images(images, model, version, conn, timeout):
    """Get a vector of features for a list images

    :param images: List of raw vectors read from image files (JPEG or PNG)
    :type images: list()
    :param model: Name of the image model you wish to use. (Default: `generic`)
    :type model: character()
    :param version: Version of the image model you wish to use. (Default: `default`)
    :type version: character()
    :param conn: Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
    :type conn: environment()
    :param timeout: Time (in seconds) before requests times out. (Default `5`)
    :type timeout: number()
    :returns: An embedding.
    :rtype: Matrix
    """
    pass

def embed_image_file(image_path, model, version, conn, timeout):
    """Get a vector of features for an image

    :param image_path: Path to an image (JPEG or PNG)
    :type images: character()
    :param model: Name of the image model you wish to use. (Default: `generic`)
    :type model: character()
    :param version: Version of the image model you wish to use. (Default: `default`)
    :type version: character()
    :param conn: Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
    :type conn: environment()
    :param timeout: Time (in seconds) before requests times out. (Default `5`)
    :type timeout: number()
    :returns: An embedding.
    :rtype: Matrix
    """
    pass

def embed_image_files(image_paths, model, version, conn, timeout):
    """Get a vector of features for a list images

    :param image_paths: List of file paths to images (JPEG or PNG)
    :type images: list()
    :param model: Name of the image model you wish to use. (Default: `generic`)
    :type model: character()
    :param version: Version of the image model you wish to use. (Default: `default`)
    :type version: character()
    :param conn: Basilica connection. Must be created with the `connect` function (Default: Global `basilica_connection`)
    :type conn: environment()
    :param timeout: Time (in seconds) before requests times out. (Default `5`)
    :type timeout: number()
    :returns: An embedding.
    :rtype: Matrix
    """
    pass

