TITLE: Example JavaScript Tool: Execute JS Code
DESCRIPTION: This JavaScript snippet illustrates how to create a tool that executes arbitrary JavaScript code within a Node.js environment. It uses JSDoc-style comments for automatic JSON declaration generation, defining the `code` argument.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_10

LANGUAGE: javascript
CODE:
```
/**
 * Execute the javascript code in node.js.
 * @typedef {Object} Args
 * @property {string} code - Javascript code to execute, such as `console.log("hello world")`
 * @param {Args} args
 */
exports.run = function ({ code }) {
  eval(code);
}
```

----------------------------------------

TITLE: Example Python Tool: Execute Python Code
DESCRIPTION: This Python function demonstrates how to build a tool that executes arbitrary Python code. It uses a docstring to describe its purpose and arguments, which is then used for automatic JSON declaration generation.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_11

LANGUAGE: python
CODE:
```
def run(code: str):
    """Execute the python code.
    Args:
        code: Python code to execute, such as `print("hello world")`
    """
    exec(code)
```

----------------------------------------

TITLE: Link a Web Search Tool using argc
DESCRIPTION: This command demonstrates how to use `argc` to create a symbolic link for a chosen web search tool, making it available as `web_search.sh` for inclusion in `tools.txt`. This allows flexibility in selecting the underlying web search provider.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_2

LANGUAGE: sh
CODE:
```
argc link-web-search web_search_perplexity.sh
```

----------------------------------------

TITLE: Example Bash Tool: Execute Shell Command
DESCRIPTION: This Bash script defines a tool that executes a given shell command. It uses `argc` for argument parsing and `LLM_OUTPUT` for output redirection, demonstrating how comments are used for automatic JSON declaration generation.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_9

LANGUAGE: sh
CODE:
```
#!/usr/bin/env bash
set -e

# @describe Execute the shell command.
# @option --command! The command to execute.

main() {
    eval "$argc_command" >> "$LLM_OUTPUT"
}

eval "$(argc --argc-eval "$0" "$@")"
```

----------------------------------------

TITLE: Define Tool Parameters with Type Hints and Docstrings in Python
DESCRIPTION: This snippet illustrates how to define tool parameters in Python using type hints for parameter types and docstrings for descriptions. It covers various data types, including enums and optional parameters.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_6

LANGUAGE: Python
CODE:
```
def run(
    string: str,
    string_enum: Literal["foo", "bar"],
    boolean: bool,
    integer: int,
    number: float,
    array: List[str],
    string_optional: Optional[str] = None,
    array_optional: Optional[List[str]] = None,
):
    """Demonstrate how to create a tool using Python and how to use comments.
    Args:
        string: Define a required string property
        string_enum: Define a required string property with enum
        boolean: Define a required boolean property
        integer: Define a required integer property
        number: Define a required number property
        array: Define a required string array property
        string_optional: Define a optional string property
        array_optional: Define a optional string array property
    """
    # ... your Python code ...
```

----------------------------------------

TITLE: Bash Tool Parameter Definition using Argc Comments
DESCRIPTION: Illustrates how to define tool parameters in Bash scripts using `argc` comments. It covers `# @describe` for tool description, `# @option` for various parameter types (string, enum, integer, number, array, required/optional), and `# @flag` for boolean flags. Also shows an environment variable definition.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_1

LANGUAGE: bash
CODE:
```
#!/usr/bin/env bash
set -e

# @describe Demonstrate how to create a tool using Bash and how to use comment tags.
# @option --string!                  Define a required string property
# @option --string-enum![foo|bar]    Define a required string property with enum
# @option --string-optional          Define a optional string property
# @flag --boolean                    Define a boolean property
# @option --integer! <INT>           Define a required integer property
# @option --number! <NUM>            Define a required number property
# @option --array+ <VALUE>           Define a required string array property
# @option --array-optional*          Define a optional string array property

# @env LLM_OUTPUT=/dev/stdout The output path

main() {
    # ... your bash code ...
}

eval "$(argc --argc-eval "$0" "$@")"
```

----------------------------------------

TITLE: Define Tool Parameters with JSDoc in JavaScript
DESCRIPTION: This snippet demonstrates how to define tool parameters using JSDoc comments in JavaScript. It shows the use of `@typedef` for argument objects and `@property` for individual parameters, including various data types and optional parameters.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_3

LANGUAGE: JavaScript
CODE:
```
/**
 * Demonstrate how to create a tool using Javascript and how to use comments.
 * @typedef {Object} Args
 * @property {string} string - Define a required string property
 * @property {'foo'|'bar'} string_enum - Define a required string property with enum
 * @property {string} [string_optional] - Define a optional string property
 * @property {boolean} boolean - Define a required boolean property
 * @property {Integer} integer - Define a required integer property
 * @property {number} number - Define a required number property
 * @property {string[]} array - Define a required string array property
 * @property {string[]} [array_optional] - Define a optional string array property
 * @param {Args} args
 */
exports.run = function (args) {
  // ... your JavaScript code ...
}
```

----------------------------------------

TITLE: Python Tool Parameter Definition Specification
DESCRIPTION: Specification for defining tool parameters in Python using type hints and docstrings. Details the function definition, parameter type hints, and docstring format for descriptions and optional parameters.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_5

LANGUAGE: APIDOC
CODE:
```
Python Tool Parameter Definition:
  def run(...): Function definition.
  <type> <parameter_name>: <description>: Type hints with descriptions in the docstring.
    <type>: The data type (e.g., str, bool, int, float, List[str], Literal["foo", "bar"]).
    <parameter_name>: The name of the parameter.
    <description>: Description of the parameter.
  Optional[...]: Indicates an optional parameter.
```

----------------------------------------

TITLE: Create Tool Script with argc
DESCRIPTION: Demonstrates how to use the `argc create@tool` command to quickly generate a tool script. It explains the meaning of various suffixes (!, *, +) appended to parameters, which define their characteristics such as required, array, or required array.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_12

LANGUAGE: sh
CODE:
```
argc create@tool _test.sh foo bar! baz+ qux*
```

----------------------------------------

TITLE: Create Spotify Agent Tools with aichat
DESCRIPTION: Shows how to use `aichat` to generate a comprehensive Spotify agent, complete with an `index.yaml` configuration and multiple Python tools (`tools.py`). Each tool (e.g., search, get_info, add_queue) is defined with its purpose, parameters, and default values, demonstrating `aichat`'s capability to create complex, multi-functional agents.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_14

LANGUAGE: sh
CODE:
```
aichat -f docs/agent.md -f docs/tool.md <<-'EOF'

create a spotify agent

index.yaml:
    name: spotify
    description: An AI agent that works with Spotify

tools.py:
  search: Search for tracks, albums, artists, or playlists on Spotify
    query (required): Query term
    qtype (default: "track"): Type of items to search for (track, album, artist, playlist, or comma-separated combination)
    limit (default: 10): Maximum number of items to return
  get_info: Get detailed information about a Spotify item (track, album, artist, or playlist)
    item_id (required): ID of the item to get information about
    qtype (default: "track"): Type of item: 'track', 'album', 'artist', or 'playlist'
  get_queue: Get the playback queue
  add_queue: Add tracks to the playback queue
    track_id (required): Track ID to add to queue
  get_track: Get information about user's current track
  start: Starts of resumes playback
    track_id (required): Specifies track to play
  pause: Pauses current playback
  skip: Skips current track
    num_skips (default: 1): Number of tracks to skip
EOF
```

LANGUAGE: APIDOC
CODE:
```
create a spotify agent

index.yaml:
    name: spotify
    description: An AI agent that works with Spotify

tools.py:
  search: Search for tracks, albums, artists, or playlists on Spotify
    query (required): Query term
    qtype (default: "track"): Type of items to search for (track, album, artist, playlist, or comma-separated combination)
    limit (default: 10): Maximum number of items to return
  get_info: Get detailed information about a Spotify item (track, album, artist, or playlist)
    item_id (required): ID of the item to get information about
    qtype (default: "track"): Type of item: 'track', 'album', 'artist', or 'playlist'
  get_queue: Get the playback queue
  add_queue: Add tracks to the playback queue
    track_id (required): Track ID to add to queue
  get_track: Get information about user's current track
  start: Starts of resumes playback
    track_id (required): Specifies track to play
  pause: Pauses current playback
  skip: Skips current track
    num_skips (default: 1): Number of tracks to skip
```

----------------------------------------

TITLE: Define Tools in tools.txt
DESCRIPTION: This snippet shows an example of the `tools.txt` file, where each line specifies the filename of a tool to be included in the LLM functions build process. Lines starting with '#' are treated as comments and ignored.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_1

LANGUAGE: text
CODE:
```
get_current_weather.sh
execute_command.sh
#execute_py_code.py
```

----------------------------------------

TITLE: Build LLM Functions Tools and Agents
DESCRIPTION: This command initiates the build process for all tools and agents defined in `tools.txt` and `agents.txt`, generating the necessary `bin` directory and `functions.json` file for the LLM functions.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_4

LANGUAGE: sh
CODE:
```
argc build
```

----------------------------------------

TITLE: JSDoc Tool Parameter Definition Specification
DESCRIPTION: Specification for defining tool parameters using JSDoc comments in JavaScript. Details the structure of the `@typedef` block for arguments and `@property` for individual parameters, including type, name, description, and optionality.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_2

LANGUAGE: APIDOC
CODE:
```
JSDoc Tool Parameter Definition:
  /** ... */: JSDoc comment block containing the description and parameter definitions.
  @typedef {Object} Args: Defines the type of the argument object.
  @property {<type>} <name> <description>: Defines a property (parameter) of the Args object.
    <type>: The data type (e.g., string, boolean, number, string[], {foo|bar}).
    <name>: The name of the parameter.
    <description>: A description of the parameter.
    []: Indicates an optional parameter.
```

----------------------------------------

TITLE: Export Tool Function using ESM in JavaScript
DESCRIPTION: This snippet shows an alternative way to export a tool function in JavaScript using ESM `export` expressions.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_4

LANGUAGE: JavaScript
CODE:
```
export function run() {
  // ... your JavaScript code ...
}
```

----------------------------------------

TITLE: Define Multiple Agent Tools in JavaScript
DESCRIPTION: This example shows how to define multiple tool functions for an agent in JavaScript using `exports` for `git_status` and `git_diff`, including JSDoc for parameter definition.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_10

LANGUAGE: JavaScript
CODE:
```
/**
 * Shows the working tree status
 */
exports.git_status = function() {
  // ... your JavaScript code ...
}

/**
 * Shows differences between branches or commits
 * @typedef {Object} Args
 * @property {string} target - Shows differences between branches or commits 
 * @param {Args} args
 */
exports.git_diff = function() {
  // ... your JavaScript code ...
}
```

----------------------------------------

TITLE: Create YouTube Transcript Tool with aichat
DESCRIPTION: Illustrates how to use `aichat` to automatically generate a Python tool for extracting YouTube video transcripts. The tool's description and parameters (URL, language) are defined within a markdown-like specification passed to `aichat`.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_13

LANGUAGE: sh
CODE:
```
aichat -f docs/tool.md <<-'EOF'
create tools/get_youtube_transcript.py

description: Extract transcripts from YouTube videos
parameters:
   url (required): YouTube video URL or video ID
   lang (default: "en"): Language code for transcript (e.g., "ko", "en")
EOF
```

LANGUAGE: APIDOC
CODE:
```
create tools/get_youtube_transcript.py

description: Extract transcripts from YouTube videos
parameters:
   url (required): YouTube video URL or video ID
   lang (default: "en"): Language code for transcript (e.g., "ko", "en")
```

----------------------------------------

TITLE: Define Multiple Agent Tools in Bash
DESCRIPTION: This example demonstrates how to define multiple tool functions for an agent in Bash using `@cmd` comment tags and named functions, suitable for `agents/<agent-name>/tools.sh`.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_9

LANGUAGE: Bash
CODE:
```
# @cmd Shows the working tree status
git_status() {
    # ... your bash code ...
}

# @cmd Shows differences between branches or commits
# @option --target!   Shows differences between branches or commits 
git_diff() {
    # ... your bash code ...
}

eval "$(argc --argc-eval "$0" "$@")"
```

----------------------------------------

TITLE: Bash Common Tool Definition Specification
DESCRIPTION: Specification for defining a single common tool in Bash. Uses the `@describe` comment tag and a single `main` function.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_7

LANGUAGE: APIDOC
CODE:
```
Bash Common Tool Definition:
  # @describe <description>: Comment tag for describing a single tool.
  main(): The single function for a common tool.
```

----------------------------------------

TITLE: Bash Agent Tool Definition Specification
DESCRIPTION: Specification for defining multiple tool functions for an agent in Bash. Uses `@cmd` comment tags and named functions, along with `argc` for argument parsing.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_8

LANGUAGE: APIDOC
CODE:
```
Bash Agent Tool Definition:
  # @cmd <description>: Comment tag for describing a tool function.
  # @option --<option_name>!: Option definition for a command.
  <function_name>(): Named function for an agent tool.
  eval "$(argc --argc-eval "$0" "$@")": Required for parsing arguments in agent tools.
```

----------------------------------------

TITLE: LLM-Functions Agent Directory Structure
DESCRIPTION: This snippet illustrates the standard file and directory layout for an LLM-Functions agent. It shows where configuration files (`index.yaml`), function declarations (`functions.json`), and various tool scripts (`tools.txt`, `tools.{sh,js,py}`) are located within the agent's dedicated folder.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_12

LANGUAGE: text
CODE:
```
└── agents
    └── myagent
        ├── functions.json                  # JSON declarations for functions (Auto-generated)
        ├── index.yaml                      # Agent definition
        ├── tools.txt                       # Shared tools
        └── tools.{sh,js,py}                # Agent tools 
```

----------------------------------------

TITLE: LLM-Functions Agent Definition (index.yaml)
DESCRIPTION: This YAML configuration defines the core properties of an LLM-Functions agent. It includes metadata such as name, description, and version, along with operational instructions, example conversation starters, variable definitions, and references to local or remote documents for RAG purposes.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_13

LANGUAGE: yaml
CODE:
```
name: TestAgent                             
description: This is test agent
version: 0.1.0
instructions: You are a test ai agent to ... 
conversation_starters:
  - What can you do?
variables:
  - name: foo
    description: This is a foo
documents:
  - local-file.txt
  - local-dir/
  - https://example.com/remote-file.txt
```

----------------------------------------

TITLE: Agent Metadata Configuration in index.yaml
DESCRIPTION: Defines basic information for the agent, including its unique name, a brief description of its purpose, and its version number. This section is crucial for identifying and tracking the agent's lifecycle and updates.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/agent.md#_snippet_1

LANGUAGE: yaml
CODE:
```
name: TestAgent
description: This is test agent
version: 0.1.0
```

----------------------------------------

TITLE: Agent Initial Instructions in index.yaml
DESCRIPTION: Specifies the initial context or behavioral directives for the agent. This instruction set guides the agent's primary function and interaction style, setting its foundational behavior.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/agent.md#_snippet_2

LANGUAGE: yaml
CODE:
```
instructions: You are a test ai agent to ...
```

----------------------------------------

TITLE: Defining Custom Variables in index.yaml
DESCRIPTION: Illustrates the syntax for defining custom variables within the agent's configuration. These variables can store user-related data or preferences, and can include optional default values for flexibility.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/agent.md#_snippet_3

LANGUAGE: yaml
CODE:
```
variables:
  - name: foo
    description: This is a foo
  - name: bar
    description: This is a bar with default value
    default: val
```

----------------------------------------

TITLE: Accessing Variables within Agent Instructions (YAML)
DESCRIPTION: Demonstrates how to embed and access both user-defined and built-in variables within the agent's instructions using templating syntax. This allows for dynamic and personalized agent behavior based on configured values.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/agent.md#_snippet_4

LANGUAGE: yaml
CODE:
```
instructions: |
  The instructions can access user-defined variables: {{foo}} and {{bar}}, or built-in variables: {{__cwd__}}
```

----------------------------------------

TITLE: Accessing Variables in Agent Tool Scripts (Shell)
DESCRIPTION: Shows how user-defined variables are exposed as environment variables within shell scripts executed as agent tools. This enables tool scripts to dynamically retrieve and utilize configuration values, integrating them into script logic.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/agent.md#_snippet_5

LANGUAGE: sh
CODE:
```
echo "he tools script can access user-defined variables in environment variables: $LLM_AGENT_VAR_FOO and $LLM_AGENT_VAR_BAR"
```

----------------------------------------

TITLE: Defining Agent Documents for RAG in index.yaml
DESCRIPTION: Specifies a list of local and remote resources that the agent can access for Retrieval-Augmented Generation (RAG). This allows the agent to incorporate external knowledge into its responses, enhancing its information retrieval capabilities.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/agent.md#_snippet_6

LANGUAGE: yaml
CODE:
```
documents:
  - local-file.txt
  - local-dir/
  - https://example.com/remote-file.txt
```

----------------------------------------

TITLE: Defining Conversation Starters in index.yaml
DESCRIPTION: Provides predefined prompts or questions that users can use to initiate interactions with the agent. This feature helps guide users and demonstrates the agent's capabilities, making it easier to engage.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/agent.md#_snippet_7

LANGUAGE: yaml
CODE:
```
conversation_starters:
  - What can you do?
```

----------------------------------------

TITLE: Link LLM Functions to AIChat's functions_dir
DESCRIPTION: These commands demonstrate two ways to link the LLM Functions repository to AIChat's expected `functions_dir`. The first uses a direct symbolic link, while the second leverages an `argc` helper command for convenience.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_6

LANGUAGE: sh
CODE:
```
ln -s "$(pwd)" "$(aichat --info | sed -n 's/^functions_dir\s\+//p')"
# OR
argc link-to-aichat
```

----------------------------------------

TITLE: Set AIChat Functions Directory via Environment Variable
DESCRIPTION: This command sets the `AICHAT_FUNCTIONS_DIR` environment variable to the current directory, explicitly telling AIChat where to find the LLM Functions tools and agents without requiring a symbolic link.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_7

LANGUAGE: sh
CODE:
```
export AICHAT_FUNCTIONS_DIR="$(pwd)"
```

----------------------------------------

TITLE: Environment Variables Injected by AIChat Runtime
DESCRIPTION: These environment variables are injected by the AIChat runtime component of `llm-functions`, primarily used for handling tool execution results and managing agent-specific variables during runtime.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/environment-variables.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
LLM_OUTPUT: File to store the the execution results of the tool.
LLM_AGENT_VAR_<NAME>: Agent variables.
```

----------------------------------------

TITLE: Environment Variables Injected by Tool/Agent Runners
DESCRIPTION: These environment variables are automatically set by the `run-tool.*` or `run-agent.*` scripts within the `llm-functions` framework, providing essential context about the current tool or agent execution, including paths and names.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/environment-variables.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
LLM_ROOT_DIR: Path to <llm-functions-dir>
LLM_TOOL_NAME: Tool name, such as execute_command
LLM_TOOL_CACHE_DIR: Path to <llm-functions-dir>/cache/<tool-name>, The tool script can use this directory to store some cache data
LLM_AGENT_NAME: Agent name, such as todo
LLM_AGENT_FUNC: Agent function, such as list_todos
LLM_AGENT_ROOT_DIR: Path to <llm-functions-dir>/agents/<agent-name>
LLM_AGENT_CACHE_DIR: Path to <llm-functions-dir>/cache/<agent-name>, The agent tool script can use this directory to store some cache data
```

----------------------------------------

TITLE: User-Provided Environment Variables for LLM-Functions
DESCRIPTION: These environment variables allow users to customize various behaviors of `llm-functions`, such as controlling whether to print execution results or managing confirmation prompts before executing specific tools. They can be set via a `.env` file.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/environment-variables.md#_snippet_2

LANGUAGE: APIDOC
CODE:
```
LLM_DUMP_RESULTS: Controls whether to print the execution results of the tool, e.g. get_current_weather|fs.*|todo:.*, .*
LLM_MCP_NEED_CONFIRM: Controls whether to prompt for confirmation before executing certain tools, e.g., git_commit|git_reset, .*
LLM_MCP_SKIP_CONFIRM: Controls whether to bypass confirmation requests for certain tools, e.g., git_status|git_diff.*, .*
```

----------------------------------------

TITLE: Clone LLM Functions Repository
DESCRIPTION: This command clones the LLM Functions GitHub repository to your local machine and navigates into the project directory, preparing for further setup and development.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_0

LANGUAGE: sh
CODE:
```
git clone https://github.com/sigoden/llm-functions
cd llm-functions
```

----------------------------------------

TITLE: Check LLM Functions Setup Readiness
DESCRIPTION: This command performs a readiness check for the LLM Functions environment, verifying environment variables, Node/Python dependencies, and the `mcp-bridge` server to ensure everything is correctly configured.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_5

LANGUAGE: sh
CODE:
```
argc check
```

----------------------------------------

TITLE: Interact with LLM Functions using AIChat
DESCRIPTION: These commands demonstrate how to use AIChat to interact with the deployed LLM functions. The first example queries for weather information using a tool, and the second uses an agent to list todos.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_8

LANGUAGE: sh
CODE:
```
aichat --role %functions% what is the weather in Paris?
aichat --agent todo list all my todos
```

----------------------------------------

TITLE: Define Agents in agents.txt
DESCRIPTION: This snippet illustrates the structure of the `agents.txt` file, where each line lists the name of an agent to be built and included in the LLM functions system.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/README.md#_snippet_3

LANGUAGE: text
CODE:
```
coder
todo
```

----------------------------------------

TITLE: Configure MCP Server for LLM-functions Tools
DESCRIPTION: This JSON configuration snippet defines an entry within the 'mcpServers' object to serve LLM-functions tools. It specifies 'npx' as the command executor and 'mcp-llm-functions' along with the LLM functions directory as arguments. This setup allows the MCP server to expose a collection of tools.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/mcp/server/README.md#_snippet_0

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "tools": {
      "command": "npx",
      "args": [
        "mcp-llm-functions",
        "<llm-functions-dir>"
      ]
    }
  }
}
```

----------------------------------------

TITLE: Configure MCP Server for a Specific LLM-functions Agent
DESCRIPTION: This JSON configuration snippet illustrates how to define an MCP server entry for serving a specific LLM-functions agent. It uses 'node' as the command and 'mcp-llm-functions' with the functions directory and the agent's name as arguments. This allows the MCP server to expose a particular agent's capabilities.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/mcp/server/README.md#_snippet_1

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "<agent-name>": {
      "command": "node",
      "args": [
        "mcp-llm-functions",
        "<llm-functions-dir>",
        "<agent-name>"
      ]
    }
  }
}
```

----------------------------------------

TITLE: Environment Variables for MCP-Server Configuration
DESCRIPTION: This section documents environment variables that can be used to modify the behavior of the MCP-Server, specifically concerning the visibility and handling of agent tools versus shared tools.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/mcp/server/README.md#_snippet_2

LANGUAGE: APIDOC
CODE:
```
AGENT_TOOLS_ONLY:
  Description: When set to 'true' or '1', the server will ignore shared tools and exclusively display tools associated with the agent.
  Type: string ('true' | '1') or boolean
  Default: (not specified)
```

----------------------------------------

TITLE: Configure MCP-Bridge Servers in mcp.json
DESCRIPTION: This JSON configuration defines various MCP servers (SQLite, Git, GitHub) that MCP-Bridge will launch and register as tools. It specifies the command, arguments, and environment variables for each server, with an option to disable automatic tool name prefixing to avoid clashes.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/mcp/bridge/README.md#_snippet_0

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "sqlite": {
      "command": "uvx",
      "args": [
        "mcp-server-sqlite",
        "--db-path",
        "/tmp/foo.db"
      ]
    },
    "git": {
      "command": "uvx",
      "args": [
        "mcp-server-git",
        "--repository",
        "path/to/git/repo"
      ],
      "prefix": false
    },
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_TOKEN>"
      }
    }
  }
}
```

----------------------------------------

TITLE: Start MCP-Bridge Server and Build Tools
DESCRIPTION: This command initiates the MCP-Bridge server, builds necessary MCP tool binaries, and updates the `functions.json` file to include the newly registered tools. It's the primary command to get the bridge operational and integrate external MCP tools.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/mcp/bridge/README.md#_snippet_1

LANGUAGE: shell
CODE:
```
argc mcp start
```

----------------------------------------

TITLE: General Argcfile Usage with argc
DESCRIPTION: Provides a comprehensive list of `argc` commands for interacting with `Argcfile.sh`, covering help, build, check, run, test, clean, and link operations for LLM tools and agents. These commands facilitate the management and execution of various components.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/argcfile.md#_snippet_0

LANGUAGE: Shell
CODE:
```
# -------- Help --------
argc -h
argc <command> -h

# -------- Build --------
# Build all
argc build

# Build all tools
argc build@tool
# Build specific tools
argc build@tool get_current_weather.sh execute_command.sh

# Build all agents
argc build@agent
# Build specific agents
argc build@agent coder todo

# -------- Check --------
# Check all
argc check

# Check all tools
argc check@tool
# Check specific tools
argc check@tool get_current_weather.sh execute_command.sh

# Check all agents
argc check@agent
# Check specific agents
argc check@agent coder todo

# -------- Run --------
# Run tool
argc run@tool get_current_weather.sh '{"location":"London"}'
# Run agent tool
argc run@agent todo add_todo '{"desc":"Watch a movie"}'

# -------- Test --------
# Test all
argc test
# Test tools
argc test@tool
# Test agents
argc test@agent

# -------- Clean --------
# Clean all
argc clean
# Clean tools
argc clean@tool
# Clean agents
argc clean@agent

# -------- Link --------
argc link-web-search web_search_tavily.sh
argc link-code-interpreter execute_py_code.py

# -------- Misc --------
# Link this repo to aichat functions_dir
argc link-to-aichat
# Displays version information for required tools
argc version
```

----------------------------------------

TITLE: Argcfile MCP Bridge Server Management
DESCRIPTION: Demonstrates `argc` commands specifically for managing the MCP (Multi-Component Proxy) bridge server. These commands allow users to start, stop, run tools through the server, and view its operational logs.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/argcfile.md#_snippet_1

LANGUAGE: Shell
CODE:
```
# Start/restart the mcp bridge server
argc mcp start

# Stop the mcp bridge server
argc mcp stop

# Run the mcp tool
argc mcp run@tool fs_read_file '{"path":"/tmp/file1"}'

# Show the logs
argc mcp logs
```

----------------------------------------

TITLE: Agent Folder Structure Overview
DESCRIPTION: Illustrates the standard directory layout for an agent, showing the location of configuration files like `functions.json`, `index.yaml`, and tool scripts. This structure ensures proper organization and functionality for the agent.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/agent.md#_snippet_0

LANGUAGE: text
CODE:
```
└── agents
    └── myagent
        ├── functions.json                  # Auto-generated JSON declarations for functions
        ├── index.yaml                      # Main agent definition file
        ├── tools.txt                       # List of shared tools
        └── tools.{sh,js,py}                # Scripts implementing agent-specific tools
```

----------------------------------------

TITLE: JSON Schema for Tool Parameters
DESCRIPTION: An example JSON schema demonstrating various property types (string, enum, boolean, integer, number, array) that can be defined for LLM tool parameters, including required and optional fields.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_0

LANGUAGE: json
CODE:
```
{
  "name": "demo",
  "description": "Demonstrate how to create a tool using Javascript and how to use comments.",
  "parameters": {
    "type": "object",
    "properties": {
      "string": {
        "type": "string",
        "description": "Define a required string property"
      },
      "string_enum": {
        "type": "string",
        "enum": [
          "foo",
          "bar"
        ],
        "description": "Define a required string property with enum"
      },
      "string_optional": {
        "type": "string",
        "description": "Define a optional string property"
      },
      "boolean": {
        "type": "boolean",
        "description": "Define a required boolean property"
      },
      "integer": {
        "type": "integer",
        "description": "Define a required integer property"
      },
      "number": {
        "type": "number",
        "description": "Define a required number property"
      },
      "array": {
        "type": "array",
        "items": {
          "type": "string"
        },
        "description": "Define a required string array property"
      },
      "array_optional": {
        "type": "array",
        "items": {
          "type": "string"
        },
        "description": "Define a optional string array property"
      }
    },
    "required": [
      "string",
      "string_enum",
      "boolean",
      "integer",
      "number",
      "array"
    ]
  }
}
```

----------------------------------------

TITLE: Define Multiple Agent Tools in Python
DESCRIPTION: This example illustrates how to define multiple tool functions for an agent in Python using type hints and docstrings for `git_status` and `git_diff`.
SOURCE: https://github.com/sigoden/llm-functions/blob/main/docs/tool.md#_snippet_11

LANGUAGE: Python
CODE:
```
def git_status():
    """Shows the working tree status"""
    # ... your Python code ...


def git_diff(target: str):
    """Shows differences between branches or commits
    Args:
      target: Shows differences between branches or commits 
    """
    # ... your Python code ...
```
