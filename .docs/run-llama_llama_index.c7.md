TITLE: Querying Data with LlamaIndex 5-Line Quickstart
DESCRIPTION: This Python snippet demonstrates the LlamaIndex 5-line quickstart for ingesting and querying data. It loads documents from a 'data' directory, creates a vector store index, initializes a query engine, and then queries the indexed data, printing the response. This example showcases the high-level API for rapid prototyping.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/index.md#_snippet_1

LANGUAGE: python
CODE:
```
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

documents = SimpleDirectoryReader("data").load_data()
index = VectorStoreIndex.from_documents(documents)
query_engine = index.as_query_engine()
response = query_engine.query("Some question about the data should go here")
print(response)
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library - Python
DESCRIPTION: Installs the core `llama-index` library. This is essential for using LlamaIndex functionalities, especially when running in environments like Google Colab.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/data_connectors/NotionDemo.ipynb#_snippet_2

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Python Package
DESCRIPTION: Installs or upgrades the LlamaIndex library, a core dependency for building RAG applications, ensuring the latest features and bug fixes are available.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/workflow/rag.ipynb#_snippet_0

LANGUAGE: python
CODE:
```
!pip install -U llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library - Python
DESCRIPTION: This command installs the main `llama-index` library, which provides the core functionalities for data indexing, querying, and evaluation. It is a fundamental dependency for running any LlamaIndex-based application or notebook.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/evaluation/correctness_eval.ipynb#_snippet_1

LANGUAGE: Python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library
DESCRIPTION: Installs the main `llama-index` library, a core dependency for leveraging LlamaIndex functionalities. This step is particularly important for environments like Google Colab where the library might not be pre-installed.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/llm/xinference_local_deployment.ipynb#_snippet_2

LANGUAGE: bash
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library (Python)
DESCRIPTION: Installs the core `llama-index` library, which is essential for building and managing indexes, loading documents, and performing queries. This is a fundamental dependency for any LlamaIndex application.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/vector_stores/FaissIndexDemo.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library
DESCRIPTION: Installs the core `llama-index` library, which is essential for running LlamaIndex applications. This is a fundamental dependency for the examples provided.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/llm/litellm.ipynb#_snippet_1

LANGUAGE: Python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Quickstart Installation of LlamaIndex via Pip
DESCRIPTION: This command installs the default LlamaIndex starter bundle, which includes core components and common integrations like OpenAI LLMs and embeddings. It's the recommended way to quickly get started with LlamaIndex for most users.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/getting_started/installation.md#_snippet_0

LANGUAGE: bash
CODE:
```
pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library
DESCRIPTION: This Python command installs the core `llama-index` library, which is essential for building applications with LlamaIndex. It provides the foundational components for data indexing, querying, and interacting with various LLMs.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/llm/llamafile.ipynb#_snippet_2

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library (Python)
DESCRIPTION: Installs the core LlamaIndex library using pip. This is a fundamental dependency for any LlamaIndex application.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/vector_stores/TencentVectorDBIndexDemo.ipynb#_snippet_1

LANGUAGE: Python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library (Python)
DESCRIPTION: Installs the core `llama-index` library, which is a fundamental dependency for building applications with LlamaIndex. This package provides the base functionalities required for various LLM operations and data indexing.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/llm/yi.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Python Library
DESCRIPTION: This command installs the LlamaIndex Python library using pip, the standard package installer for Python. It is the first step to set up LlamaIndex in your development environment, enabling access to its high-level and low-level APIs.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/index.md#_snippet_0

LANGUAGE: bash
CODE:
```
pip install llama-index
```

----------------------------------------

TITLE: Building VectorStoreIndex from Documents (Python)
DESCRIPTION: Constructs a `VectorStoreIndex` from the loaded `documents`. This process involves embedding the document content into vector representations, which are then stored in the index for efficient semantic search and retrieval during query operations.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/vector_stores/SimpleIndexDemoLlama2.ipynb#_snippet_7

LANGUAGE: Python
CODE:
```
index = VectorStoreIndex.from_documents(documents)
```

----------------------------------------

TITLE: Complete RAG Application with ASI and OpenAI Embeddings (Python)
DESCRIPTION: This comprehensive example illustrates how to build a Retrieval Augmented Generation (RAG) application using ASI as the Large Language Model (LLM) and OpenAI for embeddings within LlamaIndex. It covers loading documents, parsing them into nodes, creating an embedding model, initializing the ASI LLM, building a vector store index, and performing a streaming query. This setup highlights ASI's flexibility as a drop-in replacement for other LLMs in a RAG pipeline.
SOURCE: https://github.com/run-llama/llama_index/blob/main/llama-index-integrations/llms/llama-index-llms-asi/README.md#_snippet_6

LANGUAGE: python
CODE:
```
from llama_index.llms.asi import ASI
from llama_index.embeddings.openai import OpenAIEmbedding
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.core.node_parser import SentenceSplitter

# Load documents
documents = SimpleDirectoryReader("./data").load_data()

# Create parser
parser = SentenceSplitter(chunk_size=1024)

# Create embeddings model (still using OpenAI for embeddings)
embedding_model = OpenAIEmbedding(model="text-embedding-3-small")

# Create ASI LLM (instead of OpenAI)
llm = ASI(model="asi1-mini", api_key="your_asi_api_key")

# Create index
nodes = parser.get_nodes_from_documents(documents)
index = VectorStoreIndex(nodes, embed_model=embedding_model)

# Create query engine with ASI as the LLM
query_engine = index.as_query_engine(llm=llm)

# Query with streaming
response = query_engine.query(
    "What information is in these documents?", streaming=True
)

# Process streaming response
for token in response.response_gen:
    print(token, end="", flush=True)
```

----------------------------------------

TITLE: Defining a Modular RAG Workflow Class in LlamaIndex
DESCRIPTION: This snippet defines the `RAGWorkflow` class, inheriting from `Workflow`, which orchestrates a multi-step RAG process. It includes methods for document ingestion (`ingest`), information retrieval (`retrieve`), reranking of retrieved nodes (`rerank`), and synthesizing a final response (`synthesize`), utilizing LlamaIndex components like `SimpleDirectoryReader`, `VectorStoreIndex`, `LLMRerank`, and `CompactAndRefine`. Each method is decorated with `@step` and handles specific events and context.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/workflow/rag.ipynb#_snippet_7

LANGUAGE: python
CODE:
```
from llama_index.core import SimpleDirectoryReader, VectorStoreIndex
from llama_index.core.response_synthesizers import CompactAndRefine
from llama_index.core.postprocessor.llm_rerank import LLMRerank
from llama_index.core.workflow import (
    Context,
    Workflow,
    StartEvent,
    StopEvent,
    step,
)

from llama_index.llms.openai import OpenAI
from llama_index.embeddings.openai import OpenAIEmbedding


class RAGWorkflow(Workflow):
    @step
    async def ingest(self, ctx: Context, ev: StartEvent) -> StopEvent | None:
        """Entry point to ingest a document, triggered by a StartEvent with `dirname`."""
        dirname = ev.get("dirname")
        if not dirname:
            return None

        documents = SimpleDirectoryReader(dirname).load_data()
        index = VectorStoreIndex.from_documents(
            documents=documents,
            embed_model=OpenAIEmbedding(model_name="text-embedding-3-small"),
        )
        return StopEvent(result=index)

    @step
    async def retrieve(
        self, ctx: Context, ev: StartEvent
    ) -> RetrieverEvent | None:
        "Entry point for RAG, triggered by a StartEvent with `query`."
        query = ev.get("query")
        index = ev.get("index")

        if not query:
            return None

        print(f"Query the database with: {query}")

        # store the query in the global context
        await ctx.set("query", query)

        # get the index from the global context
        if index is None:
            print("Index is empty, load some documents before querying!")
            return None

        retriever = index.as_retriever(similarity_top_k=2)
        nodes = await retriever.aretrieve(query)
        print(f"Retrieved {len(nodes)} nodes.")
        return RetrieverEvent(nodes=nodes)

    @step
    async def rerank(self, ctx: Context, ev: RetrieverEvent) -> RerankEvent:
        # Rerank the nodes
        ranker = LLMRerank(
            choice_batch_size=5, top_n=3, llm=OpenAI(model="gpt-4o-mini")
        )
        print(await ctx.get("query", default=None), flush=True)
        new_nodes = ranker.postprocess_nodes(
            ev.nodes, query_str=await ctx.get("query", default=None)
        )
        print(f"Reranked nodes to {len(new_nodes)}")
        return RerankEvent(nodes=new_nodes)

    @step
    async def synthesize(self, ctx: Context, ev: RerankEvent) -> StopEvent:
        """Return a streaming response using reranked nodes."""
        llm = OpenAI(model="gpt-4o-mini")
        summarizer = CompactAndRefine(llm=llm, streaming=True, verbose=True)
        query = await ctx.get("query", default=None)

        response = await summarizer.asynthesize(query, nodes=ev.nodes)
        return StopEvent(result=response)
```

----------------------------------------

TITLE: Installing LlamaIndex Core Package (Python)
DESCRIPTION: Installs the core `llama-index` package using pip, which provides the fundamental components, including the `GuidelineEvaluator`. This is a primary dependency for running the notebook's examples.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/evaluation/guideline_eval.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Core Package
DESCRIPTION: This Python command installs the core LlamaIndex library. It is a fundamental dependency for using any LlamaIndex components, including the LlamafileEmbedding class, to build applications with LLMs.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/embeddings/llamafile.ipynb#_snippet_2

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex in Python
DESCRIPTION: This snippet installs the LlamaIndex library using pip, which is a prerequisite for running the examples in this notebook, especially when using Google Colab.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/customization/prompts/chat_prompts.ipynb#_snippet_0

LANGUAGE: Python
CODE:
```
%pip install llama-index
```

----------------------------------------

TITLE: Importing LlamaIndex Core Modules - Python
DESCRIPTION: Imports essential classes and functions from LlamaIndex, including readers, storage contexts, various index types (VectorStoreIndex, SimpleKeywordTableIndex, SummaryIndex), OpenAI LLM, and utility functions for notebook display. These imports are foundational for building LlamaIndex applications.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/docstore/DynamoDBDocstoreDemo.ipynb#_snippet_4

LANGUAGE: python
CODE:
```
from llama_index.core import SimpleDirectoryReader, StorageContext
from llama_index.core import VectorStoreIndex, SimpleKeywordTableIndex
from llama_index.core import SummaryIndex
from llama_index.llms.openai import OpenAI
from llama_index.core.response.notebook_utils import display_response
from llama_index.core import Settings
```

----------------------------------------

TITLE: Initializing LlamaIndex Function Calling Agent with Tools (Python)
DESCRIPTION: This snippet demonstrates how to initialize a `FuncationCallingAgent` in LlamaIndex. It defines two simple Python functions (`add`, `multiply`) and converts them into `FunctionTool` instances. The agent is then configured with an OpenAI LLM, these tools, a timeout, and verbose logging, followed by an initial run.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/workflow/function_calling_agent.ipynb#_snippet_5

LANGUAGE: python
CODE:
```
from llama_index.core.tools import FunctionTool
from llama_index.llms.openai import OpenAI

def add(x: int, y: int) -> int:
    """Useful function to add two numbers."""
    return x + y

def multiply(x: int, y: int) -> int:
    """Useful function to multiply two numbers."""
    return x * y

tools = [
    FunctionTool.from_defaults(add),
    FunctionTool.from_defaults(multiply),
]

agent = FuncationCallingAgent(
    llm=OpenAI(model="gpt-4o-mini"), tools=tools, timeout=120, verbose=True
)

ret = await agent.run(input="Hello!")
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library with pip
DESCRIPTION: This command installs the core `llama-index` library using pip, which is the fundamental dependency for building and querying indexes. It's often used in environments like Google Colab or Jupyter notebooks to ensure the library is available.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/citation/pdf_page_reference.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing Core LlamaIndex Library
DESCRIPTION: Installs the main LlamaIndex library, which provides the core functionalities for building and querying knowledge-augmented LLM applications. This is a prerequisite for using any LlamaIndex features.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/customization/llms/AzureOpenAI.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Building a Vector Store Index with OpenAI (Python)
DESCRIPTION: This Python snippet demonstrates how to create a simple vector store index using LlamaIndex with OpenAI. It involves setting the OpenAI API key, loading documents from a specified directory using `SimpleDirectoryReader`, and then building the `VectorStoreIndex` from these documents.
SOURCE: https://github.com/run-llama/llama_index/blob/main/README.md#_snippet_2

LANGUAGE: python
CODE:
```
import os

os.environ["OPENAI_API_KEY"] = "YOUR_OPENAI_API_KEY"

from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

documents = SimpleDirectoryReader("YOUR_DATA_DIRECTORY").load_data()
index = VectorStoreIndex.from_documents(documents)
```

----------------------------------------

TITLE: Initializing OpenAI LLM and Creating LlamaIndex Vector Store
DESCRIPTION: This snippet initializes an OpenAI Large Language Model (LLM) with the 'gpt-4o' model. It then creates a `VectorStoreIndex` from the loaded documents, which involves embedding the document content. Finally, it configures a `query_engine` from this index, enabling semantic search and retrieval over the indexed data using the specified LLM.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/cookbooks/crewai_llamaindex.ipynb#_snippet_12

LANGUAGE: Python
CODE:
```
llm = OpenAI(model="gpt-4o")
index = VectorStoreIndex.from_documents(docs)
query_engine = index.as_query_engine(similarity_top_k=5, llm=llm)
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library - Python
DESCRIPTION: Installs the core `llama-index` library, which is essential for building and querying vector indexes.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/vector_stores/WeaviateIndexDemo-Hybrid.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Python Package
DESCRIPTION: Installs the `llama-index` Python package using pip, which includes the `llamaindex-cli` tool necessary for downloading LlamaPacks.
SOURCE: https://github.com/run-llama/llama_index/blob/main/llama-index-packs/llama-index-packs-streamlit-chatbot/README.md#_snippet_0

LANGUAGE: Bash
CODE:
```
pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library
DESCRIPTION: Installs the core `llama-index` library, which is a fundamental dependency for building and running LlamaIndex applications.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/output_parsing/guidance_sub_question.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library - Python
DESCRIPTION: This command installs the core `llama-index` library, which is essential for using any LlamaIndex functionalities, including chat engines and data indexing. It's a fundamental dependency for the examples in this notebook.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/chat_engine/chat_engine_repl.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Setting OpenAI API Key in Python
DESCRIPTION: This snippet sets the OpenAI API key as an environment variable. This is a prerequisite for using OpenAI models with LlamaIndex for tasks like embedding generation and response synthesis.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/node_postprocessor/RecencyPostprocessorDemo.ipynb#_snippet_0

LANGUAGE: python
CODE:
```
import os

os.environ["OPENAI_API_KEY"] = "sk-..."
```

----------------------------------------

TITLE: Setting OpenAI API Key Environment Variable
DESCRIPTION: Initializes a placeholder for the OpenAI API key and sets it as an environment variable, which is required for authenticating requests to the OpenAI API.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/node_postprocessor/rankGPT.ipynb#_snippet_3

LANGUAGE: python
CODE:
```
import os

OPENAI_API_KEY = "sk-"
os.environ["OPENAI_API_KEY"] = OPENAI_API_KEY
```

----------------------------------------

TITLE: Setting OpenAI API Key in Python
DESCRIPTION: Imports necessary modules (getpass, os, openai) and prompts the user to securely enter their OpenAI API key, which is then set as an environment variable and assigned to openai.api_key for authentication with the OpenAI service.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/vector_stores/ElasticsearchIndexDemo.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
import getpass
import os

import openai

os.environ["OPENAI_API_KEY"] = getpass.getpass("OpenAI API Key:")

openai.api_key = os.environ["OPENAI_API_KEY"]
```

----------------------------------------

TITLE: Installing LlamaIndex Core Package
DESCRIPTION: Installs the core `llama-index` library using pip, a fundamental prerequisite for building applications and interacting with various components within the LlamaIndex ecosystem.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/embeddings/upstage.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Downloading, Building RAG, and Evaluating with RagEvaluatorPack in Python
DESCRIPTION: This comprehensive Python snippet demonstrates how to programmatically download the 'CovidQaDataset', build a basic RAG (Retrieval Augmented Generation) system using `VectorStoreIndex`, and then evaluate its performance using the `RagEvaluatorPack`. It highlights parameters for API call batching and sleep times, crucial for managing OpenAI API usage tiers.
SOURCE: https://github.com/run-llama/llama_index/blob/main/llama-datasets/covidqa/README.md#_snippet_2

LANGUAGE: python
CODE:
```
from llama_index.core.llama_dataset import download_llama_dataset
from llama_index.core.llama_pack import download_llama_pack
from llama_index.core import VectorStoreIndex

# download and install dependencies for benchmark dataset
rag_dataset, documents = download_llama_dataset("CovidQaDataset", "./data")

# build basic RAG system
index = VectorStoreIndex.from_documents(documents=documents)
query_engine = index.as_query_engine()

# evaluate using the RagEvaluatorPack
RagEvaluatorPack = download_llama_pack(
    "RagEvaluatorPack", "./rag_evaluator_pack"
)
rag_evaluator_pack = RagEvaluatorPack(
    rag_dataset=rag_dataset, query_engine=query_engine, show_progress=True
)

############################################################################
# NOTE: If have a lower tier subscription for OpenAI API like Usage Tier 1 #
# then you'll need to use different batch_size and sleep_time_in_seconds.  #
# For Usage Tier 1, settings that seemed to work well were batch_size=5,   #
# and sleep_time_in_seconds=15 (as of December 2023.)                      #
############################################################################

benchmark_df = await rag_evaluator_pack.arun(
    batch_size=40,  # batches the number of openai api calls to make
    sleep_time_in_seconds=1  # seconds to sleep before making an api call
)
```

----------------------------------------

TITLE: Configuring LLM and Embedding Models (Python)
DESCRIPTION: This code initializes the OpenAI Large Language Model (LLM) and OpenAI Embedding model. It then sets these models globally within LlamaIndex's `Settings`, ensuring they are used by default for subsequent operations like indexing and querying.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/cookbooks/oreilly_course_cookbooks/Module-2/Components_Of_LlamaIndex.ipynb#_snippet_4

LANGUAGE: python
CODE:
```
from llama_index.embeddings.openai import OpenAIEmbedding
from llama_index.llms.openai import OpenAI
from llama_index.core import Settings

llm = OpenAI(model="gpt-3.5-turbo", temperature=0.2)
embed_model = OpenAIEmbedding()

Settings.llm = llm
Settings.embed_model = embed_model
```

----------------------------------------

TITLE: Install LlamaIndex Core Library (Python)
DESCRIPTION: Installs the main `llama-index` library, which provides the core functionalities for data indexing, retrieval, and chat engine creation. This is a fundamental prerequisite for any LlamaIndex project.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/chat_engine/chat_engine_context.ipynb#_snippet_1

LANGUAGE: Python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Constructing and Linking Query Pipeline Modules in LlamaIndex (Python)
DESCRIPTION: This code defines a LlamaIndex `QueryPipeline` by assembling various pre-defined modules, including input, query rewriting, LLM, multiple retrievers, an argument packing component (`argpack_component`), a reranker, and the custom `response_component`. It then establishes the data flow between these modules using `add_link`, demonstrating how to chain operations like query rewriting, parallel retrieval, node joining, reranking, and final response generation.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/pipeline/query_pipeline_memory.ipynb#_snippet_8

LANGUAGE: Python
CODE:
```
pipeline = QueryPipeline(
    modules={
        "input": input_component,
        "rewrite_template": rewrite_template,
        "llm": llm,
        "rewrite_retriever": retriever,
        "query_retriever": retriever,
        "join": argpack_component,
        "reranker": reranker,
        "response_component": response_component,
    },
    verbose=False,
)

# run both retrievers -- once with the hallucinated query, once with the real query
pipeline.add_link(
    "input", "rewrite_template", src_key="query_str", dest_key="query_str"
)
pipeline.add_link(
    "input",
    "rewrite_template",
    src_key="chat_history_str",
    dest_key="chat_history_str",
)
pipeline.add_link("rewrite_template", "llm")
pipeline.add_link("llm", "rewrite_retriever")
pipeline.add_link("input", "query_retriever", src_key="query_str")

# each input to the argpack component needs a dest key -- it can be anything
# then, the argpack component will pack all the inputs into a single list
pipeline.add_link("rewrite_retriever", "join", dest_key="rewrite_nodes")
pipeline.add_link("query_retriever", "join", dest_key="query_nodes")

# reranker needs the packed nodes and the query string
pipeline.add_link("join", "reranker", dest_key="nodes")
pipeline.add_link(
    "input", "reranker", src_key="query_str", dest_key="query_str"
)
```

----------------------------------------

TITLE: Setting Up Tools for MistralAI Function Calling
DESCRIPTION: This code defines two Python functions, `multiply` and `mystery`, and wraps them as `FunctionTool` objects for use with LlamaIndex. It then initializes the MistralAI LLM with the `mistral-large-latest` model, which natively supports function calling.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/llm/mistralai.ipynb#_snippet_7

LANGUAGE: Python
CODE:
```
from llama_index.llms.mistralai import MistralAI
from llama_index.core.tools import FunctionTool


def multiply(a: int, b: int) -> int:
    """Multiple two integers and returns the result integer"""
    return a * b


def mystery(a: int, b: int) -> int:
    """Mystery function on two integers."""
    return a * b + a + b


mystery_tool = FunctionTool.from_defaults(fn=mystery)
multiply_tool = FunctionTool.from_defaults(fn=multiply)

llm = MistralAI(model="mistral-large-latest")
```

----------------------------------------

TITLE: Setting Environment Variables for API Keys
DESCRIPTION: Sets environment variables for GitHub and OpenAI API keys. These keys are crucial for authenticating requests to their respective services, enabling data loading and LLM interactions.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/query_engine/multi_doc_auto_retrieval/multi_doc_auto_retrieval.ipynb#_snippet_3

LANGUAGE: python
CODE:
```
import os

os.environ["GITHUB_TOKEN"] = "ghp_..."
os.environ["OPENAI_API_KEY"] = "sk_..."
```

----------------------------------------

TITLE: Setting OpenAI and Pinecone API Keys (Python)
DESCRIPTION: This code sets the PINECONE_API_KEY and OPENAI_API_KEY environment variables, which are required for authenticating with the Pinecone vector database and OpenAI API respectively. Replace '...' with your actual API keys.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/agent/openai_agent_query_cookbook.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
import os

os.environ["PINECONE_API_KEY"] = "..."
os.environ["OPENAI_API_KEY"] = "..."
```

----------------------------------------

TITLE: Setting OpenAI API Key Environment Variable
DESCRIPTION: This snippet demonstrates how to set the OpenAI API key as an environment variable using Python's `os` module. This is a prerequisite for using OpenAI's models with LlamaIndex agents.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/tools/AgentQL_browser_agent.ipynb#_snippet_11

LANGUAGE: Python
CODE:
```
# set your openai key, if using openai
import os

os.environ["OPENAI_API_KEY"] = "YOUR_OPENAI_API_KEY"
```

----------------------------------------

TITLE: Importing LlamaIndex Components for RAG
DESCRIPTION: Imports essential LlamaIndex components required for building a Retrieval Augmented Generation (RAG) system. These include `VectorStoreIndex` for managing vector stores, `SimpleDirectoryReader` for loading documents, `resolve_embed_model` for embedding models, and `SentenceSplitter` for node parsing.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/llm/predibase.ipynb#_snippet_6

LANGUAGE: python
CODE:
```
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.core.embeddings import resolve_embed_model
from llama_index.core.node_parser import SentenceSplitter
```

----------------------------------------

TITLE: Installing LlamaIndex Core Library (Python)
DESCRIPTION: Installs the core `llama-index` library, which is essential for all LlamaIndex functionalities, including index creation, query engines, and data handling. This is a fundamental dependency for the project.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/vector_stores/chroma_auto_retriever.ipynb#_snippet_1

LANGUAGE: Python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Installing Required LlamaIndex and CrewAI Libraries
DESCRIPTION: This snippet installs all necessary Python packages for the project. It includes `llama-index-core` for core LlamaIndex functionalities, `llama-index-readers-file` for file reading, `llama-index-tools-wolfram-alpha` for Wolfram Alpha integration, and `crewai[tools]` to install CrewAI along with its tool-related dependencies.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/cookbooks/crewai_llamaindex.ipynb#_snippet_1

LANGUAGE: Python
CODE:
```
!pip install llama-index-core
!pip install llama-index-readers-file
!pip install llama-index-tools-wolfram-alpha
!pip install 'crewai[tools]'
```

----------------------------------------

TITLE: Initializing OpenAI LLM (Python)
DESCRIPTION: This code initializes an OpenAI Large Language Model (LLM) instance using `gpt-3.5-turbo`. This LLM will be used by the query engine for generating responses.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/vector_stores/MilvusAsyncAPIDemo.ipynb#_snippet_10

LANGUAGE: python
CODE:
```
from llama_index.llms.openai import OpenAI

llm = OpenAI(model="gpt-3.5-turbo")
```

----------------------------------------

TITLE: Configuring and Using OpenAI LLM in LlamaIndex
DESCRIPTION: This snippet demonstrates how to set OpenAI as the global default LLM in LlamaIndex settings, perform a local text completion using the OpenAI LLM, and integrate an LLM into query and chat engines for specific usage contexts. It showcases both global and local LLM configuration patterns.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/module_guides/models/llms.md#_snippet_1

LANGUAGE: Python
CODE:
```
from llama_index.core import Settings
from llama_index.llms.openai import OpenAI

# changing the global default
Settings.llm = OpenAI()

# local usage
resp = OpenAI().complete("Paul Graham is ")
print(resp)

# per-query/chat engine
query_engine = index.as_query_engine(..., llm=llm)
chat_engine = index.as_chat_engine(..., llm=llm)
```

----------------------------------------

TITLE: Querying LlamaIndex with Metadata Filters (Python)
DESCRIPTION: This snippet demonstrates how to configure a LlamaIndex retriever with advanced metadata filtering capabilities. It sets `similarity_top_k` to 3 and applies a complex set of filters using `MetadataFilters` with an 'and' condition, combining an `ExactMatchFilter` for `file_name` and `MetadataFilter` instances for `updated_at` (greater than or equal to a timestamp) and `text` (text match).
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/vector_stores/RedisIndexDemo.ipynb#_snippet_20

LANGUAGE: python
CODE:
```
from llama_index.core.vector_stores import (
    MetadataFilters,
    MetadataFilter,
    ExactMatchFilter,
)

retriever = index.as_retriever(
    similarity_top_k=3,
    filters=MetadataFilters(
        filters=[
            ExactMatchFilter(key="file_name", value="paul_graham_essay.txt"),
            MetadataFilter(
                key="updated_at",
                value=date_to_timestamp("2023-01-01"),
                operator=">=",
            ),
            MetadataFilter(
                key="text",
                value="learn",
                operator="text_match",
            )
        ],
        condition="and"
    )
)
```

----------------------------------------

TITLE: Setting Anthropic API Key Environment Variable
DESCRIPTION: This code sets the Anthropic API key as an environment variable, which is a common practice for securely providing credentials to applications. The LlamaIndex Anthropic LLM client will automatically pick up this key.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/llm/anthropic.ipynb#_snippet_2

LANGUAGE: python
CODE:
```
import os

os.environ["ANTHROPIC_API_KEY"] = "sk-..."
```

----------------------------------------

TITLE: Setting Netmind API Key Environment Variable (Python)
DESCRIPTION: This Python snippet demonstrates how to set your Netmind API key as an environment variable. This is a common and secure practice for authenticating API requests, preventing the key from being hardcoded directly in the application.
SOURCE: https://github.com/run-llama/llama_index/blob/main/llama-index-integrations/embeddings/llama-index-embeddings-netmind/README.md#_snippet_1

LANGUAGE: python
CODE:
```
import os

os.environ["NETMIND_API_KEY"] = "you_api_key"
```

----------------------------------------

TITLE: Querying Vector Index in LlamaIndex - Python
DESCRIPTION: This code initializes a query engine from a `vector_index` and performs a query to retrieve information based on semantic similarity. Vector indices are ideal for questions requiring deep contextual understanding and similarity-based retrieval.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/docstore/RedisDocstoreIndexStoreDemo.ipynb#_snippet_23

LANGUAGE: python
CODE:
```
query_engine = vector_index.as_query_engine()
vector_response = query_engine.query("What did the author do growing up?")
```

----------------------------------------

TITLE: Loading Documents and Creating Vector Store Index
DESCRIPTION: Loads documents from a specified file path using `SimpleDirectoryReader` and then creates a `VectorStoreIndex` from these documents. This index is crucial for efficient retrieval of relevant information during query processing.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/customization/llms/AzureOpenAI.ipynb#_snippet_5

LANGUAGE: python
CODE:
```
documents = SimpleDirectoryReader(
    input_files=["../../data/paul_graham/paul_graham_essay.txt"]
).load_data()
index = VectorStoreIndex.from_documents(documents)
```

----------------------------------------

TITLE: Defining DocsAssistantWorkflow for Multi-Branch Operations - Python
DESCRIPTION: This class defines a `DocsAssistantWorkflow` that acts as an intelligent documentation assistant. It uses an OpenAI LLM to evaluate incoming queries and decide on multiple concurrent actions, such as writing content from LlamaIndex or Weaviate URLs to respective document collections, or answering questions using a query agent. The `send_event` method is crucial for triggering multiple steps from a single evaluation.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/agent/multi_agent_workflow_with_weaviate_queryagent.ipynb#_snippet_24

LANGUAGE: python
CODE:
```
class ActionCompleted(Event):
    result: str


class DocsAssistantWorkflow(Workflow):
    def __init__(self, *args, **kwargs):
        self.llm = OpenAIResponses(model="gpt-4.1-mini")
        self.system_prompt = """You are a docs assistant. You evaluate incoming queries and break them down to subqueries when needed.
                      You decide on the next best course of action. Overall, here are the options:
                      - You can write the contents of a URL to llamaindex docs (if it's a llamaindex url)
                      - You can write the contents of a URL to weaviate docs (if it's a weaviate url)
                      - You can answer a question about llamaindex and weaviate using the QueryAgent"""
        super().__init__(*args, **kwargs)

    @step
    async def start(self, ctx: Context, ev: StartEvent) -> EvaluateQuery:
        return EvaluateQuery(query=ev.query)

    @step
    async def evaluate_query(
        self, ctx: Context, ev: EvaluateQuery
    ) -> QueryAgentEvent | WriteLlamaIndexDocsEvent | WriteWeaviateDocsEvent | None:
        await ctx.set("results", [])
        sllm = self.llm.as_structured_llm(Actions)
        response = await sllm.achat(
            [
                ChatMessage(role="system", content=self.system_prompt),
                ChatMessage(role="user", content=ev.query),
            ]
        )
        actions = response.raw.actions
        await ctx.set("num_events", len(actions))
        await ctx.set("results", [])
        print(actions)
        for action in actions:
            if isinstance(action, SaveToLlamaIndexDocs):
                ctx.send_event(
                    WriteLlamaIndexDocsEvent(urls=action.llama_index_urls)
                )
            elif isinstance(action, SaveToWeaviateDocs):
                ctx.send_event(
                    WriteWeaviateDocsEvent(urls=action.weaviate_urls)
                )
            elif isinstance(action, Ask):
                for query in action.queries:
                    ctx.send_event(QueryAgentEvent(query=query))

    @step
    async def write_li_docs(
        self, ctx: Context, ev: WriteLlamaIndexDocsEvent
    ) -> ActionCompleted:
        print(f"Writing {ev.urls} to LlamaIndex Docs")
        write_webpages_to_weaviate(
            client, urls=ev.urls, collection_name="LlamaIndexDocs"
        )
        results = await ctx.get("results")
        results.append(f"Wrote {ev.urls} it LlamaIndex Docs")
        return ActionCompleted(result=f"Writing {ev.urls} to LlamaIndex Docs")

    @step
    async def write_weaviate_docs(
        self, ctx: Context, ev: WriteWeaviateDocsEvent
    ) -> ActionCompleted:
        print(f"Writing {ev.urls} to Weaviate Docs")
        write_webpages_to_weaviate(
            client, urls=ev.urls, collection_name="WeaviateDocs"
        )
        results = await ctx.get("results")
        results.append(f"Wrote {ev.urls} it Weavite Docs")
        return ActionCompleted(result=f"Writing {ev.urls} to Weaviate Docs")

    @step
    async def query_agent(
        self, ctx: Context, ev: QueryAgentEvent
    ) -> ActionCompleted:
        print(f"Sending {ev.query} to agent")
        response = weaviate_agent.run(ev.query)
        results = await ctx.get("results")
        results.append(f"QueryAgent responded with:\n {response.final_answer}")
        return ActionCompleted(result=f"Sending `'" + ev.query + "`' to agent")

    @step
    async def collect(
        self, ctx: Context, ev: ActionCompleted
    ) -> StopEvent | None:
        num_events = await ctx.get("num_events")
        evs = ctx.collect_events(ev, [ActionCompleted] * num_events)
        if evs is None:
            return None
        return StopEvent(result=[ev.result for ev in evs])


everything_docs_agent = DocsAssistantWorkflow(timeout=None)
```

----------------------------------------

TITLE: Applying Nested Metadata Filters in LlamaIndex
DESCRIPTION: This snippet demonstrates how to apply complex, nested metadata filters in LlamaIndex, mirroring the SQL example. It combines a date range filter (AND condition) and an author filter (OR condition) using an outer 'and' condition, then retrieves nodes based on this intricate logic.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/vector_stores/postgres.ipynb#_snippet_29

LANGUAGE: python
CODE:
```
filters = MetadataFilters(
    filters=[
        MetadataFilters(
            filters=[
                MetadataFilter(
                    key="commit_date", value="2023-08-01", operator=">="
                ),
                MetadataFilter(
                    key="commit_date", value="2023-08-15", operator="<="
                )
            ],
            condition="and"
        ),
        MetadataFilters(
            filters=[
                MetadataFilter(key="author", value="mats@timescale.com"),
                MetadataFilter(key="author", value="sven@timescale.com")
            ],
            condition="or"
        )
    ],
    condition="and"
)

retriever = index.as_retriever(
    similarity_top_k=10,
    filters=filters,
)

retrieved_nodes = retriever.retrieve("What is this software project about?")

for node in retrieved_nodes:
    print(node.node.metadata)
```

----------------------------------------

TITLE: Parsing Documents into Nodes with SentenceSplitter
DESCRIPTION: This snippet uses `SentenceSplitter` from LlamaIndex to break down the loaded `documents` into smaller, manageable `nodes`. `SentenceSplitter` typically splits text based on sentence boundaries, which is a common preprocessing step for creating embeddings and improving retrieval accuracy in RAG applications.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/docstore/CloudSQLPgDocstoreDemo.ipynb#_snippet_11

LANGUAGE: Python
CODE:
```
from llama_index.core.node_parser import SentenceSplitter

nodes = SentenceSplitter().get_nodes_from_documents(documents)
```

----------------------------------------

TITLE: Initializing VectorStoreIndex with Documents in Python
DESCRIPTION: Demonstrates the simplest way to create a VectorStoreIndex by loading documents from a directory using `SimpleDirectoryReader` and then building the index directly from these documents. This method automatically handles document splitting and node creation.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/module_guides/indexing/vector_store_index.md#_snippet_0

LANGUAGE: python
CODE:
```
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

# Load documents and build index
documents = SimpleDirectoryReader(
    "../../examples/data/paul_graham"
).load_data()
index = VectorStoreIndex.from_documents(documents)
```

----------------------------------------

TITLE: Setting OpenAI API Key in Python
DESCRIPTION: This code sets the `OPENAI_API_KEY` environment variable, which is required for authenticating with the OpenAI API. The RAFT dataset creation process, specifically when using GPT-4, relies on this key for making API calls. Users must replace `<YOUR OPENAI API KEY>` with their actual key.
SOURCE: https://github.com/run-llama/llama_index/blob/main/llama-index-packs/llama-index-packs-raft-dataset/examples/raft_dataset.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
import os

os.environ["OPENAI_API_KEY"] = "<YOUR OPENAI API KEY>"
```

----------------------------------------

TITLE: Setting Perplexity API Key from Environment
DESCRIPTION: This Python snippet demonstrates how to securely set the Perplexity API key as an environment variable. It prompts the user for the key if it's not already present, ensuring sensitive information is not hardcoded.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/llm/perplexity.ipynb#_snippet_2

LANGUAGE: python
CODE:
```
import getpass
import os

if "PPLX_API_KEY" not in os.environ:
    os.environ["PPLX_API_KEY"] = getpass.getpass(
        "Enter your Perplexity API key: "
    )
```

----------------------------------------

TITLE: Building VectorStoreIndex and Query Engines for RAG (Python)
DESCRIPTION: Creates `VectorStoreIndex` instances from the loaded Uber and Lyft documents, then converts them into `QueryEngine`s with a specified `similarity_top_k`. These query engines enable retrieval-augmented generation on the financial data, allowing for semantic search.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/cookbooks/oreilly_course_cookbooks/Module-6/Agents.ipynb#_snippet_12

LANGUAGE: python
CODE:
```
from llama_index.core import VectorStoreIndex

uber_index = VectorStoreIndex.from_documents(uber_docs)
uber_query_engine = uber_index.as_query_engine(similarity_top_k=3)

lyft_index = VectorStoreIndex.from_documents(lyft_docs)
lyft_query_engine = lyft_index.as_query_engine(similarity_top_k=3)
```

----------------------------------------

TITLE: Setting OpenAI API Key Environment Variable
DESCRIPTION: Sets the `OPENAI_API_KEY` environment variable, which is required for LlamaIndex to authenticate with the OpenAI API for embedding and language model operations. Users must replace `<your openai key>` with their actual OpenAI API key.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/vector_stores/DocArrayInMemoryIndexDemo.ipynb#_snippet_3

LANGUAGE: python
CODE:
```
import os

os.environ["OPENAI_API_KEY"] = "<your openai key>"
```

----------------------------------------

TITLE: Linking Modules to Form a Full RAG Pipeline DAG in LlamaIndex
DESCRIPTION: Establishes explicit links between the previously added modules in the `QueryPipeline` to form a complete RAG DAG. It defines the flow from prompt generation to LLM, retrieval, reranking (with separate inputs for nodes and query string), and finally response synthesis, demonstrating complex data flow.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/pipeline/query_pipeline.ipynb#_snippet_24

LANGUAGE: python
CODE:
```
p.add_link("prompt_tmpl", "llm")
p.add_link("llm", "retriever")
p.add_link("retriever", "reranker", dest_key="nodes")
p.add_link("llm", "reranker", dest_key="query_str")
p.add_link("reranker", "summarizer", dest_key="nodes")
p.add_link("llm", "summarizer", dest_key="query_str")
```

----------------------------------------

TITLE: Defining Custom Query Engine Class - Python
DESCRIPTION: Defines the `MyQueryEngine` class, a custom query engine that encapsulates retrieval and hierarchical summarization logic. It includes an `__init__` method for configuration and both synchronous (`query`) and asynchronous (`aquery`) methods for executing queries, returning a `Response` object.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/low_level/response_synthesis.ipynb#_snippet_37

LANGUAGE: python
CODE:
```
from llama_index.core.retrievers import BaseRetriever
from llama_index.core.llms import LLM
from dataclasses import dataclass
from typing import Optional, List


@dataclass
class Response:
    response: str
    source_nodes: Optional[List] = None

    def __str__(self):
        return self.response


class MyQueryEngine:
    """My query engine.

    Uses the tree summarize response synthesis module by default.

    """

    def __init__(
        self,
        retriever: BaseRetriever,
        qa_prompt: PromptTemplate,
        llm: LLM,
        num_children=10,
    ) -> None:
        self._retriever = retriever
        self._qa_prompt = qa_prompt
        self._llm = llm
        self._num_children = num_children

    def query(self, query_str: str):
        retrieved_nodes = self._retriever.retrieve(query_str)
        response_txt, _ = generate_response_hs(
            retrieved_nodes,
            query_str,
            self._qa_prompt,
            self._llm,
            num_children=self._num_children,
        )
        response = Response(response_txt, source_nodes=retrieved_nodes)
        return response

    async def aquery(self, query_str: str):
        retrieved_nodes = await self._retriever.aretrieve(query_str)
        response_txt, _ = await agenerate_response_hs(
            retrieved_nodes,
            query_str,
            self._qa_prompt,
            self._llm,
            num_children=self._num_children,
        )
        response = Response(response_txt, source_nodes=retrieved_nodes)
        return response
```

----------------------------------------

TITLE: Loading Documents and Building Vector Index (Python)
DESCRIPTION: Loads documents from the specified directory using `SimpleDirectoryReader` and then constructs a `VectorStoreIndex` from these documents, preparing them for similarity search.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/node_postprocessor/ColbertRerank.ipynb#_snippet_4

LANGUAGE: python
CODE:
```
documents = SimpleDirectoryReader("./data/paul_graham/").load_data()

# build index
index = VectorStoreIndex.from_documents(documents=documents)
```

----------------------------------------

TITLE: Installing LlamaIndex Core with pip
DESCRIPTION: This command installs the core `llama-index` library using `pip`, a prerequisite for utilizing LlamaIndex functionalities, often used in notebook environments with `!` for shell commands.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/embeddings/netmind.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
!pip install llama-index
```

----------------------------------------

TITLE: Streaming Text Completion from OpenRouter LLM - Python
DESCRIPTION: Demonstrates streaming a text completion response. The `llm.stream_complete()` method is used with a prompt, and the response deltas are iterated and printed as they become available, similar to chat streaming.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/llm/openrouter.ipynb#_snippet_7

LANGUAGE: python
CODE:
```
resp = llm.stream_complete("Tell me a story in 250 words")
for r in resp:
    print(r.delta, end="")
```

----------------------------------------

TITLE: Chaining Prompt and LLM in QueryPipeline (Python)
DESCRIPTION: This snippet demonstrates a basic `QueryPipeline` by chaining a `PromptTemplate` with an `OpenAI` LLM. It defines a prompt string with a placeholder, initializes the prompt and LLM, and then creates a pipeline where the output of the prompt feeds directly into the LLM. The `verbose=True` flag enables detailed logging of pipeline execution.
SOURCE: https://github.com/run-llama/llama_index/blob/main/llama-index-integrations/callbacks/llama-index-callbacks-arize-phoenix/examples/query_pipeline.ipynb#_snippet_6

LANGUAGE: python
CODE:
```
# try chaining basic prompts
prompt_str = "Please generate related movies to {movie_name}"
prompt_tmpl = PromptTemplate(prompt_str)
llm = OpenAI(model="gpt-3.5-turbo")

p = QueryPipeline(chain=[prompt_tmpl, llm], verbose=True)
```

----------------------------------------

TITLE: Configuring LlamaIndex RAG Pipeline Components - Python
DESCRIPTION: This snippet demonstrates the setup of a LlamaIndex Retrieval Augmented Generation (RAG) pipeline. It involves creating text nodes from documents, constructing a VectorStoreIndex, configuring a VectorIndexRetriever with a specified similarity_top_k, and initializing a response synthesizer. Finally, it combines these components into a RetrieverQueryEngine for performing queries.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/cookbooks/oreilly_course_cookbooks/Module-2/Components_Of_LlamaIndex.ipynb#_snippet_20

LANGUAGE: python
CODE:
```
from llama_index.core.retrievers import VectorIndexRetriever
from llama_index.core.response_synthesizers import get_response_synthesizer
from llama_index.core.query_engine import RetrieverQueryEngine

# create nodes
splitter = TokenTextSplitter(chunk_size=1024, chunk_overlap=20)
nodes = splitter.get_nodes_from_documents(documents)

# Construct an index by loading documents into a VectorStoreIndex.
index = VectorStoreIndex(nodes)

# configure retriever
retriever = VectorIndexRetriever(index=index, similarity_top_k=3)

# configure response synthesizer
synthesizer = get_response_synthesizer(response_mode="refine")

# construct query engine
query_engine = RetrieverQueryEngine(
    retriever=retriever,
    response_synthesizer=synthesizer,
)
```

----------------------------------------

TITLE: Setting OpenAI API Key Environment Variable
DESCRIPTION: Demonstrates how to set the OpenAI API key as an environment variable, which is necessary for LlamaIndex to authenticate with OpenAI services. Users should uncomment and replace 'INSERT OPENAI KEY' with their actual key.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/evaluation/RetryQuery.ipynb#_snippet_1

LANGUAGE: python
CODE:
```
# import os
# os.environ['OPENAI_API_KEY'] = "INSERT OPENAI KEY"
```

----------------------------------------

TITLE: Creating Google Calendar Event with OpenAI Agent (Python)
DESCRIPTION: This snippet showcases the agent's ability to create a new event on Google Calendar based on a natural language command. It specifies the date, time, duration, and attendees, demonstrating the agent's capability to perform write operations through the integrated tool.
SOURCE: https://github.com/run-llama/llama_index/blob/main/llama-index-integrations/tools/llama-index-tools-google/examples/google_calendar.ipynb#_snippet_4

LANGUAGE: python
CODE:
```
agent.chat(
    "Please create an event for june 15th, 2023 at 5pm for 1 hour and invite"
    " adam@example.com to discuss tax laws"
)
```

----------------------------------------

TITLE: Querying the LlamaIndex RAG Engine
DESCRIPTION: This snippet executes a query against the previously initialized RAG query engine (`rag`). It uses the `query` variable defined earlier to retrieve contextually relevant information and generate a response augmented by the loaded documents.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/presentations/materials/2024-06-19-georgian-genai-bootcamp.ipynb#_snippet_14

LANGUAGE: Python
CODE:
```
response = rag.query(query)
```

----------------------------------------

TITLE: Initializing OpenAI LLM and Embedding Models with LlamaIndex in Python
DESCRIPTION: This snippet imports necessary classes from 'llama_index.embeddings.openai' and 'llama_index.llms.openai' to initialize the 'OpenAIEmbedding' model for generating text embeddings and the 'OpenAI' LLM, specifically using the "gpt-4o-mini" model, for language generation tasks. These models are crucial for the RAG pipeline.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/node_parsers/topic_parser.ipynb#_snippet_4

LANGUAGE: python
CODE:
```
from llama_index.embeddings.openai import OpenAIEmbedding
from llama_index.llms.openai import OpenAI

embed_model = OpenAIEmbedding()
llm = OpenAI(model="gpt-4o-mini")
```

----------------------------------------

TITLE: Configuring Query Engine with Reranker and Structured LLM in LlamaIndex (Python)
DESCRIPTION: This snippet configures the `query_engine` for the RAG pipeline. It sets `similarity_top_k` to retrieve 5 initial nodes, applies the previously defined `reranker` as a node post-processor, and integrates the `sllm` (structured LLM) for generating responses. The `response_mode` is set to `tree_summarize` for comprehensive answer generation.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/structured_outputs/structured_outputs.ipynb#_snippet_17

LANGUAGE: python
CODE:
```
query_engine = index.as_query_engine(
    similarity_top_k=5,
    node_postprocessors=[reranker],
    llm=sllm,
    response_mode="tree_summarize"  # you can also select other modes like `compact`, `refine`
)
```

----------------------------------------

TITLE: Querying Data with LlamaIndex Query Engine - Python
DESCRIPTION: This code shows how to execute a query against a previously initialized `query_engine`. It takes a natural language question as input and returns a `response` object containing the answer, demonstrating the core functionality of the query engine.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/module_guides/deploying/query_engine/usage_pattern.md#_snippet_1

LANGUAGE: python
CODE:
```
response = query_engine.query("Who is Paul Graham?")
```

----------------------------------------

TITLE: Loading Documents with SimpleDirectoryReader (Python)
DESCRIPTION: Utilizes `SimpleDirectoryReader` from LlamaIndex to load all documents found within the specified local directory `./data/paul_graham`. This step prepares the raw text data for subsequent indexing operations.
SOURCE: https://github.com/run-llama/llama_index/blob/main/docs/docs/examples/observability/TokenCountingHandler.ipynb#_snippet_5

LANGUAGE: python
CODE:
```
from llama_index.core import SimpleDirectoryReader

documents = SimpleDirectoryReader("./data/paul_graham").load_data()
```
