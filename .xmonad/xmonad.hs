import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import qualified Data.Map as Map

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce

myModMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = m}) = Map.fromList $
	[ ((m              , xK_Left ), prevWS)
	, ((m              , xK_Right), nextWS)
	, ((m .|. shiftMask, xK_Left ), shiftToPrev >> prevWS)
	, ((m .|. shiftMask, xK_Right), shiftToNext >> nextWS)
	]

main = do
	session <- getEnv "DESKTOP_SESSION"
	let config = maybe desktopConfig desktop session
	xmonad $ config
		{ modMask = myModMask
		, keys    = myKeys <+> keys config
		}

desktop s = case s of
	"gnome"        -> gnomeConfig
	"kde"          -> kde4Config
	"xfce"         -> xfceConfig
	"xmonad-gnome" -> gnomeConfig
	_              -> desktopConfig
