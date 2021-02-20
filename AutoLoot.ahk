#SingleInstance, force

; .ini File handling
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
myIniFile := A_ScriptDir . "\Wertespeicher.ini" 

if not (FileExist(myIniFile)) { 
    FileAppend,
    (
    [mySection]
    ItemBoxColor=0x5a046e
    Geschwindigkeit=2.3
    ), % myIniFile, utf-16 
}

IniRead, ItemBoxColor, % myIniFile, mySection, ItemBoxColor 
IniRead, SpeedValue, % myIniFile, mySection, Geschwindigkeit 

; GUI Init
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
Gui, AutoLoot:New, +Border
Gui, Color, 202020
Gui, Font, C874600
Gui, Font, s12, Verdana
Gui, Font, w550
Gui, Add, Text,, Changing this slider will determine how fast your Looter picks up`nthe next Item.`nJust try it and find the speed which suits you best.`n(Possible Values: 1.00-4.00) 
Gui, Add, Button, x370 y100 h40 w180 gControlClick, General Control Informations!
Gui, Add, Text, vTextSpeed x300 y110 w50 h50, %SpeedValue%

Gui, Font, s18
initSpeed := Floor(SpeedValue * 100)
Gui, Add, Slider, x20 y105 vSlider gSpeedSlider range100-400 AltSubmit tickinterval100, %initSpeed%

Gui, Font, s8
Gui, Add, Button, x490 y80 h15 w60 gFarbeGui, Farbe

Gui, Show, w560 h150, Path of Exile - AutoLoot
;ARSCH
; Labels
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
FarbeGui: 
    Gui,2: New, +Owner +Border -SysMenu
    Gui,2: Color, 202020
    Gui,2: Font, s10, Verdana
    Gui,2: Font, w550
    Gui,2: Font, C874600

    Gui,2: Add, Text,, Hier die Farbe des Lootfilters eingegeben werden.
    Gui,2: Show, w350 h100, Path of Exile - AutoLoot
return

SpeedSlider: 
    Gui,Submit,NoHide
    SpeedValue := slider/100
    tSpeedText:=SubStr(SpeedValue, 1 , 4)
    GuiControl,,TextSpeed,%tSpeedText% 

    SetFormat, float, 0.2
    Speicher_G := SpeedValue
    Speicher_G += 0
    IniWrite % Speicher_G, % myIniFile, mySection, Geschwindigkeit
return

ControlClick:
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

        SleepTime := Sqrt(RelativX*RelativX + RelativY*RelativY) * (SpeedValue) 
        Sleep SleepTime 
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

