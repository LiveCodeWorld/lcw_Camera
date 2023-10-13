script "Global | Camera | Recording | Dev | Menu"
--> MetaData
-
license: GPLv3
name: Global | Camera | Recording | Dev | Menu
type: controller
author: David Bovill
version: 0.1

/*
Here you can describe this menu.
Full help text should be provided on the linked wiki.
*/

--> Variables
-
local LocalArray

--> Menu | Props
-
getprop menu_Target [tObject]
   put the camera_ViewGuess of tObject into cameraView
   if exists (cameraView) is false then return empty
   return cameraView
   
   -- put camera_ListLocalRecordings() into recordingFiles
   -- put recordingFiles into LocalArray ["recordingFiles"]
end menu_Target


--> Global | Camera | Recording | Dev | Menu
-
on menu_Refresh
   display_CameraRecordings
   
   /*
   put camera_ListLocalRecordings() into recordingFiles
   put recordingFiles into LocalArray ["recordingFiles"]
   --
   set the displayed_Index of displayView to recordingFiles
   */
end menu_Refresh

on menu_RevealRecording cameraView
   camera_RevealRecording cameraView
end menu_RevealRecording

private on _
end _

on menu_RecordingMetadata cameraView, shortFile
   put camera_LocalRecordingPath (shortFile, true) into movieFile
   --
   put spotlight_ListMovieInfo (movieFile)
end menu_RecordingMetadata

on menu_UploadToAtopia cameraView, shortFile
   put camera_LocalRecordingPath (shortFile, true) into mFilePath
   --
   set the itemdelimiter to slash
   put item -1 of mFilePath into shortFile
   put lcw_Ask ("Choose a title for a wiki page for this recording...", shortFile) into pTitle
   put lcw_Ask ("Describe this recording...", empty) into pDescription
   --
   atopia_UploadRecording mFilePath, pTitle, pDescription
   --
   put the result into wikiURL
   if theResult is empty then
      answer "Failed to upload file :("
   else
      launch url wikiURL
   end if
end menu_UploadToAtopia

on menu_TestOpenProcess displayView
   /*
   put the selected_Line of displayView into shortFile
   put camera_LocalRecordingPath (shortFile, true) into localFile
   set the itemdelimiter to slash
   put localFile into rFolder
   put slash into item -1 of rFolder
   --
   */
   put camera_GetRecordingFolder() into rFolder
   rsync_OpenProcess rFolder, "david.obeya.xyz"
end menu_TestOpenProcess

on menu_Behavior displayView
   put the behavior of displayView into bObject
   edit the script of bObject
end menu_Behavior
