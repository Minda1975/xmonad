import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Layout.Gaps
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
      , layoutHook         = avoidStruts  $ smartBorders $ layoutHook def
      -- this must be in this order, docksEventHook must be last
      , handleEventHook    = handleEventHook def <+> docksEventHook
      , logHook            = dynamicLogWithPP xmobarPP
          { ppOutput          = hPutStrLn xmproc
          , ppTitle           = xmobarColor "green"  "" . shorten 50
          , ppHiddenNoWindows = xmobarColor "#25383C" ""
          }
      , startupHook        = setWMName "LG3D"
      } `additionalKeys`
      [ ((mod4Mask, xK_b), sendMessage ToggleStruts) 
      , ((mod4Mask, xK_p), spawn "/home/mindaugas/.scripts/emenu_run")
      , ((mod4Mask, xK_r), spawn "/home/mindaugas/.scripts/shutdown.sh")
      , ((mod4Mask, xK_x), spawn "/home/mindaugas/.scripts/mpdmenu")
      , ((mod4Mask, xK_F1), spawn "/home/mindaugas/.scripts/dmenu_fm")
      , ((mod4Mask, xK_w), spawn "/home/mindaugas/.scripts/screenshot")
      , ((0, xK_Print), spawn "/home/mindaugas/.scripts/select-screenshot")
      , ((mod4Mask .|. shiftMask, xK_w), spawn "firefox")
      , ((mod4Mask .|. shiftMask, xK_f), spawn "urxvtc -e /usr/bin/mc") ]

myPP = xmobarPP { ppOutput          = putStrLn
                , ppCurrent         = xmobarColor "#336433" "" . wrap "[" "]"
                --, ppHiddenNoWindows = xmobarColor "#25383C" ""
                , ppTitle           = xmobarColor "darkgreen"  "" . shorten 20
                , ppLayout          = shorten 6
                --, ppVisible         = wrap "(" ")"
                , ppUrgent          = xmobarColor "red" "yellow"
                }
                
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

             
