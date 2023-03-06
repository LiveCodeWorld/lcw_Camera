script "behavior_ViewCamera"
--> MetaData
-
license: GPLv3
name: behavior_ViewCamera
type: behavior
version: 0.2

/*
cameraControlDo cameraName, "takePicture"
put the result -- into url ("file:" & specialFolderPath("documents") & "/snapshot.jpg")
*/

--> Variables
-
local LocalArray

/*
--> Events
-
on dragDrop
   put the keys of the dragData into dropKeys
   put the dragData ["text"] into droppedURL
   --
   put the dragData ["html"] into droppedHTML
   put "<p><a href='(.+\.html)'>.+</a></p>" into wikiHtmlURlReg
   replace "'" with quote in wikiHtmlURlReg
   --
   switch
      case "image" is among the lines of dropKeys
         put the dragData ["image"] into imageContents
         put "image" & CR & line 1 of imageContents
         break
      case droppedURL begins with "https://www.bbc.co.uk/iplayer/episode/"
         -- case matchtext (droppedURL, "https://www.bbc.co.uk/iplayer/episode/(.+)")
         put droppedURL
         break
      case droppedURL begins with "https://www.youtube.com/watch?v="
      case matchText (droppedURL, "https://www.youtube.com/watch?v=(.+)", tubeID)
         put droppedURL
         break
      case matchText (droppedURL, "https://vimeo.com/(.+)", vimeoID)
      case matchText (droppedURL, "https://vimeo.com/channels/staffpicks/(.+)", vimeoID)
         put droppedURL
         break
      case matchText (droppedHTML, wikiHtmlURlReg, wikiHtmlURl)
         put droppedHTML
         break
      default
         -- do nothing
         answer warning "I don't recognise this url!"
         put droppedURL
         break
      default
         put dropKeys
   end switch
   pass dragDrop
end dragDrop

on dragEnter
   set the allowableDragActions to "link"
   set the dragAction to "Link"
   pass dragEnter
end dragEnter

on mouseEnter
   focus on me
   pass mouseEnter
end mouseEnter

on mouseMove
   if the mouse is not "down" then pass mouseMove
   
   put the stack_Name of me into stackName
   put LocalArray ["mOffset"] into mOffset
   if mOffset is empty then pass mouseMove
   
   put the globalloc of the mouseloc into newLoc
   --
   add item 1 of mOffset to item 1 of newLoc
   add item 2 of mOffset to item 2 of newLoc
   --
   set the loc of stack stackName to newLoc
   --
   pass mouseMove
end mouseMove
*/


--> Working on
-


--> Geometry
-
on resizeControl   
   put the rect of me into viewRect
   LayoutControl viewRect
end resizeControl

command LayoutControl pRect
   lock screen
   if pRect is empty then put the rect of me into pRect
   put the margins of me into someMargin
   margin_Normalize someMargin, leftM, topM, rightM, bottomM
   --
   put pRect into graphicRect
   rect_SubtractMargins graphicRect, 2
   --
   set the camera_Rect of me to graphicRect
   --
   set the rect of _graphicObject() to graphicRect
   set the rect of _ImageObject() to graphicRect
   --
   unlock screen
end LayoutControl

private function _GetMouseOffset
   put the loc of me into mOffset
   get the mouseLoc
   subtract item 1 of it from item 1 of mOffset
   subtract item 2 of it from item 2 of mOffset
   return mOffset
end _GetMouseOffset


--> Camera | Close
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

getprop graphic_Shape
   put _graphicObject() into gObject
   --
   put the style of gObject into gShape
   if gShape is not "regular" then
      return gShape
   end if
   
   -- work out regular polygon names
   put the polySides of gObject into pNum
   switch pNum
      case 6
         return "hexagon"
      case 5
         return "pentagon"
      case 4
         return "rect"
      case 3
         return "triangle"
      default
         return pNum
   end switch
end graphic_Shape

setprop graphic_Shape gShape
   put _graphicObject() into gObject
   --
   switch gShape
      case "hexagon"
         set the style of gObject to regular
         set the polySides of gObject to 6
         break
      case "pentagon"
         set the style of gObject to regular
         set the polySides of gObject to 5
         break
      case "rect"
         set the style of gObject to regular
         set the polySides of gObject to 4
         break 
      case "triangle"
         set the style of gObject to regular
         set the polySides of gObject to 3
         break 
      default
         set the style of gObject to gShape
   end switch
   --
   return gObject
end graphic_Shape


--> Load
-
on mouseDown pButtonNum
   switch pButtonNum
      case 3
         -- put empty into LocalArray ["mOffset"]
         menu_PopUp "Global | Camera | Menu"
         break
      default
         -- set the label of _graphicObject() to the params
         -- put _GetMouseOffset() into mOffset
         -- put mOffset into LocalArray ["mOffset"]
   end switch
end mouseDown

on preOpenControl
   camera_Init
   pass preOpenControl
end preOpenControl

on camera_Init
   put the camera_Name of me into cameraName
   
   ## Open
   cameraControlCreate cameraName
   
   ## Load VideoDeviceArray
   _LoadVideoDeviceArray
   put the result into videoDeviceArray
   
   ## Load AudioDeviceArray
   _LoadAudioDeviceArray cameraName
   
   ## Default video device
   put _DefaultVideoDeviceID (videoDeviceArray) into videoDeviceID
   cameraControlSet cameraName, "videoDevice", videoDeviceID
   --
   return videoDeviceArray
end camera_Init


--> Camera | Geometry
-
getprop camera_Rect
   put the camera_Name of me into cameraName
   if cameraName is empty then return empty
   
   put cameraControlGet (cameraName, "rect") into someRect
   return someRect
end camera_Rect

setprop camera_Rect someRect
   put the camera_Name of me into cameraName
   if cameraName is empty then return empty
   
   cameraControlSet cameraName, "rect", someRect
   return the result
end camera_Rect


--> Camera | Names
-
getprop camera_Name
   put the short id of me into myID
   put the stack_Name of me into stackName
   return stackName && myID
end camera_Name


--> Video | DeviceName
-
getprop video_DefaultDeviceName
   return _DefaultVideoDeviceName()
end video_DefaultDeviceName

getprop video_DeviceName
   -- return LocalArray ["videoDeviceName"]
   put _VideoDeviceID() into videoDeviceID
   return _VideoDeviceName (videoDeviceID)
end video_DeviceName

setprop video_DeviceName videoDeviceName
   if videoDeviceName is empty then
      _DeleteCamera
      put the result into oldCameraName
      return oldCameraName
   else
      put _VideoDeviceIDFromName (videoDeviceName) into videoDeviceID
      _OpenCamera videoDeviceID
      return videoDeviceID
   end if
end video_DeviceName

getprop video_DeviceNames
   put camera_ListVideoDeviceNames() into deviceNames
   return deviceNames
end video_DeviceNames

private function camera_ListVideoDeviceNames pVideoDeviceArray
   if pVideoDeviceArray is not an array then put _VideoDeviceArray() into pVideoDeviceArray
   put the camera_Name of me into cameraName
   --
   put pVideoDeviceArray ["name"] into nameArray
   put keys (nameArray) into videoDeviceNames
   sort videoDeviceNames
   return videoDeviceNames
end camera_ListVideoDeviceNames


--> Camera | DeviceID
-
getprop video_DeviceID
   return _VideoDeviceID()
end video_DeviceID

setprop video_DeviceID deviceID
   put the camera_Name of me into cameraName
   cameraControlSet cameraName, "videoDevice", deviceID
   return the result
end video_DeviceID

function _VideoDeviceName videoDeviceID
   put _VideoDeviceArray() into videoDeviceArray
   put videoDeviceArray ["id"][videoDeviceID] into videoDeviceName
   -- put item -1 of videoDeviceName into videoDeviceName -- not sure quick hack
   return videoDeviceName
end _VideoDeviceName

private function _VideoDeviceID
   put the camera_Name of me into cameraName
   get cameraControlGet (cameraName, "videoDevice")
   put item 1 of it into videoDeviceID
   return videoDeviceID
end _VideoDeviceID

private function _VideoDeviceIDFromName pDeviceName, pVideoDeviceArray
   if pDeviceName is empty then put _DefaultVideoDeviceName() into pDeviceName
   if pVideoDeviceArray is not an array then put _VideoDeviceArray() into pVideoDeviceArray
   
   put pVideoDeviceArray ["name"][pDeviceName] into videoDeviceID
   return videoDeviceID
end _VideoDeviceIDFromName


--> Camera | Open and Close
-
getprop camera_Open
   put the camera_Name of me into cameraName
   put cameraControls() into cameraNames
   return cameraName is among the lines of cameraNames
end camera_Open

setprop camera_Open sBoolean
   if sBoolean is true then
      camera_Init
      --
      _OpenCamera
      put the result into videoDeviceID
      return videoDeviceID
   else
      _DeleteCamera
      return empty 
   end if
end camera_Open

private command _DeleteCamera
   put the camera_Name of me into cameraName
   cameraControlDelete cameraName
   return cameraName
end _DeleteCamera

private command _OpenCamera pVideoDeviceID
   if pVideoDeviceID is empty then put _VideoDeviceIDFromName() into pVideoDeviceID
   put the camera_Name of me into cameraName
   put the rect of _graphicObject() into graphicRect
   --
   cameraControlSet cameraName, "videoDevice", pVideoDeviceID
   cameraControlSet cameraName, "rect", graphicRect
   cameraControlSet cameraName, "visible", true
   --
   return videoDeviceID
end _OpenCamera


--> Load
-
private function _DefaultVideoDeviceID pVideoDeviceArray
   if pVideoDeviceArray is not an array then
      put _VideoDeviceArray() into pVideoDeviceArray
   end if
   
   put _DefaultVideoDeviceName() into deviceName
   put pVideoDeviceArray ["name"][deviceName] into videoDeviceID
   return videoDeviceID
end _DefaultVideoDeviceID

private function _DefaultVideoDeviceName
   put the camera_Name of me into cameraName
   put camera_ListVideoDeviceNames (cameraName) into cameraDeviceNames
   get cameraDeviceNames
   filter it with "FaceTime *"
   if it is empty then
      put line 1 of cameraDeviceNames into pDeviceName
   else
      put line 1 of it into pDeviceName
   end if
   return pDeviceName
end _DefaultVideoDeviceName

private function _VideoDeviceArray
   put LocalArray ["videoDeviceArray"] into videoDeviceArray
   if videoDeviceArray is an array then return videoDeviceArray
   
   _LoadVideoDeviceArray
   put the result into videoDeviceArray
   return videoDeviceArray 
end _VideoDeviceArray

private command _LoadVideoDeviceArray
   put _ConstructVideoDeviceArray() into videoDeviceArray
   put videoDeviceArray into LocalArray ["videoDeviceArray"]
   return videoDeviceArray
end _LoadVideoDeviceArray

private function _ConstructVideoDeviceArray
   put the camera_Name of me into cameraName
   put cameraControlGet (cameraName, "videoDevices") into videoDeviceTable
   put _ArrayFromTable (videoDeviceTable) into VideoDeviceArray
   return VideoDeviceArray
end _ConstructVideoDeviceArray

private command _LoadAudioDeviceArray cameraName
   put audio_ConstructDeviceArray (cameraName) into audioDeviceArray
   put audioDeviceArray into LocalArray ["audioDeviceArray"]
   return audioDeviceArray
end _LoadAudioDeviceArray

private function audio_ConstructDeviceArray cameraName
   put cameraControlGet (cameraName, "audioDevices") into audioDeviceTable
   put _ArrayFromTable (audioDeviceTable) into audioDeviceArray
   return audioDeviceArray
end audio_ConstructDeviceArray


--> Frame
-
getprop stack_Frame
   put the stack_Name of me into stackName
   --
   put the decorations of stack stackName is empty into isFrameless
   put the mode of stack stackName into sMode
   --
   switch
      case isFrameless
         return "frameless"
      case sMode = 4
         return "palette"
      default
         return "toplevel"
   end switch
end stack_Frame

setprop stack_Frame frameStyle
   put the stack_Name of me into stackName
   --
   switch frameStyle
      case false
      case empty
      case "frameless"
         set the decorations of stack stackName to empty
         break
      case "palette"
         -- palette of stack stackName
         set the style of stack stackName to "palette"
         set the decorations of stack stackName to "default"
         break
      case true
      case "toplevel"
      default
         set the style of stack stackName to "toplevel"
         set the decorations of stack stackName to "default"
   end switch
end stack_Frame

getprop system_Window
   put the stack_Name of me into stackName
   put the systemwindow of stack stackName into someBoolean
   return someBoolean
end system_Window

setprop system_Window someBoolean
   put the stack_Name of me into stackName
   set the systemwindow of stack stackName to someBoolean
   return someBoolean
end system_Window


--> Audio | Device
-
getprop audio_DeviceName
   put the audio_DeviceID of me into audioDeviceID
   --
   put LocalArray ["audioDeviceArray"] into audioDeviceArray
   get audioDeviceArray ["id"][audioDeviceID]
   put item -1 of it into audioDeviceName -- not sure quick hack
   return audioDeviceName
end audio_DeviceName

getprop audio_DeviceID
   put the camera_Name of me into cameraName
   get cameraControlGet (cameraName, "audioDevice")
   put item 1 of it into audioDeviceID -- not sure quick hack
   return audioDeviceID
end audio_DeviceID


--> Interface
-
on refreshDisplay
   put the rect of me into viewRect
   LayoutControl viewRect
end refreshDisplay


--> Snap
-
getprop snap_Mask
   put the graphic_Object of me into graphicObject
   put the short name of the defaultstack into stackName
   --
   get the windowshape of stack stackName
   put it is not 0 into someBoolean
   --
   return someBoolean
end snap_Mask

setprop snap_Mask [someInk] someBoolean
   put the graphic_Object of me into graphicObject
   --
   if someBoolean is true then
      if someInk is empty then
         -- set the ink of me to "blendSrc"
         export snapshot from graphicObject with effects to img "mask" of me as PNG
      else
         -- set the ink of graphicObject to "blendDstIn"
         -- set the ink of me to "blendSrcOver"
         export snapshot from me with effects to img "mask" of me as PNG
      end if
      put the short id of _ImageObject() into imageID
   else
      put 0 into imageID
   end if
   --
   put the short name of the defaultstack into stackName
   set the windowshape of stack stackName to imageID
end snap_Mask


--> Private
-
private function png_IsTransparent pImageFile
   if not (there is a file pImageFile) then return "ERROR: Invalid file path!"
   set the filename of the templateImage to pImageFile
   put numtochar(0) into tZero
   return (tZero is in the alphaData of the templateImage) OR (tZero is in the maskData of the templateImage)
end png_IsTransparent

private function audio_ListDeviceNames cameraName
   put audio_ConstructDeviceArray (cameraName) into audioDeviceArray
   put audioDeviceArray into LocalArray ["audioDeviceArray"]
   --
   put audioDeviceArray ["name"] into nameArray
   put keys (nameArray) into deviceNames
   sort deviceNames
   return deviceNames
end audio_ListDeviceNames

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


--> Objects
-
function _ImageObject
   return the long id of image 1 of me
end _ImageObject


--> Camera | Props
-
getprop audio_DeviceArray
   put the camera_Name of me into cameraName
   --
   _LoadAudioDeviceArray cameraName
   put the result into audioDeviceArray
   --
   return audioDeviceArray
end audio_DeviceArray

getprop camera_DeviceArray
   put the camera_Name of me into cameraName
   --
   _LoadVideoDeviceArray cameraName
   put the result into VideoDeviceArray
   --
   return VideoDeviceArray
end camera_DeviceArray


--> Audio | Device
-
setprop audio_DeviceName audioDeviceName
   put audioDeviceName into LocalArray ["audioDeviceName"]
   put LocalArray ["audioDeviceArray"] into audioDeviceArray
   --
   put audioDeviceArray ["name"][audioDeviceName] into audioDeviceID
   set the audio_DeviceID of me to audioDeviceID
   return audioDeviceID
end audio_DeviceName

getprop audio_DeviceNames
   put the camera_Name of me into cameraName
   put audio_ListDeviceNames (cameraName) into deviceNames
   return deviceNames
end audio_DeviceNames

setprop audio_DeviceID audioDeviceID
   put the camera_Name of me into cameraName
   cameraControlSet cameraName, "audioDevice", audioDeviceID
   return audioDeviceID
end audio_DeviceID


--> Objects
-
getprop camera_View
   return the long id of me
end camera_View

getprop graphic_Object
   return _graphicObject()
end graphic_Object

getprop view_Object
   return the long id of me
end view_Object

private function _graphicObject
   return the long id of grc 1 of me
end _graphicObject
