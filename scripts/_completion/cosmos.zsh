#compdef cosmos cosmos-backup cosmos-calendar cosmos-contacts cosmos-cookbook cosmos-docs cosmos-gallery cosmos-mail cosmos-mcp cosmos-memory cosmos-notes cosmos-personal cosmos-preset cosmos-research cosmos-sessions cosmos-signature cosmos-skills cosmos-tasks cosmos-theme cosmos-webhook
# Zsh tab-completion for the cosmos umbrella + sub-CLIs.
#
# Drop in any directory on $fpath, e.g.:
#     fpath=(/path/to/cosmos-ui/scripts/_completion $fpath)
#     autoload -U compinit; compinit
#
# Then `cosmos <tab>` completes subcommands; `cosmos mail <tab>`
# completes mail subcommands; `cosmos-mail <tab>` works the same.

_cosmos_scripts_dir() {
    local self="${(%):-%x}"
    while [[ -L "$self" ]]; do self="$(readlink "$self")"; done
    cd "${self:h}/.." && pwd
}

typeset -gA _cosmos_subs

_cosmos_refresh() {
    _cosmos_subs=()
    local dir="$(_cosmos_scripts_dir)"
    local py="$dir/../venv/bin/python"
    [[ -x "$py" ]] || py="$(command -v python3)"
    local f sub help_out commands
    for f in "$dir"/cosmos-*; do
        [[ -x "$f" ]] || continue
        case "$f" in
            *.bak|*.pyc|*.pre-*) continue ;;
        esac
        sub="${${f:t}#cosmos-}"
        help_out=$("$py" "$f" --help 2>/dev/null) || continue
        commands=$(echo "$help_out" | grep -oE '\{[a-z0-9_,-]+\}' | head -1 \
            | tr -d '{}' | tr ',' ' ')
        _cosmos_subs[$sub]="$commands"
    done
}

_cosmos() {
    [[ ${#_cosmos_subs} -eq 0 ]] && _cosmos_refresh

    local cmd="${words[1]}"

    if [[ "$cmd" == "cosmos" ]]; then
        if (( CURRENT == 2 )); then
            local -a subs=(${(k)_cosmos_subs} help)
            _describe 'subcommand' subs
            return
        fi
        local sub="${words[2]}"
        if [[ "$sub" == "help" ]] && (( CURRENT == 3 )); then
            local -a subs=(${(k)_cosmos_subs})
            _describe 'subcommand' subs
            return
        fi
        if (( CURRENT == 3 )); then
            local -a sc=(${(s/ /)_cosmos_subs[$sub]})
            _describe 'command' sc
            return
        fi
        return
    fi

    # cosmos-foo <tab>
    local sub="${cmd#cosmos-}"
    if (( CURRENT == 2 )); then
        local -a sc=(${(s/ /)_cosmos_subs[$sub]})
        _describe 'command' sc
        return
    fi
}

_cosmos "$@"
