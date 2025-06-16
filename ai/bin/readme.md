# LiteLLM User-Service Scripts

This folder contains **turn-key helper scripts** that install, run, validate and, if needed, cleanly remove a personal [LiteLLM](https://github.com/BerriAI/litellm) proxy on your workstation.

---

## 1  What is LiteLLM and why run it locally ?

LiteLLM is a lightweight proxy and SDK that presents **one unified, OpenAI-compatible API** in front of **hundreds of language-model providers** (OpenAI, Anthropic, Google, Meta, Mistral, etc.).  
Running the proxy locally gives you:

* A single endpoint (`http://localhost:4000`) for **all** your tools (Aider, LlamaIndex, …).
* Centralised rate-limit handling, retries, logging and cost accounting.
* The ability to **hot-swap models or providers** without touching application code.
* A place to add caching, auth or routing logic that is completely under your control.

The scripts here configure LiteLLM to use the  
**OpenRouter “autorouter”**, a smart router that automatically forwards each request to the _best_ model available on OpenRouter’s platform.

> 🗒️ OpenRouter ~= “one API key → hundreds of models”.  
> See <https://openrouter.ai/openrouter/auto> for how autorouting works.

---

## 2  Quick installation

1. **Prerequisites**

   | Tool | Purpose | Install hint |
   |------|---------|--------------|
   | `pkgx` | used to bootstrap `pipx` | `curl -fsS https://pkgx.sh | sh` |
   | `pipx` | isolates Python apps | `pkgx install pipx` |
   | `gopass` | secrets manager | `pkgx install gopass` |

   Store your OpenRouter key once:

   ```bash
   gopass insert api/openrouter        # paste your key when prompted
   ```

2. **Run the installer**

   ```bash
   ./ai/bin/install-litellms.sh
   ```

   The script will

   * install / upgrade LiteLLM via **pipx**
   * write `~/.local/lite-llm/config.yaml`
   * create a **user-level service** (systemd, launchd or nohup)
   * start the proxy on `localhost:4000`

3. **Check that it works**

   ```bash
   ./ai/bin/validate-litellm.sh
   ```

   All tests should be green; see next section for details.

### Script flags

| Flag | What it does |
|------|--------------|
| *(none)* | normal install (no-op if already healthy) |
| `--reinstall` | stop service ➜ update package ➜ regenerate config ➜ restart |
| `--uninstall` | stop service ➜ optional purge of config/logs and pipx venv |

---

## 3  Configuration explained

`~/.local/lite-llm/config.yaml` (generated automatically):

```
model_list:
  - model_name: autorouter:openrouter/auto      # alias visible to clients
    litellm_params:
      model: openrouter/auto                    # real model id
      api_base: https://openrouter.ai/api/v1
      api_key: os.environ/OPENROUTER_API_KEY
      extra_headers:
        HTTP-Referer: os.environ/OR_SITE_URL
        X-Title:      os.environ/OR_APP_NAME

environment_variables:
  OPENROUTER_API_KEY: os.environ/OPENROUTER_API_KEY
  OPENROUTER_API_BASE: https://openrouter.ai/api/v1
  OR_SITE_URL:  https://shell-settings.local
  OR_APP_NAME:  Shell Settings LiteLLM
```

Key points:

* **autorouter** chooses the optimal model for every request – you no longer hard-code model names.
* Your OpenRouter key **never appears in plain-text**; LiteLLM reads it from the environment which is populated by the service definition (`Environment="OPENROUTER_API_KEY=…"`)
* Custom headers let your requests appear on the OpenRouter analytics/leaderboard.

---

## 4  Validation script

`./ai/bin/validate-litellm.sh` performs seven checks:

1. Service reachable on port 4000  
2. `/health` returns JSON  
3. `/v1/models` responds  
4. Simple chat completion  
5. Arithmetic sanity test (2 + 2)  
6. Fallback: try first model returned by `/models`  
7. Tail log file for common errors

Output resembles:

```
✅ Service is running on port 4000
✅ Health endpoint is working
✅ Models endpoint is working
✅ Completion request successful
✅ Arithmetic test passed!
✅ Model gpt-3.5 is working
✅ No common errors found in log file
```

If anything fails the script prints targeted hints and `tail`s suspicious log lines.

---

## 5  Troubleshooting guide

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `Invalid model name … openrouter/auto` | LiteLLM < v1.71 lacks mapping | `./install-litellms.sh --reinstall` (always pulls latest) |
| `/v1/models` empty | wrong / missing API key | `gopass show api/openrouter` then restart |
| Network timeouts | local firewall or DNS | test `curl https://openrouter.ai/api/v1/models` |
| Service won’t start on macOS | launchd cache | `launchctl remove com.litellm` then reinstall |
| Want a clean slate | `./install-litellms.sh --uninstall` **→ y y** |

Useful commands:

```bash
tail -f ~/.local/lite-llm/lite-llm.log        # live debug
curl http://localhost:4000/v1/models | jq     # inspect models
export OR_SITE_URL="https://myapp.local"      # customise analytics tag
```

---

## 6  References

* LiteLLM OpenRouter docs – <https://docs.litellm.ai/docs/providers/openrouter>
* OpenRouter Auto Router – <https://openrouter.ai/openrouter/auto>
* AIlice example (OpenRouter via LiteLLM) – <https://github.com/myshell-ai/AIlice>
* LiteLLM routing strategies – <https://docs.litellm.ai/docs/routing>

Happy hacking 🤖
