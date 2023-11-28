script "Global | Menu | Group | Menu"
--> MetaData
-
license: GPLv3
name: Global | Menu | Group | Menu
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
   return display_MenuTarget(tObject)
   -- return the display_View of tObject
end menu_Target

getprop menu_CheckTarget [cameraView]
   return exists (cameraView)
end menu_CheckTarget

getprop checked_InsertMenu [cameraView]
   put the menu_Group of cameraView into mGroup
   return exists (mGroup)
end checked_InsertMenu

getprop checked_Activate [cameraView]
   put the menu_IsActive of cameraView into isActive
   return isActive
end checked_Activate

getprop checked_IsGlobal [cameraView]
   put the menu_IsGlobal of cameraView into isGlobal
   return isGlobal
end checked_IsGlobal


--> Global | Menu | Group | Menu
-
on menu_MenuManager cameraView
   put the menu_Group of cameraView into mGroup
   --
   display_MenuManager mGroup
end menu_MenuManager

on menu_InsertMenu cameraView
   put the stack_Name of cameraView into sName
   put the menu_Group of cameraView into mGroup
   --
   if exists (mGroup) then
      set the menubar of stack sName to empty
      ide_ResetDefaultmenubar
      --
      delete mGroup
      set the menu_Group of cameraView to empty
   else
      put view_GetTemplateObject ("View|Menu|Camera") into mGroup
      put the long owner of cameraView into sContainer
      copy mGroup to sContainer
      put it into clonedMenu
      choose browse tool
      --
      put revRuggedId(clonedMenu) into mGroup
      put the short name of mGroup into mName
      set the menubar of stack sName to mName
      --
      set the defaultMenuBar to mGroup
      set the menu_Group of cameraView to mGroup
   end if
end menu_InsertMenu

on menu_Activate cameraView
   put the menu_IsActive of cameraView into isActive
   set the menu_IsActive [true] of cameraView to (isActive is false)
end menu_Activate

on menu_IsGlobal cameraView
   put the menu_IsGlobal of cameraView into isGlobal
   set the menu_IsGlobal of cameraView to (isGlobal is false)
end menu_IsGlobal

on menu_TestMenu cameraView
   put the menu_Group of cameraView into mGroup
   --
   -- set the menu_Title of button "Camera" of mGroup to "Global | Camera | Tools | Menu"
   set the menu_Title of button "Edit" of mGroup to"Global | Camera | Edit | Menu"
end menu_TestMenu

private on __
end __

on submenu_Dev
   return menu_DevTitle ("Global | Menu | Group | Menu")
end submenu_Dev
