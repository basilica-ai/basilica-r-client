.. _quickstart:

Quickstart
==========

Install the R client
^^^^^^^^^^^^^^^^^^^^^^^^^

First, install the R client.

.. code-block:: bash

   install.packages("https://storage.googleapis.com/basilica-r-client/basilica_0.0.1.tar.gz", repos=NULL)

Embed some sentences
^^^^^^^^^^^^^^^^^^^^

Let's embed some sentences to make sure the client is working.

.. code-block:: R

   library('basilica')
   conn <- connect("SLOW_DEMO_KEY")

   sentences = c(
       "This is a sentence!",
       "This is a similar sentence!",
       "I don't think this sentence is very similar at all..."
   )
   embeddings <- embed_sentences(sentences, conn=conn)
   print(embeddings)

::

   [[0.8556405305862427, ...], ...]

Let's also make sure these embeddings make sense, by checking that the
cosine distance between the two similar sentences is smaller:

.. code-block:: R

   print(cor(embeddings[1,], embeddings[2,]))
   print(cor(embeddings[1,], embeddings[3,]))

::

   0.8048559
   0.6877435

Great!

Get an API key
^^^^^^^^^^^^^^

The example above uses the slow demo key.  You can get an API key of
your own by signing up at https://www.basilica.ai/accounts/register .
(If you already have an account, you can view your API keys at
https://www.basilica.ai/api-keys .)

What next?
^^^^^^^^^^

* Read the documentation for the client: :ref:`basilica`
* See an in-depth tutorial on training an image model: `How To Train
  An Image Model With Basilica
  <https://www.basilica.ai/tutorials/how-to-train-an-image-model/>`_
