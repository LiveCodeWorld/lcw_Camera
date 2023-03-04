script "Global | Camera | Test | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Camera | Test | Menu
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
   put the camera_ViewGuess of tObject into cameraView
   return cameraView
end menu_Target

getprop checked_Mask [cameraView]
   put the snap_Mask of cameraView into someBoolean
   return someBoolean
end checked_Mask


--> Global | Camera | Test | Menu
-
on menu_DisplayRecordings
   display_CameraRecordings
end menu_DisplayRecordings

getprop testClone_Params
   return LocalArray ["deviceNames"]
end testClone_Params

on menu_TestClone cameraView, deviceName
   put the camera_DeviceNames of cameraView
   --
   display_Camera deviceName
end menu_TestClone

on menu_PresentationMode cameraView
   put camera_ListStackNames() into sNames
   put camera_CheckAllFrameless (sNames) is false into toggleBoolean
   --
   repeat for each line sName in sNames
      if exists (control 1 of cd 1 of stack sName) is false then next repeat
      put the long id of control 1 of cd 1 of stack sName into cameraView
      --
      if toggleBoolean is true then
         set the stack_Frame of cameraView to "frameless"
      else
         set the stack_Frame of cameraView to "default"
      end if
      --
      set the systemwindow of stack sName to toggleBoolean
      set the shadow of stack sName to (not toggleBoolean)
   end repeat
end menu_PresentationMode

on _
end _

on menu_DisplayPageTitleArray
   display_PageTitleArray "vlog.mediagarden.org"
   put the result into displayView
   return displayView
end menu_DisplayPageTitleArray

on _
end _

on menu_Mask cameraView
   put the snap_Mask of cameraView into someBoolean
   set the snap_Mask ["blendDstIn"] of cameraView to (not someBoolean)
end menu_Mask
