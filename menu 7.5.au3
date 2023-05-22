#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=D:\Backup\Downloads\logo.ico
#AutoIt3Wrapper_Outfile=D:\Launcher Offical\menu.exe
#AutoIt3Wrapper_Outfile_x64=C:\Users\Administrator\Desktop\menu.Exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Nguyễn Thế Nam
#AutoIt3Wrapper_Res_Description=Apps Menu
#AutoIt3Wrapper_Res_Fileversion=5.0
#AutoIt3Wrapper_Res_ProductName=Apps Menu
#AutoIt3Wrapper_Res_ProductVersion=5.0
#AutoIt3Wrapper_Res_CompanyName=Nguyễn Thế Nam
#AutoIt3Wrapper_Res_LegalCopyright=Copyright ©Nguyễn Thế Nam
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1066
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WindowsConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include "GUIScrollbars_Ex.au3"
#include <GuiButton.au3>
#include <StringConstants.au3>
#include <InetConstants.au3>
#include "_Zip.au3"
#include "GIFAnimation.au3"
#include "MetroGUI_UDF.au3"
Opt("TrayMenuMode",1) ; no default menu (Paused/Exit)
Global $settingsini = @ScriptDir & "\settings.ini"
Global $value = IniRead("settings.ini", "ram", "value", "")

$x = 25
$y = 110
$p = 1
Global $wide = 826
Global $high = 517
$input = @ScriptDir & "\menu"
Global $button[]
Global $version = "7.5"
Global $check = @ScriptDir & "\" & "Open.exe"; Đường dẫn đến file exe được tạo ra
if FileExists($check) = 0 Then
	_Metro_MsgBox (0,"Apps Menu", "Không tìm thấy Open.exe")
	Exit
EndIf



#Region ### START Koda GUI section ### Form=
$Form1 = _Metro_CreateGUI("Apps Menu",$wide,$high,(@DesktopWidth-$wide)/2, (@DesktopHeight-$high)/2,$WS_POPUP)
_SetTheme("DarkTeal")
$Control_Buttons = _Metro_AddControlButtons(True, False, True, False, True)
;CloseBtn = True, MaximizeBtn = True, MinimizeBtn = True, FullscreenBtn = True, MenuBtn = True
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
$GUI_MENU_BUTTON = $Control_Buttons[6]
$Pic1 = _GUICtrlCreateGIF("data.dll","10;1", 0,-8, 828, 84)
$find = _GUICtrlCreateGIF("data.dll","PNG;1", 625, 82,20, 20)
$searchInput = GUICtrlCreateInput("", 650, 82, 150, 20)
GUICtrlSetStyle(-1, $ES_AUTOHSCROLL + $ES_WANTRETURN, $WS_EX_WINDOWEDGE)
GUICtrlSetFont(-1, 11, 500, Default, "Segoe UI", 5)
GUICtrlSetColor(-1,0x6A1B9A)
GUICtrlSetTip(-1, "Tìm kiếm...")
Local $aFileList = _FileListToArray($input, "*")
for $i=1 to $aFileList[0] Step 1
	 $path = @ScriptDir & "\menu\" & $aFileList[$i]
	 $aDetails_wrong = FileGetShortcut($path)
	$button[$p]=GUICtrlCreateButton('',$x,$y, 75, 75,$BS_ICON)
	GUICtrlSetImage(-1,$aDetails_wrong[0],0)
	GUICtrlSetTip(-1,$aFileList[$i])
	GUICtrlSetCursor(-1,0)

    $x = $x + 100
	$p = $p + 1
	if mod($p,8)==1 then
	$x= 25
	$y = $y + 130
	_GUIScrollbars_Generate($Form1,0,$y+130)
	EndIf
Next

AdlibRegister("find", 250)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
	$value = IniRead("settings.ini", "ram", "value", "")
	$memo = MemGetStats()
	if $memo[0] > $value and $value <> 0 Then
		reco()
		EndIf

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE ,$GUI_CLOSE_BUTTON
			_Metro_GUIDelete($Form1)
			Exit
		Case $GUI_MINIMIZE_BUTTON
			WinSetState($Form1, "", @SW_MINIMIZE)
		Case $GUI_MENU_BUTTON
			Local $MenuButtonsArray[5] = ["Update","Optimize", "Settings","About", "Exit"]
			; Open the metro Menu. See decleration of $MenuButtonsArray above.
			Local $MenuSelect = _Metro_MenuStart($Form1, 150, $MenuButtonsArray)
			Switch $MenuSelect ;Above function returns the index number of the selected button from the provided buttons array.
				Case "0"
					update_launcher()
				Case "3"
					About()
				Case "4"
					exit
				Case "2"
					Settings()
				case "1"
					Optimize()
			EndSwitch

	EndSwitch
        For $i = 1 To UBound($aFileList)
            If $nMsg == $button[$i] Then
	 $path = @ScriptDir & "\menu\" & $aFileList[$i]
				ShellExecute($path)
				WinSetState($Form1,"",@SW_MINIMIZE)
               ExitLoop
            EndIf
        Next
WEnd

func update_launcher()
	$path_update = @TempDir & "\update.zip"
$Data = InetRead("https://raw.githubusercontent.com/ntnhacker1/appsmenu/main/version.txt",1)
$data_converted = BinaryToString($Data,4)
$data_array=StringSplit($data_converted,"|")
if $version == $data_array[1] then _Metro_MsgBox (0,"Apps Menu", "Bạn đang dùng phiên bản mới nhất")
$t = _Metro_MsgBox (4, "Phiên bản hiện tại:" & $version ,"Phiên bản mới nhất là : " & $data_array[1] & @CRLF& $data_array[3] & @CRLF & "Cập nhập ngay =>")
If $t = "Yes" Then
    SplashTextOn ("", "Đang tải nội dung", 270, 50,-1,-1,1,-1,14,600)
	$hDownload = InetGet($data_array[2],$path_update,1,1)
        Do
                Sleep(250)
		Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)
		SplashOff()
		Sleep(100)
		SplashTextOn ("", "Đang tiến hành cập nhật", 270, 50,-1,-1,1,-1,14,600)
		_Zip_UnzipAll(@TempDir & '\update.zip', @ScriptDir)
		Sleep(100)
		SplashOff()
		FileDelete(@TempDir & '\update.zip')
		SplashTextOn ("", "Cập nhật xong! Đang chạy lại apps !", 350, 50,-1,-1,1,-1,14,600)
		Sleep(1500)
		SplashOff()
		RUN("runtime.dll menu.dll")
		Exit
EndIf
EndFunc


Func find()
    Local $searchTerm = GUICtrlRead($searchInput)
    If $searchTerm = "" Then Return
    For $i = 1 To UBound($button)
        If StringInStr($aFileList[$i], $searchTerm) Then
            Local $pos = ControlGetPos($Form1, "", $button[$i])
			Local $pos2 = ControlGetPos($Form1, "", $button[1])
            GUICtrlSetPos($button[1], $pos[0], $pos[1])
            GUICtrlSetPos($button[$i],$pos2[0],$pos2[1])
            Local $temp = $aFileList[1]
            $aFileList[1] = $aFileList[$i]
            $aFileList[$i] = $temp
            Local $tempButton = $button[1]
            $button[1] = $button[$i]
            $button[$i] = $tempButton
            ExitLoop
        EndIf
    Next
EndFunc
func About()
	Local $aboutgui = _Metro_CreateGUI("About", 600, 400, -1, -1, True)
	_Metro_CreateLabel("Apps Menu " & $version, 200, 40, 300, 50)
		GUICtrlSetFont(-1, 25, 500, Default, "Segoe UI", 5)
		_Metro_CreateLabel("Tác giả : Nguyễn Thế Nam", 175, 100, 300, 50)
		GUICtrlSetFont(-1, 15, 500, Default, "Segoe UI", 5)
		_Metro_CreateLabel("Copyright © " & @YEAR, 235, 140, 300, 50)
		GUICtrlSetFont(-1, 10, 500, Default, "Segoe UI", 5)
		_Metro_CreateLabel("Apps Menu " & $version, 200, 40, 300, 50)
		GUICtrlSetFont(-1, 25, 500, Default, "Segoe UI", 5)
		$logo = _GUICtrlCreateGIF("data.dll","PNG;LOGO", 215,170, 150, 150)
	Local $Button1 = _Metro_CreateButton("Close", 250, 340, 100, 40)

	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Button1
				_Metro_GUIDelete($aboutgui) ;Delete GUI/release resources, make sure you use this when working with multiple GUIs!
				Return 0
		EndSwitch
	WEnd
EndFunc   ;==>_SecondGUI
Func _Metro_CreateLabel($Text,$x,$y,$w,$h,$tyle=-1,$xstyle =-1,$Font_Color = $FontThemeColor, $Font = "Segoe UI", $Fontsize = "12")
$hLabel = GUICtrlCreateLabel($Text,$x,$y,$w,$h,$tyle,$xstyle)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($hLabel), "wstr", 0, "wstr", 0)
    GUICtrlSetFont($hLabel, $Fontsize, 500, 0, $Font)
    GUICtrlSetColor($hLabel, $Font_Color)
    Return $hLabel
EndFunc
Func Settings()
	Local $settingsgui = _Metro_CreateGUI("Settings", 400, 200, -1, -1, True)
	$Toggle1 = _Metro_CreateToggle("Load on system startup", 100, 70, 300, 30)
	if FileExists(@UserProfileDir & "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\" & "Open.exe.lnk") Then
	_Metro_ToggleCheck($Toggle1)
	EndIf
	_Metro_CreateLabel("Settings", 10, 10, 100, 40)
	Local $Button1 = _Metro_CreateButton("Close", 150, 150, 100, 40)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Button1
				_Metro_GUIDelete($settingsgui) ;Delete GUI/release resources, make sure you use this when working with multiple GUIs!
				Return 0
			Case $Toggle1
			If _Metro_ToggleIsChecked($Toggle1) Then
				_Metro_ToggleUnCheck($Toggle1)
				unload()
			Else
				_Metro_ToggleCheck($Toggle1)
				load()
			EndIf
		EndSwitch
	WEnd

EndFunc   ;==>Settings gui
func load()
		Local $sExeName = "Open.exe" ; Tên của file exe được tạo ra
Local $sExePath = @ScriptDir & "\" & $sExeName ; Đường dẫn đến file exe được tạo ra
Local $sShortcutPath = @ScriptDir & "\" & $sExeName & ".lnk" ; Đường dẫn đến shortcut của file exe
Local $startupPath = @UserProfileDir & "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\" & $sExeName & ".lnk" ;
FileCreateShortcut($sExePath,$startupPath,@ScriptDir)
Sleep(100)
FileMove($sShortcutPath,$startupPath,1)
EndFunc
func unload()
Local $startupPath = @UserProfileDir & "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\" & "Open.exe.lnk" ;
	FileDelete($startupPath)
EndFunc

func Optimize()
	Local $optimizegui = _Metro_CreateGUI("Optimizer", 400, 200, -1, -1, True)
	_Metro_CreateLabel("Optimize", 10, 10, 100, 40)
	$Toggle1 = _Metro_CreateToggle("Auto clean ram :", 10, 70, 200, 30)
	if $value > 0 then
		_Metro_ToggleCheck($Toggle1)
		reco()
		EndIf

	Global	$Input1 = _Metro_CreateInput("", 210, 70, 30, 30)
	GUICtrlSetData(-1,$value)
GUICtrlSetFont(-1, 12, 500, Default, "Segoe UI", 5)
$label = _Metro_CreateLabel(" % (mức giới hạn)", 240, 70, 150, 30)

	Local $Button1 = _Metro_CreateButton("Close", 150, 150, 100, 40)
	GUISetState(@SW_SHOW)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Button1
				_Metro_GUIDelete($optimizegui) ;Delete GUI/release resources, make sure you use this when working with multiple GUIs!
				Return 0
			Case $Toggle1
			If _Metro_ToggleIsChecked($Toggle1) Then
				GUICtrlSetData($Input1,"0")
IniWrite("settings.ini", "ram", "value","0")
				_Metro_ToggleUnCheck($Toggle1)
			Else
				_Metro_ToggleCheck($Toggle1)
IniWrite("settings.ini", "ram", "value",GUICtrlRead($Input1))
				If $memo[0] > GUICtrlRead($Input1) Then reco()
				EndIf
		EndSwitch
	WEnd
	EndFunc
Func reco()
	$list = ProcessList()
	For $i=1 To $list[0][0]
		If StringInStr($list[$i][0], "csrss") > 0 Or StringInStr($list[$i][0], "smss") > 0 Or StringInStr($list[$i][0], "winlogon") > 0 Or StringInStr($list[$i][0], "lsass") > 0 Then ContinueLoop
		ntmem($list[$i][1])
	Next
EndFunc

Func ntmem($i_PID = -1)
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
EndFunc

Func _Metro_CreateInput($Text,$x,$y,$w,$h,$tyle=-1,$xstyle =-1,$BG_Color = $GUIThemeColor,$Font_Color = $FontThemeColor, $Font = "Arial", $Fontsize = "9")
    $hInput = GUICtrlCreateInput($Text,$x,$y,$w,$h,$tyle,$xstyle)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($hInput), "wstr", 0, "wstr", 0)
    GUICtrlSetFont($hInput, $Fontsize, 400, 0, $Font)
    GUICtrlSetColor($hInput, $Font_Color)
    GUICtrlSetBkColor($hInput,$GUIThemeColor)
    _cHvr_Register($hInput, "_iHoverOff", "_iHoverOn")
    Return $hInput
EndFunc
