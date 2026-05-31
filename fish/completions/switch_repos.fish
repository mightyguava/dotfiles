complete --command switch_repos --no-files --arguments "(
    set -l repos
    if test -d ~/Projects
        set repos \$repos (find -L ~/Projects -maxdepth 1 -type d -mindepth 1 -exec basename {} \\; 2>/dev/null)
    end
    if test -d ~/Development
        set repos \$repos (find -L ~/Development -maxdepth 3 -name '.git' 2>/dev/null | sed -E 's|(.*)/\\.git|\\1|' | xargs basename 2>/dev/null)
    end
    printf '%s\n' \$repos | sort -u
)"
