#SingleInstance, force

; Variables
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
SpeedValue := 2.30
ItemBoxColor := 0x5a046e

; GUI Init
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
Gui, AutoLoot:New, +Border 
Gui, Color, 202020
Gui, Font, s12, Verdana
Gui, Font, w550
Gui, Font, C874600

Gui, Add, Text,, Changing this slider will determine how fast your Looter picks up`nthe next Item.`nJust try it and find the speed which suits you best.`n(Possible Values: 1.00-4.00) 
Gui, Add, Button, x370 y100 h40 w180 gControlClick, General Control Informations!
Gui, Show, w560 h150, Path of Exile - AutoLoot

Gui, Font, s12
Gui, Add, Text, vTextSpeed x300 y110 w50 h50, %SpeedValue%

Gui, Font, s18
initSpeed := SpeedValue * 100
;TODO: den Slider von anfang an als "gedrückt" anzeigen, sodass er auch gleich schwarzen hintergrund hat
Gui, Add, Slider, x20 y105 vSlider gSpeedSlider range100-400 AltSubmit tickinterval100, %initSpeed%

; Labels
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
SpeedSlider: ;wird aufgerufen, sobald sich die Werte im Speedslider ändern
    Gui,Submit,NoHide
    SpeedValue := slider/100
    tSpeedText:=SubStr(SpeedValue, 1 , 4)
    GuiControl,,TextSpeed,%tSpeedText% ;update das Textfeld mit der Speed-Angabe
    ;fra := Mod(SpeedValue, 100)
    ;fra := SubStr(fra, InStr(fra,".")+1, 2 )
    ;val := Floor(SpeedValue) "." fra
    ;tooltip % val
    ;SetTimer, RemoveToolTip, 500
return

;RemoveToolTip: ;überschreibt den Tooltip für den SpeedSlider
;    SetTimer, RemoveToolTip, Off
;    ToolTip
;return

ControlClick: ;Zeigt Hilfe-Text an
    MsgBox, 0, InformationWindow, - Numpad 0:`nCloses the Script entirely!`n`n- MouseButton 4 (BackButton):`nStarts the scanning process until no item are visible anymore!`n`n- MouseButton 5 (ForwardButton):`nStops the scanning process!
return 

; Hotkeys
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
XButton1::
    LoopPixelSearch := True
    FoundX := ""
    FoundY := ""

    PixelSearch, FoundX, FoundY, 0, 100, 1600, 1000, %ItemBoxColor%, 4, Fast RGB

    while (LoopPixelSearch && FoundX != "" && FoundY != "")
    {
        X := FoundX + 50
        Y := FoundY + 10

        MouseMove, %X%, %Y%
        sleep 100
        Send {LButton down}
        sleep 50
        Send {LButton up}

        RelativX := (960 - X)
        RelativY := (480 - Y)

        SleepTime := Sqrt(RelativX*RelativX + RelativY*RelativY) * (SpeedValue/10) 
        Sleep SleepTime ;Wait till the char travelled the beeline distance to the item
        PixelSearch, FoundX, FoundY, 0, 100, 1600, 1000, %ItemBoxColor%, 4, Fast RGB
    }
return

XButton2::
    LoopPixelSearch := False
return

;TODO: die labels werden irgendwie noch nicht aufgerufen :/
GuiClose: 
GuiEscape:
GuiContextMenu:
exitapp

Numpad0::
    MsgBox closed by user!
exitapp

