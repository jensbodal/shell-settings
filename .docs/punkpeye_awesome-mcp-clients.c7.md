TITLE: Install Dolphin-MCP Python Library
DESCRIPTION: This command installs the Dolphin-MCP Python library using pip, the standard package installer for Python. Dolphin-MCP is an open-source multi-server bridging client for MCP, enabling flexible tool usage and resource access with LLMs.
SOURCE: https://github.com/punkpeye/awesome-mcp-clients/blob/main/README.md#_snippet_0

LANGUAGE: bash
CODE:
```
pip install dolphin-mcp
```

----------------------------------------

TITLE: Install MCPOmni Connect CLI
DESCRIPTION: Instructions to install the MCPOmni Connect universal CLI client using `uv` or `pip` package managers. This client provides seamless integration with multiple protocols, AI models, and tools through an intelligent interface.
SOURCE: https://github.com/punkpeye/awesome-mcp-clients/blob/main/README.md#_snippet_1

LANGUAGE: Shell
CODE:
```
uv add mcpomni-connect
```

LANGUAGE: Shell
CODE:
```
pip install mcpomni-connect
```

----------------------------------------

TITLE: Create New Git Branch
DESCRIPTION: This command creates a new Git branch named `add-new-client` and immediately switches to it. This practice helps isolate changes for a specific feature or fix, preventing direct modifications to the main project branch.
SOURCE: https://github.com/punkpeye/awesome-mcp-clients/blob/main/CONTRIBUTING.md#_snippet_0

LANGUAGE: bash
CODE:
```
git checkout -b add-new-client
```

----------------------------------------

TITLE: Commit Git Changes with Message
DESCRIPTION: This command records the staged changes to the local Git repository. The `-m` flag allows for a concise, descriptive commit message, such as "Add new XYZ client", which explains the purpose of the changes.
SOURCE: https://github.com/punkpeye/awesome-mcp-clients/blob/main/CONTRIBUTING.md#_snippet_1

LANGUAGE: bash
CODE:
```
git commit -m "Add new XYZ client"
```

----------------------------------------

TITLE: Push Git Branch to Remote Repository
DESCRIPTION: This command uploads the local `add-new-client` branch and its commits to the `origin` remote repository, which typically refers to your forked GitHub repository. This makes your changes available online and ready for a pull request.
SOURCE: https://github.com/punkpeye/awesome-mcp-clients/blob/main/CONTRIBUTING.md#_snippet_2

LANGUAGE: bash
CODE:
```
git push origin add-new-client
```
