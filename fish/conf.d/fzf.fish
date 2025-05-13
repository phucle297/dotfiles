function cdf
    set dir (find . -type d -not -path '*/\.*' | fzf)
    if test -n "$dir"
        cd "$dir"
    end
end
