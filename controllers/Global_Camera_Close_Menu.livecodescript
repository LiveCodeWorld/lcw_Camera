script "Global | Camera | Close | Menu"
--> MetaData
-
copyright: Anonymous
license: GPLv3
name: Global | Camera | Close | Menu
type: controller
version: 0.1

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   put the camera_View of tObject into cameraView
   if exists (cameraView) is false then
      put the display_View of tObject into dView
      if exists (dView) is false then return empty
      
      put the displayed_Object of dView into cameraView
      put the camera_View of tObject into cameraView
      if exists (cameraView) is false then return empty
   end if
   
   put camera_ListNames() into LocalArray ["cameraNames"]
   return cameraView
end menu_Target


--> Global | Camera | Close | Menu
-
on menu_CloseCamera cameraView
   set the camera_Open of cameraView to false
end menu_CloseCamera

getprop disabled_CloseCamera [cameraView]
   put LocalArray ["cameraNames"] into cameraNames
   if cameraNames is empty then return true
   --
   put the camera_Name of cameraView into cameraName
   return cameraName is not among the lines of cameraNames
end disabled_CloseCamera

on menu_CloseNamedCamera dView, cameraName
   cameraControlDelete cameraName
end menu_CloseNamedCamera

getprop closeNamedCamera_Params
   return LocalArray ["cameraNames"]
end closeNamedCamera_Params

getprop disabled_CloseNamedCamera [dView]
   return LocalArray ["cameraNames"] is empty
end disabled_CloseNamedCamera

on menu_CloseAllCameras
   camera_CloseAll
end menu_CloseAllCameras

getprop disabled_CloseAllCameras [dView]
   return LocalArray ["cameraNames"] is empty
end disabled_CloseAllCameras
