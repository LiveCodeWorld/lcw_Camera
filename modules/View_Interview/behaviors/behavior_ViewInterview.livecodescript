script "behavior_ViewInterview"
--> MetaData
-
copyright: David Bovill
license: GPLv3
name: behavior_ViewInterview
type: behavior
version: 0.1


--> Variable
-
local LocalArray


--> Working on
-
command LayoutControl pRect
   if pRect is not a rect then put the rect of me into pRect 
   put the scale_Proportional of me into scaleProportionally
   put the displayed_RectDataNum of me into indexNum
   --
   transform_GroupScaled pRect, indexNum, scaleProportionally
   set the rect of me to pRect
end LayoutControl

command transform_GroupScaled tGroupRect, indexNum, scaleProportionally
   put the rect_Data [indexNum] of me into rectArray
   put rectArray ["target"]["rect"] into oGroupRect
   --
   put rectArray ["views"] into viewData
   repeat for each key indexNum in viewData
      put viewData [indexNum]["control"] into tView
      put viewData [indexNum]["rect"] into oViewRect
      --
      put rect_TransformFromOrigin (oViewRect, oGroupRect, tGroupRect, scaleProportionally) into sRect
      --
      set the rect of tView to sRect
   end repeat
   return rectArray
end transform_GroupScaled

getprop rectArray_AnimateScaled
   put the uRIP ["displayed_RectDataNum"] of me into indexNum
   if indexNum is not a number then put 1 into indexNum
   --
   put the rect_Data of me into rectData
   put rectData [indexNum]["meta"]["title"] into sTitle
   if sTitle is empty then
      return indexNum
   else
      return sTitle
   end if
end rectArray_AnimateScaled

setprop rectArray_AnimateScaled [pScaleProportionally] indexOrName
   put the rect_Data of me into rectData
   put _GetRectArray (indexOrName, rectData) into rectArray
   --
   set the uRIP ["displayed_RectDataNum"] of me to indexOrName
   --
   put the rect of me into tFrameRect
   put rectArray ["target"]["rect"] into oFrameRect
   
   ## Animate Views
   put rectArray ["views"] into viewData
   repeat for each key cNum in viewData
      put viewData [cNum]["control"] into tView
      put viewData [cNum]["rect"] into oViewRect
      --
      put rect_TransformFromOrigin (oViewRect, oFrameRect, tFrameRect, pScaleProportionally) into sRect
      rect_Normalise sRect -- for animationEngine
      --
      aeChangeRect tView, sRect, 1000, "inOut"
   end repeat
   
   ## Animate Controls
   -- not done yet
   
   return true
end rectArray_AnimateScaled

private function _GetRectArray @indexOrName, rectData
   switch
      case indexOrName is empty
         return rectData
      case indexOrName is a number
         return rectData [indexOrName]
      default
         put rectData_FindTitle (indexOrName, rectData) into itemNum
         put itemNum into indexOrName
         if itemNum = 0 then
            return empty
         else
            return rectData [itemNum]
         end if
   end switch
end _GetRectArray


--> Geometry
-
getprop displayed_RectDataNum [pUseTitle]
   put the uRIP ["displayed_RectDataNum"] of me into indexNum
   if indexNum is not a number then put 1 into indexNum
   --
   if pUseTitle is true then
      put the rect_Data of me into rectData
      put rectData [indexNum]["meta"]["title"] into sTitle
      if sTitle is not empty then
         return sTitle
      end if
   end if
   return indexNum
end displayed_RectDataNum

setprop displayed_RectDataNum indexNum
   set the uRIP ["displayed_RectDataNum"] of me to indexNum
   LayoutControl
end displayed_RectDataNum

getprop scale_Proportional
   put the scale_Proportional of me into sBoolean
   return sBoolean is true
end scale_Proportional

setprop scale_Proportional sBoolean
   set the scale_Proportional of me to sBoolean
   LayoutControl
end scale_Proportional


--> Events
-
on resizeControl
   LayoutControl
end resizeControl
