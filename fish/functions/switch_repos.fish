function switch_repos --description "Jump to a git repo by name, or cd to repo root"
    set -l repo_name $argv[1]

    # List known repos
    if test "$repo_name" = "-ls"
        if test -d ~/Projects
            find -L ~/Projects -maxdepth 1 -type d -mindepth 1 -exec basename {} \;
        end
        if test -d ~/Development
            find -L ~/Development -maxdepth 3 -name '.git' | sed -E 's|(.*)/\.git|\1|' | xargs basename
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

    # Repo name given: find and cd into it
    set -l repo_path (find -L ~/Projects -maxdepth 1 -type d -name "$repo_name" 2>/dev/null | head -n 1)

    if test -z "$repo_path"
        set -l matches (find -L ~/Development -maxdepth 3 -path "*/$repo_name/.git" 2>/dev/null)
        if test -n "$matches"
            set repo_path (dirname "$matches[1]")
        end
    end

    if test -z "$repo_path"
        echo "No such repo: \"$repo_name\""
    else
        cd "$repo_path"
    end
end
