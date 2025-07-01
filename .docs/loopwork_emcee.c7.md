TITLE: emcee Command Line Interface Usage and Flags
DESCRIPTION: This section documents the command-line usage for the `emcee` tool, detailing its general syntax and available flags. It covers options for various authentication methods, request handling parameters (retries, requests per second, timeout), logging verbosity, and standard help/version information, providing a comprehensive reference for running `emcee`.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_6

LANGUAGE: APIDOC
CODE:
```
Usage:
  emcee [spec-path-or-url] [flags]

Flags:
      --basic-auth string    Basic auth value (either user:pass or base64 encoded, will be prefixed with 'Basic ')
      --bearer-auth string   Bearer token value (will be prefixed with 'Bearer ')
  -h, --help                 help for emcee
      --raw-auth string      Raw value for Authorization header
      --retries int          Maximum number of retries for failed requests (default 3)
  -r, --rps int              Maximum requests per second (0 for no limit)
  -s, --silent               Disable all logging
      --timeout duration     HTTP request timeout (default 1m0s)
  -v, --verbose              Enable debug level logging to stderr
      --version              version for emcee
```

----------------------------------------

TITLE: Install emcee via Homebrew
DESCRIPTION: This command installs the emcee tool on macOS using Homebrew. It leverages Loopwork's custom tap to access the emcee formula, providing a quick and easy installation method for users.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
brew install loopwork/tap/emcee
```

----------------------------------------

TITLE: Install emcee using Installer Script
DESCRIPTION: These commands download and execute the emcee installer script, providing a convenient way to install pre-built releases for various platforms. The `fish` shell version uses `psub` for process substitution, while `bash` and `zsh` use standard process substitution to pipe the script directly to `sh`.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_3

LANGUAGE: bash
CODE:
```
sh (curl -fsSL https://get.emcee.sh | psub)
```

LANGUAGE: bash
CODE:
```
sh <(curl -fsSL https://get.emcee.sh)
```

----------------------------------------

TITLE: Run emcee using Docker
DESCRIPTION: This command pulls and runs the pre-built emcee Docker image interactively. It provides a containerized environment for using emcee without requiring a local installation, isolating its dependencies.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_4

LANGUAGE: bash
CODE:
```
docker run -it ghcr.io/loopwork/emcee
```

----------------------------------------

TITLE: Build emcee from Go Source
DESCRIPTION: These commands clone the emcee Git repository, navigate into the project directory, and then build the executable using the Go compiler. This method requires Go 1.24 or later and allows users to compile emcee directly from its source code.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_5

LANGUAGE: bash
CODE:
```
git clone https://github.com/loopwork/emcee.git
cd emcee
go build -o emcee cmd/emcee/main.go
```

----------------------------------------

TITLE: emcee Authentication Methods
DESCRIPTION: Details the various authentication types supported by emcee, including Bearer Token, Basic Auth, and Raw Value, along with their example usage and resulting HTTP headers. These methods allow emcee to securely access protected APIs.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_7

LANGUAGE: APIDOC
CODE:
```
Authentication Type | Example Usage                | Resulting Header
-------------------|------------------------------|-----------------------------------
Bearer Token       | `--bearer-auth="abc123"`     | `Authorization: Bearer abc123`
Basic Auth         | `--basic-auth="user:pass"`   | `Authorization: Basic dXNlcjpwYXNz`
Raw Value          | `--raw-auth="Custom xyz789"` | `Authorization: Custom xyz789`
```

----------------------------------------

TITLE: JSON-RPC Request: List Tools
DESCRIPTION: A standard JSON-RPC 2.0 request payload used to query the MCP server for a list of all available tools. This request has no parameters and is identified by `id: 1`.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_11

LANGUAGE: json
CODE:
```
{ "jsonrpc": "2.0", "method": "tools/list", "params": {}, "id": 1 }
```

----------------------------------------

TITLE: JSON-RPC Response: List Tools
DESCRIPTION: An example JSON-RPC 2.0 response from the MCP server, detailing the structure for listing tools. It includes information for each tool such as its `name`, `description`, and `inputSchema` (e.g., for the 'tafs' tool, specifying `stationId`).
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_12

LANGUAGE: jsonc
CODE:
```
{
  "jsonrpc": "2.0",
  "result": {
    "tools": [
      // ...
      {
        "name": "tafs",
        "description": "Returns Terminal Aerodrome Forecasts for the specified airport station.",
        "inputSchema": {
          "type": "object",
          "properties": {
            "stationId": {
              "description": "Observation station ID",
              "type": "string"
            }
          },
          "required": ["stationId"]
        }
      }
      // ...
    ]
  },
  "id": 1
}
```

----------------------------------------

TITLE: JSON-RPC Request: Call Tool
DESCRIPTION: A JSON-RPC 2.0 request payload to invoke a specific tool on the MCP server. This example demonstrates calling the 'taf' tool with the `stationId` argument set to 'KPDX'.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_13

LANGUAGE: json
CODE:
```
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": { "name": "taf", "arguments": { "stationId": "KPDX" } },
  "id": 1
}
```

----------------------------------------

TITLE: JSON-RPC Response: Call Tool
DESCRIPTION: An example JSON-RPC 2.0 response received after successfully calling a tool. This response includes the `content` generated by the tool (e.g., weather forecast in GeoJSON format) and any associated `annotations`.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_14

LANGUAGE: jsonc
CODE:
```
{
  "jsonrpc":"2.0",
  "content": [
    {
      "type": "text",
      "text": /* Weather forecast in GeoJSON format */,
      "annotations": {
        "audience": ["assistant"]
      }
    }
  ],
  "id": 1
}
```

----------------------------------------

TITLE: Filter OpenAPI Specification with jq
DESCRIPTION: Demonstrates how to use the `jq` command-line JSON processor to filter an OpenAPI specification. This example specifically selects only the `/points/{point}` path from `weather.gov`'s OpenAPI file before piping the modified specification to `emcee`.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_10

LANGUAGE: console
CODE:
```
cat path/to/openapi.json | \
  jq 'if .paths then .paths |= with_entries(select(.key == "/points/{point}")) else . end' | \
  emcee
```

----------------------------------------

TITLE: Launch MCP Inspector for Debugging
DESCRIPTION: Commands to launch the MCP Inspector, a tool for testing and debugging MCP servers. The first command starts the inspector, linking it to an emcee instance and an OpenAPI specification. The second command opens the inspector's web interface in a browser.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_15

LANGUAGE: console
CODE:
```
npx @modelcontextprotocol/inspector emcee https://api.weather.gov/openapi.json
open http://localhost:5173
```

----------------------------------------

TITLE: Configure Claude Desktop for emcee MCP Server
DESCRIPTION: This JSON configuration snippet adds a new Model Context Protocol (MCP) server entry for `weather.gov` to Claude Desktop. It specifies `emcee` as the command to run with the OpenAPI specification URL for weather data, enabling Claude to interact with external weather services through the defined tool.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_2

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "weather": {
      "command": "emcee",
      "args": ["https://api.weather.gov/openapi.json"]
    }
  }
}
```

----------------------------------------

TITLE: Open Claude Desktop Configuration File in VSCode
DESCRIPTION: This command opens the Claude Desktop configuration file directly in VSCode. It provides a convenient way for developers to access and modify the `claude_desktop_config.json` file located in the application's support directory for custom settings.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_1

LANGUAGE: bash
CODE:
```
code ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

----------------------------------------

TITLE: Install and Sign In to 1Password CLI
DESCRIPTION: Commands to install the 1Password CLI using Homebrew and then sign in. This step is crucial for emcee to access secrets stored in 1Password vaults when using `op://` references for authentication.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_8

LANGUAGE: console
CODE:
```
brew install 1password-cli

op signin
```

----------------------------------------

TITLE: Configure emcee with 1Password Secret Reference
DESCRIPTION: An example JSON configuration for emcee's `mcpServers` section, demonstrating how to use a 1Password secret reference (`op://shared/x/credential`) for bearer authentication when defining an OpenAPI specification endpoint.
SOURCE: https://github.com/loopwork/emcee/blob/main/README.md#_snippet_9

LANGUAGE: json
CODE:
```
{
  "mcpServers": {
    "twitter": {
      "command": "emcee",
      "args": [
        "--bearer-auth=op://shared/x/credential",
        "https://api.twitter.com/2/openapi.json"
      ]
    }
  }
}
```
