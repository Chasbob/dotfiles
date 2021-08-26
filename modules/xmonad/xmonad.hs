  -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen, shiftPrevScreen, shiftNextScreen, nextWS, prevWS)
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
import XMonad.Layout.Accordion
import XMonad.Layout.Gaps
import XMonad.Layout.Circle
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.IndependentScreens
import XMonad.Layout.CenteredMaster
import XMonad.Layout.MultiColumns

    -- Layouts modifiers
import XMonad.Layout.CenteredMaster
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
import XMonad.Layout.Reflect
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
myFont = "xft:JetbrainsMono Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask       -- Sets modkey to super/windows key

myTerminal :: String
-- myTerminal = "alacritty"   -- Sets default terminal
myTerminal = "kitty"   -- Sets default terminal

myBrowser :: String
myBrowser = "firefox-developer-edition -- "               
-- myBrowser = myTerminal ++ " -e lynx " -- Sets lynx as browser for tree select

myEditor :: String
myEditor = "neovide "

myBorderWidth :: Dimension
myBorderWidth = 0          -- Sets border width for windows

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
          spawnOnce "pcmanfm -d &"
          -- spawnOnce "xrandr --output DP-1 --primary --right-of HDMI-1"
          spawnOnce "xrandr --output DP-3 --auto -d :0"
          -- spawnOnce "xrandr --output DP-1 --mode 2560x1440 --primary --right-of HDMI-1"
          -- spawnOnce "xrandr --output DP-1 --mode 2560x1440"
          spawnOnce "xsetroot -cursor_name left_ptr"
          spawnOnce "volumeicon &"
          spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282c34  --height 20 &"
          spawnOnce "/usr/bin/emacs --daemon &" -- emacs daemon for the emacsclient
          spawnOnce "conky -c $HOME/.config/conky/xmonad.conkyrc &>/dev/null"
          spawnOnce "~/.config/conky/now-clocking/start.sh"
          -- spawnOnce "conky -c $HOME/.config/conky/now-clocking/conky/np.lua &>/dev/null"
          -- spawnOnce "conky -c $HOME/.config/conky/now-clocking/conky/npart.lua &>/dev/null"
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
                 , ("Firefox", "firefox")
                 , ("OBS", "obs")
                 , ("Audio CTL", "pavucontrol")
                 , ("Audio Effects", "easyeffects")
                 ]

treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
   [ Node (TS.TSNode "+ Accessories" "Accessory applications" (return ()))
       [ Node (TS.TSNode "Archive Manager" "Tool for archived packages" (spawn "file-roller")) []
       , Node (TS.TSNode "Calculator" "Gui version of qalc" (spawn "qalculate-gtk")) []
       , Node (TS.TSNode "Files" "Elementary file explorer" (spawn "io.elementary.files")) []
       , Node (TS.TSNode "Picom Toggle on/off" "Compositor for window managers" (spawn "killall picom; picom --experimental-backend")) []
       ]
   , Node (TS.TSNode "+ Development" "IDEs and such" (return ()))
       [ Node (TS.TSNode "Goland" "Golang IDE" (spawn "dex ~/.local/share/applications/jetbrains-goland.desktop")) []
       , Node (TS.TSNode "Idea" "Java IDE" (spawn "dex ~/.local/share/applications/jetbrains-idea.desktop")) []
       , Node (TS.TSNode "PyCharm" "Python IDE" (spawn "dex ~/.local/share/applications/jetbrains-pycharm.desktop")) []
       , Node (TS.TSNode "Studio" "Android IDE" (spawn "dex ~/.local/share/applications/jetbrains-studio.desktop")) []
       , Node (TS.TSNode "WebStorm" "JavaScript IDE" (spawn "dex ~/.local/share/applications/jetbrains-webstorm.desktop")) []
       , Node (TS.TSNode "DataGrip" "SQL IDE" (spawn "dex ~/.local/share/applications/jetbrains-datagrip.desktop")) []
       ]
   , Node (TS.TSNode "+ Multimedia" "sound and video applications" (return ()))
       [ Node (TS.TSNode "Alsa Mixer" "Alsa volume control utility" (spawn ("pavucontrol"))) []
       , Node (TS.TSNode "OBS Studio" "Open Broadcaster Software" (spawn "obs")) []
       , Node (TS.TSNode "VLC" "Multimedia player and server" (spawn "vlc")) []
       , Node (TS.TSNode "Spotify" "Spotify streaming service" (spawn "spotify")) []
       ]
   , Node (TS.TSNode "+ System" "system tools and utilities" (return ()))
       [ Node (TS.TSNode "Htop" "Terminal process viewer" (spawn (myTerminal ++ " -e htop"))) []
       , Node (TS.TSNode "LXAppearance" "Customize look and feel; set GTK theme" (spawn "lxappearance")) []
       , Node (TS.TSNode "Nitrogen" "Wallpaper viewer and setter" (spawn "nitrogen")) []
       , Node (TS.TSNode "PCManFM" "Lightweight graphical file manager" (spawn "pcmanfm")) []
       , Node (TS.TSNode "Qt5ct" "Change your Qt theme" (spawn "qt5ct")) []
       ]
   , Node (TS.TSNode "+ Comms" "Chat / Mail etc." (return ()))
       [ Node (TS.TSNode "Discord" "Chat..." (spawn "discord")) []
       ]
   , Node (TS.TSNode "------------------------" "" (spawn "xdotool key Escape")) []
   , Node (TS.TSNode "+ Screenshots" "take a screenshot" (return ()))
       [ Node (TS.TSNode "Quick fullscreen" "take screenshot immediately" (spawn "maim -d 1 ~/Pictures/ss/$(date -u +\"%Y-%m-%d_%H:%M:%S\").png")) []
       , Node (TS.TSNode "Delayed fullscreen" "take screenshot in 5 secs" (spawn "maim -d 5 ~/Pictures/ss/$(date -u +\"%Y-%m-%d_%H:%M:%S\").png")) []
       , Node (TS.TSNode "Section screenshot" "take screenshot of section" (spawn "maim -s ~/Pictures/ss/$(date -u +\"%Y-%m-%d_%H:%M:%S\").png")) []
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
    , ((0, xK_a),        TS.moveTo ["+ Accessories"])
    , ((0, xK_d),        TS.moveTo ["+ Development"])
    , ((0, xK_m),        TS.moveTo ["+ Multimedia"])
    , ((0, xK_s),        TS.moveTo ["+ System"])
    , ((0, xK_r),        TS.moveTo ["+ Screenshots"])
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

archwiki, ebay, news, reddit, urban, yacy, github :: S.SearchEngine

archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
aur      = S.searchEngine "aur" "https://aur.archlinux.org/packages/?O=0&K="
ebay     = S.searchEngine "ebay" "https://www.ebay.com/sch/i.html?_nkw="
news     = S.searchEngine "news" "https://news.google.com/search?q="
reddit   = S.searchEngine "reddit" "https://www.reddit.com/search/?q="
urban    = S.searchEngine "urban" "https://www.urbandictionary.com/define.php?term="
yacy     = S.searchEngine "yacy" "http://localhost:8090/yacysearch.html?query="
github   = S.searchEngine "github" "https://github.com/search?q="

-- This is the list of search engines that I want to use. Some are from
-- XMonad.Actions.Search, and some are the ones that I added above.
searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("C-a", aur)
             , ("d", S.duckduckgo)
             , ("e", ebay)
             , ("g", S.google)
             , ("C-g", github)
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
                , NS "spotify" spawnSpotify findSpotify manageSpotify
                , NS "emoji" spawnEmoji findEmoji manageEmoji
                , NS "htop" spawnHtop findHtop manageHtop
                , NS "clockify" spawnClockify findClockify manageClockify
                , NS "conky" spawnConky findConky manageConky
                , NS "neovide" spawnNeovide findNeovide manageNeovide
                , NS "firefox" spawnFirefox findFirefox manageFirefox
                ]
  where
    spawnHtop  = myTerminal ++ " --name=htop-scratchpad 'htop'"
    findHtop   = resource =? "htop-scratchpad"
    manageHtop = customFloating $ W.RationalRect l t w h
               where
                 h = 0.4
                 w = 0.4
                 t = 0.45 -h
                 l = 0.45 -w
    spawnEmoji  = myTerminal ++ " --name=emoji-scratchpad -e zsh -li -c 'emoji::emoji_get | xclip -selection clipboard -in'"
    findEmoji   = resource =? "emoji-scratchpad"
    manageEmoji = customFloating $ W.RationalRect l t w h
               where
                 h = 0.4
                 w = 0.4
                 t = 0.45 -h
                 l = 0.45 -w
    spawnClockify  = "clockify"
    findClockify   = resource =? "clockify"
    manageClockify = customFloating $ W.RationalRect l t w h
               where
                 h = 0.4
                 w = 0.4
                 t = 0.45 -h
                 l = 0.45 -w
    spawnConky  = "conky -c $HOME/.config/conky/scratchpad.conkyrc" 
    findConky   = title =? "conky-scratchpad"
    manageConky = defaultFloating
    spawnFirefox  = "firefox -P scratchpad --class scratchpad" 
    findFirefox   = className =? "scratchpad"
    manageFirefox = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    -- manageConky = customFloating $ W.RationalRect l t w h
               -- where
                 -- h = 0.4
                 -- w = 0.4
                 -- t = 0.45 -h
                 -- l = 0.45 -w
    -- spawnNeovide  = myTerminal ++ "'/home/chasbob/.local/bin/change-title 'neovide-scratchpad' 'neovide --multiGrid'"
    spawnNeovide  = "zsh -li -c 'neovide --multiGrid'"
    findNeovide   = resource =? "neovide-scratchpad"
    manageNeovide = customFloating $ W.RationalRect l t w h
               where
                 h = 0.4
                 w = 0.4
                 t = 0.45 -h
                 l = 0.45 -w
    spawnTerm  = myTerminal ++ " --name=scratchpad --title=scratchpad 'zsh'"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnSpotify  = "spotify" 
    findSpotify   = className =? "Spotify"
    manageSpotify = customFloating $ W.RationalRect l t w h
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
-- floats   = renamed [Replace "floats"]
           -- $ windowNavigation
           -- $ addTabs shrinkText myTabTheme
           -- $ subLayout [] (smartBorders Simplest)
           -- $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 0
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
threeCol = renamed [Replace "threeCol"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 8
           $ ThreeColMid 1 (3/100) (1/2)
threeCol2 = renamed [Replace "threeCol2"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 8
           $ ThreeColMid 2 (3/100) (1/2)
-- this is very much setup for my ultrawide display and for having space for floats and conky windows
myGaps   = renamed [Replace "gaps"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 8
           -- $ description (MyTall (Tall n _ _)) = "Tall " ++ show n
           $ gaps [(L,700), (R,700)]
           -- $ Tall 1 (3/100) (1/2)
           $ ThreeColMid 1 (3/100) (1/2)
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ gaps [(L,700), (R,700)]
           $ limitWindows 20 Full
wideAccordion  = renamed [Replace "accordion"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 8
           $ Mirror Accordion
myMultCol = renamed [Replace "multiCol"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing 8
           $ multiCol [1] 2 0.01 0.5

-- setting c >> sendMessage (IncGap 8 L) olors for tabs layout and tabs sublayout.
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
myLayoutHook = avoidStruts $ mouseResize $ windowArrange  
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT)
               $ mkToggle (single REFLECTX)
               $ mkToggle (single REFLECTY)
               $ T.toggleLayouts myGaps
               $ T.toggleLayouts monocle
               $ myDefaultLayout
             where
               myDefaultLayout =     threeCol
                                 ||| threeCol2
                                 -- ||| gapsAcc
                                 -- ||| myGaps
                                 -- ||| tall
                                 -- ||| columns
                                 ||| myMultCol
                                 ||| grid
                                 -- ||| threeRow
                                 ||| wideAccordion

myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
-- myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " mail "]
-- myWorkspaces = [" dev ", " www ", " chat ", " mus ", " mail ", " sys "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     [ className =? "mpv"     --> doShift ( myWorkspaces !! 7 )
     , className =? "Gimp"    --> doShift ( myWorkspaces !! 8 )
     , className =? "EasyEffects"    --> doShift ( myWorkspaces !! 8 )
     , className =? "Volume Control"    --> doShift ( myWorkspaces !! 8 )
     -- , className =? "Spotify"     --> doFloat
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
        -- , ("M-S-<Return>", shellPrompt dtXPConfig) -- Xmonad Shell Prompt
        , ("M-S-<Return>", spawn "dmenu_run -i -p \"Run: \"") -- Dmenu
    -- Other Prompts
        , ("M-p c", calcPrompt dtXPConfig' "qalc") -- calcPrompt
        , ("M-p s", sshPrompt dtXPConfig')          -- sshPrompt
        , ("M-p x", xmonadPrompt dtXPConfig)       -- xmonadPrompt

    -- Useful programs to have a keybinding for launch
        , ("M-<Return>", spawn (myTerminal ++ " -e zsh"))
        , ("M-b", spawn (myBrowser))
        , ("M-C-p", spawn ("dmproject"))
        , ("M-C-n", spawn ("dm-note"))
        , ("M-f", spawn ("io.elementary.files"))


    -- Kill windows
        , ("M-S-c", kill1)     -- Kill the currently focused client
        , ("M-S-a", killAll)   -- Kill all windows on current workspace

    -- Workspaces
        , ("M3-l", nextWS)
        -- , ("M-S-l", nextWS)                        -- Switch focus to next workspace
        , ("M3-h", prevWS)                        -- Switch focus to prev workspace
        -- , ("M-.", nextScreen)                      -- Switch focus to next monitor
        -- , ("M-,", prevScreen)                      -- Switch focus to prev monitor
        , ("M3-.", shiftNextScreen >> nextScreen) -- Shift focused window to next monitor and follow with focus
        , ("M3-,", shiftPrevScreen >> prevScreen) -- Shift focused window to prev monitor and follow with focus
        , ("M-S-<KP_Add>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-<KP_Subtract>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- Floating windows
        -- , ("M-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- Increase/decrease spacing (gaps)
        , ("M-d", decWindowSpacing 8)           -- Decrease window spacing
        , ("M-i", incWindowSpacing 8)           -- Increase window spacing
        , ("M-C-i", setScreenWindowSpacing 150)
        , ("M-g", sendMessage (T.Toggle "gaps"))
        , ("M-C-x", sendMessage (T.Toggle "monocle"))
        -- , ("M-C-i", sendMessage (IncGap 8 R) >> sendMessage (IncGap 8 L) )
        , ("M-S-d", decScreenSpacing 8)         -- Decrease screen spacing
        , ("M-S-i", incScreenSpacing 8)         -- Increase screen spacing

    -- Grid Select (CTR-g followed by a key)
        , ("M3-g", spawnSelected' myAppGrid)                 -- grid select favorite apps
        , ("M3-f", goToSelected $ mygridConfig myColorizer)  -- goto selected window
        , ("M-C-s b", bringSelected $ mygridConfig myColorizer) -- bring selected window

    -- Tree Select
        , ("M3-s", treeselectAction tsDefaultConfig)

    -- Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
        , ("M-C-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
        , ("M-S-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- Layouts
        , ("M-x", sendMessage (MT.Toggle REFLECTX))
        , ("M-y", sendMessage (MT.Toggle REFLECTY))
        , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-C-M1-<Up>", sendMessage Arrange)
        , ("M-C-M1-<Down>", sendMessage DeArrange)
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("M-C-<Space>", sendMessage ToggleStruts)     -- Toggles struts
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

    -- Scratchpads
        , ("M-C-<Return>", namedScratchpadAction myScratchPads "terminal")
        , ("M-C-m", namedScratchpadAction myScratchPads "spotify")
        , ("M-C-h", namedScratchpadAction myScratchPads "htop")
        , ("M-C-e", namedScratchpadAction myScratchPads "emoji")
        , ("M-C-t", namedScratchpadAction myScratchPads "clockify")
        , ("M-C-b", namedScratchpadAction myScratchPads "firefox")
        , ("M-C-c", namedScratchpadAction myScratchPads "conky")
        -- , ("M-C-c", spawn "killall conky || conky -c $HOME/.config/conky/xmonad.conkyrc")
        -- , ("M-C-n", spawn "neovide --multiGrid")conky -c $HOME/.config/conky/xmonad.conkyrc

    -- Controls for mocp music player (SUPER-u followed by a key)
        , ("M-u p", spawn "playerctl play")
        , ("M-u l", spawn "playerctl next")
        , ("M-u h", spawn "playerctl previous")
        , ("M-u <Space>", spawn "playerctl play-pause")

    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn ("playerctl play-pause"))
        , ("<XF86AudioPrev>", spawn ("playerctl previous"))
        , ("<XF86AudioNext>", spawn ("playerctl next"))
        , ("<XF86AudioMute>", spawn "amixer set Master toggle")
        , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
        , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
        , ("M3-<XF86AudioLowerVolume>", spawn "v4l2-ctl -d /dev/video0 -c zoom_absolute=\"$(v4l2-ctl -d /dev/video0 -C zoom_absolute|awk '{sum = $2 - 5; print sum}')\"")
        , ("M3-<XF86AudioRaiseVolume>", spawn "v4l2-ctl -d /dev/video0 -c zoom_absolute=\"$(v4l2-ctl -d /dev/video0 -C zoom_absolute|awk '{sum = $2 + 5; print sum}')\"")
    -- Screenshots
        , ("M-C-4", spawn "maim -s | xclip -selection clipboard -t image/png")
        , ("M-C-3", spawn "maim -st 9999999 | convert - \'(' +clone -background black -shadow 80x3+5+5 \')' +swap -background none -layers merge +repage | xclip -selection clipboard -t image/png")
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
    xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobarrc0"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh def
        { manageHook         = myManageHook <+> manageDocks
        , handleEventHook    = docksEventHook
                               -- Uncomment this line to enable fullscreen support on things like YouTube/Netflix.
                               -- This works perfect on SINGLE monitor systems. On multi-monitor systems,
                               -- it adds a border around the window if screen does not have focus. So, my solution
                               -- is to use a keybinding to toggle fullscreen noborders instead.  (M-<Space>)
                               -- <+> fullscreenEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
              -- the following variables beginning with 'pp' are settings for xmobar.
              { ppOutput = \x -> hPutStrLn xmproc0 x                          -- xmobar on monitor 1
              , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"           -- Current workspace
              , ppVisible = xmobarColor "#98be65" ""              -- Visible but not current workspace
              , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" "" -- Hidden workspaces
              -- , ppHiddenNoWindows = xmobarColor "#c792ea" ""       -- Hidden workspaces (no windows)
              , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
              , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
              , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
              , ppExtras  = [windowCount]                                     -- # of windows current workspace
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
              }
        } `additionalKeysP` myKeys
