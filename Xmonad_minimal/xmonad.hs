import XMonad
import XMonad.Hooks.EwmhDesktops
import System.Exit
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Prompt.RunOrRaise
import qualified XMonad.StackSet as W 
import XMonad.Util.Scratchpad (scratchpadSpawnAction, scratchpadManageHook, scratchpadFilterOutWorkspace)
import XMonad.Layout.Named 
import qualified Data.Map as M
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.ConfirmPrompt
import XMonad.Layout.NoBorders
import XMonad.Actions.CycleWS
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.SetWMName
 
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh def
      { modMask            = mod4Mask
      , manageHook         = manageDocks <+> scratchpadManageHook (W.RationalRect 0.25 0.375 0.5 0.35)
      , terminal           = "urxvt"
      , borderWidth        = 2
      , focusedBorderColor = "#4422FF"
      , layoutHook         = smartBorders $ myLayoutHook
      -- this must be in this order, docksEventHook must be last
      , handleEventHook    = handleEventHook def <+> fullscreenEventHook <+> docksEventHook
      , logHook            = dynamicLogWithPP xmobarPP
          { ppOutput          = hPutStrLn xmproc
          , ppTitle           = xmobarColor "green"  "" . shorten 50
          }
      , startupHook        = setWMName "LG3D"
      } `additionalKeys`
      [ ((mod4Mask, xK_g), runOrRaisePrompt myXPConfig)
      , ((mod4Mask .|. controlMask, xK_x), spawn "rofi -show run -modi run")
      , ((mod4Mask .|. shiftMask, xK_q), confirmPrompt myXPConfig "exit" $ io (exitWith ExitSuccess))
      , ((mod4Mask, xK_grave), scratchpadSpawnAction def  {terminal = "urxvt"}) 
      , ((mod4Mask .|. shiftMask, xK_r), spawn "/home/mindaugas/.scripts/shutdown.sh")
      , ((mod4Mask, xK_x), spawn "/home/mindaugas/.scripts/mpdmenu")
      , ((mod4Mask, xK_F1), spawn "/home/mindaugas/.scripts/dmenu_fm")
      , ((mod4Mask, xK_w), spawn "/home/mindaugas/.scripts/screenshot")
      , ((0, xK_Print), spawn "/home/mindaugas/.scripts/select-screenshot")
      , ((mod4Mask .|. shiftMask, xK_w), spawn "firefox")
      , ((mod4Mask , xK_z), shellPrompt myXPConfig)
      , ((mod4Mask,               xK_Down),  nextWS)
      , ((mod4Mask,               xK_Up),    prevWS)
      , ((mod4Mask .|. shiftMask, xK_Down),  shiftToNext >> nextWS)
      , ((mod4Mask .|. shiftMask, xK_Up),    shiftToPrev >> prevWS)
      , ((mod4Mask,               xK_a),     toggleWS)
      , ((mod4Mask,                xK_m    ), viewEmptyWorkspace)
      , ((mod4Mask .|. shiftMask,  xK_m    ), tagToEmptyWorkspace)
      , ((mod4Mask .|. shiftMask, xK_f), spawn "urxvt -e /usr/bin/mc") ]

             

myLayoutHook = avoidStruts $ smartBorders ( full ||| mtiled ||| tiled )
  where
    full    = named "X" $ Full
    mtiled  = named "M" $ Mirror tiled
    tiled   = named "T" $ Tall 1 (5/100) (2/(1+(toRational(sqrt(5)::Double))))
                   
    

myXPConfig = def
  { position          = Top
  , alwaysHighlight   = True
  , bgColor             = "#090300"
  , fgColor             = "#a5a2a2"
  , bgHLight            = "#090300"
  , fgHLight            = "#db2d20"
  , promptBorderWidth = 0
  , font              = "-misc-fixed-*-*-*-*-10-*-*-*-*-*-*-*"
}


