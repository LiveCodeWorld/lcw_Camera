script "Global | Camera | Menu"
--> MetaData
-
license: GPLv3
name: Global | Camera | Menu
type: controller
version: 0.2


--> Menu | Init
-
local LocalArray

getprop menu_Target [tObject]
   put camera_ViewGuess (tObject) into cameraView
   if exists (cameraView) then
      put the video_DeviceNames of cameraView into deviceNames
      put deviceNames into LocalArray ["deviceNames"]
   end if
   --
   return cameraView
end menu_Target

function camera_ViewGuess tObject
   ## Camera View?
   put the camera_View of tObject into cameraView
   if exists (cameraView) is true then
      return cameraView
   end if
   
   ## ???
   put the display_View of tObject into dView
   if exists (dView) is true then
      put the title_Text of dView into displayTitle
      switch displayTitle 
         case "lcw_Camera"
         case "View|Camera"
            break
         default
            -- breakpoint
      end switch
      put view_GetTemplateObject ("View|Camera") into cameraView
      return cameraView
   end if
   
   # Another display
   put the displayed_Object of dView into cameraView
   put the camera_View of tObject into cameraView
   if exists (cameraView) is true then
      return cameraView
   else
      return empty
   end if
end camera_ViewGuess

getprop cameraColour_Params
   return "default,-,black,white,red,yellow,green,-,choose"
end cameraColour_Params

getprop video_Param [cameraView]
   put the video_DeviceName of cameraView into videoDeviceName
   return videoDeviceName
end video_Param

getprop video_Params [cameraView]
   return LocalArray ["deviceNames"]
end video_Params

getprop audio_Param [cameraView]
   put the audio_DeviceName of cameraView into deviceName
   return deviceName
end audio_Param

getprop audio_Params [cameraView]
   put the audio_DeviceNames of cameraView into deviceNames
   return deviceNames
end audio_Params

getprop shape_Param [cameraView]
   put the graphic_Shape of cameraView into gShape
   return gShape
end shape_Param

getprop shape_Params
   return "rectangle,roundrect,oval,-,hexagon,pentagon,triangle"
end shape_Params

getprop checked_Open [cameraView]
   put the camera_Open of cameraView into sBoolean
   return sBoolean
end checked_Open

getprop disabled_CloneCamera
   return exists (stack "View|Camera") is false
end disabled_CloneCamera


--> Global | Camera | Menu
-
on menu_CameraInit cameraView
   dispatch "camera_Init" to cameraView
end menu_CameraInit

private on _
end _

on menu_OpenCamera cameraView
   put the camera_Open of cameraView into sBoolean
   set the camera_Open of cameraView to (sBoolean is false)
end menu_OpenCamera

private on __
end __

on menu_Video cameraView, deviceName
   set the video_DeviceName of cameraView to deviceName
end menu_Video

on menu_Audio cameraView, deviceName
   set the audio_DeviceName of cameraView to deviceName
end menu_Audio

on submenu_Record
   return "Global | Camera | Recording | Menu"
end submenu_Record

on submenu_Close
   return "Global | Camera | Close | Menu"
end submenu_Close

on submenu_Screen
   return "Global | Screen | Record | Menu"
end submenu_Screen

private on ___
end ___

on menu_CameraColour cameraView, colourChoice
   switch colourChoice
      case "default"
         set the backgroundcolor of cameraView to empty
         break
      case "Choose"
         answer color with "white"
         if it is not empty then
            set the backgroundcolor of cameraView to it
         end if
         break
      default
         set the backgroundcolor of cameraView to colourChoice
   end switch
end menu_CameraColour

on menu_Shape cameraView, gShape
   set the graphic_Shape of cameraView to gShape
end menu_Shape

getprop checked_Opaque [cameraView]
   return the opaque of cameraView is false
end checked_Opaque
   
on menu_Opaque cameraView
   put the opaque of cameraView into isOpaque
   set the opaque of cameraView to (isOpaque is false)
   if isOpaque is false then
      set the backgroundcolor of cameraView to empty
   end if
end menu_Opaque

private on ____
end ____

on menu_CloneCamera cameraView
   stack_Clone "View|Camera"
end menu_CloneCamera

on menu_ReplaceWithPlaceholder tObject
   put the short name of tObject into oName
   set the control_Type [oName] of tObject to "placeHolder"
   put the result into newView
end menu_ReplaceWithPlaceholder

on menu_LayoutControl cameraView
   dispatch "LayoutControl" to cameraView
end menu_LayoutControl

private on _____
end _____

on menu_EditBehavior cameraView
   put the behavior of cameraView into bObject
   edit the script of bObject
end menu_EditBehavior

on submenu_Frame
   return "Global | Frame | Menu"
end submenu_Frame

on submenu_Dev
   return "Global | Camera | Test | Menu"
end submenu_Dev
