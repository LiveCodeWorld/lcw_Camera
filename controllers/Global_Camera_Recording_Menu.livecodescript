script "Global | Camera | Recording | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Camera | Recording | Menu
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
   put camera_ViewGuess (tObject) into cameraView
   if exists (cameraView) is false then return empty
   --
   put camera_ListLocalRecordings() into recordingFiles
   put recordingFiles into LocalArray ["recordingFiles"]
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

command mDouble_UploadRecording
   breakpoint
   put the params
end mDouble_UploadRecording

command _AnswerResult theResult
   if theResult is empty then
      answer "Uploaded asset!"
   else
      put the result
      answer "Failed to upload file :("
   end if
end _AnswerResult

getprop uploadRecording_Params
   return LocalArray ["recordingFiles"]
end uploadRecording_Params

getprop deleteLocalRecording_Params
   return LocalArray ["recordingFiles"]
end deleteLocalRecording_Params

getprop recordingMetadata_Params
   return LocalArray ["recordingFiles"]
end recordingMetadata_Params

getprop disabled_StartRecording [cameraView]
   if the shiftkey is "Down" then return false
   put the camera_RecordingPath of cameraView into mFilePath
   if mFilePath is empty then
      return false
   else
      return true
   end if
end disabled_StartRecording

-- getprop disabled_StopRecording [cameraView]
   put the camera_RecordingPath of cameraView into mFilePath
   if mFilePath is empty then
      return true
   else
      return false
   end if
end disabled_StopRecording

getprop disabled_DeleteLocalRecording [cameraView]
   return LocalArray ["recordingFiles"] is empty
end disabled_DeleteLocalRecording

getprop disabled_DisplayRecordings [cameraView]
   return LocalArray ["recordingFiles"] is empty
end disabled_DisplayRecordings

on mDoubleUp_Recording fldObject, shortFile
   put camera_LocalRecordingPath (shortFile, true) into mFilePath
   --
   put spotlight_ListMovieInfo (mFilePath)
   finder_Reveal mFilePath
end mDoubleUp_Recording

getprop activeCamera_Param [cameraView]
   return the camera_name of cameraView
end activeCamera_Param

getprop activeCamera_Params
   return cameraControls()
end activeCamera_Params


--> Global | Camera | Recording | Menu
-
on menu_ActiveCamera cameraView, cameraName
   cameraControlDelete cameraName
end menu_ActiveCamera

private command _
end _

on menu_StartRecording cameraView
   put the stack_Label of cameraView into sLabel
   if sLabel is empty then
      put the camera_Name of cameraView into cameraName
      put cameraName & ".mp4" into shortFile
   else
      put sLabel & ".mp4" into shortFile
   end if
   put lcw_Ask ("Choose a file name for this recording", shortFile, cameraView) into shortFile
   put camera_LocalRecordingPath (shortFile, true) into mFilePath
   --
   if there is a file mFilePath then
      put mFilePath
      lcw_AnswerWarning "File already exists. Please choose another file name", cameraView
   end if
   --
   cameraControlDo cameraName, "startRecording", mFilePath
   put the result into someResult
   --
   set the camera_RecordingPath of cameraView to mFilePath
end menu_StartRecording

on menu_StopRecording cameraView
   put the camera_Name of cameraView into cameraName
   --
   cameraControlDo cameraName, "stopRecording"
   put the result into doResult
   -- 
   display_CameraRecordings
end menu_StopRecording

private command __
end __

getprop checked_SetRecordingFolder [cameraView]
   put the uLCW ["recording_Folder"] of cameraView into rFolder
   put there is a folder rFolder into folderExists
   return folderExists
end checked_SetRecordingFolder
   
on menu_SetRecordingFolder cameraView
   camera_SetRecordingFolder
   put the result into rFolder
   if rFolder is empty then exit to top
   --
   set the uLCW ["recording_Folder"] of cameraView to rFolder
   --
   display_CameraRecordings
end menu_SetRecordingFolder

on menu_DeleteLocalRecording cameraView, shortFile
   put the long id of control 1 of cd 1 of stack "View|Camera" into cameraView
   --
   put camera_LocalRecordingPath (shortFile, true) into mFilePath
   --
   lcw_Answer "Are you sure you want to delete the local recording '[[shortFile]]'?", cameraView, shortFile
   --
   -- delete file mFilePath
   revDeleteFile mFilePath
end menu_DeleteLocalRecording

private command ___
end ___

on menu_DisplayRecordings cameraView
   put the uLCW ["recording_Folder"] of cameraView into rFolder
   if rFolder is empty then
      put camera_GetRecordingFolder() into rFolder
   end if
   if there is not a folder rFolder then
      lcw_AnswerWarning "Recording folder does not exist!"
   end if
   --
   display_CameraRecordings rFolder
end menu_DisplayRecordings

on submenu_Dev
   return menu_DevTitle ("Global | Camera | Recording | Menu")
end submenu_Dev
