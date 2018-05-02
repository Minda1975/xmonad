import XMonad
import XMonad.Hooks.EwmhDesktops
import System.Exit
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Prompt.RunOrRaise
import qualified XMonad.StackSet as W 
import XMonad.Util.Scratchpad (scratchpadSpawnAction, scratchpadManageHook, scratchpadFilterOutWorkspace)
import XMonad.Layout.StackTile
import XMonad.Layout.FixedColumn
import XMonad.Layout.MosaicAlt
import qualified Data.Map as M
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.ConfirmPrompt
import XMonad.Layout.NoBorders
import XMonad.Actions.CycleWS
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.SetWMName
 
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh def
      { modMask            = mod4Mask
      , manageHook         = manageDocks <+> scratchpadManageHook (W.RationalRect 0.25 0.375 0.5 0.35)
      , workspaces         = myworkspaces
      , terminal           = "urxvt"
      , borderWidth        = 1
      , normalBorderColor  = "#a5a2a2"
      , focusedBorderColor = "#db2d20"
      , layoutHook         = smartBorders $ myLayoutHook
      -- this must be in this order, docksEventHook must be last
      , handleEventHook    = handleEventHook def <+> fullscreenEventHook <+> docksEventHook
      , logHook            = dynamicLogWithPP xmobarPP
          { ppOutput          = hPutStrLn xmproc
          , ppCurrent         = xmobarColor "#01a252" "" . wrap "{" "}"
          , ppHidden          = xmobarColor "#f7f7f7" ""
          , ppLayout          = xmobarColor "#01a0e4"  "" . shorten 15
          , ppUrgent          = xmobarColor "red" "yellow"
          , ppTitle           = xmobarColor "#a5a2a2"  "" . shorten 50
          , ppHiddenNoWindows = xmobarColor "#a16a94" ""
          }
      , startupHook        = setWMName "LG3D"
      } `additionalKeys`
      [ ((mod4Mask, xK_g), runOrRaisePrompt myXPConfig)
      , ((mod4Mask .|. shiftMask  , xK_a), withFocused (sendMessage . expandWindowAlt))
      , ((mod4Mask .|. shiftMask  , xK_z), withFocused (sendMessage . shrinkWindowAlt))
      , ((mod4Mask .|. shiftMask  , xK_s), withFocused (sendMessage . tallWindowAlt))
      , ((mod4Mask .|. shiftMask  , xK_d), withFocused (sendMessage . wideWindowAlt))
      , ((mod4Mask .|. controlMask, xK_space), sendMessage resetAlt)
      , ((mod4Mask .|. controlMask, xK_x), spawn "rofi -show run -modi run -theme solarized")
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
      , ((mod4Mask .|. shiftMask, xK_f), spawn "urxvt -e /usr/bin/mc") ]

                
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
myLayoutHook = ( avoidStruts (FixedColumn 1 20 80 10 ||| StackTile 1 (3/100) (1/2) ||| MosaicAlt M.empty ||| Full )) ||| smartBorders Full
                   
    

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
