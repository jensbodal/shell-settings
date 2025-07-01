TITLE: Handle Chat Message Processing and Streaming
DESCRIPTION: This asynchronous block manages the lifecycle of a chat message, from initial user input to displaying the streamed AI response. It integrates RAG for user messages, fetches chat completions, handles streaming updates, renders markdown, and manages UI state (loading, success, failure, abortion).
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_23

LANGUAGE: JavaScript
CODE:
```
(message.role === "user" && typeof message.content === "string") { message.content = await this.searchRag(this.settings.rag, message.content); } } const stream = await fetchChatCompletions(CHAT_COMPLETIONS_URL, body, this.askAbortController.signal) for await (const chunk of stream) { lastMessage.state = "streaming"; lastMessage.content += chunk?.choices[0]?.delta?.content || ""; lastMessage.html = renderMarkdown(lastMessage.content, lastMessage.error); this.$nextTick(() => { this.autoScrollChatBodyToBottom(); }); } lastMessage.state = "succeed"; succeed = true; } catch (err) { lastMessage.state = "failed"; if (this.askAbortController?.signal?.aborted) { lastMessage.error = "Error: Aborted"; } else { lastMessage.error = err?.message || err; } lastMessage.html = renderMarkdown(lastMessage.content, lastMessage.error); } if (succeed) { this.sessionMode = true; } this.asking = false; },
```

----------------------------------------

TITLE: Fetch and Stream Chat Completions from API in JavaScript
DESCRIPTION: Sends a POST request to a chat completions API endpoint. It supports both streaming and non-streaming responses. For streaming, it reads the response body in chunks, decodes them, handles partial lines, and yields parsed JSON objects. It also manages abortion signals and throws errors for non-OK responses.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/arena.html#_snippet_24

LANGUAGE: JavaScript
CODE:
```
async function* fetchChatCompletions(url, body, signal) {
  const stream = body.stream;
  const response = await fetch(url, {
    method: "POST",
    signal,
    headers: getHeaders(),
    body: JSON.stringify(body),
  });
  if (!response.ok) {
    const error = await response.json();
    throw error?.error || error;
  }
  if (!stream) {
    const data = await response.json();
    return data;
  }
  const reader = response.body.getReader();
  const decoder = new TextDecoder();
  let done = false;
  let reamingChunkValue = "";
  while (!done) {
    if (signal?.aborted) {
      reader.cancel();
      break;
    }
    const { value, done: doneReading } = await reader.read();
    done = doneReading;
    const chunkValue = decoder.decode(value);
    const lines = (reamingChunkValue + chunkValue).split("\n").filter(line => line.trim().length > 0);
    reamingChunkValue = "";
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const message = line.replace(/^data: /, "");
      if (message === "[DONE]") {
        continue
      }
      try {
        const parsed = JSON.parse(message);
        yield parsed;
      } catch {
        if (i === lines.length - 1) {
          reamingChunkValue += line;
          break;
        }
      }
    }
  }
}
```

----------------------------------------

TITLE: Fetch Chat Completions with Streaming
DESCRIPTION: This asynchronous generator function handles fetching chat completions, supporting both streaming and non-streaming responses. It sends a POST request with a JSON body, manages abort signals, and parses Server-Sent Events (SSE) for streaming, yielding each parsed chunk. It also includes error handling for network issues or API errors.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_27

LANGUAGE: JavaScript
CODE:
```
async function* fetchChatCompletions(url, body, signal) { const stream = body.stream; const response = await fetch(url, { method: "POST", signal, headers: getHeaders(), body: JSON.stringify(body), }); if (!response.ok) { const error = await response.json(); throw error?.error || error; } if (!stream) { const data = await response.json(); return data; } const reader = response.body.getReader(); const decoder = new TextDecoder(); let done = false; let reamingChunkValue = ""; while (!done) { if (signal?.aborted) { reader.cancel(); break; } const { value, done: doneReading } = await reader.read(); done = doneReading; const chunkValue = decoder.decode(value); const lines = (reamingChunkValue + chunkValue).split("\n").filter(line => line.trim().length > 0); reamingChunkValue = ""; for (let i = 0; i < lines.length; i++) { const line = lines[i]; const message = line.replace(/^data: /, ""); if (message === "[DONE]") { continue } try { const parsed = JSON.parse(message); yield parsed; } catch { if (i === lines.length - 1) { reamingChunkValue += line; break; } } } } }
```

----------------------------------------

TITLE: Send Chat Completion Request and Stream Response in JavaScript
DESCRIPTION: Initiates a chat completion request to an AI model, handling streaming responses. It manages the chat state, updates the last message content incrementally, renders markdown, and handles errors and abortion signals. It also ensures the chat body scrolls to the bottom as new content arrives.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/arena.html#_snippet_21

LANGUAGE: JavaScript
CODE:
```
async ask(index) {
  const chat = this.chats[index];
  chat.askAbortController = new AbortController();
  chat.shouldScrollChatBodyToBottom = true;
  this.$nextTick(() => {
    this.autoScrollChatBodyToBottom(index);
  });
  const lastMessage = chat.messages[chat.messages.length - 1];
  const body = this.buildBody(index);
  let succeed = false;
  try {
    const stream = await fetchChatCompletions(CHAT_COMPLETIONS_URL, body, chat.askAbortController.signal)
    for await (const chunk of stream) {
      lastMessage.state = "streaming";
      lastMessage.content += chunk?.choices[0]?.delta?.content || "";
      lastMessage.html = renderMarkdown(lastMessage.content, lastMessage.error);
      this.$nextTick(() => {
        this.autoScrollChatBodyToBottom(index);
      });
    }
    lastMessage.state = "succeed";
    succeed = true;
  } catch (err) {
    lastMessage.state = "failed";
    if (this.askAbortController?.signal?.aborted) {
      lastMessage.error = "";
    } else {
      lastMessage.error = err?.message || err;
    }
    lastMessage.html = renderMarkdown(lastMessage.content, lastMessage.error);
  }
  this.asking--;
}
```

----------------------------------------

TITLE: Install AIChat using Package Managers
DESCRIPTION: Instructions for installing AIChat using various package managers like Cargo (for Rust developers), Homebrew/Linuxbrew, Pacman, Windows Scoop, and Android Termux's pkg.
SOURCE: https://github.com/sigoden/aichat/blob/main/README.md#_snippet_0

LANGUAGE: Rust
CODE:
```
cargo install aichat
```

LANGUAGE: Shell
CODE:
```
brew install aichat
```

LANGUAGE: Shell
CODE:
```
pacman -S aichat
```

LANGUAGE: Shell
CODE:
```
scoop install aichat
```

LANGUAGE: Shell
CODE:
```
pkg install aichat
```

----------------------------------------

TITLE: Escape HTML Special Characters
DESCRIPTION: Escapes common HTML special characters (&, <, >, ", ') in a string to prevent cross-site scripting (XSS) vulnerabilities when rendering user-provided content directly into HTML.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_37

LANGUAGE: JavaScript
CODE:
```
function escapeForHTML(input) { const escapeMap = { "&": "&amp;", "<": "&lt;", ">": "&gt;", "\"": "&quot;", "'": "&#39;" }; return input.replace(/([&<>"'])/g, char => escapeMap[char]); }
```

----------------------------------------

TITLE: Escape Special Characters for HTML (JavaScript)
DESCRIPTION: Escapes common HTML special characters (`&`, `<`, `>`, `"`, `'`) in a string to their corresponding HTML entities. This prevents cross-site scripting (XSS) vulnerabilities and ensures text is rendered correctly in HTML contexts.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/arena.html#_snippet_32

LANGUAGE: JavaScript
CODE:
```
function escapeForHTML(input) { const escapeMap = { "&": "&amp;", "<": "&lt;", ">": "&gt;", "\"": "&quot;", "'": "&#39;" }; return input.replace(/([&<>"'])/g, char => escapeMap[char]); }
```

----------------------------------------

TITLE: Global CSS Styles and UI Component Layout for AIChat LLM Arena
DESCRIPTION: This extensive CSS block defines the foundational styling for the AIChat LLM Arena application. It sets up global CSS variables for colors and fonts, establishes the overall page layout, and styles individual UI components such as chat panels, message displays, input areas, and interactive buttons. It also includes media queries for responsive design and a dark mode theme.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/arena.html#_snippet_0

LANGUAGE: css
CODE:
```
:root { --fg-primary: #1652f1; --fg-default: black; --bg-primary: white; --bg-default: #f9f9f9; --bg-toast: rgba(0, 0, 0, 0.7); --border-color: #c3c3c3; }
[x-cloak] { display: none !important; }
html { font-family: Noto Sans, SF Pro SC, SF Pro Text, SF Pro Icons, PingFang SC, Helvetica Neue, Helvetica, Arial, sans-serif }
body, div { padding: 0; margin: 0; box-sizing: border-box; }
textarea, input, select, option { color: var(--fg-default); background-color: var(--bg-primary); }
body { font-family: Arial, sans-serif; font-size: 1rem; display: flex; height: 100vh; color: var(--fg-default); background-color: var(--bg-default); }
.container { display: flex; flex-direction: column; background-color: var(--bg-primary); width: 100%; }
.chats { display: flex; flex-direction: row; flex-grow: 1; width: 100%; }
.chat-panel { display: flex; flex-direction: column; width: 100%; }
.chat-header { display: flex; padding: 0.5rem; flex-direction: row; border-bottom: 1px solid var(--border-color); }
.chat-header select { width: 100%; outline: none; font-size: 1.25rem; border: none; }
.chat-body { display: flex; flex-direction: column; flex-grow: 1; overflow-x: hidden; overflow-y: auto; }
.chat-message { display: flex; padding: 0.7rem; margin-bottom: 0.7rem; }
.chat-avatar svg { width: 1.25rem; height: 1.25rem; border-radius: 50%; }
.chat-message-content { position: relative; display: flex; flex-direction: column; width: calc(100% - 1rem); margin-top: -2px; padding-left: 0.625rem; flex-grow: 1; }
.chat-message-content .error { color: red; background: none; padding: 0; }
.chat-message-content .message-text { white-space: pre-wrap; padding-top: 0.2rem; }
.message-image-bar { display: flex; flex-direction: row; overflow-x: auto; }
.message-image { margin: 0.25rem; }
.message-image img { width: 10rem; height: 10rem; object-fit: cover; }
.markdown-body { display: flex; width: 100%; padding: 0; flex-direction: column; background-color: var(--bg-primary); }
.markdown-body:first-child { margin-top: 0; padding-top: 0; }
.markdown-body pre { overflow-x: auto; word-wrap: break-word; }
.code-block { position: relative; width: 100%; }
.message-toolbox { display: flex; position: absolute; bottom: -1.4rem; }
.copy-message-btn, .regenerate-message-btn, .tts-message-btn { top: 0.7rem; right: 0.7rem; cursor: pointer; font-size: 0.9rem; padding-right: 4px; }
.copy-message-btn svg, .regenerate-message-btn svg, .tts-message-btn svg { width: 1rem; height: 1rem; }
.copy-code-btn { position: absolute; top: 0.7rem; right: 0.7rem; cursor: pointer; font-size: 0.9rem; }
.copy-code-btn svg { width: 1rem; height: 1rem; }
.scroll-to-bottom-btn { position: absolute; text-align: center; cursor: pointer; width: 1.5rem; height: 1.5rem; border-radius: 0.75rem; background-color: var(--bg-primary); }
.scroll-to-bottom-btn svg { width: 1.5rem; height: 1.5rem; border-radius: 50%; }
.input-panel { position: relative; border-top: 1px solid var(--border-color); }
.input-panel-inner { margin: 1rem; padding: 0.5rem; border: 1px solid var(--border-color); border-radius: 1rem; }
.input-panel-inner textarea { width: 100%; font-size: 1rem; padding: 0.4rem; box-sizing: border-box; border: none; outline: none; resize: none; max-height: 500px; overflow-x: hidden; overflow-y: auto; }
.input-toolbox { position: absolute; display: flex; right: 1.875rem; font-size: 1rem; bottom: 1.875rem; cursor: pointer; }
.input-toolbox svg { width: 1.875rem; height: 1.875rem; fill: var(--fg-default); }
.image-btn { position: relative; display: inline-block; margin-right: 0.5rem; }
.image-btn input[type="file"] { position: absolute; top: 0; left: 0; width: 100%; height: 100%; opacity: 0; cursor: pointer; }
.input-image-bar { display: flex; flex-direction: row; width: 100%; overflow-x: auto; }
.input-image-item { display: flex; margin: 0.25rem; width: 5rem; position: relative; }
.input-image-item img { width: 5rem; height: 5rem; object-fit: cover; }
.image-remove-btn { font-size: 1rem; margin-left: -0.8rem; cursor: pointer; }
.image-remove-btn { width: 1rem; height: 1rem; }
.input-btn.disabled { opacity: 0.3; }
.spinner { width: 1.1rem; height: 1.1rem; margin-top: 3px; border: 2px solid var(--fg-default); border-bottom-color: transparent; border-radius: 50%; display: inline-block; animation: spinner-rotation 1s linear infinite; }
.toast { display: none; position: fixed; top: 2px; left: 50%; text-align: center; transform: translate(-50%, 0); background-color: var(--bg-toast); color: var(--bg-primary); padding: 0.5rem; border-radius: 0.3rem; z-index: 9999; }
@keyframes spinner-rotation { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
@media (prefers-color-scheme: dark) { :root { --fg-primary: #1652f1; --fg-default: white; --bg-primary: black; --bg-default: #121212; --bg-toast: rgba(255, 255, 255, 0.7); --border-color: #3c3c3c; } }
@media screen and (max-width: 768px) { body { height: calc(100vh - 56px); height: 100dvh; }
.container { padding: 3px; }
```

----------------------------------------

TITLE: Update URL Search Parameters
DESCRIPTION: This function dynamically updates the browser's URL search parameters based on specific settings. It iterates over a predefined list of keys ('model', 'rag', 'role', etc.) from `this.settings`. If a setting has a value, it's added to the URL; otherwise, it's removed. The browser history is updated without a full page reload.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_18

LANGUAGE: javascript
CODE:
```
updateUrl() { const newUrl = new URL(location.href); ["model", "rag", "role", "max_output_tokens", "temperature", "top_p"].forEach(key => { if (this.settings[key] || typeof this.settings[key] === "number") { newUrl.searchParams.set(key, this.settings[key]); } else { newUrl.searchParams.delete(key); } }); history.replaceState(null, '', newUrl.toString()); }
```

----------------------------------------

TITLE: Alpine.js Application Data and Initialization Logic
DESCRIPTION: This code defines the `setupApp` function and the Alpine.js `app` data object. It initializes default settings, fetches models, RAGs, and roles from APIs, and sets up watchers for input, settings, and model/role changes. It also includes a keydown event listener for global shortcuts.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_2

LANGUAGE: JavaScript
CODE:
```
function setupApp() { let msgIdx = 0; let defaultSettings = { model: QUERY.model || "default", rag: QUERY.rag || "", role: QUERY.role || "", prompt: "", max_output_tokens: parseInt(QUERY.max_output_tokens) || null, temperature: QUERY.temperature ? parseFloat(QUERY.temperature) : null, top_p: QUERY.top_p ? parseFloat(QUERY.top_p) : null, }; Alpine.data("app", () => ({ models: [], rags: [""], roles: [{ name: "", prompt: "" }], settings: defaultSettings, modelData: {}, messages: [], input: "", images: [], asking: false, askAbortController: null, hoveredMessageIndex: null, shouldScrollChatBodyToBottom: true, isShowScrollToBottomBtn: false, showModal: "", sessionMode: false, sessionTitle: "", selectSessionId: null, sessions: [], async init() { await Promise.all([ fetchJSON(MODELS_API).then(models => { this.models = models.filter(v => !v.type || v.type === "chat"); }).catch(err => { toast("No model available"); console.error("Failed to load models", err); }), fetchJSON(RAGS_API).then(rags => { this.rags.push(...rags); }).catch(() => { }), fetchJSON(ROLES_API).then(roles => { this.roles.push(...roles.filter(v => !!v.prompt)); }).catch(() => { }), ]) this.$refs.input.addEventListener("paste", (e) => this.handlePaste(e)); this.$watch("input", () => this.autosizeInput(this.$refs.input)); this.$watch("settings", () => this.updateUrl()); this.$watch("settings.model", () => this.handleModelChange()); if (this.models.find(model => model.id === this.settings.model)) { this.handleModelChange(); } else { this.settings.model = "default"; } if (!this.rags.find(rag => rag === this.settings.rag)) { this.settings.rag = ""; } this.$watch("settings.role", () => this.handleRoleChange()) if (this.roles.find(role => role.name === this.settings.role)) { this.handleRoleChange(); } else { this.settings.role = ""; } document.addEventListener("keydown", (event) => this.handleKeyDown(event)) },
```

----------------------------------------

TITLE: Start New Chat Session
DESCRIPTION: This function initiates a new chat session. If an existing session is active and has a title, it saves the current session's state (settings, messages, mode, title) to the `sessions` array. It then resets all chat-related state variables, including clearing messages, setting `asking` to false, and focusing the input field.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_16

LANGUAGE: javascript
CODE:
```
handleNewChat() { if (this.asking) { this.askAbortController?.abort(); } if (this.sessionTitle) { const lastMessage = this.messages[this.messages.length - 1]; if (lastMessage.state === "loading") { lastMessage.state = "failed"; lastMessage.error = "Error: Aborted"; lastMessage.html = renderMarkdown(lastMessage.content, lastMessage.error); } const sessionData = JSON.parse(JSON.stringify({ settings: this.settings, messages: this.messages, sessionMode: this.sessionMode, sessionTitle: this.sessionTitle })); let session = this.sessions.find(v => v.id === this.selectSessionId); if (session) { Object.assign(session, sessionData); } else { this.sessions.unshift({ id: randomUUID(), createdAt: Date.now(), ...sessionData }); } } this.messages = []; this.asking = false; this.askAbortController = null; this.hoveredMessageIndex = null; this.shouldScrollChatBodyToBottom = true; this.isShowScrollToBottomBtn = false; this.showModal = ""; this.sessionMode = false; this.sessionTitle = ""; this.selectSessionId = null; this.focusInput(); }
```

----------------------------------------

TITLE: Implement Asynchronous Sleep in JavaScript
DESCRIPTION: This snippet shows how to create an asynchronous delay function in JavaScript. It uses a Promise that resolves after a specified number of milliseconds, effectively pausing execution without blocking the main thread. Useful for controlling timing in async operations.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/roles/%code%.md#_snippet_0

LANGUAGE: javascript
CODE:
```
async function timeout(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
```

----------------------------------------

TITLE: Configure Marked.js for Markdown Rendering
DESCRIPTION: Sets up the Marked.js library with custom renderers and extensions for enhanced markdown processing. It includes a custom code block renderer with syntax highlighting, a 'think' block extension for displaying hidden thoughts, and support for KaTeX for mathematical expressions.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_36

LANGUAGE: JavaScript
CODE:
```
function setupMarked() { const renderer = { code({ text, lang }) { const validLang = !!(lang && hljs.getLanguage(lang)); const highlighted = validLang ? hljs.highlight(text, { language: lang }).value : escapeForHTML(text); return `<div class="code-block"> <pre><code class="hljs ${lang}">${highlighted}</code></pre> <div class="copy-code-btn" @click="handleCopyCode" title="Copy code"> <svg fill="currentColor" viewBox="0 0 16 16"> <path fill-rule="evenodd" d="M4 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 5a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-1h1v1a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h1v1z"/> </svg> </div> </div>`; } }; const thinkExtension = { name: 'think', level: 'block', start(src) { const match = /^(\s*)<think>/.exec(src); if (match) { return match[1].length } else { return -1; } }, tokenizer(src, tokens) { const rule = /^\s*<think>([\s\S]*?)(<\/think>|$)/; const match = rule.exec(src); if (match) { return { type: 'think', raw: match[0], text: match[1].trim(), }; } }, renderer(token) { const text = '<p>' + token.text.trim().replace(/\n+/g, '</p><p>') + '</p>'; return `<details open class="think"> <summary>Deeply thought</summary> <blockquote>${text}</blockquote> </details>`; }, }; marked.use({ renderer }); marked.use(markedKatex({ throwOnError: false, inlineTolerantNoSpace: true })); marked.use({ extensions: [thinkExtension] }) }
```

----------------------------------------

TITLE: CSS Styles for AIChat User Interface
DESCRIPTION: This CSS defines the visual appearance and layout for key components of the AIChat application. It includes styles for interactive elements such as file input buttons, image display, session list items, modal dialogs, loading spinners, and transient toast messages. Media queries are used to provide responsive design for smaller screens and to support dark mode preferences.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_0

LANGUAGE: CSS
CODE:
```
y: inline-block; margin-right: 0.5rem; } .image-btn input[type="file"] { position: absolute; top: 0; left: 0; width: 100%; height: 100%; opacity: 0; cursor: pointer; } .input-image-bar { display: flex; flex-direction: row; width: 100%; overflow-x: auto; } .input-image-item { display: flex; margin: 0.25rem; width: 5rem; position: relative; } .input-image-item img { width: 5rem; height: 5rem; object-fit: cover; } .image-remove-btn { font-size: 1rem; margin-left: -0.8rem; cursor: pointer; } .image-remove-btn { width: 1rem; height: 1rem; } .input-btn.disabled { opacity: 0.3; } .session-list { padding-top: 0.4rem; max-height: 80vh; font-size: 0.8rem; overflow-y: auto; overflow-x: hidden; } .session-item { padding: 5px; border-bottom: 1px solid var(--border-color); cursor: pointer; } .session-item:hover { background-color: var(--bg-hover); } .session-title { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; } .modal { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: var(--bg-cover); z-index: 1000; display: flex; align-items: flex-start; justify-content: center; padding-top: 50px; } .modal-content { position: relative; padding: 0.8rem; border-radius: 8px; max-width: 1000px; width: calc(100% - 100px); background-color: var(--bg-primary); box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); } .modal-header { display: flex; flex-direction: row; align-items: center; } .modal-header .title { font-weight: 500; font-size: 1.5rem; } .modal-header .close-btn { margin-left: auto; color: var(--fg-default); background: none; border: none; font-size: 24px; cursor: pointer; } .spinner { width: 1.1rem; height: 1.1rem; margin-top: 3px; border: 2px solid var(--fg-default); border-bottom-color: transparent; border-radius: 50%; display: inline-block; animation: spinner-rotation 1s linear infinite; } .toast { display: none; position: fixed; bottom: 1rem; left: 1rem; text-align: center; background-color: var(--bg-toast); color: var(--bg-primary); padding: 0.5rem; border-radius: 0.3rem; z-index: 9999; } @keyframes spinner-rotation { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } } @media (prefers-color-scheme: dark) { :root { --fg-primary: #1652f1; --fg-default: white; --bg-primary: black; --bg-default: #121212; --bg-toast: rgba(255, 255, 255, 0.7); --bg-cover: rgba(255, 255, 255, 0.5); --bg-hover: #1f1f1f; --border-color: #3c3c3c; --shadow-color: rgba(255, 255, 255, 0.1); } } @media screen and (max-width: 768px) { body { height: calc(100vh - 56px); height: 100dvh; } .container { padding: 3px; } .sidebar { display: none; width: 100%; height: 100%; margin-right: 0; } .main-panel { width: 100%; } .chat-header { padding: 0.6rem; } .chat-header select { font-size: 1rem; } .chat-body { padding: 0.6rem; } .input-panel-inner { margin: 0.5rem; } .scroll-to-bottom-btn { right: 50%; } .hide-sidebar-btn { display: block; } .show-sidebar-btn { display: block; } }
```

----------------------------------------

TITLE: Fetch JSON Data with Custom Headers in JavaScript
DESCRIPTION: Asynchronously fetches JSON data from a specified URL. It applies custom headers obtained from the `getHeaders()` function to the request. Upon successful response, it parses the JSON and returns the `data` property from the parsed object.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/arena.html#_snippet_23

LANGUAGE: JavaScript
CODE:
```
async function fetchJSON(url) {
  const res = await fetch(url, { headers: getHeaders() });
  const data = await res.json()
  return data.data;
}
```

----------------------------------------

TITLE: Handle Global Keyboard Shortcuts
DESCRIPTION: This function listens for global keyboard events to trigger specific actions. It supports 'Ctrl+Shift+O' (or 'Cmd+Shift+O' on Mac) for a new chat, 'Ctrl+Shift+L' (or 'Cmd+Shift+L' on Mac) to show a list of sessions, 'Shift+Escape' to focus the input, and 'Escape' to close any active modal.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_15

LANGUAGE: javascript
CODE:
```
handleKeyDown(event) { const isMac = navigator.platform.toUpperCase().indexOf('MAC') > -1; const controlKey = isMac ? event.metaKey : event.ctrlKey; if (controlKey && event.shiftKey && event.key.toLowerCase() === 'o') { event.preventDefault(); this.handleNewChat(); } else if (controlKey && event.shiftKey && event.key.toLowerCase() === 'l') { event.preventDefault(); this.showModal = 'list-sessions' } else if (event.shiftKey && event.key === "Escape") { event.preventDefault(); this.focusInput(); } else if (this.showModal && event.key === "Escape") { event.preventDefault(); this.showModal = ""; } }
```

----------------------------------------

TITLE: Test AIChat Chat Completions API with cURL
DESCRIPTION: This cURL command demonstrates how to interact with the local AIChat Chat Completions API endpoint. It sends a POST request with a JSON payload to request a chat completion from a specified model, enabling streaming responses.
SOURCE: https://github.com/sigoden/aichat/blob/main/README.md#_snippet_4

LANGUAGE: sh
CODE:
```
curl -X POST -H "Content-Type: application/json" -d '{
  "model":"claude:claude-3-5-sonnet-20240620",
  "messages":[{"role":"user","content":"hello"}], 
  "stream":true
}' http://127.0.0.1:8000/v1/chat/completions
```

----------------------------------------

TITLE: Alpine.js App Data and Initialization Logic
DESCRIPTION: Defines the core Alpine.js `app` data object, including state variables for chat models, user input, images, and an array of chat instances. The `init` method fetches available models, configures chat panel widths based on the number of chats, and sets up event listeners for input pasting and resizing.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/arena.html#_snippet_3

LANGUAGE: JavaScript
CODE:
```
function setupApp() {
  let $inputPanel = document.querySelector('.input-panel');
  let $chatPanels = [];
  let $scrollToBottomBtns = [];
  let msgIdx = 0;
  Alpine.data("app", () => ({
    chatModels: [],
    input: "",
    images: [],
    asking: 0,
    chats: Array.from(Array(NUM)).map(_ => ({
      model: "",
      messages: [],
      hoveredMessageIndex: null,
      askAbortController: null,
      shouldScrollChatBodyToBottom: true,
      isShowScrollToBottomBtn: false,
    })),
    async init() {
      try {
        const models = await fetchJSON(MODELS_API);
        this.chatModels = models.filter(v => !v.type || v.type === "chat");
      } catch (err) {
        toast("No available model");
        console.error("Failed to load models", err);
      }
      let models = []
      if (QUERY.models) {
        models = QUERY.models.split(",");
      }
      $chatPanels = document.querySelectorAll('.chat-panel');
      $scrollToBottomBtns = document.querySelectorAll('.scroll-to-bottom-btn');
      const offsets = calculateOffsets(NUM);
      for (let i = 0; i < NUM; i++) {
        this.chats[i].model = models[i] || "default";
        $chatPanels[i].style.width = (100 / NUM) + '%';
        if (i > 0) {
          $chatPanels[i].style.borderLeft = '1px solid var(--border-color)';
        }
        $scrollToBottomBtns[i].style.left = offsets[i];
      }
      this.$refs.input.addEventListener("paste", (e) => this.handlePaste(e));
      this.$watch("input", () => this.autosizeInput(this.$refs.input));
      new ResizeObserver(() => {
        this.autoHeightChatPanel();
      }).observe($inputPanel)
    }
```

----------------------------------------

TITLE: Alpine.js `handleAsk` Method for Sending Messages
DESCRIPTION: Handles the submission of user messages. It constructs message objects, including text and image parts if images are present, and pushes them to each chat instance's message array. It then initiates the `ask` process for all active chats and clears the input fields.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/arena.html#_snippet_5

LANGUAGE: JavaScript
CODE:
```
handleAsk() {
  const isEmptyInput = this.input.trim() === "";
  const isEmptyImage = this.images.length === 0;
  if (this.asking > 0 || (isEmptyImage && isEmptyInput)) {
    return;
  }
  for (let index = 0; index < this.chats.length; index++) {
    const chat = this.chats[index];
    if (isEmptyImage) {
      chat.messages.push({ id: msgIdx++, role: "user", content: this.input, });
    } else {
      const parts = [];
      if (!isEmptyInput) {
        parts.push({ type: "text", text: this.input });
      }
      for (const image of this.images) {
        parts.push({ type: "image_url", image_url: { url: image } });
      }
      chat.messages.push({ id: msgIdx++, role: "user", content: parts, })
    }
    chat.messages.push({ id: msgIdx++, role: "assistant", content: "", state: "loading", // streaming, succeed, failed error: "", html: "", });
  }
  for (let index = 0; index < this.chats.length; index++) {
    this.asking++;
    this.ask(index);
  }
  this.input = "";
  this.images = [];
},
```

----------------------------------------

TITLE: Initiate AI Chat Request
DESCRIPTION: This asynchronous function initiates a request to the AI model. It sets up an `AbortController` for potential cancellation, ensures the chat body scrolls to the bottom, and prepares the request body. The function is cut off, but it typically proceeds to make an API call.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_22

LANGUAGE: javascript
CODE:
```
async ask() { this.askAbortController = new AbortController(); this.shouldScrollChatBodyToBottom = true; this.$nextTick(() => { this.autoScrollChatBodyToBottom(); }); const lastMessage = this.messages[this.messages.length - 1]; const body = this.buildBody(); let succeed = false; try { if (this.settings.rag) { const message = body.messages[body.messages.length - 1]; if
```

----------------------------------------

TITLE: Configure Marked.js for Custom Markdown Rendering (JavaScript)
DESCRIPTION: Configures the `marked.js` library with a custom renderer for code blocks and a custom extension for a `<think>` tag. The code renderer adds syntax highlighting using `highlight.js` and a copy button. The `think` extension renders content within `<think>` tags into an expandable `<details>` block with a 'Deeply thought' summary.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/arena.html#_snippet_31

LANGUAGE: JavaScript
CODE:
```
function setupMarked() { const renderer = { code({ text, lang }) { const validLang = !!(lang && hljs.getLanguage(lang)); const highlighted = validLang ? hljs.highlight(text, { language: lang }).value : escapeForHTML(text); return "<div class=\"code-block\">\n <pre><code class=\"hljs ${lang}\">${highlighted}</code></pre>\n <div class=\"copy-code-btn\" @click=\"handleCopyCode\" title=\"Copy code\">\n <svg fill=\"currentColor\" viewBox=\"0 0 16 16\">\n <path fill-rule=\"evenodd\" d=\"M4 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 5a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-1h1v1a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h1v1z\"/>\n </svg>\n </div>\n </div>"; } }; const thinkExtension = { name: 'think', level: 'block', start(src) { const match = /^(\s*)<think>/.exec(src); if (match) { return match[1].length } else { return -1; } }, tokenizer(src, tokens) { const rule = /^\s*<think>([\s\S]*?)(<\/think>|$)/; const match = rule.exec(src); if (match) { return { type: 'think', raw: match[0], text: match[1].trim(), }; } }, renderer(token) { const text = '<p>' + token.text.trim().replace(/\n+/g, '</p><p>') + '</p>'; return "<details open class=\"think\"> <summary>Deeply thought</summary> <blockquote>${text}</blockquote> </details>"; }, }; marked.use({ renderer }); marked.use(markedKatex({ throwOnError: false, inlineTolerantNoSpace: true })); marked.use({ extensions: [thinkExtension] }) }
```

----------------------------------------

TITLE: JavaScript Function to Handle User Ask/Submit
DESCRIPTION: This function manages the user's submission of a new message, including text and images. It constructs the message object for the chat history, updates the session title if it's the first message, clears the input, and initiates the AI `ask` process.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_3

LANGUAGE: JavaScript
CODE:
```
handleAsk() { const isEmptyInput = this.input.trim() === ""; const isEmptyImage = this.images.length === 0; if (this.asking || (isEmptyImage && isEmptyInput)) { return; } if (this.messages.length === 0) { let sessionTitle = "" if (this.images.length > 0) { sessionTitle = `🖼️x${this.images.length} ` } if (this.input) { sessionTitle += this.input.trim().replace(/\n/g, "↵").slice(0, 200); } this.sessionTitle = sessionTitle; } if (isEmptyImage) { this.messages.push({ id: msgIdx++, role: "user", content: this.input, }); } else { const parts = []; if (!isEmptyInput) { parts.push({ type: "text", text: this.input }); } for (const image of this.images) { parts.push({ type: "image_url", image_url: { url: image } }); } this.messages.push({ id: msgIdx++, role: "user", content: parts, }) } this.messages.push({ id: msgIdx++, role: "assistant", content: "", state: "loading", // streaming, succeed, failed error: "", html: "", }); this.input = ""; this.images = []; this.asking = true; this.ask(); },
```

----------------------------------------

TITLE: Fetch JSON Data
DESCRIPTION: A utility asynchronous function to fetch data from a given URL. It sends a GET request with standard headers and parses the response as JSON, returning the `data` property from the JSON object.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_26

LANGUAGE: JavaScript
CODE:
```
async function fetchJSON(url) { const res = await fetch(url, { headers: getHeaders() }); const data = await res.json() return data.data; }
```

----------------------------------------

TITLE: Display Toast Notification
DESCRIPTION: This function displays a temporary toast notification on the UI. It sets the text content of an element with ID 'toast', makes it visible, and automatically hides it after a specified duration (defaulting to 2500ms). It also clears any previous toast timers to prevent overlapping.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_30

LANGUAGE: JavaScript
CODE:
```
function toast(text, duration = 2500) { const $toast = document.getElementById("toast"); clearTimeout($toast._timer); $toast.textContent = text; $toast.style.display = "block"; $toast._timer = setTimeout(function () { $toast.style.display = "none"; }, duration); }
```

----------------------------------------

TITLE: JavaScript Function to Cancel AI Request
DESCRIPTION: This function aborts any ongoing AI request by calling the `abort()` method on the `askAbortController`. This allows users to stop a long-running generation.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_6

LANGUAGE: JavaScript
CODE:
```
handleCancelAsk() { this.askAbortController?.abort(); },
```

----------------------------------------

TITLE: Chunk Array into Smaller Arrays
DESCRIPTION: Splits a given array into smaller arrays (chunks) of a specified size. This is useful for processing large arrays in batches or for pagination purposes.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_39

LANGUAGE: JavaScript
CODE:
```
function chunkArray(array, chunkSize) { const chunks = []; for (let i = 0; i < array.length; i += chunkSize) { chunks.push(array.slice(i, i + chunkSize)); } return chunks; }
```

----------------------------------------

TITLE: Chunk Array into Smaller Arrays (JavaScript)
DESCRIPTION: Splits a given array into smaller arrays (chunks) of a specified size. It iterates through the original array, creating new sub-arrays for each chunk.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/arena.html#_snippet_34

LANGUAGE: JavaScript
CODE:
```
function chunkArray(array, chunkSize) { const chunks = []; for (let i = 0; i < array.length; i += chunkSize) { chunks.push(array.slice(i, i + chunkSize)); } return chunks; }
```

----------------------------------------

TITLE: Start AIChat Local Server
DESCRIPTION: This command starts the built-in HTTP server for AIChat, exposing various API endpoints and web UIs like the LLM Playground and Arena. It provides local access to chat completions, embeddings, and rerank APIs.
SOURCE: https://github.com/sigoden/aichat/blob/main/README.md#_snippet_3

LANGUAGE: Shell
CODE:
```
$ aichat --serve
Chat Completions API: http://127.0.0.1:8000/v1/chat/completions
Embeddings API:       http://127.0.0.1:8000/v1/embeddings
Rerank API:           http://127.0.0.1:8000/v1/rerank
LLM Playground:       http://127.0.0.1:8000/playground
LLM Arena:            http://127.0.0.1:8000/arena?num=2
```

----------------------------------------

TITLE: Build Chat Completions Request Body
DESCRIPTION: This function constructs the JSON request body for the chat completions API. It processes chat messages, integrates system prompts (including handling `__INPUT__` placeholders and structured prompts), sanitizes messages, and applies model settings such as `model`, `stream`, `max_output_tokens`, `temperature`, and `top_p`.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_25

LANGUAGE: JavaScript
CODE:
```
buildBody() { let messages = []; for ([userMessage, assistantMessage] of chunkArray(this.messages, 2)) { if (assistantMessage.state === "failed") { continue; } else if (assistantMessage.state === "loading") { messages.push({ role: userMessage.role, content: userMessage.content, }); } else { messages.push({ role: userMessage.role, content: userMessage.content, }); messages.push({ role: assistantMessage.role, content: assistantMessage.content, }); } } const systemPrompt = this.settings.prompt.trim(); if (systemPrompt) { if (messages[0]?.content?.indexOf("__INPUT__") > -1) { messages[0].content = systemPrompt.replace("__INPUT__", messages[0].content); } else { const { system, cases } = parseStructurePrompt(systemPrompt); const promptMessages = []; if (system) { promptMessages.push({ role: "system", content: system, }); } for (const item of cases) { promptMessages.push({ role: "user", content: item.input, }); promptMessages.push({ role: "assistant", content: item.output, }); } messages = [...promptMessages, ...messages]; } } sanitizeMessages(messages); const body = { model: this.settings.model, messages: messages, stream: true, }; [["max_output_tokens", "max_tokens"], ["temperature"], ["top_p"]].forEach(([setting_key, body_key]) => { if (typeof this.settings[setting_key] === "number") { body[body_key || setting_key] = this.settings[setting_key]; } }); const { max_output_token, require_max_tokens } = this.modelData; if (!body["max_tokens"] && require_max_tokens) { body["max_tokens"] = max_output_token; }; return body; },
```

----------------------------------------

TITLE: Auto-Scroll Chat Body to Bottom
DESCRIPTION: This function automatically scrolls the chat body to its bottommost position. It checks a `shouldScrollChatBodyToBottom` flag and then programmatically sets the `scrollTop` property of the chat body element, ensuring the latest messages are always visible.
SOURCE: https://github.com/sigoden/aichat/blob/main/assets/playground.html#_snippet_19

LANGUAGE: javascript
CODE:
```
autoScrollChatBodyToBottom() { if (this.shouldScrollChatBodyToBottom) { let $chatBody = this.$refs["chat-body"]; if (!$chatBody) { $chatBody = document.querySelector('[x-ref="chat-body"]') } $chatBody.scrollTop = $chatBody.scrollHeight; } }
```

----------------------------------------

TITLE: AIChat CMD Mode Input Examples
DESCRIPTION: Examples demonstrating how to provide various types of input (direct text, stdin, local files/directories, remote URLs, external commands, combined inputs) to AIChat in CMD mode.
SOURCE: https://github.com/sigoden/aichat/blob/main/README.md#_snippet_1

LANGUAGE: Shell
CODE:
```
aichat hello
```

LANGUAGE: Shell
CODE:
```
cat data.txt | aichat
```

LANGUAGE: Shell
CODE:
```
aichat -f image.png -f data.txt
```

LANGUAGE: Shell
CODE:
```
aichat -f dir/
```

LANGUAGE: Shell
CODE:
```
aichat -f https://example.com
```

LANGUAGE: Shell
CODE:
```
aichat -f '`git diff`'
```

LANGUAGE: Shell
CODE:
```
aichat -f dir/ -f data.txt explain
```
