script "Global | Camera | Edit | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Camera | Edit | Menu
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
   return tObject
end menu_Target

getprop menu_CheckTarget
   return true
end menu_CheckTarget


--> Global | Camera | Edit | Menu
-
on menu_Cut displayView
   breakpoint
end menu_Cut 

on menu_Copy displayView
   breakpoint
end menu_Copy

on menu_Paste
   breakpoint
end menu_Paste

private on __
end __

on menu_Clear
   breakpoint
end menu_Clear
