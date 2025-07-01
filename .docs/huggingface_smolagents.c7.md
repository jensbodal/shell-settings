TITLE: Share a Custom Tool to Hugging Face Hub
DESCRIPTION: This example shows how to publish a custom tool to the Hugging Face Hub using the `push_to_hub` method. It requires a pre-created repository on the Hub and a Hugging Face API token with write access. Tools must be self-contained with imports defined within functions to ensure proper serialization and sharing.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/tools.md#_snippet_1

LANGUAGE: python
CODE:
```
model_downloads_tool.push_to_hub("{your_username}/hf-model-downloads", token="<YOUR_HUGGINGFACEHUB_API_TOKEN>")
```

----------------------------------------

TITLE: CodeAgent Python Tool Call Example
DESCRIPTION: Demonstrates how `CodeAgent` generates tool calls as Python code snippets, showing a simple `search_docs` function call and printing its result. This highlights its code-centric approach, allowing for complex logic and control flow.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_0

LANGUAGE: Python
CODE:
```
result = search_docs("What is the capital of France?")
print(result)
```

----------------------------------------

TITLE: Implement Custom Webpage Visitor Tool in Python
DESCRIPTION: Provides the full Python implementation for the `visit_webpage` tool. This function uses `requests` to fetch webpage content and `markdownify` to convert HTML to Markdown, including error handling for network requests.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/multiagents.md#_snippet_3

LANGUAGE: python
CODE:
```
import re
import requests
from markdownify import markdownify
from requests.exceptions import RequestException
from smolagents import tool


@tool
def visit_webpage(url: str) -> str:
    """Visits a webpage at the given URL and returns its content as a markdown string.

    Args:
        url: The URL of the webpage to visit.

    Returns:
        The content of the webpage converted to Markdown, or an error message if the request fails.
    """
    try:
        # Send a GET request to the URL
        response = requests.get(url)
        response.raise_for_status()  # Raise an exception for bad status codes

        # Convert the HTML content to Markdown
        markdown_content = markdownify(response.text).strip()

        # Remove multiple line breaks
        markdown_content = re.sub(r"\n{3,}", "\n\n", markdown_content)

        return markdown_content

    except RequestException as e:
        return f"Error fetching the webpage: {str(e)}"
    except Exception as e:
        return f"An unexpected error occurred: {str(e)}"
```

----------------------------------------

TITLE: Improved Weather API Tool with Validation and Clear Output
DESCRIPTION: This snippet presents an improved version of the weather tool. It includes explicit format requirements for 'location' and 'date_time' in its docstring, incorporates robust error handling with informative messages for invalid date formats, and formats the output into a human-readable string. This design significantly reduces the burden on the LLM for understanding and correcting errors.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/building_good_agents.md#_snippet_1

LANGUAGE: python
CODE:
```
@tool
def get_weather_api(location: str, date_time: str) -> str:
    """
    Returns the weather report.

    Args:
        location: the name of the place that you want the weather for. Should be a place name, followed by possibly a city name, then a country, like "Anchor Point, Taghazout, Morocco".
        date_time: the date and time for which you want the report, formatted as '%m/%d/%y %H:%M:%S'.
    """
    lon, lat = convert_location_to_coordinates(location)
    try:
        date_time = datetime.strptime(date_time)
    except Exception as e:
        raise ValueError("Conversion of `date_time` to datetime format failed, make sure to provide a string in format '%m/%d/%y %H:%M:%S'. Full trace:" + str(e))
    temperature_celsius, risk_of_rain, wave_height = get_weather_report_at_coordinates((lon, lat), date_time)
    return f"Weather report for {location}, {date_time}: Temperature will be {temperature_celsius}°C, risk of rain is {risk_of_rain*100:.0f}%, wave height is {wave_height}m."
```

----------------------------------------

TITLE: Passing Additional Arguments to a SmolAgent
DESCRIPTION: This example demonstrates how to provide extra context or data to a SmolAgent beyond the primary task string. By using the 'additional_args' parameter in the 'agent.run()' method, users can pass any type of object, such as a URL to an audio file, allowing the agent to leverage diverse inputs for its operations.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/building_good_agents.md#_snippet_2

LANGUAGE: python
CODE:
```
from smolagents import CodeAgent, InferenceClientModel

model_id = "meta-llama/Llama-3.3-70B-Instruct"

agent = CodeAgent(tools=[], model=InferenceClientModel(model_id=model_id), add_base_tools=True)

agent.run(
    "Why does Mike not know many people in New York?",
    additional_args={"mp3_sound_file_url":'https://huggingface.co/datasets/huggingface/documentation-images/resolve/main/transformers/recording.mp3'}
)
```

----------------------------------------

TITLE: Define Custom Retriever Tool with SmolAgents
DESCRIPTION: This Python class `RetrieverTool` extends `smolagents.Tool` to create a custom retrieval mechanism. It uses BM25 for document retrieval, initialized with processed documents, and formats the output for readability. The `forward` method executes the retrieval based on a provided query string.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/rag.md#_snippet_3

LANGUAGE: python
CODE:
```
from smolagents import Tool

class RetrieverTool(Tool):
    name = "retriever"
    description = "Uses semantic search to retrieve the parts of transformers documentation that could be most relevant to answer your query."
    inputs = {
        "query": {
            "type": "string",
            "description": "The query to perform. This should be semantically close to your target documents. Use the affirmative form rather than a question.",
        }
    }
    output_type = "string"

    def __init__(self, docs, **kwargs):
        super().__init__(**kwargs)
        # Initialize the retriever with our processed documents
        self.retriever = BM25Retriever.from_documents(
            docs, k=10  # Return top 10 most relevant documents
        )

    def forward(self, query: str) -> str:
        """Execute the retrieval based on the provided query."""
        assert isinstance(query, str), "Your search query must be a string"

        # Retrieve relevant documents
        docs = self.retriever.invoke(query)

        # Format the retrieved documents for readability
        return "\nRetrieved documents:\n" + "".join(
            [
                f"\n\n===== Document {str(i)} =====\n" + doc.page_content
                for i, doc in enumerate(docs)
            ]
        )

# Initialize our retriever tool with the processed documents
retriever_tool = RetrieverTool(docs_processed)
```

----------------------------------------

TITLE: Dynamically Add Tool to SmolAgents Toolbox
DESCRIPTION: Shows how to manage an agent's toolbox by adding a new tool. This snippet initializes a `CodeAgent` and then directly modifies its `agent.tools` dictionary to include a `model_download_tool`, expanding the agent's capabilities.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/tools.md#_snippet_12

LANGUAGE: python
CODE:
```
from smolagents import InferenceClientModel

model = InferenceClientModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct")

agent = CodeAgent(tools=[], model=model, add_base_tools=True)
agent.tools[model_download_tool.name] = model_download_tool
```

----------------------------------------

TITLE: Initialize CodeAgent with Additional Authorized Imports
DESCRIPTION: Shows how to initialize a `CodeAgent` instance, providing an empty list of tools, a model, and explicitly authorizing `requests` and `bs4` modules for import within the agent's execution environment. It then demonstrates running a query that would utilize these authorized imports.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_2

LANGUAGE: Python
CODE:
```
model = InferenceClientModel()
agent = CodeAgent(tools=[], model=model, additional_authorized_imports=['requests', 'bs4'])
agent.run("Could you get me the title of the page at url 'https://huggingface.co/blog'?")
```

----------------------------------------

TITLE: Define SQL Query Tool for Agent
DESCRIPTION: This Python function, decorated with `@smolagents.tool`, defines a callable tool named `sql_engine`. It enables the agent to execute SQL queries against the in-memory database and returns the results as a string. The comprehensive docstring provides essential context, including table schema and argument details, for the LLM to effectively use this tool.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/text_to_sql.md#_snippet_5

LANGUAGE: python
CODE:
```
from smolagents import tool

@tool
def sql_engine(query: str) -> str:
    """
    Allows you to perform SQL queries on the table. Returns a string representation of the result.
    The table is named 'receipts'. Its description is as follows:
        Columns:
        - receipt_id: INTEGER
        - customer_name: VARCHAR(16)
        - price: FLOAT
        - tip: FLOAT

    Args:
        query: The query to perform. This should be correct SQL.
    """
    output = ""
    with engine.connect() as con:
        rows = con.execute(text(query))
        for row in rows:
            output += "\n" + str(row)
    return output
```

----------------------------------------

TITLE: Initialize and Run Text-to-SQL Agent
DESCRIPTION: This snippet initializes a `CodeAgent` from `smolagents`, providing it with the `sql_engine` tool and configuring it to use a specified LLM via `InferenceClientModel`. It then demonstrates running the agent with a natural language query, allowing the agent to generate and execute SQL to retrieve the requested information.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/text_to_sql.md#_snippet_6

LANGUAGE: python
CODE:
```
from smolagents import CodeAgent, InferenceClientModel

agent = CodeAgent(
    tools=[sql_engine],
    model=InferenceClientModel(model_id="meta-llama/Llama-3.1-8B-Instruct"),
)
agent.run("Can you give me the name of the client who got the most expensive receipt?")
```

----------------------------------------

TITLE: Execute Agent with Newly Added Custom Tool
DESCRIPTION: Demonstrates running a `CodeAgent` after a new tool has been dynamically added to its toolbox. The agent is prompted with a query that requires the functionality of the newly added tool, showcasing its expanded capabilities.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/tools.md#_snippet_13

LANGUAGE: python
CODE:
```
agent.run(
    "Can you give me the name of the model that has the most downloads in the 'text-to-video' task on the Hugging Face Hub but reverse the letters?"
)
```

----------------------------------------

TITLE: Agent Execution Trace for Image Generation
DESCRIPTION: This snippet illustrates an agent's execution trace when attempting to generate an image. It demonstrates a common LLM reasoning error where the agent returns a file path instead of the actual image, highlighting the importance of proper output handling and LLM capabilities. The trace shows calls to an `image_generator` function and a `final_answer` function.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/building_good_agents.md#_snippet_3

LANGUAGE: Python
CODE:
```
image_generator(prompt="A cool, futuristic sports car with LED headlights, aerodynamic design, and vibrant color, high-res, photorealistic")
final_answer("/var/folders/6m/9b1tts6d5w960j80wbw9tx3m0000gn/T/tmpx09qfsdd/652f0007-3ee9-44e2-94ac-90dae6bb89a4.png")
```

----------------------------------------

TITLE: Initialize OpenRouter Model with OpenAIServerModel
DESCRIPTION: This Python code demonstrates how to initialize any model available on OpenRouter (e.g., `openai/gpt-4o`) using `smolagents.OpenAIServerModel`. It configures the `api_base` to OpenRouter's API endpoint and uses the provided API key for authentication.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/using_different_models.md#_snippet_4

LANGUAGE: python
CODE:
```
from smolagents import OpenAIServerModel

model = OpenAIServerModel(
    # You can use any model ID available on OpenRouter
    model_id="openai/gpt-4o",
    # OpenRouter API base URL
    api_base="https://openrouter.ai/api/v1",
    api_key=OPENROUTER_API_KEY,
)
```

----------------------------------------

TITLE: Initialize CodeAgent with OpenAI or Anthropic API via LiteLLM
DESCRIPTION: Demonstrates configuring a `CodeAgent` to use OpenAI or Anthropic APIs through `LiteLLMModel`. Authentication requires setting `ANTHROPIC_API_KEY` or `OPENAI_API_KEY` environment variables, or passing the `api_key` parameter directly.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_9

LANGUAGE: python
CODE:
```
# !pip install smolagents[litellm]
from smolagents import CodeAgent, LiteLLMModel

model = LiteLLMModel(model_id="anthropic/claude-3-5-sonnet-latest", api_key="YOUR_ANTHROPIC_API_KEY") # Could use 'gpt-4o'
agent = CodeAgent(tools=[], model=model, add_base_tools=True)

agent.run(
    "Could you give me the 118th number in the Fibonacci sequence?",
)
```

----------------------------------------

TITLE: Integrate LangChain Tools with SmolAgents
DESCRIPTION: Explains how to incorporate tools from the LangChain ecosystem into SmolAgents using `Tool.from_langchain`. This example demonstrates importing a `serpapi` search tool, noting the necessary `langchain` and `google-search-results` pip installations.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/tools.md#_snippet_11

LANGUAGE: python
CODE:
```
from langchain.agents import load_tools

search_tool = Tool.from_langchain(load_tools(["serpapi"])[0])

agent = CodeAgent(tools=[search_tool], model=model)

agent.run("How many more blocks (also denoted as layers) are in BERT base encoder compared to the encoder from the architecture proposed in Attention is All You Need?")
```

----------------------------------------

TITLE: Initialize and Run ToolCallingAgent
DESCRIPTION: Demonstrates how to initialize a `ToolCallingAgent` with an empty tool list and a specified model, then execute a query to perform a tool call.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_5

LANGUAGE: python
CODE:
```
from smolagents import ToolCallingAgent

agent = ToolCallingAgent(tools=[], model=model)
agent.run("Could you get me the title of the page at url 'https://huggingface.co/blog'?")
```

----------------------------------------

TITLE: Integrate and Run Custom Tool with Hugging Face CodeAgent
DESCRIPTION: This Python code demonstrates the integration of a newly created custom tool (e.g., `model_download_tool`) into a `smolagents.CodeAgent`. It shows how to initialize the agent with a list of tools and an `InferenceClientModel`, then execute a natural language query, allowing the agent to autonomously select and utilize the appropriate custom tool to fulfill the request.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_27

LANGUAGE: python
CODE:
```
from smolagents import CodeAgent, InferenceClientModel
agent = CodeAgent(tools=[model_download_tool], model=InferenceClientModel())
agent.run(
    "Can you give me the name of the model that has the most downloads in the 'text-to-video' task on the Hugging Face Hub?"
)
```

----------------------------------------

TITLE: Configure Inference Model ID for Agent
DESCRIPTION: Sets the `model_id` variable to specify the large language model (Qwen/Qwen2.5-Coder-32B-Instruct) that will power the agent. This model is accessed through Hugging Face's Inference API.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/multiagents.md#_snippet_2

LANGUAGE: python
CODE:
```
model_id = "Qwen/Qwen2.5-Coder-32B-Instruct"
```

----------------------------------------

TITLE: Integrate Ollama with Smolagents using LiteLLMModel
DESCRIPTION: This snippet demonstrates how to connect `smolagents` to a local Ollama instance. It utilizes `LiteLLMModel` and requires specifying the `model_id`, `api_base` (typically `http://localhost:11434`), and adjusting `num_ctx` for better performance. The example shows an agent running a simple query.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_10

LANGUAGE: python
CODE:
```
# !pip install smolagents[litellm]
from smolagents import CodeAgent, LiteLLMModel

model = LiteLLMModel(
    model_id="ollama_chat/llama3.2", # This model is a bit weak for agentic behaviours though
    api_base="http://localhost:11434", # replace with 127.0.0.1:11434 or remote open-ai compatible server if necessary
    api_key="YOUR_API_KEY", # replace with API key if necessary
    num_ctx=8192 # ollama default is 2048 which will fail horribly. 8192 works for easy tasks, more is better. Check https://huggingface.co/spaces/NyxKrage/LLM-Model-VRAM-Calculator to calculate how much VRAM this will need for the selected model.
)

agent = CodeAgent(tools=[], model=model, add_base_tools=True)

agent.run(
    "Could you give me the 118th number in the Fibonacci sequence?",
)
```

----------------------------------------

TITLE: Define Helium Instructions String for Agent
DESCRIPTION: Assigns a multi-line string containing detailed instructions and embedded code examples for using Helium to a Python variable, which is then passed to the agent for context.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/web_browser.md#_snippet_6

LANGUAGE: python
CODE:
```
helium_instructions = """
You can use helium to access websites. Don't bother about the helium driver, it's already managed.
We've already ran "from helium import *"
Then you can go to pages!
Code:
```py
go_to('github.com/trending')
```<end_code>

You can directly click clickable elements by inputting the text that appears on them.
Code:
```py
click("Top products")
```<end_code>

If it's a link:
Code:
```py
click(Link("Top products"))
```<end_code>

If you try to interact with an element and it's not found, you'll get a LookupError.
In general stop your action after each button click to see what happens on your screenshot.
Never try to login in a page.

To scroll up or down, use scroll_down or scroll_up with as an argument the number of pixels to scroll from.
Code:
```py
scroll_down(num_pixels=1200) # This will scroll one viewport down
```<end_code>

When you have pop-ups with a cross icon to close, don't try to click the close icon by finding its element or targeting an 'X' element (this most often fails).
Just use your built-in tool `close_popups` to close them:
Code:
```py
close_popups()
```<end_code>

You can use .exists() to check for the existence of an element. For example:
Code:
```py
if Text('Accept cookies?').exists():
    click('I accept')
```<end_code>
"""
```

----------------------------------------

TITLE: Initialize Web Automation Agent
DESCRIPTION: Initializes the `CodeAgent` from `smolagents` with the previously defined browser interaction tools. It configures the agent to use a specified Vision-Language Model (VLM), authorizes additional imports like `helium`, and integrates the `save_screenshot` callback for visual observations. The agent's behavior is further controlled by `max_steps` and `verbosity_level`.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/web_browser.md#_snippet_4

LANGUAGE: python
CODE:
```
from smolagents import InferenceClientModel

# Initialize the model
model_id = "Qwen/Qwen2-VL-72B-Instruct"  # You can change this to your preferred VLM model
model = InferenceClientModel(model_id=model_id)

# Create the agent
agent = CodeAgent(
    tools=[go_back, close_popups, search_item_ctrl_f],
    model=model,
    additional_authorized_imports=["helium"],
    step_callbacks=[save_screenshot],
    max_steps=20,
    verbosity_level=2,
)
```

----------------------------------------

TITLE: Configure Chrome Browser and Screenshot Callback
DESCRIPTION: Sets up Chrome browser options for `selenium` to control window size, position, and disable PDF viewer. It then initializes the browser using `helium` and defines a `save_screenshot` callback function. This callback captures and processes browser screenshots after each agent step, updating observations with the current URL and managing memory by clearing old screenshots.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/web_browser.md#_snippet_3

LANGUAGE: python
CODE:
```
# Configure Chrome options
chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument("--force-device-scale-factor=1")
chrome_options.add_argument("--window-size=1000,1350")
chrome_options.add_argument("--disable-pdf-viewer")
chrome_options.add_argument("--window-position=0,0")

# Initialize the browser
driver = helium.start_chrome(headless=False, options=chrome_options)

# Set up screenshot callback
def save_screenshot(memory_step: ActionStep, agent: CodeAgent) -> None:
    sleep(1.0)  # Let JavaScript animations happen before taking the screenshot
    driver = helium.get_driver()
    current_step = memory_step.step_number
    if driver is not None:
        for previous_memory_step in agent.memory.steps:  # Remove previous screenshots for lean processing
            if isinstance(previous_memory_step, ActionStep) and previous_memory_step.step_number <= current_step - 2:
                previous_memory_step.observations_images = None
        png_bytes = driver.get_screenshot_as_png()
        image = Image.open(BytesIO(png_bytes))
        print(f"Captured a browser screenshot: {image.size} pixels")
        memory_step.observations_images = [image.copy()]  # Create a copy to ensure it persists

    # Update observations with current URL
    url_info = f"Current url: {driver.current_url}"
    memory_step.observations = (
        url_info if memory_step.observations is None else memory_step.observations + "\n" + url_info
    )
```

----------------------------------------

TITLE: smolagents.Tool Class API Reference
DESCRIPTION: Detailed API documentation for the `smolagents.Tool` base class, outlining its attributes and methods. This class serves as the foundation for creating custom tools that can be integrated into LLM-powered agents, enabling them to perform specific actions.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/tools.md#_snippet_3

LANGUAGE: APIDOC
CODE:
```
class smolagents.Tool:
  Description: Base class for defining custom tools that LLMs can use within an agentic system.
  
  Attributes:
    name: str
      Description: The unique name of the tool, typically describing its primary action.
    description: str
      Description: A detailed, human-readable description of the tool's purpose and functionality. This is used to inform the LLM.
    inputs: dict
      Description: A dictionary specifying the input parameters required by the tool's 'forward' method. Each key represents a parameter name, and its value is a dictionary with 'type' (Pydantic format) and 'description'.
    output_type: str
      Description: The expected data type of the output returned by the tool's 'forward' method (Pydantic format).
  
  Methods:
    __init__(self):
      Description: Constructor for the Tool class. When subclassing, it's recommended that this method accepts no arguments other than 'self' to ensure proper serialization and sharing to the Hugging Face Hub.
    
    forward(self, *args, **kwargs) -> Any:
      Description: The core method containing the tool's execution logic. All necessary imports for this method should be defined directly within its scope to ensure self-containment.
      Parameters:
        *args, **kwargs: The input arguments corresponding to the 'inputs' attribute.
      Returns:
        Any: The result of the tool's operation, conforming to the 'output_type'.
    
    push_to_hub(self, repo_id: str, token: str):
      Description: Publishes the custom tool to the Hugging Face Hub as a Space repository. Requires a pre-existing repository and a Hugging Face API token with write access.
      Parameters:
        repo_id: str
          The target repository ID on the Hugging Face Hub (e.g., "{your_username}/my-tool").
        token: str
          Your Hugging Face API token with write permissions.
    
    save(self, path: str):
      Description: Saves the tool's definition and associated code to a local path. This method is implicitly used during the push_to_hub process.
      Parameters:
        path: str
          The local file path where the tool should be saved.
  
  Static Methods / Functions:
    load_tool(repo_id: str, trust_remote_code: bool) -> Tool:
      Description: Loads a tool instance directly from a specified Hugging Face Hub repository.
      Parameters:
        repo_id: str
          The repository ID of the tool on the Hugging Face Hub.
        trust_remote_code: bool
          A boolean flag that must be set to `True` to allow loading and executing custom code from a remote repository. Use with caution.
      Returns:
        Tool: An instantiated object of the loaded tool.
    
    Tool.from_hub(cls, repo_id: str, trust_remote_code: bool) -> Tool:
      Description: A class method alternative to `load_tool` for creating a Tool instance by loading it from the Hugging Face Hub.
      Parameters:
        repo_id: str
          The repository ID of the tool on the Hugging Face Hub.
        trust_remote_code: bool
          A boolean flag that must be set to `True` to allow loading and executing custom code from a remote repository. Use with caution.
      Returns:
        Tool: An instantiated object of the loaded tool.
```

----------------------------------------

TITLE: Run Agent to Answer Questions
DESCRIPTION: This Python code demonstrates how to use the initialized `CodeAgent` to answer a specific question. It defines a question string that requires information retrieval and then calls the agent's `run` method with the question. Finally, it prints the agent's generated output, which includes the final answer.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/rag.md#_snippet_5

LANGUAGE: python
CODE:
```
# Ask a question that requires retrieving information
question = "For a transformers model training, which is slower, the forward or the backward pass?"

# Run the agent to get an answer
agent_output = agent.run(question)

# Display the final answer
print("\nFinal answer:")
print(agent_output)
```

----------------------------------------

TITLE: Execute an Agent with a Specific Task
DESCRIPTION: Shows a straightforward example of running an initialized agent with a given natural language prompt. The agent will attempt to process the request based on its configuration and available tools.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_18

LANGUAGE: python
CODE:
```
agent.run("Calculate the least common multiple of 3 and 7")
```

----------------------------------------

TITLE: Calculate Pope's Age Raised to a Power
DESCRIPTION: Shows how to retrieve information (Pope's age) using `wiki` and `web_search` tools, then perform a mathematical computation on the retrieved data before providing the final answer.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/building_good_agents.md#_snippet_8

LANGUAGE: python
CODE:
```
pope_age_wiki = wiki(query="current pope age")
print("Pope age as per wikipedia:", pope_age_wiki)
pope_age_search = web_search(query="current pope age")
print("Pope age as per google search:", pope_age_search)
```

LANGUAGE: python
CODE:
```
pope_current_age = 88 ** 0.36
final_answer(pope_current_age)
```

----------------------------------------

TITLE: Helium Web Automation Usage Examples
DESCRIPTION: Illustrates common Helium functions for web automation, including navigating to URLs, clicking various types of elements, scrolling, closing pop-ups, and conditionally interacting with elements based on their existence.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/web_browser.md#_snippet_7

LANGUAGE: python
CODE:
```
go_to('github.com/trending')
```

LANGUAGE: python
CODE:
```
click("Top products")
```

LANGUAGE: python
CODE:
```
click(Link("Top products"))
```

LANGUAGE: python
CODE:
```
scroll_down(num_pixels=1200) # This will scroll one viewport down
```

LANGUAGE: python
CODE:
```
close_popups()
```

LANGUAGE: python
CODE:
```
if Text('Accept cookies?').exists():
    click('I accept')
```

----------------------------------------

TITLE: Configure and Run CodeAgent with Multi-Table SQL Tool
DESCRIPTION: This Python snippet configures the `CodeAgent` with the previously updated SQL tool description and switches to a more powerful LLM model ('Qwen/Qwen2.5-Coder-32B-Instruct') to handle complex text-to-SQL queries involving multiple tables. It then executes a query to find which waiter earned more tips, demonstrating the agent's ability to reason over joined data.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/text_to_sql.md#_snippet_9

LANGUAGE: python
CODE:
```
sql_engine.description = updated_description

agent = CodeAgent(
    tools=[sql_engine],
    model=InferenceClientModel(model_id="Qwen/Qwen2.5-Coder-32B-Instruct"),
)

agent.run("Which waiter got more total money from tips?")
```

----------------------------------------

TITLE: Connect to Azure OpenAI with AzureOpenAIServerModel
DESCRIPTION: This example illustrates how to integrate `smolagents` with Azure OpenAI using the `AzureOpenAIServerModel`. Users need to provide their model deployment name as `model_id` and ensure `azure_endpoint`, `api_key`, and `api_version` are either passed as arguments or set as environment variables. The agent then executes a query.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_11

LANGUAGE: python
CODE:
```
# !pip install smolagents[openai]
from smolagents import CodeAgent, AzureOpenAIServerModel

model = AzureOpenAIServerModel(model_id="gpt-4o-mini")
agent = CodeAgent(tools=[], model=model, add_base_tools=True)

agent.run(
    "Could you give me the 118th number in the Fibonacci sequence?",
)
```

----------------------------------------

TITLE: Basic Amazon Bedrock Integration with AmazonBedrockServerModel
DESCRIPTION: This snippet shows the basic setup for integrating `smolagents` with Amazon Bedrock using `AmazonBedrockServerModel`. It requires specifying the `model_id` for the desired Bedrock model. The example initializes a `CodeAgent` and runs a simple query.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_13

LANGUAGE: python
CODE:
```
# !pip install smolagents[aws_sdk]
from smolagents import CodeAgent, AmazonBedrockServerModel

model = AmazonBedrockServerModel(model_id="anthropic.claude-3-sonnet-20240229-v1:0")
agent = CodeAgent(tools=[], model=model, add_base_tools=True)

agent.run(
    "Could you give me the 118th number in the Fibonacci sequence?",
)
```

----------------------------------------

TITLE: Configure CodeAgent with various LLM providers
DESCRIPTION: Illustrates the flexibility of `smolagents` in integrating with different large language models. Examples include using a specific Hugging Face model via `InferenceClientModel`, OpenAI/Anthropic models via `LiteLLMModel` (requiring `smolagents[litellm]`), and local models via `TransformersModel` (requiring `smolagents[transformers]`).
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/index.md#_snippet_3

LANGUAGE: python
CODE:
```
# Using a specific model from Hugging Face
model = InferenceClientModel(model_id="meta-llama/Llama-2-70b-chat-hf")

# Using OpenAI/Anthropic (requires smolagents[litellm])
from smolagents import LiteLLMModel
model = LiteLLMModel(model_id="gpt-4")

# Using local models (requires smolagents[transformers])
from smolagents import TransformersModel
model = TransformersModel(model_id="meta-llama/Llama-2-7b-chat-hf")
```

----------------------------------------

TITLE: Initialize Advanced Retrieval Agent with SmolAgents
DESCRIPTION: This Python code initializes a `CodeAgent` from `smolagents`, providing it with a list of available tools, such as the `retriever_tool`. It configures the agent with an `InferenceClientModel` (defaulting to 'Qwen/Qwen2.5-Coder-32B-Instruct'), sets a maximum number of reasoning steps, and specifies the verbosity level for detailed agent reasoning. It also shows how to specify a custom model ID.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/rag.md#_snippet_4

LANGUAGE: python
CODE:
```
from smolagents import InferenceClientModel, CodeAgent

# Initialize the agent with our retriever tool
agent = CodeAgent(
    tools=[retriever_tool],  # List of tools available to the agent
    model=InferenceClientModel(),  # Default model "Qwen/Qwen2.5-Coder-32B-Instruct"
    max_steps=4,  # Limit the number of reasoning steps
    verbosity_level=2  # Show detailed agent reasoning
)

# To use a specific model, you can specify it like this:
# model=InferenceClientModel(model_id="meta-llama/Llama-3.3-70B-Instruct")
```

----------------------------------------

TITLE: Create Agent Tool with @tool Decorator in Python
DESCRIPTION: This Python example illustrates how to define a custom agent tool by wrapping a function with the `@tool` decorator from `smolagents`. It emphasizes the importance of clear function names, precise type hints for inputs and outputs, and a detailed docstring with an `Args:` section to guide the LLM's understanding and usage of the tool.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_25

LANGUAGE: python
CODE:
```
from smolagents import tool

@tool
def model_download_tool(task: str) -> str:
    """
    This is a tool that returns the most downloaded model of a given task on the Hugging Face Hub.
    It returns the name of the checkpoint.

    Args:
        task: The task for which to get the download count.
    """
    most_downloaded_model = next(iter(list_models(filter=task, sort="downloads", direction=-1)))
    return most_downloaded_model.id
```

----------------------------------------

TITLE: Poorly Designed Weather API Tool Example
DESCRIPTION: This code snippet demonstrates a poorly designed tool for retrieving weather data. It lacks clear input format specifications for 'date_time' and 'location', provides no detailed error logging, and returns an output that is difficult for an LLM to parse or understand, making it hard to debug or use effectively.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/building_good_agents.md#_snippet_0

LANGUAGE: python
CODE:
```
import datetime
from smolagents import tool

def get_weather_report_at_coordinates(coordinates, date_time):
    # Dummy function, returns a list of [temperature in °C, risk of rain on a scale 0-1, wave height in m]
    return [28.0, 0.35, 0.85]

def convert_location_to_coordinates(location):
    # Returns dummy coordinates
    return [3.3, -42.0]

@tool
def get_weather_api(location: str, date_time: str) -> str:
    """
    Returns the weather report.

    Args:
        location: the name of the place that you want the weather for.
        date_time: the date and time for which you want the report.
    """
    lon, lat = convert_location_to_coordinates(location)
    date_time = datetime.strptime(date_time)
    return str(get_weather_report_at_coordinates((lon, lat), date_time))
```

----------------------------------------

TITLE: Import Hugging Face Gradio Space as SmolAgents Tool
DESCRIPTION: Demonstrates how to integrate a Hugging Face Gradio Space as a tool within SmolAgents using `Tool.from_space`. It requires the Space ID, a name, and a description, leveraging the `gradio-client` library for underlying calls.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/tools.md#_snippet_8

LANGUAGE: python
CODE:
```
image_generation_tool = Tool.from_space(
    "black-forest-labs/FLUX.1-schnell",
    name="image_generator",
    description="Generate an image from a prompt"
)

image_generation_tool("A sunny beach")
```

----------------------------------------

TITLE: Modify Agent System Prompt Template
DESCRIPTION: This snippet demonstrates how to programmatically append additional text to an agent's existing system prompt template. This allows for dynamic modification of the agent's core instructions or context after initialization.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/building_good_agents.md#_snippet_10

LANGUAGE: python
CODE:
```
agent.prompt_templates["system_prompt"] = agent.prompt_templates["system_prompt"] + "\nHere you go!"
```

----------------------------------------

TITLE: ToolCallingAgent / CodeAgent Initialization Parameters
DESCRIPTION: Defines the constructor parameters for `ToolCallingAgent` and `CodeAgent`, detailing the various `AgentModel` types supported for powering the agent and how to configure tools.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_6

LANGUAGE: APIDOC
CODE:
```
ToolCallingAgent / CodeAgent:
  __init__(model: AgentModel, tools: list[Tool], add_base_tools: bool = False)

  Parameters:
    model (AgentModel): A text-generation model to power your agent.
      - TransformersModel: Takes a pre-initialized `transformers` pipeline to run inference on your local machine.
      - InferenceClientModel: Leverages `huggingface_hub.InferenceClient` and supports all Hugging Face Inference Providers.
        - Parameters: model_id (str), token (str, optional), provider (str, optional)
      - LiteLLMModel: Allows calling 100+ different models and providers through LiteLLM.
        - Parameters: model_id (str), api_key (str, optional)
      - AzureOpenAIServerModel: Allows using OpenAI models deployed in Azure.
      - AmazonBedrockServerModel: Allows using Amazon Bedrock in AWS.
      - MLXModel: Creates an `mlx-lm` pipeline to run inference on your local machine.

    tools (list[Tool]): A list of `Tools` that the agent can use to solve the task. Can be an empty list.
    add_base_tools (bool, optional): If True, adds the default toolbox on top of your `tools` list. Defaults to False.
```

----------------------------------------

TITLE: Install Smolagents Core Library
DESCRIPTION: Installs the fundamental `smolagents` library without any optional dependencies. This provides the core functionalities of the framework.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/installation.md#_snippet_0

LANGUAGE: bash
CODE:
```
pip install smolagents
```

----------------------------------------

TITLE: Install smolagents dependencies for OpenAI-compatible models
DESCRIPTION: This command installs the necessary `smolagents` dependencies, specifically the `openai` extra, which is required for interacting with various OpenAI-compatible APIs, including Google Gemini and OpenRouter.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/using_different_models.md#_snippet_0

LANGUAGE: bash
CODE:
```
pip install smolagents[openai]
```

----------------------------------------

TITLE: tool Function API Reference
DESCRIPTION: API reference for the `tool` function, likely a decorator or utility function for defining and registering tools in smolagents.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/reference/tools.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
def tool(*args, **kwargs)
```

----------------------------------------

TITLE: Generate Table Schema Description for LLM
DESCRIPTION: This Python snippet uses SQLAlchemy's inspector to dynamically retrieve column names and types from the 'receipts' table. It then formats this information into a descriptive string, which will be embedded in the LLM's prompt to inform it about the table structure.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/text_to_sql.md#_snippet_3

LANGUAGE: python
CODE:
```
inspector = inspect(engine)
columns_info = [(col["name"], col["type"]) for col in inspector.get_columns("receipts")]

table_description = "Columns:\n" + "\n".join([f"  - {name}: {col_type}" for name, col_type in columns_info])
print(table_description)
```

----------------------------------------

TITLE: Initialize Agent with Helium Library Import
DESCRIPTION: Executes a Python command within the agent's environment to import the Helium library, making its functions available for subsequent web automation tasks.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/web_browser.md#_snippet_5

LANGUAGE: python
CODE:
```
agent.python_executor("from helium import *", agent.state)
```

----------------------------------------

TITLE: WebSearchTool Class API Reference
DESCRIPTION: API reference for the `WebSearchTool` class, a generic default tool designed for performing broad web searches.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/reference/tools.md#_snippet_7

LANGUAGE: APIDOC
CODE:
```
class WebSearchTool:
```

----------------------------------------

TITLE: Demonstrating LocalPythonExecutor Security Safeguards
DESCRIPTION: This Python code snippet illustrates how `smolagents`' `LocalPythonExecutor` prevents various unsafe operations. It initializes the executor with authorized imports, then attempts to run commands that are either syntactically invalid, try to import unauthorized modules (like `os`), access forbidden submodules (`random._os`), or create infinite loops. The output demonstrates how the executor catches and reports these security violations, ensuring a safer execution environment.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/secure_code_execution.md#_snippet_0

LANGUAGE: python
CODE:
```
from smolagents.local_python_executor import LocalPythonExecutor

# Set up custom executor, authorize package "numpy"
custom_executor = LocalPythonExecutor(["numpy"])

# Utilisty for pretty printing errors
def run_capture_exception(command: str):
    try:
        custom_executor(harmful_command)
    except Exception as e:
        print("ERROR:\n", e)

# Undefined command just do not work
harmful_command="!echo Bad command"
run_capture_exception(harmful_command)
# >>> ERROR: invalid syntax (<unknown>, line 1)


# Imports like os will not be performed unless explicitly added to `additional_authorized_imports`
harmful_command="import os; exit_code = os.system("echo Bad command")"
run_capture_exception(harmful_command)
# >>> ERROR: Code execution failed at line 'import os' due to: InterpreterError: Import of os is not allowed. Authorized imports are: ['statistics', 'numpy', 'itertools', 'time', 'queue', 'collections', 'math', 'random', 're', 'datetime', 'stat', 'unicodedata']

# Even in authorized imports, potentially harmful packages will not be imported
harmful_command="import random; random._os.system('echo Bad command')"
run_capture_exception(harmful_command)
# >>> ERROR: Code execution failed at line 'random._os.system('echo Bad command')' due to: InterpreterError: Forbidden access to module: os

# Infinite loop are interrupted after N operations
harmful_command="""
while True:
    pass
"""
run_capture_exception(harmful_command)
# >>> ERROR: Code execution failed at line 'while True: pass' due to: InterpreterError: Maximum number of 1000000 iterations in While loop exceeded
```

----------------------------------------

TITLE: CodeAgent Class API Reference
DESCRIPTION: API documentation for the `CodeAgent` class, a specialized agent that generates its tool calls in Python code. This is the default agent type. It requires a language model (`model`) and a list of available `tools` for initialization.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/reference/agents.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
CodeAgent:
  __init__(model: Any, tools: List[Any])
```

----------------------------------------

TITLE: Agent Task: Wikipedia Information Extraction
DESCRIPTION: Demonstrates how to run the agent with a specific task to navigate to a Wikipedia page and extract a sentence containing particular keywords, combining the search request with the Helium instructions.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/web_browser.md#_snippet_8

LANGUAGE: python
CODE:
```
search_request = """
Please navigate to https://en.wikipedia.org/wiki/Chicago and give me a sentence containing the word "1992" that mentions a construction accident.
"""

agent_output = agent.run(search_request + helium_instructions)
print("Final output:")
print(agent_output)
```

----------------------------------------

TITLE: ToolCollection Class API Reference
DESCRIPTION: API reference for the `ToolCollection` class, likely used to manage, group, and organize multiple tools within the smolagents ecosystem.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/reference/tools.md#_snippet_12

LANGUAGE: APIDOC
CODE:
```
class ToolCollection:
```

----------------------------------------

TITLE: DuckDuckGoSearchTool Class API Reference
DESCRIPTION: API reference for the `DuckDuckGoSearchTool` class, a default tool specifically configured to perform web searches using the DuckDuckGo search engine.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/reference/tools.md#_snippet_8

LANGUAGE: APIDOC
CODE:
```
class DuckDuckGoSearchTool:
```

----------------------------------------

TITLE: Connect to Stdio-based MCP Server using Context Manager
DESCRIPTION: This snippet demonstrates how to connect to a stdio-based MCP server using `MCPClient` as a Python context manager. It configures `StdioServerParameters` to launch an `uvx` command with specific arguments and environment variables, ensuring dependencies are available. The loaded tools are then passed to a `CodeAgent` to execute a research query.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/tools.md#_snippet_4

LANGUAGE: python
CODE:
```
from smolagents import MCPClient, CodeAgent
from mcp import StdioServerParameters
import os

server_parameters = StdioServerParameters(
    command="uvx",  # Using uvx ensures dependencies are available
    args=["--quiet", "pubmedmcp@0.1.3"],
    env={"UV_PYTHON": "3.12", **os.environ},
)

with MCPClient(server_parameters) as tools:
    agent = CodeAgent(tools=tools, model=model, add_base_tools=True)
    agent.run("Please find the latest research on COVID-19 treatment.")
```

----------------------------------------

TITLE: load_tool Function API Reference
DESCRIPTION: API reference for the `load_tool` function, used to dynamically load specific tools within the smolagents framework.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/reference/tools.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
def load_tool(*args, **kwargs)
```

----------------------------------------

TITLE: Connect to Streamable HTTP-based MCP Server using Context Manager
DESCRIPTION: This example illustrates connecting to a streamable HTTP-based MCP server using `MCPClient` as a context manager. It specifies the server's URL and transport type directly within the `MCPClient` initialization. The acquired tools are subsequently used by a `CodeAgent` to process a user query.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/tools.md#_snippet_5

LANGUAGE: python
CODE:
```
from smolagents import MCPClient, CodeAgent

with MCPClient({"url": "http://127.0.0.1:8000/mcp", "transport": "streamable-http"}) as tools:
    agent = CodeAgent(tools=tools, model=model, add_base_tools=True)
    agent.run("Please find a remedy for hangover.")
```

----------------------------------------

TITLE: Dynamically Update SQL Tool Description for LLM
DESCRIPTION: This Python code dynamically generates an updated description for the `SQLExecutorTool` by inspecting the database schema. It iterates through specified tables ('receipts', 'waiters') to include their column names and types, ensuring the LLM has accurate and comprehensive information for SQL query generation across joined tables.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/examples/text_to_sql.md#_snippet_8

LANGUAGE: python
CODE:
```
updated_description = """Allows you to perform SQL queries on the table. Beware that this tool's output is a string representation of the execution output.
It can use the following tables:"""

inspector = inspect(engine)
for table in ["receipts", "waiters"]:
    columns_info = [(col["name"], col["type"]) for col in inspector.get_columns(table)]

    table_description = f"Table '{table}':\n"

    table_description += "Columns:\n" + "\n".join([f"  - {name}: {col_type}" for name, col_type in columns_info])
    updated_description += "\n\n" + table_description

print(updated_description)
```

----------------------------------------

TITLE: Load a Custom Tool from Hugging Face Hub
DESCRIPTION: This snippet demonstrates how to load a custom tool that has been shared on the Hugging Face Hub. It uses the `smolagents.load_tool` function, which requires specifying the repository ID and setting `trust_remote_code=True` due to the execution of custom code from a remote source. This allows agents to utilize community-contributed or privately shared tools.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/tutorials/tools.md#_snippet_2

LANGUAGE: python
CODE:
```
from smolagents import load_tool, CodeAgent

model_download_tool = load_tool(
    "{your_username}/hf-model-downloads",
    trust_remote_code=True
)
```

----------------------------------------

TITLE: Manually Use a Web Search Tool
DESCRIPTION: Illustrates how to directly import, initialize, and invoke a 'WebSearchTool' outside of an agent's context. This demonstrates the standalone usability of individual tools.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_23

LANGUAGE: python
CODE:
```
# !pip install smolagents[toolkit]
from smolagents import WebSearchTool

search_tool = WebSearchTool()
print(search_tool("Who's the current president of Russia?"))
```

----------------------------------------

TITLE: Agent Run Inspection Attributes
DESCRIPTION: Describes key attributes available on an agent object after a run, allowing for inspection of the execution process. This includes fine-grained logs and a method to convert memory into chat messages for a higher-level view.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_20

LANGUAGE: APIDOC
CODE:
```
agent.logs: List[Dict]
  - Stores fine-grained logs of the agent's run.
  - Each step's information is stored in a dictionary and appended to this list.

agent.write_memory_to_messages(): List[Dict]
  - Writes the agent's memory as a list of chat messages.
  - Iterates over log steps, storing relevant information (e.g., system prompt, task, LLM output, tool call output) as messages.
  - Provides a higher-level view of the run, but not all log details are transcribed.
```

----------------------------------------

TITLE: Use LiteLLMModel for Amazon Bedrock Integration
DESCRIPTION: This snippet illustrates how to integrate `smolagents` with Amazon Bedrock models using `LiteLLMModel`. It requires specifying the `model_name` with a `bedrock/` prefix, followed by the specific Bedrock model identifier. This provides an alternative to `AmazonBedrockServerModel` for Bedrock integration.
SOURCE: https://github.com/huggingface/smolagents/blob/main/docs/source/en/guided_tour.md#_snippet_15

LANGUAGE: python
CODE:
```
from smolagents import LiteLLMModel, CodeAgent

model = LiteLLMModel(model_name="bedrock/anthropic.claude-3-sonnet-20240229-v1:0")
agent = CodeAgent(tools=[], model=model)

agent.run("Explain the concept of quantum computing")
```
