script "Global | Camera | Tools | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Camera | Tools | Menu
type: controller
version: 0.2

/*Here you can describe this menu.
Full help text should be provided on the linked wiki.*/


--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   return the camera_View of tObject
end menu_Target

getprop menu_CheckTarget [mTarget]
   return exists (mTarget)
end menu_CheckTarget

getprop video_Param
   return 2
end video_Param

getprop video_Params
   return 1,2,3
end video_Params


--> Global | Camera | Tools | Menu
-
on menu_CameraInit cameraView
   dispatch "camera_Init" to cameraView
end menu_CameraInit

on menu_OpenCamera cameraView
   put the camera_Open of cameraView into sBoolean
   set the camera_Open of cameraView to (sBoolean is false)
end menu_OpenCamera

private on _
end _

on menu_Video cameraView, deviceName
   set the video_DeviceName of cameraView to deviceName
end menu_Video

on menu_Audio cameraView, deviceName
   set the audio_DeviceName of cameraView to deviceName
end menu_Audio

on menu_Record cameraView
   breakpoint
end menu_Record

on menu_Close cameraView
   breakpoint
end menu_Close

private on __
end __

on menu_SetMenu cameraView
   get the camera_MenuGroupData of cameraView
   display_Data it, "camera_MenuGroupData"
end menu_SetMenu

on menu_MenuManager cameraView
   put the name of cameraView
end menu_MenuManager


