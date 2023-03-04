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
   put the camera_ViewGuess of tObject into cameraView
   --
   if exists (cameraView) then
      put the video_DeviceNames of cameraView into deviceNames
      put deviceNames into LocalArray ["deviceNames"]
   end if
   --
   return cameraView
end menu_Target

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

on menu_Open cameraView
   put the camera_Open of cameraView into sBoolean
   set the camera_Open of cameraView to (sBoolean is false)
end menu_Open

private command _
end _

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

private command __
end __

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

on menu_EditBehavior cameraView
   put the behavior of cameraView into bObject
   edit the script of bObject
end menu_EditBehavior

on menu_CloneCamera cameraView
   stack_Clone "View|Camera"
end menu_CloneCamera

on submenu_Frame
   return "Global | Frame | Menu"
end submenu_Frame
