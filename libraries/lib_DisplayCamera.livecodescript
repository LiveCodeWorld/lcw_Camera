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
getprop camera_IsOpen
   put the camera_DefaultName of the target into cameraName
   --
   put cameraControls() into cameraNames
   return cameraName is among the lines of cameraNames
end camera_IsOpen

setprop camera_Video [pRect] videoDeviceName
   put the long id of the target into tObject
   if pRect is empty then put the rect of tObject into pRect
   
   # Create camera if needed
   put the camera_DefaultName of tObject into cameraName
   --
   put cameraControls() into cameraNames
   if cameraName is among the lines of cameraNames then
      if videoDeviceName is empty then
         cameraControlDelete cameraName
         return empty
      end if
   else
      cameraControlCreate cameraName 
   end if
   
   # Set camera props
   put camera_VideoDeviceArray (cameraName) into videoDeviceArray
   put camera_VideoDeviceID (videoDeviceName, videoDeviceArray) into videoDeviceID
   --
   cameraControlSet cameraName, "videoDevice", videoDeviceID
   cameraControlSet cameraName, "rect", pRect
   cameraControlSet cameraName, "visible", true
   --
   return videoDeviceID
end camera_Video

getprop camera_IsVisible
   put the camera_Property ["visible"] of the target into sBoolean
   return sBoolean
end camera_IsVisible

setprop camera_IsVisible sBoolean
   set the camera_Property ["visible"] of the target to sBoolean
   return the result
end camera_IsVisible

getprop camera_Property [propName]
   put the camera_Name of the target into cameraName
   if cameraName is empty then return "Error, no named camera:" && cameraName
   --
   put cameraControlGet (cameraName, propName) into propValue
   return propValue
end camera_Property

setprop camera_Property [propName] propValue
   put the camera_Name of the target into cameraName
   if cameraName is empty then return "Error, no named camera:" && cameraName
   --
   cameraControlSet cameraName, propName, propValue
   return the result
end camera_Property

getprop camera_Name
   put the camera_DefaultName of the target into cameraName
   put camera_ListNames() into cameraNames
   if cameraName is among the lines of cameraNames then
      return cameraName
   else
      return empty
   end if
end camera_Name

getprop camera_DefaultName
   put the long id of the target into tObject
   --
   put the short id of tObject into myID
   put the stack_Name of tObject into stackName
   put stackName && myID into cameraName
   --
   return cameraName
end camera_DefaultName


--> Display
-
command display_Camera cameraDeviceName, sRect
   display_Clone "View|Camera", "Camera", cameraDeviceName, "camera_DeviceName", sRect
   put the result into displayView
   return displayView
end display_Camera


--> Camera | Recording
-
command display_CameraRecordings pDisplayView
   put camera_ListLocalRecordings() into recordingFiles
   --
   display_Data recordingFiles, "Local", "Recordings", pDisplayView
   
   put the result into displayView
   display_SetInteractions displayView, "Camera | Recording", "mDoubleUp_Recording"
   return displayView
end display_CameraRecordings

function search_FindViews viewGetProp, pStackNames
   if viewGetProp is empty then put "view_Object" into viewGetProp
   put stack_ListNames (pStackNames) into stackNames
   --
   put search_StackNames (stackNames, "camera_View") into searchData -- searches everything in stack
   -- put search_StacksForValue (stackNames, "view_Name", "View|Camera") into searchData
   return keys (searchData)
end search_FindViews

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
