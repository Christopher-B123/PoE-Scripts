#SingleInstance, force
#Warn ;warnungen anstellen
SendMode Input

; Variables
;-------------------------------------------------
;-------------------------------------------------
mousespeed := 1
speed := 2.3

; Hotkeys
;-------------------------------------------------
;-------------------------------------------------
;Gui Fenster erstellen
XButton1::

    ;Gui, Color, A834BF ; Hintergrundfarbe einstellen
    Gui, Font, s16, VERDANA
    Gui, Add, Text,, aktuelle Geschwindigkeit:
    ;Gui, Add, Button, default, +
    ;Gui, Add, Button, default, -

    initSpeed := Floor(speed * 100)

    Gui, Add, Slider, vSlider gSpeedSlider range100-300 AltSubmit tickinterval100, %initSpeed%
    ;Gui, Add, Button, default, update
    Gui, Show, w500 h400, PathofExile - AutoLoot ;erstellt leeres Fenster in der Mitte

return

; Labels
;-------------------------------------------------
;-------------------------------------------------
;Buttonupdate:
;Gui, Submit, nohide
;return

; wird aufgerufen, wenn der Slider für speed verändert wird
SpeedSlider:
    Gui,Submit,NoHide
    speed := slider/100
    fra := Mod(speed, 100)
    fra := SubStr(fra, InStr(fra,".")+1, 2 )
    val := Floor(speed) "." fra
    tooltip % val
    SetTimer, RemoveToolTip, 500
return

RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
return

GuiClose:
GuiContextMenu:
Numpad0::
exitapp

; Functions
;-------------------------------------------------
;-------------------------------------------------

/*
BreakLoop = 0
FoundX := 0
FoundY := 0
	
PixelSearch, FoundX, FoundY, 0, 100, 1600, 1000, 0x5a046e, 4, Fast RGB

while (FoundX != "" && FoundY != "")
{
	if (BreakLoop = 1)
		break 
		
	X := FoundX + 50
	Y := FoundY + 10
	
	MouseMove, %X%, %Y%
	sleep 100
	Send {LButton down}
	sleep 50
	Send {LButton up}
	
	RelativX := (960 - X)*(960 - X)
	RelativY := (480 - Y)*(480 - Y)
	
	SleepTime := Sqrt(RelativX + RelativY) * 2,3
	Sleep SleepTime
	PixelSearch, FoundX, FoundY, 0, 100, 1600, 1000, 0x5a046e, 4, Fast RGB
	
	if (BreakLoop = 1)
		break 
}
*/

return

XButton2::
    Gui, Destroy
    BreakLoop = 1
return

