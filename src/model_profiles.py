"""Stable runtime profiles for models with Cosmos-specific contracts."""

from pathlib import PurePosixPath
import re


AJAX_C375_MODEL_ID = "ajax_c375"
TRIAL55_BASE_MODEL_ID = "cosmos-qwen3.5-heretic-trial55-base"
GENERIC_TOOL_SCHEMA_PROFILE = "generic"
COSMOS_COMPACT_TOOL_SCHEMA_PROFILE = "cosmos_compact"
_COSMOS_TOOL_PROFILE_TOKEN = re.compile(
    r"(?:^|[^a-z0-9])(?:cosmos|ajax)(?:[^a-z0-9]|$)",
    re.IGNORECASE,
)


def model_id_leaf(value: object) -> str:
    """Normalize a model id while preserving provider/path aliases."""

    normalized = str(value or "").strip().lower().rstrip("/")
    return PurePosixPath(normalized).name


def is_cosmos_tool_profile_model(value: object) -> bool:
    """Return whether a model name opts into the Cosmos tool runtime."""

    return bool(_COSMOS_TOOL_PROFILE_TOKEN.search(model_id_leaf(value)))


def tool_schema_profile(value: object) -> str:
    """Select the sole schema contract for a model before turn routing."""

    if is_cosmos_tool_profile_model(value):
        return COSMOS_COMPACT_TOOL_SCHEMA_PROFILE
    return GENERIC_TOOL_SCHEMA_PROFILE


def is_cosmos_merged_tools_model(value: object) -> bool:
    """Compatibility alias for the Cosmos tool runtime profile."""

    return is_cosmos_tool_profile_model(value)


def uses_cosmos_progressive_thinking(value: object) -> bool:
    """Models whose native Qwen thinking is selected from the turn surface."""

    return is_cosmos_tool_profile_model(value)


def supports_user_thinking_toggle(value: object) -> bool:
    """Whether the chat UI may expose an explicit thinking on/off switch."""
    leaf = model_id_leaf(value)
    if not leaf or uses_cosmos_progressive_thinking(leaf):
        return False
    if leaf.startswith(("gpt", "o1", "o3", "o4")):
        return False
    return any(pattern in leaf for pattern in (
        "kimi-k2.5", "kimi-k2.6", "kimi-k3",
        "qwen3", "qwq", "deepseek-r1", "deepseek-reasoner",
        "minimax", "m2-reap", "gemma", "stepfun", "step-3", "step3",
        "magistral", "mistral-small", "mistral-medium",
    ))
