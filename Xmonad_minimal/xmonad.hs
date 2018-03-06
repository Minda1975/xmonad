import System.Exit
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.ToggleLayouts (ToggleLayout(..), toggleLayouts)
import XMonad.Prompt
import XMonad.Actions.WindowBringer
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig

--------------------------------------------------------------------------------
main = do
    -- Start xmonad using the main desktop configuration with a few
  -- simple overrides:
  xmonad $ desktopConfig
    { modMask    = mod4Mask -- Use the "Win" key for the mod key
    , manageHook = myManageHook <+> manageHook desktopConfig
    , layoutHook = desktopLayoutModifiers $ myLayouts
    , logHook    = dynamicLogString def >>= xmonadPropLog
    }

    `additionalKeysP` -- Add some extra key bindings:
      [ ("M-S-q",   confirmPrompt myXPConfig "exit" (io exitSuccess))
      , ("M-S-p",     shellPrompt myXPConfig)
      , ("M-S-f", spawn "pcmanfm")
      , ("M-S-w", spawn "firefox")
      , ("M-p", spawn "/home/mindaugas/.scripts/emenu_run")
      , ("M-r", spawn "/home/mindaugas/.scripts/shutdown.sh")
      , ("M-x", spawn "/home/mindaugas/.scripts/mpdmenu")
      , ("C-<Tab>", spawn "/home/mindaugas/.scripts/dmenu_fm")
      , ("M-w", spawn "/home/mindaugas/.scripts/screenshot")
      , ("<Print>", spawn "/home/mindaugas/.scripts/select-screenshot")
      , ("M-<Esc>", sendMessage (Toggle "Full"))
      , ("M-S-g", gotoMenu)
      , ("M-S-b", bringMenu)
      ]

--------------------------------------------------------------------------------
-- | Customize layouts.
--
-- This layout configuration uses two primary layouts, 'ResizableTall'
-- and 'BinarySpacePartition'.  You can also use the 'M-<Esc>' key
-- binding defined above to toggle between the current layout and a
-- full screen layout.
myLayouts = toggleLayouts (noBorders Full) others
  where
    others = ResizableTall 1 (1.5/100) (3/5) [] ||| emptyBSP

--------------------------------------------------------------------------------
-- | Customize the way 'XMonad.Prompt' looks and behaves.  It's a
-- great replacement for dzen.
myXPConfig = def
  { position          = Top
  , alwaysHighlight   = True
  , promptBorderWidth = 0
  , font              = "xft:Fira Code:size=10:antialias=true"
  }

--------------------------------------------------------------------------------
-- | Manipulate windows as they are created.  The list given to
-- @composeOne@ is processed from top to bottom.  The first matching
-- rule wins.
--
-- Use the `xprop' tool to get the info you need for these matches.
-- For className, use the second value that xprop gives you.
myManageHook = composeOne
  [ className =? "Gimp" -?> doFloat
  , className =? "SMPlayer"  -?> doFloat
  , className =? "mpv"    -?> doFloat
  , className =? "feh"    -?> doCenterFloat
  , className =? "Gmpc"    -?> doCenterFloat
  , className =? "Audacious"    -?> doCenterFloat
  , isDialog              -?> doCenterFloat

    -- Move transient windows to their parent:
  , transience
  ]
