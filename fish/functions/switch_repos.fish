function switch_repos --description "Jump to a git repo by name, or cd to repo root"
    set -l repo_name $argv[1]

    # Default search roots; override in config.local.fish:
    #   set -g SWITCH_REPOS_ROOTS ~/Projects ~/Development ~/other
    if not set -q SWITCH_REPOS_ROOTS
        set -g SWITCH_REPOS_ROOTS ~/Projects ~/Development
    end

    # List known repos
    if test "$repo_name" = "-ls"
        for root in $SWITCH_REPOS_ROOTS
            test -d "$root" || continue
            _find_gitdirs "$root" | string replace -r '.*/([^/]+)/\.git$' '$1'
        end
        return
    end

    # No argument: cd to the root of the current git repo
    if test -z "$repo_name"
        set -l repo_root (git rev-parse --show-toplevel 2>&1)
        if string match -q "fatal:*" -- "$repo_root"
            echo "Could not find repo root. Are you in a git repo?"
        else
            cd "$repo_root"
        end
        return
    end

    # Repo name given: find and cd into it — use targeted search with early termination
    set -l repo_path
    if command -q fd
        set repo_path (fd --follow --max-depth 3 --hidden --no-ignore --type d --full-path --glob "**/$repo_name/.git" $SWITCH_REPOS_ROOTS 2>/dev/null | string replace -r '/$' '' | head -n 1)
    else
        set repo_path (find -L $SWITCH_REPOS_ROOTS -maxdepth 3 -path "*/$repo_name/.git" -print -quit 2>/dev/null)
    end

    if test -z "$repo_path"
        echo "No such repo: \"$repo_name\""
    else
        cd (dirname "$repo_path")
    end
end
