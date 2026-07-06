function blender --wraps='flatpak run org.blender.Blender' --description 'alias blender=flatpak run org.blender.Blender'
  flatpak run org.blender.Blender $argv
        
end
