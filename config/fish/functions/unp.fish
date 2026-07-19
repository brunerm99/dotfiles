function unp
    for f in $argv
        set base (basename "$f")
        set dir (string replace -r '\.[^.]+$' '' "$base")

        mkdir -p "$dir"
        cp "$f" "$dir/"

        pushd "$dir" > /dev/null

        if unzip -q "$base"
            rm "$base"
        else
            echo "Failed to unzip: $f"
        end

        popd > /dev/null
    end
end
