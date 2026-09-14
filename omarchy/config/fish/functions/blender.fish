function blender --wraps=blender --description 'Run native Blender or the Flatpak'
    if command -q blender
        command blender $argv
    else
        flatpak run org.blender.Blender $argv
    end
end
