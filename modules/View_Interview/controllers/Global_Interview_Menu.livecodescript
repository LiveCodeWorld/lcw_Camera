script "Global | Interview | Menu"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: Global | Interview | Menu
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
   -- return display_MenuTarget(tObject)
   return the display_View of tObject
end menu_Target


--> Global | Interview | Menu
-
on menu_Test iView
   transform_CardScaled iView
end menu_Test

private on _
end _

on submenu_Screen
   return "Global | Screen | Record | Menu"
end submenu_Screen

on submenu_RectArray
   return "Global | RectArray | Menu"
end submenu_RectArray

on submenu_Dev
   return menu_DevTitle ("Global | Interview | Menu")
end submenu_Dev
