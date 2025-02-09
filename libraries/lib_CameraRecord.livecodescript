script "lib_CameraRecord"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_CameraRecord
type: library
version: 0.1

/*Some help*/


--> Working on
-


--> Camera | Record
-
--> Camera | Record
-
function record_GetCameraName
   put record_GetSettingsArray() into sArray
   
end record_GetCameraName

function record_GetSettingsArray
   global gLCW
   --
   return gLCW ["temp"]["Record"]
end record_GetSettingsArray

function record_GetWhat
   global gLCW
   put gLCW ["temp"]["Record"]["What"] into recordWhat
   return recordWhat
end record_GetWhat

command record_SetWhat recordWhat, pCameraView, pRecordPath
   global gLCW
   if recordWhat is empty then put "Screen" into recordWhat
   --
   switch recordWhat
      case "Camera"
         put pCameraView into gLCW ["temp"]["Record"]["Camera"]["View"]
         --
         put the camera_Name of pCameraView into cameraName
         put cameraName into gLCW ["temp"]["Record"]["Camera"]["camera_Name"]
         put mFilePath into gLCW ["temp"]["Record"]["Camera"]["recording_Path"]
         --
         if exists (pCameraView) then
            set the camera_RecordingPath of pCameraView to mFilePath
         end if
         break
      case "Screen"
         put empty into gLCW ["temp"]["Record"]["Screen"]
         delete variable gLCW ["temp"]["Record"]["Camera"]
      default
         put empty into gLCW ["temp"]["Record"][recordWhat]
         delete variable gLCW ["temp"]["Record"]["Camera"]
   end switch
   return record_GetSettingsArray()
end record_SetWhat

command camera_ToggleRecord
   
end camera_ToggleRecord


