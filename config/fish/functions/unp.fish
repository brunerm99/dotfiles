function unp
    for f in $argv
        set dir (string replace -r '\.\w+$' '' (basename $f))
        mkdir -p $dir
        cp $f $dir/
        pushd $dir
        command unp (basename $f)
        rm (basename $f)
        popd
    end
end
