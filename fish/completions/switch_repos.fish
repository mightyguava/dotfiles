complete --command switch_repos --no-files --arguments "(
    if not set -q SWITCH_REPOS_ROOTS
        set -g SWITCH_REPOS_ROOTS ~/Projects ~/Development
    end
    set -l repos
    for root in \$SWITCH_REPOS_ROOTS
        test -d \"\$root\" || continue
        set repos \$repos (_find_gitdirs \"\$root\" | string replace -r '.*/([^/]+)/\.git\$' '\$1' 2>/dev/null)
    end
    printf '%s\n' \$repos | sort -u
)"
