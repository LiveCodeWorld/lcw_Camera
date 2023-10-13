script "lib_DisplayCamera"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_DisplayCamera
type: library
version: 0.1

/*Some help*/


--> Variables
-
local LocalArray


--> Working on
-
command display_CameraRecordings pDisplayView
   put camera_ListLocalRecordings() into recordingFiles
   --
   display_Data recordingFiles, "Local", "Recordings", pDisplayView
   
   put the result into displayView
   display_SetInteractions displayView, "Camera | Recording", "mDoubleUp_Recording"
   return displayView
end display_CameraRecordings


--> Camera | Toggle
-
command camera_ToggleLoaded
   put camera_GetLoaded() into cameraViews
   if cameraViews is empty then return false
   --
   put line 1 of cameraViews into testView
   put the camera_Open of testView into isOpen
   put isOpen is false into sBoolean
   --
   _ToggleCameras sBoolean, cameraViews
   return the result
end camera_ToggleLoaded

command camera_OpenLoaded pCameraViews
   if pCameraViews is empty then put camera_GetLoaded() into pCameraViews
   ---
   _ToggleCameras true, pCameraViews
   return the result
end camera_OpenLoaded

command camera_CloseLoaded pCameraViews, pSearchWhat
   if pCameraViews is empty then put camera_GetLoaded() into pCameraViews
   ---
   _ToggleCameras false, pCameraViews
   return the result
end camera_CloseLoaded


--> Camera | Load
-
function camera_GetLoaded
   put LocalArray ["goodCameraViews"] into goodCameraViews
   if goodCameraViews is empty then
      camera_SetLoaded
   end if
   return goodCameraViews
end camera_GetLoaded

command camera_SetLoaded pSearchWhat
   put camera_FindViews (pSearchWhat) into pCameraViews
   --
   repeat for each line cameraView in pCameraViews
      if exists (cameraView) is false then
         put cameraView & CR after badCameraViews
         next repeat
      end if
      put revRuggedID (cameraView) & CR after goodCameraViews
   end repeat
   delete char -1 of goodCameraViews
   put goodCameraViews into LocalArray ["goodCameraViews"]
   --
   delete char -1 of badCameraViews
   put badCameraViews into LocalArray ["badCameraViews"]
   --
   return goodCameraViews
end camera_SetLoaded

function camera_FindViews pSearchWhat
   switch pSearchWhat
      case "loaded"
         put search_FindViews ("camera_View", "loaded") into cameraViews
         break
      case "named"
         put stack_ListNamedViews ("View|Camera") into cameraViews
         break
      case "open"
      default
         put search_FindViews ("camera_View") into cameraViews
   end switch
   return cameraViews
end camera_FindViews


--> Private
-
private command _ToggleCameras sBoolean, pCameraViews
   set the cursor to watch
   repeat for each line cameraView in pCameraViews
      if exists (cameraView) is false then next repeat
      --
      set the camera_Open of cameraView to sBoolean
      put cameraView & CR after goodCameraViews
   end repeat
   delete char -1 of goodCameraViews
   --
   put goodCameraViews into LocalArray ["goodCameraViews"]
   return goodCameraViews
end _ToggleCameras
