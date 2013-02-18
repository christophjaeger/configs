import System.Posix.Env (getEnv)
import Data.Maybe (maybe)

import qualified Data.Map as Map

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders

import qualified DBus as DBus
import qualified DBus.Client as C
import qualified Codec.Binary.UTF8.String as UTF8

myModMask = mod4Mask

myKeys conf@(XConfig {XMonad.modMask = m}) = Map.fromList $
	[ ((m              , xK_Left ), prevWS)
	, ((m              , xK_Right), nextWS)
	, ((m .|. shiftMask, xK_Left ), shiftToPrev >> prevWS)
	, ((m .|. shiftMask, xK_Right), shiftToNext >> nextWS)
	]

myLogHook dbus = defaultPP
	{ ppCurrent = const ""
	, ppVisible = const ""
	, ppHidden  = const ""
	, ppUrgent  = const ""
	, ppLayout  = const ""
	, ppSep     = ""
	, ppOutput  = \ s ->
		C.emit dbus (DBus.signal (DBus.objectPath_ "/org/xmonad/Log")
		                         (DBus.interfaceName_ "org.xmonad.Log")
		                         (DBus.memberName_ "Update"))
			{DBus.signalBody = [DBus.toVariant (UTF8.decodeString s)]}
	}

myTerminal = c ++ "; if [ $? -eq 2 ]; then " ++ d ++ "; " ++ c ++ "; fi"
	where d = "urxvt256cd --quiet --opendisplay --fork"
	      c = "urxvt256cc -e tmux -2"

main = do
	session <- getEnv "DESKTOP_SESSION"
	let config = maybe desktopConfig desktop session
	dbus <- C.connectSession
	C.requestName dbus (DBus.busName_ "org.xmonad.Log")
		[ C.nameAllowReplacement
		, C.nameReplaceExisting
		, C.nameDoNotQueue
		]
	xmonad $ config
		{ modMask    = myModMask
		, keys       = myKeys <+> keys config
		, logHook    = dynamicLogWithPP (myLogHook dbus) <+> logHook config
		, layoutHook = smartBorders $ layoutHook config
		, terminal   = myTerminal
		}

desktop s = case s of
	"gnome"        -> gnomeConfig
	"kde"          -> kde4Config
	"xfce"         -> xfceConfig
	"xmonad-gnome" -> gnomeConfig
	_              -> desktopConfig
