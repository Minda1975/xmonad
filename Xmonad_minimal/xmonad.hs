import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Spacing
import XMonad.Actions.GridSelect
import XMonad.Layout.OneBig
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.SetWMName
 
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ def
      { modMask            = mod4Mask
      , manageHook         = manageDocks <+> manageHook def
      , workspaces         = myworkspaces
      , terminal           = "urxvtc"
      , borderWidth        = 1
      , normalBorderColor  = "#dddddd"
      , focusedBorderColor = "#00dd00"
      , layoutHook         = smartBorders $ myLayoutHook
      -- this must be in this order, docksEventHook must be last
      , handleEventHook    = handleEventHook def <+> docksEventHook
      , logHook            = dynamicLogWithPP xmobarPP
          { ppOutput          = hPutStrLn xmproc
          , ppCurrent         = xmobarColor "#3EA055" "" . wrap "[" "]"
          , ppLayout          = xmobarColor "#9DC209"  "" . shorten 15
          , ppUrgent          = xmobarColor "red" "yellow"
          , ppTitle           = xmobarColor "green"  "" . shorten 50
          , ppVisible         = xmobarColor "#ffffff" "" . wrap "(" ")"
          , ppHiddenNoWindows = xmobarColor "#2554C7" ""
          }
      , startupHook        = setWMName "LG3D"
      } `additionalKeys`
      [ ((mod4Mask, xK_g), goToSelected def) 
      , ((mod4Mask, xK_p), spawn "/home/mindaugas/.scripts/emenu_run")
      , ((mod4Mask, xK_r), spawn "/home/mindaugas/.scripts/shutdown.sh")
      , ((mod4Mask, xK_x), spawn "/home/mindaugas/.scripts/mpdmenu")
      , ((mod4Mask, xK_F1), spawn "/home/mindaugas/.scripts/dmenu_fm")
      , ((mod4Mask, xK_w), spawn "/home/mindaugas/.scripts/screenshot")
      , ((0, xK_Print), spawn "/home/mindaugas/.scripts/select-screenshot")
      , ((mod4Mask .|. shiftMask, xK_w), spawn "firefox")
      , ((mod4Mask .|. shiftMask, xK_f), spawn "urxvtc -e /usr/bin/mc") ]

                
myworkspaces = [ "code"
               , "web"
               , "media"
               , "sys"
               , "random"
               , "var"
               , "docs"
               , "music"
               , "root"
               ]
-- with spacing
myLayoutHook = (spacing 10 $ avoidStruts (tall ||| OneBig (3/4) (3/4) ||| Full )) ||| smartBorders Full
                  where tall = Tall 1 (3/100) (1/2) 
    
