  -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen, nextWS, prevWS)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.Unicode
import XMonad.Prompt.XMonad
import Control.Arrow (first)

   -- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

myFont :: String
myFont = "xft:CaskaydiaCove Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myEmojiFont :: String
myEmojiFont = "xft:JoyPixels:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask       -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "kitty"   -- Sets default terminal

myBrowser :: String
myBrowser = "brave -- "               -- Sets qutebrowser as browser for tree select
-- myBrowser = myTerminal ++ " -e lynx " -- Sets lynx as browser for tree select

myEditor :: String
myEditor = "emacsclient -c -a emacs "  -- Sets emacs as editor for tree select
-- myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor for tree select

myBorderWidth :: Dimension
myBorderWidth = 2          -- Sets border width for windows

myNormColor :: String
myNormColor   = "#282c34"  -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#46d9ff"  -- Border color of focused windows

altMask :: KeyMask
altMask = mod1Mask         -- Setting this for use in xprompts

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
          spawnOnce "lxsession &"
          spawnOnce "feh --bg-fill --randomize /home/chasbob/wallpapers/*"
          spawnOnce "picom --experimental-backends &"
          spawnOnce "nm-applet &"
          spawnOnce "blueman-applet &"
          spawnOnce "xrandr --output DP-1 --mode 2560x1440"
          spawnOnce "volumeicon &"
          spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 20 &"
          spawnOnce "/usr/bin/emacs --daemon &" -- emacs daemon for the emacsclient
          -- spawnOnce "kak -d -s mysession &"  -- kakoune daemon for better performance
          -- spawnOnce "urxvtd -q -o -f &"      -- urxvt daemon for better performance
          setWMName "LG3D"

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("Spotify", "spotify")
                 , ("Emacs", "emacsclient -c -a emacs")
                 , ("Brave", "brave")
                 , ("OBS", "obs")
                 , ("Audio", "pavucontrol")
                 ]

treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
   [ Node (TS.TSNode "+ Accessories" "Accessory applications" (return ()))
       [ Node (TS.TSNode "Archive Manager" "Tool for archived packages" (spawn "file-roller")) []
       , Node (TS.TSNode "Calculator" "Gui version of qalc" (spawn "qalculate-gtk")) []
       , Node (TS.TSNode "Picom Toggle on/off" "Compositor for window managers" (spawn "killall picom; picom --experimental-backend")) []
       , Node (TS.TSNode "Virt-Manager" "Virtual machine manager" (spawn "virt-manager")) []
       , Node (TS.TSNode "Virtualbox" "Oracle's virtualization program" (spawn "virtualbox")) []
       ]
   , Node (TS.TSNode "+ Internet" "internet and web programs" (return ()))
       [ Node (TS.TSNode "Brave" "A privacy-oriented web browser" (spawn "brave")) []
       , Node (TS.TSNode "Discord" "Chat and video chat platform" (spawn "discord")) []
       , Node (TS.TSNode "Zoom" "Web conferencing" (spawn "zoom")) []
       ]
   , Node (TS.TSNode "+ Multimedia" "sound and video applications" (return ()))
       [ Node (TS.TSNode "Alsa Mixer" "Alsa volume control utility" (spawn (myTerminal ++ " -e alsamixer"))) []
       , Node (TS.TSNode "OBS Studio" "Open Broadcaster Software" (spawn "obs")) []
       , Node (TS.TSNode "VLC" "Multimedia player and server" (spawn "vlc")) []
       , Node (TS.TSNode "Spotify" "Spotify streaming service" (spawn "spotify")) []
       ]
   , Node (TS.TSNode "+ System" "system tools and utilities" (return ()))
       [ Node (TS.TSNode "Gufw" "GUI uncomplicated firewall" (spawn "gufw")) []
       , Node (TS.TSNode "Htop" "Terminal process viewer" (spawn (myTerminal ++ " -e htop"))) []
       , Node (TS.TSNode "LXAppearance" "Customize look and feel; set GTK theme" (spawn "lxappearance")) []
       , Node (TS.TSNode "Nitrogen" "Wallpaper viewer and setter" (spawn "nitrogen")) []
       , Node (TS.TSNode "PCManFM" "Lightweight graphical file manager" (spawn "pcmanfm")) []
       , Node (TS.TSNode "Qt5ct" "Change your Qt theme" (spawn "qt5ct")) []
       ]
   , Node (TS.TSNode "------------------------" "" (spawn "xdotool key Escape")) []
   , Node (TS.TSNode "+ Bookmarks" "a list of web bookmarks" (return ()))
       [ Node (TS.TSNode "+ Linux" "a list of web bookmarks" (return ()))
           [ Node (TS.TSNode "+ Arch Linux" "btw, i use arch!" (return ()))
               [ Node (TS.TSNode "Arch Linux" "Arch Linux homepage" (spawn (myBrowser ++ "https://www.archlinux.org/"))) []
               , Node (TS.TSNode "Arch Wiki" "The best Linux wiki" (spawn (myBrowser ++ "https://wiki.archlinux.org/"))) []
               , Node (TS.TSNode "AUR" "Arch User Repository" (spawn (myBrowser ++ "https://aur.archlinux.org/"))) []
               , Node (TS.TSNode "Arch Forums" "Arch Linux web forum" (spawn (myBrowser ++ "https://bbs.archlinux.org/"))) []
               ]
           , Node (TS.TSNode "+ Linux News" "linux news and blogs" (return ()))
               [ Node (TS.TSNode "DistroWatch" "Linux distro release announcments" (spawn (myBrowser ++ "https://distrowatch.com/"))) []
               , Node (TS.TSNode "LXer" "LXer linux news aggregation" (spawn (myBrowser ++ "http://lxer.com"))) []
               , Node (TS.TSNode "OMG Ubuntu" "Ubuntu news, apps and reviews" (spawn (myBrowser ++ "https://www.omgubuntu.co.uk"))) []
               ]
           , Node (TS.TSNode "+ Window Managers" "window manager documentation" (return ()))
               [ Node (TS.TSNode "+ XMonad" "xmonad documentation" (return ()))
                   [ Node (TS.TSNode "XMonad" "Homepage for XMonad" (spawn (myBrowser ++ "http://xmonad.org"))) []
                   , Node (TS.TSNode "XMonad GitHub" "The GitHub page for XMonad" (spawn (myBrowser ++ "https://github.com/xmonad/xmonad"))) []
                   , Node (TS.TSNode "xmonad-contrib" "Third party extensions for XMonad" (spawn (myBrowser ++ "https://hackage.haskell.org/package/xmonad-contrib"))) []
                   , Node (TS.TSNode "xmonad-ontrib GitHub" "The GitHub page for xmonad-contrib" (spawn (myBrowser ++ "https://github.com/xmonad/xmonad-contrib"))) []
                   , Node (TS.TSNode "Xmobar" "Minimal text-based status bar"  (spawn (myBrowser ++ "https://hackage.haskell.org/package/xmobar"))) []
                   ]
               ]
           ]
       , Node (TS.TSNode "+ Search and Reference" "Search engines, indices and wikis" (return ()))
           [ Node (TS.TSNode "DuckDuckGo" "Privacy-oriented search engine" (spawn (myBrowser ++ "https://duckduckgo.com/"))) []
           , Node (TS.TSNode "Google" "The evil search engine" (spawn (myBrowser ++ "http://www.google.com"))) []
           , Node (TS.TSNode "Thesaurus" "Lookup synonyms and antonyms" (spawn (myBrowser ++ "https://www.thesaurus.com/"))) []
           , Node (TS.TSNode "Wikipedia" "The free encyclopedia" (spawn (myBrowser ++ "https://www.wikipedia.org/"))) []
           ]
       , Node (TS.TSNode "My Start Page" "Custom start page for browser" (spawn (myBrowser ++ "file://$HOME/.surf/html/homepage.html"))) []
       ]
   , Node (TS.TSNode "+ Config Files" "config files that edit often" (return ()))
       [ Node (TS.TSNode "+ doom emacs configs" "My doom emacs config files" (return ()))
         [ Node (TS.TSNode "Doom Emacs config.org" "doom emacs config" (spawn (myEditor ++ "$HOME/.doom.d/config.org"))) []
         , Node (TS.TSNode "Doom Emacs init.el" "doom emacs init" (spawn (myEditor ++ "$HOME/.doom.d/init.el"))) []
         , Node (TS.TSNode "Doom Emacs packages.el" "doom emacs packages" (spawn (myEditor ++ "$HOME/.doom.d/packages.el"))) []
         , Node (TS.TSNode "Doom Emacs eshell aliases" "the aliases for use in eshell" (spawn (myEditor ++ "$HOME/.doom.d/aliases"))) []
         ]
       , Node (TS.TSNode "+ xmobar configs" "My xmobar config files" (return ()))
           [ Node (TS.TSNode "xmobar mon1" "status bar on monitor 1" (spawn (myEditor ++ "$HOME/.config/xmobar/xmobarrc0"))) []
           , Node (TS.TSNode "xmobar mon2" "status bar on monitor 2" (spawn (myEditor ++ "$HOME/.config/xmobar/xmobarrc2"))) []
           , Node (TS.TSNode "xmobar mon3" "status bar on monitor 3" (spawn (myEditor ++ "$HOME/.config/xmobar/xmobarrc1"))) []
           ]
       , Node (TS.TSNode "+ xmonad configs" "My xmonad config files" (return ()))
           [ Node (TS.TSNode "xmonad.hs" "My XMonad Main" (spawn (myEditor ++ "$HOME/.xmonad/xmonad.hs"))) []
           , Node (TS.TSNode "xmonadctl.hs" "The xmonadctl script" (spawn (myEditor ++ "$HOME/.xmonad/xmonadctl.hs"))) []
           ]
       , Node (TS.TSNode "neovim init.vim" "neovim text editor" (spawn (myEditor ++ "$HOME/.config/nvim/init.vim"))) []
       , Node (TS.TSNode "xresources" "xresources file" (spawn (myEditor ++ "$HOME/.Xresources"))) []
       , Node (TS.TSNode "zshrc" "Config for the z shell" (spawn (myEditor ++ "$HOME/.config/zsh/.zshrc"))) []
       ]
   , Node (TS.TSNode "+ Screenshots" "take a screenshot" (return ()))
       [ Node (TS.TSNode "Quick fullscreen" "take screenshot immediately" (spawn "maim -d 1 ~/Pictures/ss/$(date -u +\"%Y-%m-%d_%H:%M:%S\").png")) []
       , Node (TS.TSNode "Delayed fullscreen" "take screenshot in 5 secs" (spawn "maim -d 5 ~/Pictures/ss/$(date -u +\"%Y-%m-%d_%H:%M:%S\").png")) []
       , Node (TS.TSNode "Section screenshot" "take screenshot of section" (spawn "maim -s ~/Pictures/ss/$(date -u +\"%Y-%m-%d_%H:%M:%S\").png")) []
       ]
   , Node (TS.TSNode "------------------------" "" (spawn "xdotool key Escape")) []
   , Node (TS.TSNode "+ XMonad Controls" "window manager commands" (return ()))
       [ Node (TS.TSNode "+ View Workspaces" "View a specific workspace" (return ()))
         [ Node (TS.TSNode "View 1" "View workspace 1" (spawn "~/.xmonad/xmonadctl 1")) []
         , Node (TS.TSNode "View 2" "View workspace 2" (spawn "~/.xmonad/xmonadctl 3")) []
         , Node (TS.TSNode "View 3" "View workspace 3" (spawn "~/.xmonad/xmonadctl 5")) []
         , Node (TS.TSNode "View 4" "View workspace 4" (spawn "~/.xmonad/xmonadctl 7")) []
         , Node (TS.TSNode "View 5" "View workspace 5" (spawn "~/.xmonad/xmonadctl 9")) []
         , Node (TS.TSNode "View 6" "View workspace 6" (spawn "~/.xmonad/xmonadctl 11")) []
         , Node (TS.TSNode "View 7" "View workspace 7" (spawn "~/.xmonad/xmonadctl 13")) []
         , Node (TS.TSNode "View 8" "View workspace 8" (spawn "~/.xmonad/xmonadctl 15")) []
         , Node (TS.TSNode "View 9" "View workspace 9" (spawn "~/.xmonad/xmonadctl 17")) []
         ]
       , Node (TS.TSNode "+ Shift Workspaces" "Send focused window to specific workspace" (return ()))
         [ Node (TS.TSNode "View 1" "View workspace 1" (spawn "~/.xmonad/xmonadctl 2")) []
         , Node (TS.TSNode "View 2" "View workspace 2" (spawn "~/.xmonad/xmonadctl 4")) []
         , Node (TS.TSNode "View 3" "View workspace 3" (spawn "~/.xmonad/xmonadctl 6")) []
         , Node (TS.TSNode "View 4" "View workspace 4" (spawn "~/.xmonad/xmonadctl 8")) []
         , Node (TS.TSNode "View 5" "View workspace 5" (spawn "~/.xmonad/xmonadctl 10")) []
         , Node (TS.TSNode "View 6" "View workspace 6" (spawn "~/.xmonad/xmonadctl 12")) []
         , Node (TS.TSNode "View 7" "View workspace 7" (spawn "~/.xmonad/xmonadctl 14")) []
         , Node (TS.TSNode "View 8" "View workspace 8" (spawn "~/.xmonad/xmonadctl 16")) []
         , Node (TS.TSNode "View 9" "View workspace 9" (spawn "~/.xmonad/xmonadctl 18")) []
         ]
       , Node (TS.TSNode "Next layout" "Switch to next layout" (spawn "~/.xmonad/xmonadctl next-layout")) []
       , Node (TS.TSNode "Recompile" "Recompile XMonad" (spawn "xmonad --recompile")) []
       , Node (TS.TSNode "Restart" "Restart XMonad" (spawn "xmonad --restart")) []
       , Node (TS.TSNode "Quit" "Restart XMonad" (io exitSuccess)) []
       ]
   ]

tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0xdd282c34
                              , TS.ts_font         = myFont
                              , TS.ts_node         = (0xffd0d0d0, 0xff1c1f24)
                              , TS.ts_nodealt      = (0xffd0d0d0, 0xff282c34)
                              , TS.ts_highlight    = (0xffffffff, 0xff755999)
                              , TS.ts_extra        = 0xffd0d0d0
                              , TS.ts_node_width   = 200
                              , TS.ts_node_height  = 20
                              , TS.ts_originX      = 100
                              , TS.ts_originY      = 100
                              , TS.ts_indent       = 80
                              , TS.ts_navigate     = myTreeNavigation
                              }

myTreeNavigation = M.fromList
    [ ((0, xK_Escape),   TS.cancel)
    , ((0, xK_Return),   TS.select)
    , ((0, xK_space),    TS.select)
    , ((0, xK_Up),       TS.movePrev)
    , ((0, xK_Down),     TS.moveNext)
    , ((0, xK_Left),     TS.moveParent)
    , ((0, xK_Right),    TS.moveChild)
    , ((0, xK_k),        TS.movePrev)
    , ((0, xK_j),        TS.moveNext)
    , ((0, xK_h),        TS.moveParent)
    , ((0, xK_l),        TS.moveChild)
    , ((0, xK_o),        TS.moveHistBack)
    , ((0, xK_i),        TS.moveHistForward)
    , ((0, xK_a),        TS.moveTo ["+ Accessories"])
    , ((0, xK_e),        TS.moveTo ["+ Games"])
    , ((0, xK_g),        TS.moveTo ["+ Graphics"])
    , ((0, xK_i),        TS.moveTo ["+ Internet"])
    , ((0, xK_m),        TS.moveTo ["+ Multimedia"])
    , ((0, xK_o),        TS.moveTo ["+ Office"])
    , ((0, xK_p),        TS.moveTo ["+ Programming"])
    , ((0, xK_s),        TS.moveTo ["+ System"])
    , ((0, xK_b),        TS.moveTo ["+ Bookmarks"])
    , ((0, xK_c),        TS.moveTo ["+ Config Files"])
    , ((0, xK_r),        TS.moveTo ["+ Screenshots"])
    , ((mod4Mask, xK_l), TS.moveTo ["+ Bookmarks", "+ Linux"])
    , ((mod4Mask, xK_e), TS.moveTo ["+ Bookmarks", "+ Emacs"])
    , ((mod4Mask, xK_s), TS.moveTo ["+ Bookmarks", "+ Search and Reference"])
    , ((mod4Mask, xK_p), TS.moveTo ["+ Bookmarks", "+ Programming"])
    , ((mod4Mask, xK_v), TS.moveTo ["+ Bookmarks", "+ Vim"])
    , ((mod4Mask .|. altMask, xK_a), TS.moveTo ["+ Bookmarks", "+ Linux", "+ Arch Linux"])
    , ((mod4Mask .|. altMask, xK_n), TS.moveTo ["+ Bookmarks", "+ Linux", "+ Linux News"])
    , ((mod4Mask .|. altMask, xK_w), TS.moveTo ["+ Bookmarks", "+ Linux", "+ Window Managers"])
    ]

dtXPConfig :: XPConfig
dtXPConfig = def
      { font                = myFont
      , bgColor             = "#282c34"
      , fgColor             = "#bbc2cf"
      , bgHLight            = "#c792ea"
      , fgHLight            = "#000000"
      , borderColor         = "#535974"
      , promptBorderWidth   = 0
      , promptKeymap        = dtXPKeymap
      , position            = Top
      -- , position            = CenteredAt { xpCenterY = 0.3, xpWidth = 0.3 }
      , height              = 23
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000  -- set Just 100000 for .1 sec
      , showCompletionOnTab = False
      -- , searchPredicate     = isPrefixOf
      , searchPredicate     = fuzzyMatch
      , defaultPrompter     = id $ map toUpper  -- change prompt to UPPER
      -- , defaultPrompter     = unwords . map reverse . words  -- reverse the prompt
      -- , defaultPrompter     = drop 5 .id (++ "XXXX: ")  -- drop first 5 chars of prompt and add XXXX:
      , alwaysHighlight     = True
      , maxComplRows        = Nothing      -- set to 'Just 5' for 5 rows
      }

-- The same config above minus the autocomplete feature which is annoying
-- on certain Xprompts, like the search engine prompts.
dtXPConfig' :: XPConfig
dtXPConfig' = dtXPConfig
      { autoComplete        = Nothing
      }

emojiXPConfig :: XPConfig
emojiXPConfig = dtXPConfig
      { font             = myEmojiFont
      }

calcPrompt c ans =
    inputPrompt c (trim ans) ?+ \input ->
        liftIO(runProcessWithInput "qalc" [input] "") >>= calcPrompt c
    where
        trim  = f . f
            where f = reverse . dropWhile isSpace

dtXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
dtXPKeymap = M.fromList $
     map (first $ (,) controlMask)      -- control + <key>
     [ (xK_z, killBefore)               -- kill line backwards
     , (xK_k, killAfter)                -- kill line forwards
     , (xK_a, startOfLine)              -- move to the beginning of the line
     , (xK_e, endOfLine)                -- move to the end of the line
     , (xK_m, deleteString Next)        -- delete a character foward
     , (xK_b, moveCursor Prev)          -- move cursor forward
     , (xK_f, moveCursor Next)          -- move cursor backward
     , (xK_BackSpace, killWord Prev)    -- kill the previous word
     , (xK_y, pasteString)              -- paste a string
     , (xK_g, quit)                     -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)          -- meta key + <key>
     [ (xK_BackSpace, killWord Prev)    -- kill the prev word
     , (xK_f, moveWord Next)            -- move a word forward
     , (xK_b, moveWord Prev)            -- move a word backward
     , (xK_d, killWord Next)            -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ]

archwiki, ebay, news, reddit, urban, yacy :: S.SearchEngine

archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
ebay     = S.searchEngine "ebay" "https://www.ebay.com/sch/i.html?_nkw="
news     = S.searchEngine "news" "https://news.google.com/search?q="
reddit   = S.searchEngine "reddit" "https://www.reddit.com/search/?q="
urban    = S.searchEngine "urban" "https://www.urbandictionary.com/define.php?term="
yacy     = S.searchEngine "yacy" "http://localhost:8090/yacysearch.html?query="

-- This is the list of search engines that I want to use. Some are from
-- XMonad.Actions.Search, and some are the ones that I added above.
searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("d", S.duckduckgo)
             , ("e", ebay)
             , ("g", S.google)
             , ("h", S.hoogle)
             , ("i", S.images)
             , ("n", news)
             , ("r", reddit)
             , ("s", S.stackage)
             , ("t", S.thesaurus)
             , ("v", S.vocabulary)
             , ("b", S.wayback)
             , ("u", urban)
             , ("w", S.wikipedia)
             , ("y", S.youtube)
             , ("S-y", yacy)
             , ("z", S.amazon)
             ]

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                ]
  where
    spawnTerm  = myTerminal ++ " -n scratchpad 'fish'"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -n mocp 'mocp'"
    findMocp   = resource =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
magnify  = renamed [Replace "magnify"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 0
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 8
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 8
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     tall
                                 ||| magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| spirals
                                 ||| threeCol
                                 ||| threeRow

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " mail "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces, and the names would very long if using clickable workspaces.
     [ title =? "Mozilla Firefox"     --> doShift ( myWorkspaces !! 1 )
     , className =? "mpv"     --> doShift ( myWorkspaces !! 7 )
     , className =? "Gimp"    --> doShift ( myWorkspaces !! 8 )
     , className =? "Gimp"    --> doFloat
     , title =? "Oracle VM VirtualBox Manager"     --> doFloat
     , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     ] <+> namedScratchpadManageHook myScratchPads

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1.0

myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-C-r", spawn "xmonad --recompile") -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")   -- Restarts xmonad
        , ("M-S-q", io exitSuccess)             -- Quits xmonad

    -- Run Prompt
        , ("M-S-<Return>", shellPrompt dtXPConfig) -- Xmonad Shell Prompt
        -- , ("M-S-<Return>", spawn "dmenu_run -i -p \"Run: \"") -- Dmenu
        -- , ("M-S-<Return>", spawn "rofi -show drun -config ~/.config/rofi/themes/dt-dmenu.rasi -display-drun \"Run: \" -drun-display-format \"{name}\"") -- Rofi

    -- Other Prompts
        , ("M-p c", calcPrompt dtXPConfig' "qalc") -- calcPrompt
        , ("M-p m", manPrompt dtXPConfig)          -- manPrompt
        , ("M-p p", passPrompt dtXPConfig)         -- passPrompt
        , ("M-p g", passGeneratePrompt dtXPConfig) -- passGeneratePrompt
        , ("M-p r", passRemovePrompt dtXPConfig)   -- passRemovePrompt
        , ("M-p s", sshPrompt dtXPConfig)          -- sshPrompt
        , ("M-p u", mkUnicodePrompt "xsel" ["-b"] "/home/dt/.xmonad/UnicodeData.txt" emojiXPConfig) -- unicodePrompt (for copying emojis)
        , ("M-p x", xmonadPrompt dtXPConfig)       -- xmonadPrompt

    -- Useful programs to have a keybinding for launch
        , ("M-<Return>", spawn (myTerminal ++ " -e zsh"))
        , ("M-b", spawn (myBrowser))
        , ("M-M1-h", spawn (myTerminal ++ " -e htop"))

    -- Kill windows
        , ("M-S-c", kill1)     -- Kill the currently focused client
        , ("M-S-a", killAll)   -- Kill all windows on current workspace

    -- Workspaces
        , ("M-S-l", nextWS)    -- Switch focus to next workspace
        , ("M-S-h", prevWS)    -- Switch focus to prev workspace
        , ("M-.", nextScreen)  -- Switch focus to next monitor
        , ("M-,", prevScreen)  -- Switch focus to prev monitor
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- Floating windows
        , ("M-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- Increase/decrease spacing (gaps)
        , ("M-d", decWindowSpacing 4)           -- Decrease window spacing
        , ("M-i", incWindowSpacing 4)           -- Increase window spacing
        , ("M-S-d", decScreenSpacing 4)         -- Decrease screen spacing
        , ("M-S-i", incScreenSpacing 4)         -- Increase screen spacing

    -- Grid Select (CTR-g followed by a key)
        , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
        , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window

    -- Tree Select
        , ("C-s t", treeselectAction tsDefaultConfig)

    -- Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- Layouts
        , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-S-<Space>", sendMessage ToggleStruts)     -- Toggles struts
        , ("M-S-n", sendMessage $ MT.Toggle NOBORDERS)  -- Toggles noborder

    -- Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase number of clients in master pane
        , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease number of clients in master pane
        , ("M-C-<Up>", increaseLimit)                   -- Increase number of windows
        , ("M-C-<Down>", decreaseLimit)                 -- Decrease number of windows

    -- Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-M1-k", sendMessage MirrorExpand)          -- Exoand vert window width

    -- Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        , ("M-C-h", sendMessage $ pullGroup L)
        , ("M-C-l", sendMessage $ pullGroup R)
        , ("M-C-k", sendMessage $ pullGroup U)
        , ("M-C-j", sendMessage $ pullGroup D)
        , ("M-C-m", withFocused (sendMessage . MergeAll))
        , ("M-C-u", withFocused (sendMessage . UnMerge))
        , ("M-C-/", withFocused (sendMessage . UnMergeAll))
        , ("M-C-.", onGroup W.focusUp')    -- Switch focus to next tab
        , ("M-C-,", onGroup W.focusDown')  -- Switch focus to prev tab

    -- Scratchpads
        , ("M-C-<Return>", namedScratchpadAction myScratchPads "terminal")
        , ("M-C-c", namedScratchpadAction myScratchPads "mocp")

    -- Controls for mocp music player (SUPER-u followed by a key)
        , ("M-u p", spawn "mocp --play")
        , ("M-u l", spawn "mocp --next")
        , ("M-u h", spawn "mocp --previous")
        , ("M-u <Space>", spawn "mocp --toggle-pause")

    -- Emacs (CTRL-e followed by a key)
        , ("C-e e", spawn "emacsclient -c -a 'emacs'")                            -- start emacs
        , ("C-e b", spawn "emacsclient -c -a 'emacs' --eval '(ibuffer)'")         -- list emacs buffers
        , ("C-e d", spawn "emacsclient -c -a 'emacs' --eval '(dired nil)'")       -- dired emacs file manager
        , ("C-e i", spawn "emacsclient -c -a 'emacs' --eval '(erc)'")             -- erc emacs irc client
        , ("C-e m", spawn "emacsclient -c -a 'emacs' --eval '(mu4e)'")            -- mu4e emacs email client
        , ("C-e n", spawn "emacsclient -c -a 'emacs' --eval '(elfeed)'")          -- elfeed emacs rss client
        , ("C-e s", spawn "emacsclient -c -a 'emacs' --eval '(eshell)'")          -- eshell within emacs
        , ("C-e t", spawn "emacsclient -c -a 'emacs' --eval '(mastodon)'")        -- mastodon within emacs
        , ("C-e v", spawn "emacsclient -c -a 'emacs' --eval '(+vterm/here nil)'") -- vterm within emacs
        -- emms is an emacs audio player. I set it to auto start playing in a specific directory.
        , ("C-e a", spawn "emacsclient -c -a 'emacs' --eval '(emms)' --eval '(emms-play-directory-tree \"~/Music/Non-Classical/70s-80s/\")'")

    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn (myTerminal ++ "mocp --play"))
        , ("<XF86AudioPrev>", spawn (myTerminal ++ "mocp --previous"))
        , ("<XF86AudioNext>", spawn (myTerminal ++ "mocp --next"))
        , ("<XF86AudioMute>",   spawn "amixer set Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")
        , ("<XF86HomePage>", spawn "firefox")
        , ("<XF86Search>", safeSpawn "firefox" ["https://www.duckduckgo.com/"])
        , ("<XF86Mail>", runOrRaise "thunderbird" (resource =? "thunderbird"))
        , ("<XF86Calculator>", runOrRaise "qalculate-gtk" (resource =? "qalculate-gtk"))
        , ("<XF86Eject>", spawn "toggleeject")
    -- Screenshots
        , ("M-S-4", spawn "maim -s | xclip -selection clipboard -t image/png")
        , ("M-S-3", spawn "maim -st 9999999 | convert - \'(' +clone -background black -shadow 80x3+5+5 \')' +swap -background none -layers merge +repage | xclip -selection clipboard -t image/png")
        ]
    -- Appending search engine prompts to keybindings list.
    -- Look at "search engines" section of this config for values for "k".
        ++ [("M-s " ++ k, S.promptSearch dtXPConfig' f) | (k,f) <- searchList ]
        ++ [("M-S-s " ++ k, S.selectSearch f) | (k,f) <- searchList ]
    -- The following lines are needed for named scratchpads.
          where nonNSP          = WSIs (return (\ws -> W.tag ws /= "nsp"))
                nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "nsp"))

main :: IO ()
main = do
    -- Launching three instances of xmobar on their monitors.
    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc0"
    -- xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobarrc2"
    -- xmproc2 <- spawnPipe "xmobar -x 2 $HOME/.config/xmobar/xmobarrc1"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh def
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks
        -- Run xmonad commands from command line with "xmonadctl command". Commands include:
        -- shrink, expand, next-layout, default-layout, restart-wm, xterm, kill, refresh, run,
        -- focus-up, focus-down, swap-up, swap-down, swap-master, sink, quit-wm. You can run
        -- "xmonadctl 0" to generate full list of commands written to ~/.xsession-errors.
        -- To compile xmonadctl: ghc -dynamic xmonadctl.hs
        , handleEventHook    = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> docksEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc0 x
                        , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"           -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#98be65" "" . clickable              -- Visible but not current workspace
                        , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" "" . clickable -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#c792ea" ""  . clickable     -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separators in xmobar
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
                        , ppExtras  = [windowCount]                                     -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
        } `additionalKeysP` myKeys
