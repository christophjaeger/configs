import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce

myModMask = mod4Mask

main = do
	session <- getEnv "DESKTOP_SESSION"
	xmonad $ (maybe desktopConfig desktop session)
		{ modMask = myModMask }

desktop s = case s of
	"gnome"        -> gnomeConfig
	"kde"          -> kde4Config
	"xfce"         -> xfceConfig
	"xmonad-gnome" -> gnomeConfig
	_              -> desktopConfig
