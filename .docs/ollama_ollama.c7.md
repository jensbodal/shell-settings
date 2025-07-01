TITLE: Templating Tool Calling for Mistral/Mixtral in Go
DESCRIPTION: This Go template defines the structure for handling tool calls with Mistral v0.3 and Mixtral 8x22B models in Ollama. It processes user, assistant, and tool roles, embedding available tools for user prompts and formatting tool calls and results for the model.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/template.md#_snippet_3

LANGUAGE: Go
CODE:
```
{{- range $index, $_ := .Messages }}
{{- if eq .Role "user" }}
{{- if and (le (len (slice $.Messages $index)) 2) $.Tools }}[AVAILABLE_TOOLS] {{ json $.Tools }}[/AVAILABLE_TOOLS]
{{- end }}[INST] {{ if and (eq (len (slice $.Messages $index)) 1) $.System }}{{ $.System }}

{{ end }}{{ .Content }}[/INST]
{{- else if eq .Role "assistant" }}
{{- if .Content }} {{ .Content }}</s>
{{- else if .ToolCalls }}[TOOL_CALLS] [
{{- range .ToolCalls }}{"name": "{{ .Function.Name }}", "arguments": {{ json .Function.Arguments }}}
{{- end }}]</s>
{{- end }}
{{- else if eq .Role "tool" }}[TOOL_RESULTS] {"content": {{ .Content }}}[/TOOL_RESULTS]
{{- end }}
{{- end }}
```

----------------------------------------

TITLE: Initializing OpenAI Python Client for Ollama and Performing Chat/Vision Completions
DESCRIPTION: This snippet demonstrates how to configure the OpenAI Python client to interact with a local Ollama instance, setting the `base_url` and a placeholder `api_key`. It then shows two types of chat completions: a text-only interaction with `llama3.2` and a multimodal (vision) interaction with `llava` that includes an image URL.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/openai.md#_snippet_0

LANGUAGE: python
CODE:
```
from openai import OpenAI

client = OpenAI(
    base_url='http://localhost:11434/v1/',

    # required but ignored
    api_key='ollama',
)

chat_completion = client.chat.completions.create(
    messages=[
        {
            'role': 'user',
            'content': 'Say this is a test',
        }
    ],
    model='llama3.2',
)

response = client.chat.completions.create(
    model="llava",
    messages=[
        {
            "role": "user",
            "content": [
                {"type": "text", "text": "What's in this image?"},
                {
                    "type": "image_url",
                    "image_url": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAG0AAABmCAYAAADBPx+VAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAA3VSURBVHgB7Z27r0zdG8fX743i1bi1ikMoFMQloXRpKFFIqI7LH4BEQ0NWIkjQuSWCRIEoULk0gsK1kCBI0IhrQVT7tz/7zZo888yz1r7MnDl7z5xvsjkzs2fP3uu71nNfa7lkAsm7d++Sffv2JbNmzUqcc8m0adOSzZs3Z+/XES4ZckAWJEGWPiCxjsQNLWmQsWjRIpMseaxcuTKpG/7HP27I8P79e7dq1ars/yL4/v27S0ejqwv+cUOGEGGpKHR37tzJCEpHV9tnT58+dXXCJDdECBE2Ojrqjh071hpNECjx4cMHVycM1Uhbv359B2F79+51586daxN/+pyRkRFXKyRDAqxEp4yMlDDzXG1NPnnyJKkThoK0VFd1ELZu3TpzXKxKfW7dMBQ6bcuWLW2v0VlHjx41z717
```

----------------------------------------

TITLE: Sending Multimodal Chat Completion Request with cURL
DESCRIPTION: This `curl` command demonstrates how to send a multimodal chat completion request to the Ollama API, specifically for image analysis. It uses the `llava` model and includes both text and a base64-encoded image URL in the `content` array of the user message. This showcases how to pass image data directly within the JSON payload.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/openai.md#_snippet_20

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llava",
    "messages": [
      {
        "role": "user",
        "content": [
          {
            "type": "text",
            "text": "What's in this image?"
          },
          {
            "type": "image_url",
            "image_url": {
               "url": "data:image/png;base64,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"}
          }
        ]
      }
    ]
  }'
```

----------------------------------------

TITLE: Modelfile Example for Customizing Model Prompt and Parameters
DESCRIPTION: This Modelfile demonstrates how to customize an existing Ollama model by setting parameters like `temperature` and defining a `SYSTEM` prompt, altering the model's behavior and persona.
SOURCE: https://github.com/ollama/ollama/blob/main/README.md#_snippet_7

LANGUAGE: Modelfile
CODE:
```
FROM llama3.2

# set the temperature to 1 [higher is more creative, lower is more coherent]
PARAMETER temperature 1

# set the system message
SYSTEM """
You are Mario from Super Mario Bros. Answer as Mario, the assistant, only.
"""
```

----------------------------------------

TITLE: Ollama Modelfile Instructions Reference
DESCRIPTION: This section provides a reference for all available instructions within an Ollama Modelfile, detailing their purpose and whether they are required. Instructions include `FROM`, `PARAMETER`, `TEMPLATE`, `SYSTEM`, `ADAPTER`, `LICENSE`, and `MESSAGE`.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/modelfile.md#_snippet_1

LANGUAGE: APIDOC
CODE:
```
Instruction: FROM (required)
  Description: Defines the base model to use.
Instruction: PARAMETER
  Description: Sets the parameters for how Ollama will run the model.
Instruction: TEMPLATE
  Description: The full prompt template to be sent to the model.
Instruction: SYSTEM
  Description: Specifies the system message that will be set in the template.
Instruction: ADAPTER
  Description: Defines the (Q)LoRA adapters to apply to the model.
Instruction: LICENSE
  Description: Specifies the legal license.
Instruction: MESSAGE
  Description: Specify message history.
```

----------------------------------------

TITLE: Enable Flash Attention for Ollama Models with `OLLAMA_FLASH_ATTENTION`
DESCRIPTION: Flash Attention is a critical feature for modern models that significantly reduces memory usage, especially as context sizes grow. Enabling it via this environment variable can lead to improved performance and allow for larger contexts.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/faq.md#_snippet_20

LANGUAGE: APIDOC
CODE:
```
Environment Variable: OLLAMA_FLASH_ATTENTION
  Type: number
  Description: Enables Flash Attention for most modern models to significantly reduce memory usage as context size grows.
  Value: 1 (to enable)
```

----------------------------------------

TITLE: Creating Multimodal Chat Completion with Ollama (JavaScript)
DESCRIPTION: This snippet demonstrates how to perform a multimodal chat completion using the OpenAI client with Ollama, specifically utilizing the llava model. It sends both a text prompt and an image URL (base64 encoded) as part of the user's message. This allows the model to interpret and respond based on both textual and visual input.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/openai.md#_snippet_7

LANGUAGE: JavaScript
CODE:
```
const response = await openai.chat.completions.create({
    model: "llava",
    messages: [
        {
        role: "user",
        content: [
            { type: "text", text: "What's in this image?" },
            {
            type: "image_url",
            image_url: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAG0AAABmCAYAAADBPx+VAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAA3VSURBVHgB7Z27r0zdG8fX743i1bi1ikMoFMQloXRpKFFIqI7LH4BEQ+NWIkjQuSWCRIEoULk0gsK
```

----------------------------------------

TITLE: Generate a Completion API Endpoint Definition
DESCRIPTION: Defines the `POST /api/generate` endpoint for generating text completions. It outlines all required and optional parameters, including model selection, prompt input, image support for multimodal models, and advanced controls for formatting (JSON, schema), model options, system messages, prompt templates, streaming behavior, raw input, model keep-alive duration, and conversational context.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_0

LANGUAGE: APIDOC
CODE:
```
POST /api/generate

Description: Generate a response for a given prompt with a provided model. This is a streaming endpoint, so there will be a series of responses. The final response object will include statistics and additional data from the request.

Parameters:
- model: (required) the model name
- prompt: the prompt to generate a response for
- suffix: the text after the model response
- images: (optional) a list of base64-encoded images (for multimodal models such as llava)
- think: (for thinking models) should the model think before responding?

Advanced parameters (optional):
- format: the format to return a response in. Format can be json or a JSON schema
- options: additional model parameters listed in the documentation for the Modelfile such as temperature
- system: system message to (overrides what is defined in the Modelfile)
- template: the prompt template to use (overrides what is defined in the Modelfile)
- stream: if false the response will be returned as a single response object, rather than a stream of objects
- raw: if true no formatting will be applied to the prompt. You may choose to use the raw parameter if you are specifying a full templated prompt in your request to the API
- keep_alive: controls how long the model will stay loaded into memory following the request (default: 5m)
- context (deprecated): the context parameter returned from a previous request to /generate, this can be used to keep a short conversational memory

Structured Outputs: Supported by providing a JSON schema in the 'format' parameter.
JSON Mode: Enable by setting the 'format' parameter to 'json'.
```

----------------------------------------

TITLE: Generate a Completion Request and Response Examples
DESCRIPTION: Illustrates how to make requests to the `/api/generate` endpoint using `curl`. Includes examples for both streaming responses, where partial JSON objects are returned, and non-streaming responses, where a single complete JSON object is returned after generation. Also details the structure of the JSON responses.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_1

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt": "Why is the sky blue?"
}'
```

LANGUAGE: json
CODE:
```
{
  "model": "llama3.2",
  "created_at": "2023-08-04T08:52:19.385406455-07:00",
  "response": "The",
  "done": false
}
```

LANGUAGE: json
CODE:
```
{
  "model": "llama3.2",
  "created_at": "2023-08-04T19:22:45.499127Z",
  "response": "",
  "done": true,
  "context": [1, 2, 3],
  "total_duration": 10706818083,
  "load_duration": 6338219291,
  "prompt_eval_count": 26,
  "prompt_eval_duration": 130079000,
  "eval_count": 259,
  "eval_duration": 4232710000
}
```

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt": "Why is the sky blue?",
  "stream": false
}'
```

----------------------------------------

TITLE: API Reference: Generate Chat Completion Endpoint
DESCRIPTION: Documents the `/api/chat` endpoint for generating chat completions, detailing its HTTP method, streaming behavior, and the structure of requests and responses.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_12

LANGUAGE: APIDOC
CODE:
```
POST /api/chat

Generate the next message in a chat with a provided model. This is a streaming endpoint, so there will be a series of responses. Streaming can be disabled using "stream": false. The final response object will include statistics and additional data from the request.
```

----------------------------------------

TITLE: Allow Cross-Origin Requests for Ollama
DESCRIPTION: This snippet demonstrates how to configure Ollama to accept cross-origin requests from specific browser extension patterns by setting the OLLAMA_ORIGINS environment variable. This is crucial for integrating Ollama with browser-based applications or extensions.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/faq.md#_snippet_13

LANGUAGE: shell
CODE:
```
# Allow all Chrome, Firefox, and Safari extensions
OLLAMA_ORIGINS=chrome-extension://*,moz-extension://*,safari-web-extension://* ollama serve
```

----------------------------------------

TITLE: Manage Message History in Modelfile
DESCRIPTION: The `MESSAGE` instruction allows you to specify a message history for the model to use when responding. Use multiple iterations of the `MESSAGE` command to build up a conversation which will guide the model to answer in a similar way. Each message requires a role and the message content.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/modelfile.md#_snippet_16

LANGUAGE: Modelfile
CODE:
```
MESSAGE <role> <message>
```

LANGUAGE: Modelfile
CODE:
```
MESSAGE user Is Toronto in Canada?
MESSAGE assistant yes
MESSAGE user Is Sacramento in Canada?
MESSAGE assistant no
MESSAGE user Is Ontario in Canada?
MESSAGE assistant yes
```

----------------------------------------

TITLE: Quantizing Ollama Model with `ollama create`
DESCRIPTION: This shell command quantizes an existing FP16 or FP32 model into a specified quantization level, such as `q4_K_M`. The `--quantize` flag is used with `ollama create` to perform the quantization during model creation, reducing memory footprint and improving speed.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/import.md#_snippet_10

LANGUAGE: Shell
CODE:
```
ollama create --quantize q4_K_M mymodel
```

----------------------------------------

TITLE: Send Chat Message with Conversation History (Ollama API)
DESCRIPTION: Demonstrates how to include previous messages in a chat request to maintain conversation history. This approach can also be used to initialize a conversation with multi-shot or chain-of-thought prompting.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_17

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.2",
  "messages": [
    {
      "role": "user",
      "content": "why is the sky blue?"
    },
    {
      "role": "assistant",
      "content": "due to rayleigh scattering."
    },
    {
      "role": "user",
      "content": "how is that different than mie scattering?"
    }
  ]
}'
```

----------------------------------------

TITLE: Ollama Generate API Request and Response in JSON Mode
DESCRIPTION: Illustrates the use of `format: "json"` to guarantee a well-formed JSON object as the model's output. It emphasizes the importance of also instructing the model via the `prompt` to respond in JSON for optimal results, ensuring the `response` field contains a directly parseable JSON string.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_5

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt": "What color is the sky at different times of the day? Respond using JSON",
  "format": "json",
  "stream": false
}'
```

LANGUAGE: json
CODE:
```
{
  "model": "llama3.2",
  "created_at": "2023-11-09T21:07:55.186497Z",
  "response": "{\n\"morning\": {\n\"color\": \"blue\"\n},\n\"noon\": {\n\"color\": \"blue-gray\"\n},\n\"afternoon\": {\n\"color\": \"warm gray\"\n},\n\"evening\": {\n\"color\": \"orange\"\n}\n}",
  "done": true,
  "context": [1, 2, 3],
  "total_duration": 4648158584,
  "load_duration": 4071084,
  "prompt_eval_count": 36,
  "prompt_eval_duration": 439038000,
  "eval_count": 180,
  "eval_duration": 4196918000
}
```

LANGUAGE: json
CODE:
```
{
  "morning": {
    "color": "blue"
  },
  "noon": {
    "color": "blue-gray"
  },
  "afternoon": {
    "color": "warm gray"
  },
  "evening": {
    "color": "orange"
  }
}
```

----------------------------------------

TITLE: Initializing OpenAI Client and Creating Text Chat Completion with Ollama (JavaScript)
DESCRIPTION: This snippet demonstrates how to initialize the OpenAI client to connect to a local Ollama instance and then create a basic text-based chat completion. It sets the baseURL to Ollama's API endpoint and uses a placeholder apiKey as required by the library but ignored by Ollama. The create method sends a user message to the specified llama3.2 model.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/openai.md#_snippet_6

LANGUAGE: JavaScript
CODE:
```
import OpenAI from 'openai'

const openai = new OpenAI({
  baseURL: 'http://localhost:11434/v1/',

  // required but ignored
  apiKey: 'ollama',
})

const chatCompletion = await openai.chat.completions.create({
    messages: [{ role: 'user', content: 'Say this is a test' }],
    model: 'llama3.2',
})
```

----------------------------------------

TITLE: Generating Text via Ollama API (PowerShell)
DESCRIPTION: This PowerShell command demonstrates how to interact with the Ollama API to generate text. It sends a POST request to the `/api/generate` endpoint with a specified model, prompt, and streaming preference, then parses the JSON response. This allows programmatic access to Ollama's text generation capabilities.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/windows.md#_snippet_1

LANGUAGE: powershell
CODE:
```
(Invoke-WebRequest -method POST -Body '{"model":"llama3.2", "prompt":"Why is the sky blue?", "stream": false}' -uri http://localhost:11434/api/generate ).Content | ConvertFrom-json
```

----------------------------------------

TITLE: Configure Ollama as a systemd service
DESCRIPTION: Defines the systemd service unit file for Ollama, ensuring it starts automatically on boot and restarts if it crashes. This configuration specifies the executable path, user, group, and restart policy for the service.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/linux.md#_snippet_7

LANGUAGE: ini
CODE:
```
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
ExecStart=/usr/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="PATH=$PATH"

[Install]
WantedBy=multi-user.target
```

----------------------------------------

TITLE: Generating Text Embeddings using OpenAI API - JavaScript
DESCRIPTION: This snippet demonstrates how to generate vector embeddings for given text inputs using the `openai.embeddings.create` method. It specifies the embedding model ("all-minilm") and an array of strings to embed. The method returns an embedding object containing the vector representations for each input string.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/openai.md#_snippet_11

LANGUAGE: JavaScript
CODE:
```
const embedding = await openai.embeddings.create({
  model: "all-minilm",
  input: ["why is the sky blue?", "why is the grass green?"],
})
```

----------------------------------------

TITLE: Adding Llama 3 Chat Template to Modelfile
DESCRIPTION: This Dockerfile snippet illustrates how to embed a complex chat template for Meta's Llama 3 directly into an Ollama Modelfile using the `TEMPLATE` command. It includes conditional rendering for a system prompt and iterates through messages, formatting them with specific Llama 3 tokens like `<|start_header_id|>` and `<|eot_id|>`. This ensures proper prompt construction for chat models, adhering to the model's expected input format.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/template.md#_snippet_1

LANGUAGE: Dockerfile
CODE:
```
FROM llama3.2

TEMPLATE """{{- if .System }}<|start_header_id|>system<|end_header_id|>

{{ .System }}<|eot_id|>
{{- end }}
{{- range .Messages }}<|start_header_id|>{{ .Role }}<|end_header_id|>

{{ .Content }}<|eot_id|>
{{- end }}<|start_header_id|>assistant<|end_header_id|>

"""
```

----------------------------------------

TITLE: Download and Run Specific Models from Ollama Library
DESCRIPTION: These commands demonstrate how to download and run various large language models available in the Ollama library using the `ollama run` command, specifying the model name and optionally its version or size.
SOURCE: https://github.com/ollama/ollama/blob/main/README.md#_snippet_2

LANGUAGE: shell
CODE:
```
ollama run gemma3:1b
```

LANGUAGE: shell
CODE:
```
ollama run gemma3
```

LANGUAGE: shell
CODE:
```
ollama run gemma3:12b
```

LANGUAGE: shell
CODE:
```
ollama run gemma3:27b
```

LANGUAGE: shell
CODE:
```
ollama run qwq
```

LANGUAGE: shell
CODE:
```
ollama run deepseek-r1
```

LANGUAGE: shell
CODE:
```
ollama run deepseek-r1:671b
```

LANGUAGE: shell
CODE:
```
ollama run llama4:scout
```

LANGUAGE: shell
CODE:
```
ollama run llama4:maverick
```

LANGUAGE: shell
CODE:
```
ollama run llama3.3
```

LANGUAGE: shell
CODE:
```
ollama run llama3.2
```

LANGUAGE: shell
CODE:
```
ollama run llama3.2:1b
```

LANGUAGE: shell
CODE:
```
ollama run llama3.2-vision
```

LANGUAGE: shell
CODE:
```
ollama run llama3.2-vision:90b
```

LANGUAGE: shell
CODE:
```
ollama run llama3.1
```

LANGUAGE: shell
CODE:
```
ollama run llama3.1:405b
```

LANGUAGE: shell
CODE:
```
ollama run phi4
```

LANGUAGE: shell
CODE:
```
ollama run phi4-mini
```

LANGUAGE: shell
CODE:
```
ollama run mistral
```

LANGUAGE: shell
CODE:
```
ollama run moondream
```

LANGUAGE: shell
CODE:
```
ollama run neural-chat
```

LANGUAGE: shell
CODE:
```
ollama run starling-lm
```

LANGUAGE: shell
CODE:
```
ollama run codellama
```

LANGUAGE: shell
CODE:
```
ollama run llama2-uncensored
```

LANGUAGE: shell
CODE:
```
ollama run llava
```

LANGUAGE: shell
CODE:
```
ollama run granite3.3
```

----------------------------------------

TITLE: Ollama Chat Request with Tool Calling
DESCRIPTION: Illustrates a chat request where the Ollama model uses a defined tool ('get_current_weather') based on the user's prompt, showing both the `curl` request with tool definition and the model's `tool_calls` in the JSON response.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_51

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.2",
  "messages": [
    {
      "role": "user",
      "content": "What is the weather today in Paris?"
    }
  ],
  "stream": false,
  "tools": [
    {
      "type": "function",
      "function": {
        "name": "get_current_weather",
        "description": "Get the current weather for a location",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {
              "type": "string",
              "description": "The location to get the weather for, e.g. San Francisco, CA"
            },
            "format": {
              "type": "string",
              "description": "The format to return the weather in, e.g. 'celsius' or 'fahrenheit'",
              "enum": ["celsius", "fahrenheit"]
            }
          },
          "required": ["location", "format"]
        }
      }
    }
  ]
}'
```

LANGUAGE: json
CODE:
```
{
  "model": "llama3.2",
  "created_at": "2024-07-22T20:33:28.123648Z",
  "message": {
    "role": "assistant",
    "content": "",
    "tool_calls": [
      {
        "function": {
          "name": "get_current_weather",
          "arguments": {
            "format": "celsius",
            "location": "Paris, FR"
          }
        }
      }
    ]
  },
  "done_reason": "stop",
  "done": true,
  "total_duration": 885095291,
  "load_duration": 3753500,
  "prompt_eval_count": 122,
  "prompt_eval_duration": 328493000,
  "eval_count": 33,
  "eval_duration": 552222000
}
```

----------------------------------------

TITLE: Install Ollama on Linux
DESCRIPTION: This command downloads and executes the official Ollama installation script for Linux systems, setting up the necessary components to run large language models.
SOURCE: https://github.com/ollama/ollama/blob/main/README.md#_snippet_0

LANGUAGE: shell
CODE:
```
curl -fsSL https://ollama.com/install.sh | sh
```

----------------------------------------

TITLE: Quickstart: Run Gemma 3 Model
DESCRIPTION: This command quickly starts and allows interaction with the Gemma 3 large language model using Ollama, demonstrating the basic usage for running models from the library.
SOURCE: https://github.com/ollama/ollama/blob/main/README.md#_snippet_1

LANGUAGE: shell
CODE:
```
ollama run gemma3
```

----------------------------------------

TITLE: Install Ollama on Linux using the quick script
DESCRIPTION: Provides a single command to quickly install Ollama on Linux systems by downloading and executing the official install script. This method is recommended for most users for a straightforward setup.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/linux.md#_snippet_0

LANGUAGE: shell
CODE:
```
curl -fsSL https://ollama.com/install.sh | sh
```

----------------------------------------

TITLE: Ollama Chat API Parameters Reference
DESCRIPTION: Defines the various parameters available for the Ollama `/api/chat` endpoint, including required fields, message object structure, and advanced options for controlling response format and model behavior.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_13

LANGUAGE: APIDOC
CODE:
```
Parameters:
  model: (required) The model name to use.
  messages: The messages of the chat, used for chat memory.
  tools: List of tools in JSON for the model to use if supported.
  think: (for thinking models) Should the model think before responding?

Message Object Fields:
  role: The role of the message, either `system`, `user`, `assistant`, or `tool`.
  content: The content of the message.
  thinking: (for thinking models) The model's thinking process.
  images (optional): A list of images to include in the message (for multimodal models such as `llava`).
  tool_calls (optional): A list of tools in JSON that the model wants to use.

Advanced Parameters (optional):
  format: The format to return a response in. Can be `json` or a JSON schema.
  options: Additional model parameters from Modelfile documentation (e.g., `temperature`).
  stream: If `false`, the response will be returned as a single object (default: `true` for streaming).
  keep_alive: Controls how long the model stays loaded in memory after the request (default: `5m`).
```

----------------------------------------

TITLE: Ollama Chat Request for Reproducible Outputs
DESCRIPTION: Demonstrates how to make a chat request to the Ollama API with reproducible outputs by setting the 'seed' and 'temperature' options in the request payload, followed by the expected JSON response.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_50

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.2",
  "messages": [
    {
      "role": "user",
      "content": "Hello!"
    }
  ],
  "options": {
    "seed": 101,
    "temperature": 0
  }
}'
```

LANGUAGE: json
CODE:
```
{
  "model": "llama3.2",
  "created_at": "2023-12-12T14:13:43.416799Z",
  "message": {
    "role": "assistant",
    "content": "Hello! How are you today?"
  },
  "done": true,
  "total_duration": 5191566416,
  "load_duration": 2154458,
  "prompt_eval_count": 26,
  "prompt_eval_duration": 383809000,
  "eval_count": 298,
  "eval_duration": 4799921000
}
```

----------------------------------------

TITLE: Creating Text Completion using OpenAI API - JavaScript
DESCRIPTION: This snippet demonstrates how to create a text completion using the `openai.completions.create` method. It specifies the AI model to use ("llama3.2") and the input prompt ("Say this is a test."). The method returns a completion object containing the generated text.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/openai.md#_snippet_8

LANGUAGE: JavaScript
CODE:
```
const completion = await openai.completions.create({
    model: "llama3.2",
    prompt: "Say this is a test.",
})
```

----------------------------------------

TITLE: Send Chat Message with Streaming Response (Ollama API)
DESCRIPTION: Demonstrates how to send a chat message to the Ollama API and receive a streaming response, where JSON objects are returned incrementally as the model generates content. This allows for real-time display of the assistant's reply.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_14

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.2",
  "messages": [
    {
      "role": "user",
      "content": "why is the sky blue?"
    }
  ]
}'
```

LANGUAGE: json
CODE:
```
{
  "model": "llama3.2",
  "created_at": "2023-08-04T08:52:19.385406455-07:00",
  "message": {
    "role": "assistant",
    "content": "The",
    "images": null
  },
  "done": false
}
```

LANGUAGE: json
CODE:
```
{
  "model": "llama3.2",
  "created_at": "2023-08-04T19:22:45.499127Z",
  "message": {
    "role": "assistant",
    "content": ""
  },
  "done": true,
  "total_duration": 4883583458,
  "load_duration": 1334875,
  "prompt_eval_count": 26,
  "prompt_eval_duration": 342546000,
  "eval_count": 282,
  "eval_duration": 4535599000
}
```

----------------------------------------

TITLE: Requesting Text Embeddings via HTTP
DESCRIPTION: This curl command sends a POST request to the Ollama runner's /embedding endpoint. It includes a JSON payload with a 'prompt' to be converted into a numerical embedding vector by the loaded model.
SOURCE: https://github.com/ollama/ollama/blob/main/runner/README.md#_snippet_2

LANGUAGE: shell
CODE:
```
curl -X POST -H "Content-Type: application/json" -d '{"prompt": "turn me into an embedding"}' http://localhost:8080/embedding
```

----------------------------------------

TITLE: Example Ollama Multi-Turn Prompt Template
DESCRIPTION: This code snippet provides an example of a `TEMPLATE` definition for an Ollama model, utilizing Go template syntax. It demonstrates how to structure a multi-turn conversation, including optional system messages, user prompts, and the assistant's response, using specific start/end tokens.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/modelfile.md#_snippet_12

LANGUAGE: Go Template
CODE:
```
TEMPLATE """{{ if .System }}<|im_start|>system
{{ .System }}<|im_end|>
{{ end }}{{ if .Prompt }}<|im_start|>user
{{ .Prompt }}<|im_end|>
{{ end }}<|im_start|>assistant
"""
```

----------------------------------------

TITLE: Ollama Generate API Request and Response for Structured JSON Output
DESCRIPTION: Explains how to guide the Ollama model to produce structured JSON output by defining a JSON schema within the `format` parameter. This ensures the model's response adheres to specific data types and required fields, useful for programmatic consumption of model outputs.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_4

LANGUAGE: shell
CODE:
```
curl -X POST http://localhost:11434/api/generate -H "Content-Type: application/json" -d '{
  "model": "llama3.1:8b",
  "prompt": "Ollama is 22 years old and is busy saving the world. Respond using JSON",
  "stream": false,
  "format": {
    "type": "object",
    "properties": {
      "age": {
        "type": "integer"
      },
      "available": {
        "type": "boolean"
      }
    },
    "required": [
      "age",
      "available"
    ]
  }
}'
```

LANGUAGE: json
CODE:
```
{
  "model": "llama3.1:8b",
  "created_at": "2024-12-06T00:48:09.983619Z",
  "response": "{\n  \"age\": 22,\n  \"available\": true\n}",
  "done": true,
  "done_reason": "stop",
  "context": [1, 2, 3],
  "total_duration": 1075509083,
  "load_duration": 567678166,
  "prompt_eval_count": 28,
  "prompt_eval_duration": 236000000,
  "eval_count": 16,
  "eval_duration": 269000000
}
```

----------------------------------------

TITLE: Generate Embeddings via Ollama API
DESCRIPTION: This endpoint generates embeddings for given text inputs using a specified model. It supports both single and multiple text inputs, with options for truncation and model parameters. This is the recommended endpoint for embedding generation.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/api.md#_snippet_44

LANGUAGE: APIDOC
CODE:
```
POST /api/embed
Description: Generate embeddings from a model
Parameters:
  - model (string, required): Name of model to generate embeddings from.
  - input (string or array of strings, required): Text or list of text to generate embeddings for.
Advanced parameters:
  - truncate (boolean, optional, default: true): Truncates the end of each input to fit within context length. Returns error if false and context length is exceeded.
  - options (object, optional): Additional model parameters (e.g., temperature) as listed in Modelfile documentation.
  - keep_alive (string, optional, default: '5m'): Controls how long the model will stay loaded into memory following the request.
```

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/api/embed -d '{
  "model": "all-minilm",
  "input": "Why is the sky blue?"
}'
```

LANGUAGE: json
CODE:
```
{
  "model": "all-minilm",
  "embeddings": [[
    0.010071029, -0.0017594862, 0.05007221, 0.04692972, 0.054916814,
    0.008599704, 0.105441414, -0.025878139, 0.12958129, 0.031952348
  ]],
  "total_duration": 14143917,
  "load_duration": 1019500,
  "prompt_eval_count": 8
}
```

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/api/embed -d '{
  "model": "all-minilm",
  "input": ["Why is the sky blue?", "Why is the grass green?"]
}'
```

LANGUAGE: json
CODE:
```
{
  "model": "all-minilm",
  "embeddings": [[
    0.010071029, -0.0017594862, 0.05007221, 0.04692972, 0.054916814,
    0.008599704, 0.105441414, -0.025878139, 0.12958129, 0.031952348
  ],[
    -0.0098027075, 0.06042469, 0.025257962, -0.006364387, 0.07272725,
    0.017194884, 0.09032035, -0.051705178, 0.09951512, 0.09072481
  ]]
}
```

----------------------------------------

TITLE: Sending Text-Only Chat Completion Request with cURL
DESCRIPTION: This `curl` command demonstrates how to send a text-based chat completion request to the Ollama API. It specifies the `llama3.2` model and includes a system message and a user message in the JSON payload. The request uses `Content-Type: application/json` and targets the `/v1/chat/completions` endpoint.
SOURCE: https://github.com/ollama/ollama/blob/main/docs/openai.md#_snippet_19

LANGUAGE: shell
CODE:
```
curl http://localhost:11434/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
        "model": "llama3.2",
        "messages": [
            {
                "role": "system",
                "content": "You are a helpful assistant."
            },
            {
                "role": "user",
                "content": "Hello!"
            }
        ]
    }'
```
