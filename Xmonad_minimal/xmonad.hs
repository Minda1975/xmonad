import XMonad
import XMonad.Hooks.EwmhDesktops
import System.Exit
import XMonad.Actions.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W 
import XMonad.Util.Scratchpad (scratchpadSpawnAction, scratchpadManageHook, scratchpadFilterOutWorkspace)
import qualified Data.Map as M
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell
import XMonad.Actions.CycleWS
import XMonad.Layout.Spacing
import XMonad.Actions.FindEmptyWorkspace
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.SetWMName
 
main = do
    xmproc <- spawnPipe ("xmobar " ++ myXmobarrc)
    xmonad $ ewmh def
      { modMask            = mod4Mask
      , manageHook         = manageDocks <+> myManageHookFloat <+> scratchpadManageHook (W.RationalRect 0.25 0.375 0.5 0.35)
      , terminal           = "sakura"
      , focusFollowsMouse = True
      , borderWidth        = 1
      , workspaces = myWorkspaces
      , normalBorderColor = "#5f5a60"
      , focusedBorderColor = "#7587a6"
      , layoutHook = avoidStruts  $  myLayout
      -- this must be in this order, docksEventHook must be last
      , handleEventHook    = handleEventHook def <+> fullscreenEventHook <+> docksEventHook
      , logHook            = dynamicLogWithPP xmobarPP
          { ppOutput          = hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 80
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
          }
      , startupHook        = setWMName "LG3D"
      } `additionalKeys`
      [ ((mod4Mask .|. shiftMask, xK_q), confirmPrompt myXPConfig "exit" $ io (exitWith ExitSuccess))
      , ((mod4Mask, xK_grave), scratchpadSpawnAction def  {terminal = "xterm"}) 
      , ((mod4Mask .|. shiftMask, xK_r), spawn "/home/mindaugas/.scripts/shutdown.sh")
      , ((mod4Mask, xK_z), spawn "/home/mindaugas/.scripts/emenu_run")
      , ((mod4Mask, xK_x), shellPrompt myXPConfig)
      , ((mod4Mask, xK_F1), spawn "/home/mindaugas/.scripts/dmenu_fm")
      , ((mod4Mask, xK_F2), spawn "/home/mindaugas/.scripts/mpdmenu")
      , ((mod4Mask, xK_w), spawn "/home/mindaugas/.scripts/screenshot")
      , ((0, xK_Print), spawn "/home/mindaugas/.scripts/select-screenshot")
      , ((mod4Mask .|. shiftMask, xK_w), spawn "firefox")
      , ((mod4Mask,               xK_Down),  nextWS)
      , ((mod4Mask,               xK_Up),    prevWS)
      , ((mod4Mask .|. shiftMask, xK_Down),  shiftToNext >> nextWS)
      , ((mod4Mask .|. shiftMask, xK_Up),    shiftToPrev >> prevWS)
      , ((mod4Mask,               xK_a),     toggleWS)
      , ((mod4Mask,                xK_m    ), viewEmptyWorkspace)
      , ((mod4Mask,  xK_g ),   withFocused toggleBorder)
      , ((mod4Mask .|. shiftMask, xK_f), spawn "sakura -e /usr/bin/ranger") ]

             
                    
myWorkspaces = ["1:term","2:web","3:code","4:doc","5:media"] ++ map show [6..9] 
 
myXmobarrc = "~/.xmonad/xmobarrc"  
    
myManageHookFloat = composeAll
    [ className =? "MPlayer"              --> doCenterFloat
    , className =? "feh"              --> doCenterFloat
    , isDialog                        --> doCenterFloat
    ]
    
    
myXPConfig = def
  { position          = Bottom
  , alwaysHighlight   = True
  , bgColor             = "#1e1e1e"
  , fgColor             = "#a7a7a7"
  , bgHLight            = "#7587a6"
  , fgHLight            = "#1e1e1e"
  , promptBorderWidth = 0
  , font              = "xft:Input Mono Compressed:size=9:medium:antialias=true"
  }

myLayout = avoidStruts $ spacing 8 $
           tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta = 3/100

-- Color of current window title in xmobar.
xmobarTitleColor = "#7587a6"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#8f9d6a"
