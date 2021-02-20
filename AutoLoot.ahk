#SingleInstance, force
SendMode Input

; Hotkeys Definitions
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
Hotkey, XButton2, StopItemSearch
Hotkey, XButton1, StartItemSearch
Hotkey, Rbutton, CatchColor

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

;global variables:
IniRead, ItemBoxColor, % myIniFile, mySection, ItemBoxColor 
IniRead, SpeedValue, % myIniFile, mySection, Geschwindigkeit 

; GUI Init
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
Gui, AutoLoot:New, +Border
Gui, AutoLoot:Color, 202020
Gui, AutoLoot:Font, C874600
Gui, AutoLoot:Font, s12, Verdana
Gui, AutoLoot:Font, w550
Gui, AutoLoot:Add, Text,, Changing this slider will determine how fast your Looter picks up`nthe next Item.`nJust try it and find the speed which suits you best.`n(Possible Values: 1.00-4.00) 
Gui, AutoLoot:Add, Button, x370 y100 h40 w180 gControlClick, General Control Informations!
Gui, AutoLoot:Add, Text, vTextSpeed x300 y110 w50 h50, %SpeedValue%

;add Slider
Gui, AutoLoot:Font, s18
initSpeed := Floor(SpeedValue * 100)
Gui, AutoLoot:Add, Slider, x20 y105 vSlider gSpeedSlider range100-400 AltSubmit tickinterval100, %initSpeed%

;add "Color"-Button
Gui, AutoLoot:Font, s8
Gui, AutoLoot:Add, Button, x400 y80 h15 w120 gColorPickerGUI, Choose Color

Gui, AutoLoot:Show, w560 h150, Path of Exile - AutoLoot

return

; Labels
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
ColorPickerGUI: ;Opens Window where you can choose a color
    Gui,ColorPicker: New, +Owner +Border -SysMenu
    Gui,ColorPicker: Color, 202020
    Gui,ColorPicker: Font, s10, Verdana
    Gui,ColorPicker: Font, w550
    Gui,ColorPicker: Font, C874600

    Gui,ColorPicker: Add, Text,, Choose a color.
    Gui,ColorPicker: Show, w350 h100, Path of Exile - AutoLoot
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

StartItemSearch:
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

StopItemSearch:
    LoopPixelSearch := False
return

;clicked on a pixel, which color is to be identified
CatchColor:
    ;CoordMode, Mouse, Screen
    MouseGetPos X, Y
    PixelGetColor ItemBoxColor, X, Y, RGB

return

;TODO: die labels werden irgendwie noch nicht aufgerufen :/
GuiClose: 
GuiEscape:
GuiContextMenu:
exitapp

; additional Hotkeys
;------------------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------------------
Numpad0::
    ;MsgBox closed by user!
exitapp

