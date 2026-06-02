# Emit paths to .git directories under the given root(s).
# Prefers fd over find for speed.
function _find_gitdirs
    if command -q fd
        fd --follow --max-depth 3 --hidden --no-ignore --type d --glob '.git' $argv 2>/dev/null | string replace -r '/$' ''
    else
        find -L $argv -maxdepth 3 -name '.git' 2>/dev/null
    end
end
