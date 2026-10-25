---
layout: default
---

# Configuration reference: COSMOS_* environment variables

<!-- This page is generated from the source tree by `scripts/generate_env_reference.py`. Do not edit it by hand: run the script instead. `tests/test_env_reference.py` fails when the committed page and the source disagree, or when a variable is read without an entry in the script's notes table. -->

Cosmos reads its runtime configuration from the Settings UI. The
environment variables below are the deployment-level escape hatches underneath
that: they are read directly from the process environment, mostly at import or
startup, and most installs never need any of them.

`.env.example` stays a short, deployment-level example on purpose - `APP_BIND`,
`APP_PORT`, `AUTH_ENABLED`, `DATABASE_URL` and a pre-seeded admin password. This
page is the complete list, which is a different job.

Truthiness is not uniform across the codebase. Where a variable is described as
"truthy" the read accepts `1`, `true`, `yes` and usually `on`; where it is
described as a switch that turns something off, the read rejects `0`, `false`,
`no` and `off` and treats everything else as on. The `Default` column is the
value the code falls back to when the variable is unset, quoted from the source.

The source tree reads **119** `COSMOS_*` variables: 81 an operator may want to set, and 38 that are internal - sentinels, fixture switches, capture hooks and development tooling. The internal ones are listed too, in their own section, so this page can be checked against the source mechanically.

> This page is generated. Edit `scripts/generate_env_reference.py` and
> re-run it; `tests/test_env_reference.py` enforces that the committed page
> matches the source.

## Variables you can set

### Deployment and first run

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_ADMIN_PASSWORD` | `''` | `setup.py` (+2 more) | Password for the admin account created on first run. Setup refuses a value shorter than its minimum length rather than silently falling back. |
| `COSMOS_ADMIN_USER` | `''` | `setup.py` (+2 more) | Username for the admin account created on first run. Setup uses env vars first, then an interactive prompt, then a random password. |
| `COSMOS_ALLOW_OLLAMA_CLI_SCAN` | *unset* | `routes/cookbook_helpers.py` (+1 more) | On Windows only, set truthy to let the Cookbook dependency probe shell out to `ollama list`. Ignored on other platforms, where the scan always runs. |
| `COSMOS_CONTAINER_NETWORK_MODE` | `''` | `app.py` (+1 more) | Declares the container's Docker network mode. Set to `host` to skip host-gateway probing when discovering local model endpoints. |
| `COSMOS_ENABLE_HOST_DOCKER` | `''` | `src/host_docker_access.py` | Security-relevant. Must be exactly `true` before tools may use a mounted host Docker socket, and the socket itself must exist. |
| `COSMOS_INPROCESS_POLLERS` | `'1'` | `routes/email/email_pollers.py` | The same off switch for the in-process email pollers, when `cosmos-mail poll-scheduled` is the sole external driver. |
| `COSMOS_INPROCESS_TASKS` | `'1'` | `app.py` | Set to 0, false, no or off to stop the in-process scheduled-task runner, for deployments where an external worker drives task firing. |
| `COSMOS_MODEL_KEEPALIVE` | `''` | `app.py` | Opt-in periodic model keep-alive pings. Off by default: the ping path runs model discovery, so stale LAN endpoints add background pressure. |
| `COSMOS_REQUIRE_TOOL_INDEX_READY` | `''` | `src/readiness.py` | Set truthy to make semantic tool-index readiness gate startup. Off by default so an install stays available on deterministic tool selection. |
| `COSMOS_SKIP_ADMIN_PROMPT` | *unset* | `setup.py` | Any non-empty value suppresses the interactive admin-credential prompt even on a TTY, for unattended installs. |
| `COSMOS_SLOW_REQUEST_LOG_SECONDS` | `'0.75'` | `app.py` | Request duration in seconds above which the middleware logs a slow-request warning. |
| `COSMOS_STARTUP_WARMUPS` | `''` | `app.py` | Opt-in startup pings of the configured model endpoints. Off by default because they compete with the first seconds of UI use. |
| `COSMOS_TOOL_INDEX_PREWARM` | `'1'` | `src/tool_index.py` | Set to 0, false, no or off to skip background initialization of semantic tool retrieval at startup. |

### Data directories and paths

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_DATA_DIR` | `get_default_data_dir()` | `src/constants.py` (+1 more) | Root directory for every persisted file. Prefer this over the per-path overrides; the rest of `src/constants.py` derives from it. |
| `COSMOS_MAIL_ATTACHMENTS_DIR` | `os.path.join(DATA_DIR, 'mail-attachments')` | `src/constants.py` | Dedicated override for the mail attachment store, which otherwise lives under the data directory. |

### Model routing and providers

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_COPILOT_API_VERSION` | `'2026-06-01'` | `src/copilot.py` | Dated API-version header the Copilot models and chat endpoints require. |
| `COSMOS_COPILOT_CLIENT_ID` | `'01ab8ac9400c4e429b23'` | `src/copilot.py` | GitHub OAuth client id for the Copilot device flow. The default is the public VS Code client id; override it only with your own allow-listed app. |
| `COSMOS_DEEPSEEK_REASONING_EFFORT` | `'high'` | `src/llm_core.py` | Reasoning effort for DeepSeek. Only `high` and `max` are accepted; any other value falls back to the default. |
| `COSMOS_FIRST_TOKEN_TIMEOUT` | `''` | `src/llm_core.py` | Seconds to wait for the first streamed token from a local endpoint before failing. Unset keeps the generous read timeout, which makes a stalled backend look like a hung agent. |
| `COSMOS_LOCAL_MODEL_GATE` | `'true'` | `src/llm_core.py` | On by default. Set 0, false, no or off to drop the gate that checks a local endpoint before routing a request to it. |
| `COSMOS_MISTRAL_REASONING_EFFORT` | `'high'` | `src/llm_core.py` | Reasoning effort sent to Mistral thinking-capable models. The API accepts high, medium, low and none. |
| `COSMOS_MLX_IMAGE_VLM_MODEL` | *unset* | `scripts/mlx_image_server.py` | Vision-language model id for the MLX image server script. Required unless `--vlm-model` is passed on the command line. |
| `COSMOS_QWEN_ROUTE_THINKING` | `'auto'` | `src/agent_loop.py` | Thinking policy for the Qwen routing step. An unrecognized value falls back to `auto`. |

### Agent loop and tool execution

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_DISABLE_MCP` | `''` | `src/builtin_mcp.py` | Truthy disables MCP entirely, as an escape hatch for compatibility problems with a server. |
| `COSMOS_MAX_VISUAL_EVIDENCE_FRAMES` | `'3'` | `src/agent_loop.py` | How many video frames one tool result may contribute. Clamped to 1-8. |
| `COSMOS_MAX_VISUAL_EVIDENCE_IMAGES` | `'1'` | `src/agent_loop.py` | How many images one tool result may contribute to the model turn. Clamped to 1-8. |
| `COSMOS_MCP_ALLOWED_COMMANDS` | `''` | `src/agent_tools/admin_tools.py` | Security-relevant. Comma-separated allowlist of MCP launcher basenames the agent may start. Empty by default, and the deny list still wins. |
| `COSMOS_PYTHON_TOOL_SITE_PACKAGES` | `''` | `src/agent_runtime/process_resources.py` (+1 more) | Security-relevant. Absolute package roots, separated by the platform path separator, exposed to the sandboxed Python tool. Empty exposes none. |
| `COSMOS_SCRIPT_HOST` | `'localhost'` | `src/builtin_actions.py` | Default host for the run-script action. `localhost`, `127.0.0.1`, `local` and empty run locally; any other value runs over SSH. |
| `COSMOS_TOOL_APPROVAL_GATE` | `'1'` | `src/tool_capabilities.py` | Security-relevant. On by default: after external content enters a run, tools that execute code, mutate state or cause external side effects need a separate approval. Set to 0 to opt out. |

### Browser automation

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_BROWSER_EXECUTABLE` | `''` | `src/builtin_mcp.py` | Absolute path to the Chrome or Chromium binary. Empty searches the usual names, then lets Playwright MCP pick its own browser. |
| `COSMOS_BROWSER_ISOLATED` | `'1'` | `src/builtin_mcp.py` | Security-relevant. On by default, adding `--isolated` so each browser session starts clean. Set 0, false or no to keep a persistent profile. |
| `COSMOS_BROWSER_MCP_CACHE` | `os.path.join(base_dir, 'data', 'local', 'playwright-mcp-cache')` | `src/builtin_mcp.py` | Cache directory handed to the browser MCP server, so its npm download survives a container rebuild. |
| `COSMOS_BROWSER_MCP_CALL_TIMEOUT_S` | `'90'` | `src/mcp_manager.py` | Upper bound in seconds for one browser MCP tool call. A call that exceeds it fails without being retried. |
| `COSMOS_BROWSER_MCP_REQUIRE_CACHE` | `''` | `src/builtin_mcp.py` | Truthy refuses to start the browser MCP server unless its npm package is already in the npx cache, instead of installing it at startup. |
| `COSMOS_BROWSER_NAMESPACE` | `'cosmos-ui'` | `src/agent_tools/web_tools.py` | Namespace for the detached agent-browser daemon's pid files, so two runtimes on one machine do not terminate each other's browsers. |
| `COSMOS_BROWSER_NO_SANDBOX` | `'1'` | `src/builtin_mcp.py` | Security-relevant. On by default, adding `--no-sandbox` because the Docker image cannot use the Chromium sandbox. Set 0, false or no to keep it. |
| `COSMOS_BROWSER_SCREENSHOT_DIR` | *unset* | `src/agent_tools/web_tools.py` | Where private-browser screenshots are written. Falls back to the container path, then the system temp directory. |

### Container and workspace mounts

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_WORKSPACE_CONTAINER_ROOT` | *unset* | `src/workspace_paths.py` | Container-side root that the host root maps onto. An `or` fallback, not a read default, supplies `/workspace` when it is unset. |
| `COSMOS_WORKSPACE_DEFAULT` | `''` | `routes/workspace_routes.py` | Default workspace path the admin-only workspace route reports. Empty means no default is configured. |
| `COSMOS_WORKSPACE_HOST_ROOT` | *unset* | `src/workspace_paths.py` | Single host-side root, paired with the container root below. Simpler than the explicit mount list when there is only one mount. |
| `COSMOS_WORKSPACE_MOUNTS` | `''` | `src/workspace_paths.py` | `host=container` path pairs separated by commas or semicolons, so the agent can translate a container path back to the host path a user typed. |

### Email

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_DOCUMENT_OWNER` | `''` | `mcp_servers/email_server.py` | Owner stamped on documents the email MCP server creates. Stdio MCP tools get no authenticated user, so without this a draft is invisible. |
| `COSMOS_IMAP_TIMEOUT_SECONDS` | *unset* | `routes/email/email_helpers.py` | IMAP socket timeout in seconds, clamped to 5-300. A non-numeric value falls back to 30 rather than failing. |

### Calendar, notes and single-user mode

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_ALLOW_PRIVATE_CALDAV` | `'0'` | `src/caldav_sync.py` | Security-relevant. Truthy lets CalDAV sync reach private and link-local addresses. Off by default; this is an SSRF guard. |
| `COSMOS_FALLBACK_OWNER` | `'owner@localhost'` | `routes/calendar_routes.py` | Owner address that single-user mode attributes an unauthenticated request to. Only reachable while single-user mode is on. |
| `COSMOS_SINGLE_USER` | `'1'` | `routes/calendar_routes.py` | Security-relevant. On by default. Set to 0 on a real multi-user install so unauthenticated calendar writes are rejected rather than absorbed. |

### Upload and media limits

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_CHAT_UPLOAD_MAX_BYTES` | `10 * 1024 * 1024` | `src/upload_limits.py` | Maximum bytes accepted for a chat attachment. |
| `COSMOS_EDITOR_DRAFT_MAX_BYTES` | `256 * 1024 * 1024` | `src/upload_limits.py` | Maximum bytes accepted for a saved editor draft. |
| `COSMOS_EMAIL_COMPOSE_UPLOAD_MAX_BYTES` | `25 * 1024 * 1024` | `src/upload_limits.py` | Maximum bytes accepted for an attachment added while composing mail. |
| `COSMOS_GALLERY_TRANSFORM_UPLOAD_MAX_BYTES` | `25 * 1024 * 1024` | `src/upload_limits.py` (+1 more) | Maximum bytes accepted for an image handed to a gallery transform. |
| `COSMOS_GALLERY_UPLOAD_MAX_BYTES` | `100 * 1024 * 1024` | `src/upload_limits.py` (+1 more) | Maximum bytes accepted for a gallery upload. |
| `COSMOS_ICS_MAX_BYTES` | `10 * 1024 * 1024` | `src/upload_limits.py` | Maximum bytes accepted for an imported ICS file. |
| `COSMOS_MEDIA_FRAME_TIMEOUT` | `30` | `src/media_ingress.py` | Seconds allowed for extracting frames from a video before giving up. |
| `COSMOS_MEDIA_MAX_AUDIO_BYTES` | `32 * 1024 * 1024` | `src/media_ingress.py` | Largest source audio file the media pipeline will read. |
| `COSMOS_MEDIA_MAX_DIMENSION` | `1600` | `src/media_ingress.py` | Longest edge in pixels an image is resized down to before encoding. |
| `COSMOS_MEDIA_MAX_DOCUMENT_BYTES` | `32 * 1024 * 1024` | `src/media_ingress.py` | Largest source document the media pipeline will read. |
| `COSMOS_MEDIA_MAX_DOCUMENT_CHARS` | `24000` | `src/media_ingress.py` | How many characters of an ingested document are inlined into the turn. |
| `COSMOS_MEDIA_MAX_ENCODED_BYTES` | `24 * 1024 * 1024` | `src/media_ingress.py` | Budget for the encoded payload handed to the model, counted cumulatively across one turn's attachments rather than per file. |
| `COSMOS_MEDIA_MAX_FILES` | `4` | `src/media_ingress.py` | How many local media files one agent turn may ingest. |
| `COSMOS_MEDIA_MAX_IMAGE_BYTES` | `12 * 1024 * 1024` | `src/media_ingress.py` | Largest source image the media pipeline will read. |
| `COSMOS_MEDIA_MAX_PIXELS` | `40000000` | `src/media_ingress.py` | Total pixel budget for a source image, as a decompression-bomb guard. |
| `COSMOS_MEDIA_MAX_VIDEO_BYTES` | `128 * 1024 * 1024` | `src/media_ingress.py` | Largest source video the media pipeline will read. |
| `COSMOS_MEDIA_MAX_VIDEO_FRAMES` | `8` | `src/media_ingress.py` | How many frames are sampled from a video. |
| `COSMOS_MEDIA_PROBE_TIMEOUT` | `15` | `src/media_ingress.py` | Seconds allowed for probing a video's metadata before giving up. |
| `COSMOS_MEMORY_IMPORT_MAX_BYTES` | `10 * 1024 * 1024` | `src/upload_limits.py` (+1 more) | Maximum bytes accepted for a memory import file. |
| `COSMOS_PERSONAL_UPLOAD_MAX_BYTES` | `25 * 1024 * 1024` | `src/upload_limits.py` (+1 more) | Maximum bytes accepted for a personal-documents upload. |
| `COSMOS_STT_MAX_AUDIO_BYTES` | `25 * 1024 * 1024` | `src/upload_limits.py` | Maximum bytes accepted for an audio file submitted for transcription. |

### Search

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_SEARCH_PROVIDER` | `''` | `services/search/providers.py` | Forces the search provider, overriding the Settings value. Empty keeps the UI authoritative, which is what a normal install wants. |

### Memory and skills

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_MCP_MEMORY_OWNER` | *unset* | `src/mcp_manager.py` | Application owner binding for the configured memory MCP backend. Takes precedence over COSMOS_MEMORY_OWNER; missing ownership fails closed. |
| `COSMOS_MEMORY_OWNER` | *unset* | `src/mcp_manager.py` | Fallback application owner binding for the memory MCP backend. This configuration identifies ownership; it does not grant read or egress authority. |
| `COSMOS_SKILL_SEMANTIC_RETRIEVAL` | `'1'` | `services/memory/skills.py` | On by default. Set 0, false, no or off to fall back to keyword-only skill retrieval when no vector store is reachable. |
| `COSMOS_SKILL_SEMANTIC_THRESHOLD` | `'0.4'` | `services/memory/skills.py` | Minimum semantic score a skill needs to be retrieved. A non-numeric value falls back to the default. |

### Speech and vision models

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_GROUNDING_MODEL` | `'google/owlvit-base-patch32'` | `routes/gallery/gallery_routes.py` | Object-grounding model id the gallery loads for text-driven selection. |
| `COSMOS_SAM_MODEL` | `'facebook/sam-vit-base'` | `routes/gallery/gallery_routes.py` | Segmentation model id the gallery loads for subject selection. |
| `COSMOS_STT_MODEL` | *unset* | `src/agent_tools/media_tools.py` | Default speech-to-text model for media transcription when the tool call does not name one. |
| `COSMOS_TTS_CACHE_MAX_BYTES` | `500 * 1024 * 1024` | `services/tts/tts_service.py` | Cap on the synthesized-speech cache. A non-numeric value falls back to the default. |

### Auth and internal API

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_INTERNAL_BASE` | *unset* | `src/constants.py` | Base URL the in-app tool layer uses for loopback HTTP calls. Set it when the app is not reachable at the port it thinks it is bound to. |
| `COSMOS_INTERNAL_TOKEN` | *unset* | `core/middleware.py` | Security-relevant. Token that lets the in-app tool layer reach admin-gated routes over loopback. Unset generates a fresh per-process token, which is what you want unless something outside the process needs the same value. |

### Integrations (Claude, Codex)

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_API_TOKEN` | `''` | `integrations/claude/skills/cosmos/scripts/cosmos_api.py` (+1 more) | API token those scripts authenticate with. Both this and the URL are required; the scripts name whichever is missing. |
| `COSMOS_URL` | `''` | `integrations/claude/skills/cosmos/scripts/cosmos_api.py` (+1 more) | Base URL of the Cosmos instance the bundled integration scripts call. |

## Internal and development-only variables

Listed for completeness. Setting one of these on a real install is either a no-op or a way to break something quietly.

### Model routing and providers

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_COPILOT_EDITOR_VERSION` | `'Cosmos/1.0'` | `src/copilot.py` | Editor-version header presented to the Copilot API. Kept stable on purpose. |
| `COSMOS_COPILOT_INTEGRATION_ID` | `'vscode-chat'` | `src/copilot.py` | Integration id presented to the Copilot API. Kept stable on purpose. |
| `COSMOS_COPILOT_USER_AGENT` | `'Cosmos/1.0'` | `src/copilot.py` | Editor-like User-Agent presented to the Copilot API. Kept stable on purpose. |
| `COSMOS_DEBUG_LLM_SHAPE` | `''` | `src/llm_core.py` | Truthy logs the shape of streamed provider chunks. Debugging aid for provider response parsing. |

### Agent loop and tool execution

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_CAPTURE_MODEL_REQUESTS` | `''` | `src/agent_loop.py` | Truthy writes model-request snapshots for local debugging. The marker file `/tmp/cosmos_capture_model_requests` enables the same thing. |
| `COSMOS_EXPOSE_RAW_BROWSER_MCP` | `''` | `src/agent_loop.py` | Truthy stops hiding the raw Playwright MCP tools from agent prompts when the private-browser tool is available. |
| `COSMOS_TOOL_CONTRACT_ROOT` | `str(Path(__file__).resolve().parents[1] / 'scripts')` | `src/clean_agent_preview.py` (+1 more) | Directory holding the tool-contract scripts the clean-agent preview loads. The default resolves to the bundled scripts directory relative to the installed/source tree. |

### Email

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_EMAIL_FIXTURE` | *unset* | `mcp_servers/email_server.py` (+4 more) | Exactly `1`, plus a fixture file on disk, makes the email MCP server serve fixtures instead of a real mailbox. |

### Testing, capture and development tooling

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_AJAX_TEST_URL` | *unset* | `tests/test_ajax_email_live.py` (+2 more) | Chat-completions URL of a live Ajax endpoint. Unset skips the opt-in live Ajax email tests. |
| `COSMOS_BROWSER_LIVE_CONTRACT` | *unset* | `tests/test_browser_producer_live_contract.py` | Set 1 only in the allowlisted release Docker environment to run the browser producer contract tests. Does not enable browser page operations. |
| `COSMOS_COOKIE` | `''` | `scripts/cosmos_domain_audit.py` (+2 more) | Session cookie the live audit scripts send when no --cookie argument is given. |
| `COSMOS_DOCKER_TEST_IMAGE` | `'cosmos-cosmos:latest'` | `tests/test_docker_devops_hardening.py` | Docker image tag exercised by the DevOps Docker entrypoint integration tests. |
| `COSMOS_EDITOR_ACTIONS` | `','.join([*actions, 'edit', 'update'])` | `tests/tools/editor_writing_smoke.py` | Comma-separated writing actions the editor-writing smoke tool runs. Unset runs every action plus edit and update. |
| `COSMOS_EDITOR_MAX_TOKENS` | `'4096'` | `tests/tools/editor_writing_smoke.py` | Completion token limit for each editor-writing smoke request. |
| `COSMOS_EDITOR_RICH_FIXTURE` | *unset* | `tests/tools/editor_writing_smoke.py` | Set to 1 to run the editor-writing smoke tool against a rich-text document fixture instead of Markdown. |
| `COSMOS_EDITOR_TEST_ENDPOINT` | *unset* | `tests/tools/editor_writing_smoke.py` (+1 more) | Chat-completions URL the opt-in editor-writing and organizer smoke tools drive. Both tools require it. |
| `COSMOS_EDITOR_TRACE` | *unset* | `tests/tools/editor_writing_smoke.py` | Any non-empty value prints every stream event after each editor-writing smoke action. |
| `COSMOS_EVAL_OWNER` | `'cosmos_eval'` | `scripts/eval_cosmos_contextual_tool_use.py` (+1 more) | Account the tool-use eval scripts run as; defaults to the cosmos_eval account. |
| `COSMOS_LLAMA_SERVER` | `'llama-server'` | `scripts/cosmos_related_flow_audit.py` | Binary name or path to llama-server used by the related-flow audit script. |
| `COSMOS_ORGANIZER_AUTO_CHOICE` | *unset* | `tests/tools/organizer_smoke.py` | With organizer tracing on, any non-empty value replaces forced tool choice with auto on traced requests. |
| `COSMOS_ORGANIZER_CASES` | *unset* | `tests/tools/organizer_smoke.py` | Comma-separated organizer smoke case names to run. Unset runs every case. |
| `COSMOS_ORGANIZER_TRACE` | *unset* | `tests/tools/organizer_smoke.py` | Any non-empty value prints each provider request the organizer smoke tool sends. |
| `COSMOS_ORGANIZER_TRACE_MESSAGES` | *unset* | `tests/tools/organizer_smoke.py` | With organizer tracing on, any non-empty value also prints the request messages. |
| `COSMOS_QA_PASSWORD` | *unset* | `scripts/cosmos_related_flow_audit.py` (+6 more) | Account password passed to the related-flow audit script when authenticating. |
| `COSMOS_QA_TEACHER_ATTEMPTS` | `'3'` | `scripts/cosmos_conversation_qa.py` | Retry budget for the conversation-QA teacher model call. Clamped to 1-3. |
| `COSMOS_QA_TEACHER_TIMEOUT` | `'120'` | `scripts/cosmos_conversation_qa.py` | Timeout in seconds for that call. Clamped to 15-120. |
| `COSMOS_RUNTIME_REVISION` | `''` | `routes/chat_helpers.py` (+1 more) | Revision string stamped into each captured SFT trace record, so a trace can be tied back to the build that produced it. |
| `COSMOS_SFT_DIR` | *unset* | `scripts/run_cosmos_search_teacher_pipeline.py` | Base directory containing SFT training datasets for the search teacher pipeline. |
| `COSMOS_SFT_DISABLE_WORKSPACE_TOOLS` | `'1'` | `src/agent_loop.py` | On by default. Keeps synthetic personal-assistant fixtures out of workspace mode; set 0, false, no or off to let them through. |
| `COSMOS_SFT_FORCE_UTC_TIMEZONE` | `'0'` | `routes/chat_routes.py` | Truthy forces `sft_` accounts to UTC for deterministic batch generation. Interactive accounts still follow the browser timezone. |
| `COSMOS_SFT_TRACE_CAPTURE` | `'1'` | `routes/chat_helpers.py` (+1 more) | On by default, but only for owners whose name starts with `sft_`. Set 0, false, no or off to stop writing training traces. |
| `COSMOS_SFT_TRACE_DIR` | *unset* | `routes/chat_helpers.py` (+1 more) | Directory the SFT trace JSONL files are written to. Defaults to `sft_traces` under the data directory. |
| `COSMOS_SKIP_RUN_HINT` | *unset* | `setup.py` | Any non-empty value suppresses the `start the server with` hint at the end of setup. `start-macos.sh` sets it because it starts the server itself. |
| `COSMOS_TEST_STATIC_ORIGIN` | *unset* | `scripts/css_snapshot.py` (+3 more) | Origin an already-running static server is serving the repository from, so snapshot tooling reuses it instead of starting its own. |
| `COSMOS_TEST_STATIC_PORT` | *unset* | `tests/conftest.py` | Fixed port for the test suite's static server. Unset takes an ephemeral port, which is what keeps parallel runs from colliding. |
| `COSMOS_TINY_MODEL_PATH` | *unset* | `scripts/cosmos_related_flow_audit.py` | Path to a local compact model GGUF file used in Cookbook serve lifecycle audit flows. |

### Build and release metadata

| Variable | Default | Read in | What it does |
|---|---|---|---|
| `COSMOS_BUILD_VERSION` | `''` | `src/constants.py` | Overrides the build-version string the API and UI report, without touching the public application version. |
| `COSMOS_SOURCE_COMMIT` | `''` | `src/constants.py` | Overrides the source commit reported for runtime provenance, for builds that ship without a git directory. |

## How this page is generated

The generator walks the Python sources under `app.py`, `launcher.py`, `setup.py`, `companion`, `config`, `core`, `integrations`, `mcp_servers`, `routes`, `scripts`, `services`, `src`, `tests` and finds
reads three ways, because no single pattern covers the codebase:

- Direct reads: `os.getenv(...)`, and any `.get` / `.setdefault` / `.pop` call or
  subscript keyed by an `COSMOS_*` literal, including names held in a
  module-level constant. The receiver is not required to be `os.environ`, because
  several call sites read through a mapping passed in as an argument
  (`src/tool_index.py`, `src/host_docker_access.py`).
- Calls to env-reader helpers - any function that forwards one of its own
  parameters to an environment read. This is detected rather than hardcoded, so a
  new helper needs no change here. It is what finds the upload caps in
  `src/upload_limits.py` and the media-ingress overrides in
  `src/media_ingress.py`.
- A regex sweep of the raw file text, for reads the AST cannot see.
  `routes/cookbook_helpers.py` builds an Ollama probe script as a list of source
  lines, so one read lives inside a string literal.

The three passes are not redundancy. A line-based grep for a direct
`os.environ.get("COSMOS_...` call finds 89 of the 119 variables on this
page. What it misses is reads through an env-reader helper, reads whose call
spans more than one line, reads whose variable name is held in a module
constant, and reads through a mapping passed in as an argument - which is the
whole reason this page is generated rather than maintained.

The `Default` column shows the expression as written, with one level of
indirection resolved: a module-level constant and a dataclass field default are
replaced by the literal they hold, so `defaults.max_media_files` shows as `4`.
Anything computed at import time - `get_default_data_dir()` - is shown as
written, because that is the honest answer. A few call sites supply their
fallback with `or` rather than a default argument; those show as *unset* and say
so in the last column.

Regenerate it with:

```bash
python3 scripts/generate_env_reference.py
```
