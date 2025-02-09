script "lib_Camera"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: lib_Camera
type: library
version: 0.2

/*Some help*/


--> Working on
-
command camera_LoadAndSet cameraName, pVideoDeviceID, pAudioDeviceID
   ## Load DeviceArrays
   put camera_VideoDeviceArray (cameraName) into videoDeviceArray
   put camera_AudioDeviceArray (cameraName) into audioDeviceArray
   
   ## Set video device
   if pVideoDeviceID is empty then
      put camera_DefaultVideoDeviceID (videoDeviceArray) into pVideoDeviceID
   end if
   cameraControlSet pCameraName, "videoDevice", videoDeviceID
   
   ## Set audio device
   if pAudioDeviceID is empty then
      put _DefaultAudioDeviceID (audioDeviceArray) into pAudioDeviceID
   end if
   cameraControlSet pCameraName, "videoDevice", videoDeviceID   
end camera_LoadAndSet


--> Props
-
getprop camera_RecordingPath [pAsk]
   -- refactor
   -- dont put dialogues in custom prop handlers
   
   put the camerra_View of the target into cameraView
   if exists (cameraView) is false then return empty
   --
   put the stack_Label of cameraView into sLabel
   if sLabel is empty then
      put the camera_Name of cameraView into cameraName
      put cameraName & ".mp4" into shortFile
   else
      put sLabel & ".mp4" into shortFile
   end if
   --
   if pAsk is true then
      put lcw_Ask ("Choose a file name for this recording", shortFile, cameraView) into shortFile
   end if
   put camera_LocalRecordingPath (shortFile, true) into mFilePath
   return mFilePath
end camera_RecordingPath

getprop camera_RecordingFolder [pCreate]
   put the uLCW ["recording_Folder"] of the target into rFolder
   if there is a folder rFolder then
      return rFolder
   end if
   
   put camera_GetRecordingFolder (pCreate) into rFolder
   return rFolder
end camera_RecordingFolder

setprop camera_RecordingFolder [pCreate] rFolder
   set the uLCW ["recording_Folder"] of the target to rFolder
   --
   if pCreate is not false then
      folder_CreateNested rFolder
   end if
   return false
end camera_RecordingFolder


--> Camera
-
function camera_ListNames
   return cameraControls()
end camera_ListNames


--> Camera | Hack
-
function camera_DefaultAudioDeviceID audioDeviceArray
   put camera_DefaultAudioDeviceName() into deviceName
   put audioDeviceArray ["name"][deviceName] into audioDeviceID
   return audioDeviceID
end camera_DefaultAudioDeviceID

function camera_DefaultVideoDeviceID videoDeviceArray
   put camera_DefaultVideoDeviceName() into deviceName
   put videoDeviceArray ["name"][deviceName] into videoDeviceID
   return videoDeviceID
end camera_DefaultVideoDeviceID

function camera_DefaultAudioDeviceName pCameraName, pFilter
   -- return "MacBook Air Microphone"
   if pFilter is empty then put "MacBook *" into pFilter
   --
   put camera_ListAudioDeviceNames (pCameraName) into audioDeviceNames
   if item 1 of audioDeviceNames = "Error" then return empty
   
   get audioDeviceNames
   filter it with pFilter
   if it is empty then
      put line 1 of audioDeviceNames into defaultDeviceName
   else
      put line 1 of it into defaultDeviceName
   end if
   return defaultDeviceName
end camera_DefaultAudioDeviceName

function camera_DefaultVideoDeviceName pCameraName, pFilter
   -- return "FaceTime HD Camera"
   if pFilter is empty then put "FaceTime *" into pFilter
   --
   put camera_ListVideoDeviceNames (pCameraName) into cameraDeviceNames
   if item 1 of cameraDeviceNames = "Error" then return empty
   
   get cameraDeviceNames
   filter it with pFilter
   if it is empty then
      put line 1 of cameraDeviceNames into defaultDeviceName
   else
      put line 1 of it into defaultDeviceName
   end if
   return defaultDeviceName
end camera_DefaultVideoDeviceName

function camera_ListVideoDeviceNames pCameraName
   if pCameraName is empty then
      put line 1 of camera_ListNames() into pCameraName
      if pCameraName is empty then
         return "Error, no camera is open."
      end if
   end if
   put camera_VideoDeviceArray (pCameraName) into videoDeviceArray
   --
   put videoDeviceArray ["name"] into nameArray
   put keys (nameArray) into videoDeviceNames
   return videoDeviceNames
end camera_ListVideoDeviceNames

function camera_VideoDeviceArray cameraName
   put cameraControlGet (cameraName, "videoDevices") into videoDeviceTable
   put _ArrayFromTable (videoDeviceTable) into videoDeviceArray   
   return videoDeviceArray
end camera_VideoDeviceArray

function camera_ListAudioDeviceNames pCameraName
   if pCameraName is empty then
      put line 1 of camera_ListNames() into pCameraName
      if pCameraName is empty then
         return "Error, no camera is open."
      end if
   end if
   put camera_AudioDeviceArray (pCameraName) into audioDeviceArray
   --
   put audioDeviceArray ["name"] into nameArray
   put keys (nameArray) into audioDeviceNames
   return audioDeviceNames
end camera_ListAudioDeviceNames

function camera_AudioDeviceArray cameraName
   put cameraControlGet (cameraName, "audioDevices") into audioDeviceTable
   put _ArrayFromTable (audioDeviceTable) into audioDeviceArray
   return audioDeviceArray
end camera_AudioDeviceArray


--> Camera | Files
-
function camera_LocalRecordingPath shortFile, pCreate
   -- not interesting
   put camera_GetRecordingFolder (pCreate) into rFolder
   return rFolder & shortFile
end camera_LocalRecordingPath

function camera_ListLocalRecordings
   put camera_GetRecordingFolder (false) into rFolder
   put file_ListShort (rFolder) into rFiles
   --
   sort rFiles
   if rFiles contains "_" then
      set the itemdelimiter to "_"
      sort numeric rFiles by item 1 of each
   end if
   --
   return rFiles
end camera_ListLocalRecordings

function camera_GetRecordingFolder pCreate
   put pref_GetValue ("Camera Recording Folder") into rFolder
   if rFolder is empty then
      put the home folder & "/Movies/Recordings/" into rFolder
      if pCreate is true then
         folder_CreateNested rFolder
      end if
   end if
   text_AddTrailing rFolder, slash
   return rFolder
end camera_GetRecordingFolder

command camera_SetRecordingFolder pFolder
   if pFolder is empty then
      put "~/Movies/Recordings" into defaultPath
      answer folder "Choose a recording folder..." with defaultPath
      put it into pFolder
      if pFolder is empty then
         return empty
      end if
   end if
   pref_SetValue "Camera Recording Folder", pFolder
   return pFolder
end camera_SetRecordingFolder


--> Camera | Record
-
command camera_StartRecording cameraView, pAsk
   put the camera_Name of cameraView into cameraName
   if cameraName is empty then
      breakpoint
      return empty
   end if
   put the camera_RecordingPath [pAsk] of cameraView into mFilePath
   --
   if there is a file mFilePath then
      -- Cancel, don't overwrite.
      put mFilePath
      lcw_AnswerWarning "File already exists. Please choose another file name", cameraView
   end if
   --
   cameraControlDo cameraName, "startRecording", mFilePath
   put the result into someResult
   --
   _SetRecordingMetadata cameraView, mFilePath
   --
   return mFilePath
end camera_StartRecording

command camera_StopRecording cameraView
   put the camera_Name of cameraView into cameraName
   --
   cameraControlDo cameraName, "stopRecording"
   put the result into doResult
   -- 
   display_CameraRecordings
end camera_StopRecording


--> Camera | Open
-
command camera_CloseAll pCameraNames
   if pCameraNames is empty then
      put cameraControls() into pCameraNames
   end if
   repeat for each line cameraName in pCameraNames
      cameraControlDelete cameraName
   end repeat
   -- delete variable LocalArray
end camera_CloseAll

command camera_CloseCloned
   breakpoint
   put camera_ConstructStackNameArray() into cameraStackNameArray
   put cameraStackNameArray ["open"] into openCameraArray
   repeat for each key sName in openCameraArray
      put openCameraArray [sName]["cView"] into cView
      put openCameraArray [sName]["cName"] into cName
      --
      set camera_Open of cView to false
   end repeat
end camera_CloseCloned


--> Camera | Close
-
command camera_RevealRecording cameraView
   put the camera_Name of cameraView into cameraName
   put cameraName & ".mov" into shortFile
   put camera_LocalRecordingPath (shortFile) into mFilePath
   --
   finder_Reveal mFilePath
end camera_RevealRecording

command camera_ReOpenAll cameraView
   put camera_ConstructStackNameArray() into cameraStackNameArray
   put cameraStackNameArray ["open"] into openCameraArray
   repeat for each key sName in openCameraArray
      put openCameraArray [sName]["cView"] into cView
      put openCameraArray [sName]["cName"] into cName
      --
      set camera_Open of cView to true
   end repeat
end camera_ReOpenAll


--> Camera
-
function camera_CheckAllFrameless sNames
   repeat for each line sName in sNames
      if the decorations of stack sName is not empty then
         return false
      end if
   end repeat
   return true
end camera_CheckAllFrameless

function camera_ListStackNames pFilterLive
   put camera_ConstructStackNameArray() into cameraStackNameArray
   switch pFilterLive
      case "closed"
         put cameraStackNameArray ["closed"] into sNameArray
         break
      case "open"
         put cameraStackNameArray ["open"] into sNameArray
         break
      default
         put cameraStackNameArray ["closed"] into cNameArray
         put cameraStackNameArray ["open"] into sNameArray
         union sNameArray with cNameArray
   end switch
   put the keys of sNameArray into sNames
   sort sNames
   return sNames
end camera_ListStackNames

function camera_ConstructStackNameArray
   put the openstacks into sNames
   filter sNames with "View|Camera*"
   repeat for each line sName in sNames
      get the long id of control 1 of stack sName
      put revRuggedId (it) into cameraView
      --
      put the camera_Name of cameraView into cName
      if cName is empty then
         put cameraView into cameraStackNameArray ["closed"][sName]
      else
         put cameraView into cameraStackNameArray ["open"][sName]["cView"]
         put cName into cameraStackNameArray ["open"][sName]["cName"]
      end if
   end repeat
   return cameraStackNameArray
end camera_ConstructStackNameArray


--> Private
-
private function _ArrayFromTable deviceTable
   put deviceTable into idArray
   split idArray by CR and comma
   put idArray into deviceArray ["id"]
   
   repeat for each line someLine in deviceTable
      put item 1 to -2  of someLine into deviceID
      put item -1 of someLine into deviceName
      put deviceID into deviceArray ["name"][deviceName]
   end repeat
   return deviceArray
end _ArrayFromTable
