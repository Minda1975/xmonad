import XMonad
import XMonad.Hooks.EwmhDesktops
import System.Exit
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Prompt.RunOrRaise
import qualified XMonad.StackSet as W 
import XMonad.Util.Scratchpad (scratchpadSpawnAction, scratchpadManageHook, scratchpadFilterOutWorkspace)
import qualified Data.Map as M
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.ConfirmPrompt
import XMonad.Layout.NoBorders
import XMonad.Layout.StackTile
import XMonad.Layout.Magnifier
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
      , manageHook         = manageDocks <+> myManageHookFloat <+> scratchpadManageHook (W.RationalRect 0.25 0.375 0.5 0.35)
      , terminal           = "xterm"
      , focusFollowsMouse = False
      , borderWidth        = 2
      , workspaces = myWorkspaces
      , focusedBorderColor = "#4422FF"
      , layoutHook         = smartBorders $ myLayoutHook
      -- this must be in this order, docksEventHook must be last
      , handleEventHook    = handleEventHook def <+> fullscreenEventHook <+> docksEventHook
      , logHook            = dynamicLogWithPP xmobarPP
          { ppOutput          = hPutStrLn xmproc
          , ppTitle           = xmobarColor xmobarTitleColor "" . shorten 50
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
          }
      , startupHook        = setWMName "LG3D"
      } `additionalKeys`
      [ ((mod4Mask, xK_g), runOrRaisePrompt myXPConfig)
      , ((mod4Mask .|. shiftMask, xK_q), confirmPrompt myXPConfig "exit" $ io (exitWith ExitSuccess))
      , ((mod4Mask, xK_grave), scratchpadSpawnAction def  {terminal = "xterm"}) 
      , ((mod4Mask .|. shiftMask, xK_r), spawn "/home/mindaugas/.scripts/shutdown.sh")
      , ((mod4Mask, xK_x), spawn "/home/mindaugas/.scripts/emenu_run")
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
      , ((mod4Mask .|. controlMask              , xK_equal ), sendMessage MagnifyMore)
      , ((mod4Mask .|. controlMask              , xK_minus), sendMessage MagnifyLess)
      , ((mod4Mask .|. controlMask              , xK_o    ), sendMessage ToggleOff  )
      , ((mod4Mask .|. controlMask .|. shiftMask, xK_o    ), sendMessage ToggleOn   )
      , ((mod4Mask .|. controlMask              , xK_m    ), sendMessage Toggle     )
      , ((mod4Mask .|. shiftMask, xK_f), spawn "xterm -e /usr/bin/ranger") ]

             

myLayoutHook = avoidStruts $ smartBorders $ magnifier (Tall 1 (3/100) (1/2)) ||| Full ||| StackTile 1 (3/100) (1/2) 
                     
myWorkspaces = ["1:term","2:web","3:code","4:doc","5:media"] ++ map show [6..9]    
    
myManageHookFloat = composeAll
    [ className =? "mpv"              --> doCenterFloat
    , className =? "feh"              --> doCenterFloat
    , isDialog                        --> doCenterFloat
    ]
    
    
myXPConfig = def
  { position          = Top
  , alwaysHighlight   = True
  , bgColor             = "#090300"
  , fgColor             = "#a5a2a2"
  , bgHLight            = "#090300"
  , fgHLight            = "#db2d20"
  , promptBorderWidth = 0
  , font              = "xft:mononoki:pixelsize=11:antialias=true:hinting=true"
}

-- Color of current window title in xmobar.
xmobarTitleColor = "#92659a"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#8ae234"

