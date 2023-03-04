script "lib_DisplayCamera"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_DisplayCamera
type: library
version: 0.1

/*Some help*/


--> Working on
-


--> Display | Camera
-
--> Display | Camera
-
getprop camera_ViewGuess
   put the long id of the target into tObject
   --
   put the camera_View of tObject into cameraView
   --
   if exists (cameraView) is true then
      return cameraView
   else
      put the display_View of tObject into dView
      if exists (dView) is true then
         put the title_Text of dView into displayTitle
         switch displayTitle 
            case "lcw_Camera"
            case "View|Camera"
               break
            default
               breakpoint
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
   end if
end camera_ViewGuess

command display_CameraRecordings
   put camera_ListLocalRecordings() into recordingFiles
   --
   display_Data recordingFiles, "Local", "Recordings"
   put the result into displayView
   display_SetInteractions displayView, "Camera | Recording", "mDoubleUp_Recording"
   return displayView
end display_CameraRecordings
