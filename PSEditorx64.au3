#pragma compile(Console, False)
#pragma compile(x64, True)
#pragma compile(ExecLevel, RequireAdministrator)
#pragma compile(Compatibility, Win10)
#pragma compile(UPX, True)
#pragma compile(AutoItExecuteAllowed, False)
#pragma compile(Stripper, True)
#pragma compile(FileVersion, 1.0.1.0)
#pragma compile(ProductVersion, 1.0.1.0)
#pragma compile(ProductName, PSueer Editor)
#pragma compile(FileDescription, Silence Unlimited)
#pragma compile(LegalCopyright, Rchockxm)
#pragma compile(OriginalFilename, psueereditor.exe)
#pragma compile(Comments, Rchockxm PSueer Editor 1.0.1 (Build 151206))

#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Rchockxm PSueer Editor 1.0.1 (Build 151206)
#AutoIt3Wrapper_Res_Description=Silence Unlimited
#AutoIt3Wrapper_Res_Fileversion=1.0.1.0
#AutoIt3Wrapper_Res_LegalCopyright=Rchockxm
#AutoIt3Wrapper_Res_Language=1028
#AutoIt3Wrapper_Res_Field=OriginalFilename|PSueer Editor
#AutoIt3Wrapper_Res_Field=ProductName|PSueer Editor (x86)
#AutoIt3Wrapper_Res_Field=ProductVersion|1.0.1.0
#AutoIt3Wrapper_Res_Field=Web Site|http://rchockxm.com
#AutoIt3Wrapper_Res_Field=E-Mail|Rchockxm.silver@gmail.com
#AutoIt3Wrapper_Res_Field=Support|Windows 2K/2K3/XP/Vista/7
#AutoIt3Wrapper_Run_After=Tools\ResHacker.exe -delete %out%, %out%, Dialog, 1000,
#AutoIt3Wrapper_Run_After=Tools\ResHacker.exe -delete %out%, %out%, Menu, 166,
#AutoIt3Wrapper_Run_After=Tools\ResHacker.exe -delete %out%, %out%, Icon, 99,
#AutoIt3Wrapper_Run_After=Tools\ResHacker.exe -delete %out%, %out%, Icon, 162,
#AutoIt3Wrapper_Run_After=Tools\ResHacker.exe -delete %out%, %out%, Icon, 164,
#AutoIt3Wrapper_Run_After=Tools\ResHacker.exe -delete %out%, %out%, Icon, 169,
#Obfuscator_Parameters=/cs=1 /cn=1 /cf=1 /cv=1 /sf=1 /sv=1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         rchockxm (rchockxm.silver@gmail.com)
 Web-Site:       http://rchockxm.pp.ru

 Script Function:
	Auto Install GUI Loader Edit (x86)

#ce ----------------------------------------------------------------------------

#include <Array.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <GUIListBox.au3>
#include <ComboConstants.au3>
#include "Include\UDF\PSueerAPI.au3"

Opt('GUICloseOnESC', 0)
Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
Opt("TrayAutoPause", 0)
Opt("WinTitleMatchMode", 2)
Opt("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 2)
Opt("WinDetectHiddenText", 1)

If @OSType = "WIN32_WINDOWS" Then Exit

Dim $hMutex = DllCall("kernel32.dll", "hwnd", "OpenMutex", "int", 0x1F0001, "int", False, "str", "PSEditEX")
If $hMutex[0] Then Exit
Dim $iMutex = DllCall("kernel32.dll", "hwnd", "CreateMutex", "int", 0, "int", False, "str", "PSEditEX")
If @error Then Exit

;-------------------------------------------------
;---Global Var------------------------------------
;-------------------------------------------------

Global Const $nTitle     = "PSEditor"
Global Const $nFullTitle = "PSEditor 1.0.1 Build151206"
Global Const $nAuthor    = "Rchockxm"
Global Const $nEMail     = "rchockxm.silver@gmail.com"
Global Const $nWeb       = "http://rchockxm.com"

Global $oMyError = ObjEvent("AutoIt.Error","_MyErrFunc")

;OnAutoItExitRegister("_ExitThread")

;Dim $PSueerx[2] = [@ScriptDir & "\PSueer.exe","37BB7683"] ; x86
Dim $PSueerx[2] = [@ScriptDir & "\PSueer.exe","C4E5834F"] ; x64
Dim $7Zipexe[2] = [@TempDir & "\PSEdit\7zr.exe","2C27B9BF"] ; 9.14
Dim $7ZSSsfx[2] = [@TempDir & "\PSEdit\7zS.sfx","02455B72"] ; 9.14
Dim $ResHack[2] = [@TempDir & "\PSEdit\ResHacker.exe","06920E3A"]
Dim $PEIDexe[2] = [@TempDir & "\PSEdit\PEiD.exe","66B8EBA3"]
Dim $NirCexe[2] = [@TempDir & "\PSEdit\nircmd.exe","B9AFD933"]

; Config File Path
Global Const $KPEditXi = @ScriptDir & "\PSEditeX.ini"

Global $kPSIcons = @ScriptDir & "\Theme\PSueer.ico"
Global $kEOutput = @DesktopDir & "\PSueer_Output\Example" & @YEAR & "_" & @MON & "_" & @MDAY & ".exe"

Global $KScPath = @ScriptDir
Global $KRcPath = @ScriptDir & "\Scripts"
Global $KInPath = @ScriptDir & "\Install"

DirCreate(@TempDir & "\PSEdit")
FileInstall("Tools\PEiD.exe", @TempDir & "\PSEdit\PEiD.exe", 1)
FileInstall("Tools\7zr.exe", @TempDir & "\PSEdit\7zr.exe", 1)
FileInstall("Tools\7zS.sfx", @TempDir & "\PSEdit\7zS.sfx", 1)
FileInstall("Tools\ResHacker.exe", @TempDir & "\PSEdit\ResHacker.exe", 1)
FileInstall("Tools\nircmd.exe", @TempDir & "\PSEdit\nircmd.exe", 1)

; Form Handle
Global $jForm
Dim $jLabID[26][2], $jTitID[15]

Dim $jLabLng[19] = ["Move","Exit","File","File Extension","File Type","CMD Usage","PSueer.exe Path","R","N","D","S","Source Path","Icons Path","Output Path","[ ABOUT ]","[ Tools ]","[ RECORD ]","[ PACKAGE ]","Ok"]
Dim $jTitLng[8] = ["","","","","","","",""]
Dim $jTipLng[2] = ["Copy to Clipboard","Script has been changed"]

Dim $jMsgTLng[8] = ["Message Info","About","Choose a Installer","Choose PSueer.exe","Choose Source Path","Choose Package Icons","Choose Output Folder and Filename","Choose NirCMD Script"]
Dim $hMsgCLng[7] = ["Error occurred during write the temp file.","While the content is empty now, before you input something.","PSueer.exe not found or hash incorrect!","Error occurred during save the file.","Error occurred during delete the file.","Source file does not '.exe' or '.msi'.","Installer does not exist or no PSueer.exe core."]
Dim $rMsgSLng[3] = ["If you want to run installer in current dir, please modify the line one","with below","and put the installer in"]
Dim $sMsgMLng[9] = ["PSueer.exe does not exist, you can type the name","that you want to start after extract.","The Program","not found in follow path","Path:","Does not any file in follow path.","File:","Delete script succees!!","Save script succees!!"]

Dim $pPackLng[9] = ["Loading...","Prepare Config File","Config File Not Found","Prepare Package File","Compress to Temp File","Generate EXE File","Add Package Icon","No Custom Icon, Use Default","Done"]

; ContextMenu
Global $jTlDummy
Dim $jTool[4]
Dim $jToolLng[3] = ["Readme","Setting","NirCMD Script"]

; Child-Form Handle
Global $jChForm
Dim $jChTitID[3]
Dim $jChLabID[1][2]

; Wm-message
;Global Const $WM_DROPFILES = 0x0233
Global $hDll, $pDll, $hProc

_SetCtrlTextLang() ; Get Language

If Not FileExists($PSueerx[0]) Or _CRC32ForFile($PSueerx[0]) <> $PSueerx[1] Then $PSueerx[0] = 0
If Not FileExists($7Zipexe[0]) Or _CRC32ForFile($7Zipexe[0]) <> $7Zipexe[1] Then $7Zipexe[0] = 0
If Not FileExists($7ZSSsfx[0]) Or _CRC32ForFile($7ZSSsfx[0]) <> $7ZSSsfx[1] Then $7ZSSsfx[0] = 0
If Not FileExists($ResHack[0]) Or _CRC32ForFile($ResHack[0]) <> $ResHack[1] Then $ResHack[0] = 0
If Not FileExists($PEIDexe[0]) Or _CRC32ForFile($PEIDexe[0]) <> $PEIDexe[1] Then $PEIDexe[0] = 0
If Not FileExists($NirCexe[0]) Or _CRC32ForFile($NirCexe[0]) <> $NirCexe[1] Then $NirCexe[0] = 0

;-------------------------------------------------
;---Create My GUI Interface-----------------------
;-------------------------------------------------

$jForm = GUICreate($nTitle, 610, 470, -1, -1, Bitor($WS_POPUP, $WS_BORDER), Bitor($WS_EX_ACCEPTFILES, $WS_EX_TOOLWINDOW))
GUISetBkColor(0xFFFFFF, $jForm)

$jLabID[0][0] = GUICtrlCreateLabel($jLabLng[0], 2, 2, 50, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE), $GUI_WS_EX_PARENTDRAG)
$jLabID[0][1] = GUICtrlCreateLabel("", 2, 2, 50, 21, $SS_GRAYFRAME)
$jTitID[0] = GUICtrlCreateInput($nFullTitle, 54, 2, 502, 21, Bitor($ES_CENTER, $WS_DISABLED))
$jLabID[1][0] = GUICtrlCreateLabel($jLabLng[1], 558, 2, 50, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[1][1] = GUICtrlCreateLabel("", 558, 2, 50, 21, $SS_GRAYFRAME)
$jLabID[2][0] = GUICtrlCreateLabel($jLabLng[2], 2, 28, 45, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[2][1] = GUICtrlCreateLabel("", 2, 28, 45, 21, $SS_GRAYFRAME)
$jTitID[1] = GUICtrlCreateInput("", 49, 28, 512, 21, -1 , Bitor($WS_EX_CLIENTEDGE, $WS_EX_ACCEPTFILES))
$jLabID[3][0] = GUICtrlCreateLabel(">", 563, 28, 45, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[3][1] = GUICtrlCreateLabel("", 563, 28, 45, 21, $SS_GRAYFRAME)
$jLabID[4][0] = GUICtrlCreateLabel($jLabLng[3], 2, 50, 100, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[4][1] = GUICtrlCreateLabel("", 2, 50, 100, 21, $SS_GRAYFRAME)
$jTitID[2] = GUICtrlCreateInput("", 104, 50, 457, 21)
$jLabID[5][0] = GUICtrlCreateLabel("+", 563, 50, 45, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[5][1] = GUICtrlCreateLabel("", 563, 50, 45, 21, $SS_GRAYFRAME)
$jLabID[6][0] = GUICtrlCreateLabel($jLabLng[4], 2, 72, 100, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[6][1] = GUICtrlCreateLabel("", 2, 72, 100, 21, $SS_GRAYFRAME)
$jTitID[3] = GUICtrlCreateInput("", 104, 72, 457, 21)
$jLabID[7][0] = GUICtrlCreateLabel("+", 563, 72, 45, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[7][1] = GUICtrlCreateLabel("", 563, 72, 45, 21, $SS_GRAYFRAME)
$jLabID[8][0] = GUICtrlCreateLabel($jLabLng[5], 2, 94, 100, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[8][1] = GUICtrlCreateLabel("", 2, 94, 100, 21, $SS_GRAYFRAME)
$jTitID[4] = GUICtrlCreateInput("", 104, 94, 457, 21)
$jLabID[9][0] = GUICtrlCreateLabel("+", 563, 94, 45, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[9][1] = GUICtrlCreateLabel("", 563, 94, 45, 21, $SS_GRAYFRAME)
$jLabID[10][0] = GUICtrlCreateLabel($jLabLng[6], 2, 116, 140, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[10][1] = GUICtrlCreateLabel("", 2, 116, 140, 21, $SS_GRAYFRAME)
$jTitID[5] = GUICtrlCreateInput("", 144, 116, 417, 21)
$jLabID[11][0] = GUICtrlCreateLabel("...", 563, 116, 45, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[11][1] = GUICtrlCreateLabel("", 563, 116, 45, 21, $SS_GRAYFRAME)
$jTitID[6] = GUICtrlCreateCombo("", 2, 138, 140, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL, $WS_VSCROLL))
$jTitID[7] = GUICtrlCreateCombo("", 143, 138, 160, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL, $WS_VSCROLL))
$jTitID[8] = GUICtrlCreateCombo("", 304, 138, 128, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL, $WS_VSCROLL))
$jTitID[9] = GUICtrlCreateCombo("", 433, 138, 128, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL, $WS_VSCROLL))
$jLabID[12][0] = GUICtrlCreateLabel($jLabLng[7], 563, 138, 45, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[12][1] = GUICtrlCreateLabel("", 563, 138, 45, 21, $SS_GRAYFRAME)
$jTitID[10] = GUICtrlCreateList("", 2, 160, 140, 220, BitOR($LBS_NOTIFY,$LBS_SORT,$WS_VSCROLL))
$jTitID[11] = GUICtrlCreateEdit("", 144, 160, 418, 220)
$jLabID[13][0] = GUICtrlCreateLabel($jLabLng[8], 563, 160, 45, 73, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[13][1] = GUICtrlCreateLabel("", 563, 160, 45, 73, $SS_GRAYFRAME)
$jLabID[14][0] = GUICtrlCreateLabel($jLabLng[9], 563, 234, 45, 72, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[14][1] = GUICtrlCreateLabel("", 563, 234, 45, 72, $SS_GRAYFRAME)
$jLabID[15][0] = GUICtrlCreateLabel($jLabLng[10], 563, 307, 45, 73, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[15][1] = GUICtrlCreateLabel("", 563, 307, 45, 73, $SS_GRAYFRAME)
$jLabID[16][0] = GUICtrlCreateLabel($jLabLng[11], 2, 381, 140, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[16][1] = GUICtrlCreateLabel("", 2, 381, 140, 21, $SS_GRAYFRAME)
$jTitID[12] = GUICtrlCreateInput("", 144, 381, 417, 21)
$jLabID[17][0] = GUICtrlCreateLabel("...", 563, 381, 45, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[17][1] = GUICtrlCreateLabel("", 563, 381, 45, 21, $SS_GRAYFRAME)
$jLabID[18][0] = GUICtrlCreateLabel($jLabLng[12], 2, 402, 140, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[18][1] = GUICtrlCreateLabel("", 2, 402, 140, 21, $SS_GRAYFRAME)
$jTitID[13] = GUICtrlCreateInput("", 144, 402, 417, 21)
$jLabID[19][0] = GUICtrlCreateLabel("...", 563, 402, 45, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[19][1] = GUICtrlCreateLabel("", 563, 402, 45, 21, $SS_GRAYFRAME)
$jLabID[20][0] = GUICtrlCreateLabel($jLabLng[13], 2, 424, 140, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[20][1] = GUICtrlCreateLabel("", 2, 424, 140, 21, $SS_GRAYFRAME)
$jTitID[14] = GUICtrlCreateInput("", 144, 424, 417, 21)
$jLabID[21][0] = GUICtrlCreateLabel("...", 563, 424, 45, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[21][1] = GUICtrlCreateLabel("", 563, 424, 45, 21, $SS_GRAYFRAME)
$jLabID[22][0] = GUICtrlCreateLabel($jLabLng[14], 2, 446, 140, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[22][1] = GUICtrlCreateLabel("", 2, 446, 140, 21, $SS_GRAYFRAME)
$jLabID[23][0] = GUICtrlCreateLabel($jLabLng[15], 144, 446, 140, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[23][1] = GUICtrlCreateLabel("", 144, 446, 140, 21, $SS_GRAYFRAME)
$jLabID[24][0] = GUICtrlCreateLabel($jLabLng[16], 286, 446, 160, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[24][1] = GUICtrlCreateLabel("", 286, 446, 160, 21, $SS_GRAYFRAME)
$jLabID[25][0] = GUICtrlCreateLabel($jLabLng[17], 448, 446, 160, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jLabID[25][1] = GUICtrlCreateLabel("", 448, 446, 160, 21, $SS_GRAYFRAME)

$jTlDummy = GUICtrlCreateDummy()
$jTool[0] = GUICtrlCreateContextMenu($jTlDummy)
$jTool[1] = GUICtrlCreateMenuItem($jToolLng[0], $jTool[0])
GUICtrlCreateMenuItem("", $jTool[0])
$jTool[2] = GUICtrlCreateMenuItem($jToolLng[1], $jTool[0])
GUICtrlCreateMenuItem("", $jTool[0])
$jTool[3] = GUICtrlCreateMenuItem($jToolLng[2], $jTool[0])

; Child-Form About
$jChForm = GUICreate($jMsgTLng[1], 300, 140, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU), -1, $jForm)
GUISetBkColor(0xFFFFFF, $jChForm)

$jChTitID[0] = GUICtrlCreateLabel(@ScriptName & @CRLF & @CRLF & "The program is code by rchockxm, " & $nTitle & "!!" & @CRLF & @CRLF & "Copyright (C) Silence Unlimited" & @CRLF & @CRLF & "Credits: Yashied, Zorphnog (Michael Mims)", 5, 5, 280, 100)
$jChTitID[1] = GUICtrlCreateLabel("mailto: rchockxm.silver@gmail.com", 5, 105, 210, 15)
$jChTitID[2] = GUICtrlCreateLabel("Visit the Silence Unlimited Website", 5, 120, 210, 15)
GUICtrlSetColor($jChTitID[1], 0x0000ff)
GUICtrlSetCursor($jChTitID[1], 0)
GUICtrlSetColor($jChTitID[2], 0x0000ff)
GUICtrlSetCursor($jChTitID[2], 0)
GUICtrlSetFont($jChTitID[2], 9, 400, 4)
$jChLabID[0][0] = GUICtrlCreateLabel($jLabLng[18], 240, 110, 50, 21, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$jChLabID[0][1] = GUICtrlCreateLabel("", 240, 110, 50, 21, $SS_GRAYFRAME)
GUICtrlSetCursor($jChLabID[0][0], 0)

_SetCtrlOnEvent()
_SetMenuOnEvent()
_SetCtrlStyle()

;-------------------------------------------------
;---Change PSueer Arg Var-------------------------
;-------------------------------------------------

If IsString($PSueerx[0]) Then
	GUICtrlSetData($jTitID[5], $PSueerx[0])
Else
	GUICtrlSetState($jTitID[5], $GUI_DISABLE)
	GUICtrlSetState($jLabID[10][0], $GUI_DISABLE)
	GUICtrlSetState($jLabID[12][0], $GUI_DISABLE)
	GUICtrlSetState($jLabID[24][0], $GUI_DISABLE)
    GUICtrlSetData($jTitID[5], "PSueer.exe not found or hash incorrect!")
EndIf

If FileExists($7Zipexe[0]) And FileExists($7ZSSsfx[0]) Then
	If IsString($PSueerx[0]) Then
		GUICtrlSetData($jTitID[12], $KScPath & "," & _RegExp_GetFileName($PSueerx[0]))
	Else
    	GUICtrlSetData($jTitID[12], $KScPath)
	EndIf
    GUICtrlSetData($jTitID[14], $kEOutput)
	If  IsString($ResHack[0]) And FileExists($kPSIcons) Then
        GUICtrlSetData($jTitID[13], $kPSIcons)
    Else
        GUICtrlSetState($jTitID[13], $GUI_DISABLE)
		GUICtrlSetState($jLabID[18][0], $GUI_DISABLE)
    EndIf
Else
    GUICtrlSetState($jTitID[12], $GUI_DISABLE)
    GUICtrlSetState($jTitID[13], $GUI_DISABLE)
	GUICtrlSetState($jTitID[14], $GUI_DISABLE)
    GUICtrlSetState($jLabID[16][0], $GUI_DISABLE)
	GUICtrlSetState($jLabID[17][0], $GUI_DISABLE)
    GUICtrlSetState($jLabID[18][0], $GUI_DISABLE)
    GUICtrlSetState($jLabID[19][0], $GUI_DISABLE)
    GUICtrlSetState($jLabID[20][0], $GUI_DISABLE)
    GUICtrlSetState($jLabID[21][0], $GUI_DISABLE)
	GUICtrlSetState($jLabID[25][0], $GUI_DISABLE)
	GUICtrlSetData($jTitID[12], "7zr.exe / 7zS.sfx not found or hash incorrect!")
	GUICtrlSetData($jTitID[13], "PSueer.ico not found!")
    GUICtrlSetData($jTitID[14], "")
EndIf

_SetCtrlComboData($jTitID[6], "PSrScriptDir", 1)
_SetCtrlComboData($jTitID[7], "PSrScriptFunc", 0)
_SetCtrlComboData($jTitID[8], "PSrEnv", 0)
_SetCtrlComboData($jTitID[9], "SysEnv", 0)
_SetCtrlComboFolderF(@ScriptDir & "\Scripts")
_SetCtrlToolTips()

; Register label window proc
$hDll = DllCallbackRegister('_WinProcCallback', 'ptr', 'hwnd;uint;wparam;lparam')
$pDll = DllCallbackGetPtr($hDll)
;$wProcOld = _WinAPI_SetWindowLong(GUICtrlGetHandle($jTitID[1]), $GWL_WNDPROC, DllCallbackGetPtr($wProcNew))
$hProc = _WinAPI_SetWindowLong(GUICtrlGetHandle($jTitID[1]), $GWL_WNDPROC, $pDll)

_WinAPI_DragAcceptFiles($jTitID[1], 1)

; Show Windows Form
WinSetTrans($jForm, "", 240)
WinSetTrans($jChForm, "", 200)
GUISetState(@SW_SHOW, $jForm)

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

;-------------------------------------------------
;---Loop Function---------------------------------
;-------------------------------------------------

Func _WinProcCallback($hWnd, $iMsg, $wParam, $lParam)
    Switch $iMsg
        Case $WM_DROPFILES
            Local $FileList = _WinAPI_DragQueryFileEx($wParam)
            If IsArray($FileList) Then _AnalyzeInstallPackage($FileList[1])
			;For $i = 1 To $FileList[0];Next ;EndIf
            _WinAPI_DragFinish($wParam)
            Return 0
    EndSwitch
    Return _WinAPI_CallWindowProc($hProc, $hWnd, $iMsg, $wParam, $lParam)
EndFunc

Func _GUICallbackIdle()
    Switch @GUI_CtrlId
		Case $jLabID[0][0]
			_SetCtrlIsPress($jLabID[0][0], 0xFFFFFF, 0xC0C0C0)
		Case $jLabID[1][0]
			_SetCtrlIsPress($jLabID[1][0], 0xFFFFFF, 0xC0C0C0)
            _ExitThread()
		Case $jLabID[2][0]
            _SetCtrlIsPress($jLabID[2][0], 0xFFFFFF, 0x808000)
			Local $gExe = GUICtrlRead($jTitID[1])
			If FileExists($gExe) Then ShellExecute($gExe)
		Case $jLabID[3][0] ; Analyze Install Package
			_SetCtrlIsPress($jLabID[3][0], 0xFFFFFF, 0xC0C0C0)
            Local $iFod = FileOpenDialog($jMsgTLng[2], $KInPath, "Install (*.exe;*.msi)", 3, "", $jForm)
            If $iFod Then _AnalyzeInstallPackage($iFod)
		Case $jLabID[5][0]
			ToolTip($jTipLng[0])
			_SetCtrlIsPress($jLabID[5][0], 0xFFFFFF, 0xC0C0C0)
            Local $gClip = GUICtrlRead($jTitID[2])
			If $gClip <> "" Then ClipPut($gClip)
		Case $jLabID[7][0]
			ToolTip($jTipLng[0])
			_SetCtrlIsPress($jLabID[7][0], 0xFFFFFF, 0xC0C0C0)
            Local $gClip = GUICtrlRead($jTitID[3])
			If $gClip <> "" Then ClipPut($gClip)
		Case $jLabID[8][0]
            _SetCtrlIsPress($jLabID[8][0], 0xFFFFFF, 0x808000)
			Local $gCmd = GUICtrlRead($jTitID[4])
			If $gCmd <> "" And Not Run(@ComSpec & " /c " & $gCmd, "", @SW_HIDE) Then Return 0
		Case $jLabID[9][0]
			ToolTip($jTipLng[0])
			_SetCtrlIsPress($jLabID[9][0], 0xFFFFFF, 0xC0C0C0)
            Local $gClip = GUICtrlRead($jTitID[4])
			If $gClip <> "" Then ClipPut($gClip)
		Case $jLabID[10][0]
            _SetCtrlIsPress($jLabID[10][0], 0xFFFFFF, 0x808000)
			Local $gPsl = GUICtrlRead($jTitID[5])
			If FileExists($gPsl) Then ShellExecute($gPsl)
		Case $jLabID[11][0]
			_SetCtrlIsPress($jLabID[11][0], 0xFFFFFF, 0xC0C0C0)
            Local $iFod = FileOpenDialog($jMsgTLng[3], @ScriptDir, "PSueer EXE (*.exe)", 3, "PSueer.exe", $jForm)
			If $iFod And FileExists($iFod) And _CRC32ForFile($iFod) = $PSueerx[1] Then
				$PSueerx[0] = $iFod
			    GUICtrlSetData($jTitID[5], $iFod)
	            GUICtrlSetState($jTitID[5], $GUI_ENABLE)
	            GUICtrlSetState($jLabID[10][0], $GUI_ENABLE)
				GUICtrlSetState($jLabID[12][0], $GUI_ENABLE)
	            GUICtrlSetState($jLabID[24][0], $GUI_ENABLE)
	        Else
				$PSueerx[0] = 0
				GUICtrlSetData($jTitID[5], "PSueer.exe not found or hash incorrect!")
	            GUICtrlSetState($jTitID[5], $GUI_DISABLE)
	            GUICtrlSetState($jLabID[10][0], $GUI_DISABLE)
				GUICtrlSetState($jLabID[12][0], $GUI_DISABLE)
	            GUICtrlSetState($jLabID[24][0], $GUI_DISABLE)
			EndIf
		Case $jLabID[12][0] ; Run Script
            _SetCtrlIsPress($jLabID[12][0], 0xFFFFFF, 0x800080)
            Local $lScr = GUICtrlRead($jTitID[11])
            If FileExists($PSueerx[0]) And _CRC32ForFile($PSueerx[0]) = $PSueerx[1] Then
                If $lScr Then
                    Local $vTempF = FileOpen(@TempDir & "\test.rcini", 2)
					If $vTempF Then
                        FileWrite($vTempF, $lScr)
                        FileClose($vTempF)
						If FileExists(@TempDir & "\test.rcini") Then RunWait('"' & $PSueerx[0] & '" psreadscript "' & @TempDir & "\test.rcini" & '"')
                    Else
					    Msgbox(4096, $jMsgTLng[0], $hMsgCLng[0], Default, $jForm)
					EndIf
				Else
					Msgbox(4096, $jMsgTLng[0], $hMsgCLng[1], Default, $jForm)
				EndIf
            Else
                Msgbox(4096, $jMsgTLng[0], $hMsgCLng[2], Default, $jForm)
            EndIf
		Case $jLabID[13][0]
            _SetCtrlIsPress($jLabID[13][0], 0xFFFFFF, 0x800080)
			Local $lDir = GUICtrlRead($jTitID[6])
			Local $lFil = GUICtrlRead($jTitID[10])
			Local $lScr = GUICtrlRead($jTitID[11])
            Local $iLfs = _RegExp_GetFileNameWithoutExt(GUICtrlRead($jTitID[1]))
            Local $lFop = FileOpen(@ScriptDir & "\" & $lDir & "\" & $iLfs & @YEAR & "_" & @MON & "_" & @MDAY & ".rcini2", 2)
            If $lFop Then
                FileWrite($lFop, $lScr)
                FileClose($lFop)
				_SetCtrlComboFolderF(@ScriptDir & "\" & $lDir)
			Else
                Msgbox(4096, $jMsgTLng[0], $hMsgCLng[3], Default, $jForm)
            EndIf
			GUICtrlSetData($jTitID[11], "")
			GUICtrlSetData($jTitID[11], "; Script Start - Add your code below here")
		Case $jLabID[14][0]
            _SetCtrlIsPress($jLabID[14][0], 0xFFFFFF, 0x800080)
			Local $lDir = GUICtrlRead($jTitID[6])
			Local $lFil = GUICtrlRead($jTitID[10])
            If $lFil And FileExists(@ScriptDir & "\" & $lDir & "\" & $lFil) Then
				If FileDelete(@ScriptDir & "\" & $lDir & "\" & $lFil) Then Msgbox(4096, $jMsgTLng[0], $sMsgMLng[6] & " " & @ScriptDir & "\" & $lDir & "\" & $lFil & @CRLF & @CRLF & $sMsgMLng[7], Default, $jForm)
                _SetCtrlComboFolderF(@ScriptDir & "\" & $lDir)
            Else
                Msgbox(4096, $jMsgTLng[0], $hMsgCLng[4], Default, $jForm)
            EndIf
		Case $jLabID[15][0]
            _SetCtrlIsPress($jLabID[15][0], 0xFFFFFF, 0x800080)
			Local $lDir = GUICtrlRead($jTitID[6])
			Local $lFil = GUICtrlRead($jTitID[10])
			Local $lScr = GUICtrlRead($jTitID[11])
			Local $iLfs = _RegExp_GetFileNameWithoutExt(GUICtrlRead($jTitID[1]))
			If $lFil = "" Then $lFil = $iLfs & @YEAR & "_" & @MON & "_" & @MDAY & ".rcini2"
			Local $lFop = FileOpen(@ScriptDir & "\" & $lDir & "\" & $lFil, 2)
            If $lFop Then
                FileWrite($lFop, $lScr)
                FileClose($lFop)
				_SetCtrlComboFolderF(@ScriptDir & "\" & $lDir)
				If FileExists(@ScriptDir & "\" & $lDir & "\" & $lFil) Then Msgbox(4096, $jMsgTLng[0], $sMsgMLng[6] & " " & @ScriptDir & "\" & $lDir & "\" & $lFil & @CRLF & @CRLF & $sMsgMLng[8], Default, $jForm)
			Else
                Msgbox(4096, $jMsgTLng[0], $hMsgCLng[3], Default, $jForm)
            EndIf
		Case $jLabID[16][0]
            _SetCtrlIsPress($jLabID[16][0], 0xFFFFFF, 0x808000)
			Local $gDir = StringSplit(GUICtrlRead($jTitID[12]), ",")
            If FileExists($gDir[1]) And FileGetAttrib($gDir[1]) = "D"  Then ShellExecute($gDir[1])
		Case $jLabID[17][0]
            _SetCtrlIsPress($jLabID[17][0], 0xFFFFFF, 0xC0C0C0)
            Local $iFsf = FileSelectFolder($jMsgTLng[4], @ScriptDir, 7, @ScriptDir, $jForm)
			If $iFsf Then
				If IsString($PSueerx[0]) Then
			        GUICtrlSetData($jTitID[12], $iFsf & "," & _RegExp_GetFileName($PSueerx[0]))
				Else
					GUICtrlSetData($jTitID[12], $iFsf)
				EndIf
			EndIf
		Case $jLabID[18][0]
            _SetCtrlIsPress($jLabID[18][0], 0xFFFFFF, 0x808000)
			Local $gDir = _RegExp_GetPathDir(GUICtrlRead($jTitID[13]))
			If FileExists($gDir) And FileGetAttrib($gDir) = "D" Then ShellExecute($gDir)
		Case $jLabID[19][0]
            _SetCtrlIsPress($jLabID[19][0], 0xFFFFFF, 0xC0C0C0)
            Local $iFod = FileOpenDialog($jMsgTLng[5], @ScriptDir & "\Theme", "Icons (*.ico)", 3, "PSueer.ico", $jForm)
			If $iFod And FileExists($iFod) Then
				$kPSIcons = $iFod
				GUICtrlSetState($jTitID[13], $GUI_ENABLE)
				GUICtrlSetState($jLabID[18][0], $GUI_ENABLE)
			    GUICtrlSetData($jTitID[13], $iFod)
			Else
				$kPSIcons = 0
				GUICtrlSetState($jTitID[13], $GUI_DISABLE)
				GUICtrlSetState($jLabID[18][0], $GUI_DISABLE)
			    GUICtrlSetData($jTitID[13], "")
			EndIf
        Case $jLabID[20][0]
            _SetCtrlIsPress($jLabID[20][0], 0xFFFFFF, 0x808000)
			Local $gDir = _RegExp_GetPathDir(GUICtrlRead($jTitID[14]))
			If FileExists($gDir) And FileGetAttrib($gDir) = "D" Then ShellExecute($gDir)
		Case $jLabID[21][0]
            _SetCtrlIsPress($jLabID[21][0], 0xFFFFFF, 0xC0C0C0)
            Local $iFsd = FileSaveDialog($jMsgTLng[6], @DesktopDir, "7-Zip Self-Extract Archive (*.exe)", 16, "Example" & @YEAR & "_" & @MON & "_" & @MDAY & ".exe", $jForm)
		    If $iFsd Then GUICtrlSetData($jTitID[14], $iFsd)
		Case $jLabID[22][0]
            _SetCtrlIsPress($jLabID[22][0], 0xFFFFFF, 0xC0C0C0)
			Local $tP = _SetChildWinPos(150, 180)
            If IsArray($tP) Then WinMove('[TITLE:' & $jMsgTLng[1] & ';CLASS:AutoIt v3 GUI]', "", $tP[0], $tP[1])
			GUISetState(@SW_SHOW, $jChForm)
		Case $jLabID[23][0]
            _SetCtrlIsPress($jLabID[23][0], 0xFFFFFF, 0xC0C0C0)
			ShowMenu($jForm, $jLabID[23][0], $jTool[0])
		Case $jLabID[24][0] ; Record Install Script
            _SetCtrlIsPress($jLabID[24][0], 0xFFFFFF, 0xFF0000)
			Local $gFile = GUICtrlRead($jTitID[1])
			Local $gFsot = _RegExp_GetFileName($gFile)
			;Local $gPsli = GUICtrlRead($jTitID[5])
            If FileExists($gFile) And FileExists($PSueerx[0]) And _CRC32ForFile($PSueerx[0]) = $PSueerx[1] And Not ProcessExists(_RegExp_GetFileName($PSueerx[0])) Then
			    Local $cRn = StringRight($gFile, 3)
				If $cRn = "exe" Or $cRn = "msi" Then
				    RunWait('"' & $PSueerx[0] & '" psautorecord "' & $gFile & '"')
				    Local $lDir = GUICtrlRead($jTitID[6])
				    If $lDir Then
                        _SetCtrlComboFolderF(@ScriptDir & "\" & $lDir)
				    Else
                        _SetCtrlComboFolderF(@ScriptDir & "\Scripts")
                    EndIf
				    Msgbox(4096, $jMsgTLng[0], $rMsgSLng[0] & @CRLF & @CRLF & 'run="' & $gFile & '"' & @CRLF & @CRLF & $rMsgSLng[1] & @CRLF & @CRLF & 'run="Dir name\' & $gFsot & '"' & @CRLF & @CRLF & $rMsgSLng[2] & ' "Dir name\' & $gFsot & '"', Default, $jForm)
                Else
                    Msgbox(4096, $jMsgTLng[0], $hMsgCLng[5], Default, $jForm)
				EndIf
			Else
                Msgbox(4096, $jMsgTLng[0], $hMsgCLng[6], Default, $jForm)
            EndIf
		Case $jLabID[25][0] ; Package File
            _SetCtrlIsPress($jLabID[25][0], 0xFFFFFF, 0xFF0000)
			Local $qSour[6] = [$KScPath,"","","yes","",""] ; Sources, ExeName, Args, Progress, Message, Title
            Local $qStmp = StringSplit(GUICtrlRead($jTitID[12]), ",")
            If $qStmp[0] >= 1 And $qStmp[1] <> "" Then $qSour[0] = $qStmp[1] ; Source Path
			If $qStmp[0] >= 2 And $qStmp[2] <> "" Then $qSour[1] = $qStmp[2] ; ExeName
			If $qStmp[0] >= 3 And $qStmp[3] <> "" Then $qSour[2] = $qStmp[3] ; Args
			If $qStmp[0] >= 4 And $qStmp[4] <> "" Then $qSour[3] = $qStmp[4] ; Progress
            If $qStmp[0] >= 5 And $qStmp[5] <> "" Then $qSour[4] = $qStmp[5] ; Message
			If $qStmp[0] = 6 And $qStmp[6] <> "" Then $qSour[5] = $qStmp[6]  ; Title
            If $qSour[3] <> "yes" And $qSour[3] <> "no" Then $qSour[3] = "yes"
			; Check If PSueer.exe not exist then use user define process name
			If $qSour[1] = "" And (Not FileExists(GUICtrlRead($jTitID[5])) Or _CRC32ForFile(GUICtrlRead($jTitID[12])) <> $PSueerx[1]) Then
                Msgbox(4096, $jMsgTLng[0], $sMsgMLng[0] & @CRLF & $sMsgMLng[1], Default, $jForm)
				Return 0
            EndIf
            ; Check if user define process name not in sources.exe
			If Not FileExists($qStmp[1] & "\" & $qStmp[2]) Then
                Msgbox(4096, $jMsgTLng[0], $sMsgMLng[2] & ' "' & $qStmp[2] & '" ' & $sMsgMLng[3] & @CRLF & @CRLF & $sMsgMLng[4] & " " & $qStmp[1], Default, $jForm)
				Return 0
			EndIf
			If Not FileExists($qStmp[1] & "\*.*") Then
                Msgbox(4096, $jMsgTLng[0], $sMsgMLng[5] & @CRLF & @CRLF & $sMsgMLng[4] & " " & $qStmp[1], Default, $jForm)
				Return 0
			EndIf
            ; Set path global
			Local $gIco = GUICtrlRead($jTitID[13]) ; Icons Path
			Local $gOut = GUICtrlRead($jTitID[14]) ; Output Path
			If $gIco = "" Then $gIco = $kPSIcons
			If $gOut = "" Then $gOut = $kEOutput
			If Not FileExists($7Zipexe[0]) Or _CRC32ForFile($7Zipexe[0]) <> $7Zipexe[1] Then Return 0
            If Not FileExists($7ZSSsfx[0]) Or _CRC32ForFile($7ZSSsfx[0]) <> $7ZSSsfx[1] Then Return 0
			GUISetState(@SW_DISABLE, $jForm)
            ; Get Main Form X,Y Pos
            Local $chX = -1, $chY = -1
			Local $tP = _SetChildWinPos(160, 208)
            If IsArray($tP) Then
				$chX = $tP[0]
				$chY = $tP[1]
			EndIf
            ; Create Progress GUI
			Local $chForm = GUICreate($nTitle & "_Progress", 290, 55, $chX, $chY, Bitor($WS_POPUP, $WS_BORDER), $WS_EX_TOOLWINDOW, $jForm)
            GUISetBkColor(0xFFFFFF, $chForm)
            Local $chLab[3]
            $chLab[0] = GUICtrlCreateLabel("", 5, 24, 280, 25, $SS_BLACKFRAME)
            $chLab[1] = GUICtrlCreateLabel("", 5, 24, 10, 25)
            $chLab[2] = GUICtrlCreateLabel($pPackLng[0], 8, 5, 200, 17)
            GUICtrlSetBkColor($chLab[1], 0x800080)
            GUICtrlSetFont($chLab[1], 9, 800, 0, "Verdana")
            GUICtrlSetColor($chLab[2], 0x3399FF)
			WinSetTrans($chForm, "", 200)
            GUISetState(@SW_SHOW, $chForm)
			; Prepare Config File
			GUICtrlSetData($chLab[2], $pPackLng[1])
            GUICtrlSetPos($chLab[1], 5, 24, 25, 25)
            Local $tsscon = @TempDir & "\PSEdit\Rc_Config.txt"
            Local $iCFx = FileOpen($tsscon, 2)
			If $iCFx Then
                FileWrite($iCFx, ';!@Install@!UTF-8!' & @CRLF)
                FileWrite($iCFx, 'ExecuteFile=' & '"' & $qStmp[2] & '"'  & @CRLF)
				If $qStmp[0] >= 3 And $qStmp[3] <> "" Then FileWrite($iCFx, 'ExecuteParameters=' & '"' & $qStmp[3] & '"'  & @CRLF)
                If $qStmp[0] >= 4 And $qStmp[4] = "no" Then FileWrite($iCFx, 'Progress="no"'  & @CRLF)
				If $qStmp[0] >= 5 And $qStmp[5] <> "" Then FileWrite($iCFx, 'BeginPrompt=' & '"' & $qStmp[5] & '"'  & @CRLF)
				If $qStmp[0] = 6 And $qStmp[6] <> "" Then
				    FileWrite($iCFx, 'Title=' & '"' & $qStmp[6] & '"'  & @CRLF)
				Else
					FileWrite($iCFx, 'Title=' & '"' & $nFullTitle & '"' & @CRLF)
				EndIf
				FileWrite($iCFx, ';!@InstallEnd@!' & @CRLF)
                FileClose($iCFx)
				If @error Then Return 0
			Else
				GUICtrlSetData($chLab[2], $pPackLng[2])
                Return 0
            EndIf
			Sleep(1000)
			; Prepare Package File
			GUICtrlSetData($chLab[2], $pPackLng[3])
            GUICtrlSetPos($chLab[1], 5, 24, 65, 25)
            If Not DirCreate(_RegExp_GetPathDir($gOut)) Then Return 0
            Local $aTempf = @TempDir & "\PSEdit\RchockxmTemp.7z"
            Local $iInclude = '"' & $qSour[0] & "\*.*" & '" -r'
			; Change Path if source path include psueer.exe path
			;If StringInstr(GUICtrlRead($jTitID[5]), $qSour[0], 0) Then $iInclude = '"' & @ScriptDir & "\*.*" & '" "' & @ScriptDir & "\Install\" & '" "' & @ScriptDir & "\Scripts\" & '" "' & @ScriptDir & "\Theme\" & '"'
            If _RegExp_GetPathDir(GUICtrlRead($jTitID[5])) = $qSour[0] Then $iInclude = '"' & $qSour[0] & "\*.*" & '" "' & $qSour[0] & "\Install\" & '" "' & $qSour[0] & "\Scripts\" & '" "' & $qSour[0] & "\Theme\" & '"'
			If FileExists($7Zipexe[0]) And FileExists($7ZSSsfx[0]) And FileExists($tsscon) Then
			    GUICtrlSetData($chLab[2], $pPackLng[4])
                GUICtrlSetPos($chLab[1], 5, 24, 100, 25)
                If FileExists($aTempf) Then FileDelete($aTempf)
				RunWait($7Zipexe[0] & ' a -t7z ' & '"' & $aTempf & '" ' & $iInclude & ' -m0=LZMA2', "", @SW_HIDE)
                Sleep(1000)
                ; Combine File with SFX
			    GUICtrlSetData($chLab[2], $pPackLng[5])
                GUICtrlSetPos($chLab[1], 5, 24, 200, 25)
				If FileExists($aTempf) Then
                    RunWait(@ComSpec & ' /c ' & 'copy /b ' & '"' & $7ZSSsfx[0] & '"' & ' + ' & '"' & $tsscon & '"' & ' + '& '"' & $aTempf & '"' & ' ' & '"' & $gOut, "", @SW_HIDE)
                    Sleep(1000)
                    ; Add Icons Resources
			        GUICtrlSetData($chLab[2], $pPackLng[6])
                    GUICtrlSetPos($chLab[1], 5, 24, 250, 25)
					If FileExists($gIco) And FileExists($ResHack[0]) And _CRC32ForFile($ResHack[0]) = $ResHack[1] Then
					    Local $nOf = _RegExp_GetPathDir($gOut) & "\" & _RegExp_GetFileNameWithoutExt($gOut) & "_New.exe"
					    RunWait($ResHack[0] & ' -addoverwrite ' & '"' & $gOut & '","' & $nOf & '","' & $gIco & '","Icon","1",', "", @SW_HIDE)
					    Sleep(1000)
					    If FileExists($nOf) Then FileDelete($gOut)
					EndIf
				Else
					GUICtrlSetData($chLab[2], $pPackLng[7])
                    Return 0
                EndIf
            Else
                Return 0
            EndIf
			FileDelete($aTempf)
			FileDelete($tsscon)
            ; Close Progress
			GUICtrlSetData($chLab[2], $pPackLng[8])
			GUICtrlSetPos($chLab[1], 5, 24, 280, 25)
            ; Delete Progress GUI
            GUIDelete($chForm)
            GUISetState(@SW_ENABLE, $jForm)
	EndSwitch
EndFunc

Func _AboutCallbackIdle()
    Switch @GUI_CtrlId
		Case $jChTitID[1]
            ShellExecute("mailto:rchockxm.silver@gmail.com")
		Case $jChTitID[2]
			ShellExecute("http://rchockxm.pp.ru")
        Case $jChLabID[0][0]
			_SetCtrlIsPress($jChLabID[0][0], 0xFFFFFF, 0xC0C0C0)
			GUISetState(@SW_HIDE, $jChForm)
	EndSwitch
EndFunc

Func _MenuCallbackIdle()
    Switch @GUI_CtrlId
		Case $jTool[1]
            If FileExists(@ScriptDir & "\Readme\Readme.html") Then ShellExecute(@ScriptDir & "\Readme\Readme.html")
		Case $jTool[2]
            If FileExists(@ScriptDir & "\PSEditeX.ini") Then ShellExecute(@ScriptDir & "\PSEditeX.ini")
		Case $jTool[3]
			Local $iFod = FileOpenDialog($jMsgTLng[7], @ScriptDir & "\NirScript", "NirCMD Script (*.ncl)", 3, "", $jForm)
			If $iFod And FileExists($iFod) And FileExists($NirCexe[0]) And _CRC32ForFile($NirCexe[0]) = $NirCexe[1] Then
				If Run($NirCexe[0] & " script " & '"' & $iFod & '"', "", @SW_HIDE) = 0 Then Return 0
			Else
				Return 0
			EndIf
	EndSwitch
EndFunc

AdlibRegister("MyAdlib", 600)

Func MyAdlib()
	ToolTip("")
EndFunc

While 1
	_SetGUIFadout()
	Sleep(150)
	If _WinAPI_EmptyWorkingSet(@AutoItPID) Then ContinueLoop
WEnd

Func _ExitThread()
    _WinAPI_SetWindowLong(GUICtrlGetHandle($jTitID[1]), $GWL_WNDPROC, $hProc)
    ;DllCallbackFree($hDll)
	FileDelete(@TempDir & "\test.rcini")
	FileDelete($7Zipexe)
	FileDelete($7ZSSsfx)
	FileDelete($ResHack)
    FileDelete($PEIDexe)
	DirRemove(@TempDir & "\PSEdit", 1)
    Exit
EndFunc

;-------------------------------------------------
;---Main Function---------------------------------
;-------------------------------------------------

Func _SetCtrlOnEvent()
	For $i = 0 To UBound($jLabID, 1) -1
        If $i <> 4 Or $i <> 6 Then GUICtrlSetOnEvent($jLabID[$i][0], "_GUICallbackIdle")
	Next
	GUICtrlSetOnEvent($jChTitID[1], "_AboutCallbackIdle")
	GUICtrlSetOnEvent($jChTitID[2], "_AboutCallbackIdle")
	GUICtrlSetOnEvent($jChLabID[0][0], "_AboutCallbackIdle")
Endfunc

Func _SetMenuOnEvent()
	For $i = 1 To UBound($jTool, 1) -1
	    GUICtrlSetOnEvent($jTool[$i], "_MenuCallbackIdle")
	Next
Endfunc

Func _SetCtrlStyle()
	;GUICtrlSetBkColor($jLabID[0][0], 0xC0C0C0)
    ;GUICtrlSetBkColor($jLabID[1][0], 0xC0C0C0)
	For $i = 0 To UBound($jLabID, 1) -1
        GUICtrlSetBkColor($jLabID[$i][0], "0xFFFFFF")
    Next
	GUICtrlSetColor($jLabID[2][0], 0x800000)
    GUICtrlSetColor($jLabID[10][0], 0x800000)
	GUICtrlSetColor($jLabID[12][0], 0xFF0000)
    GUICtrlSetColor($jLabID[16][0], 0x800000)
    GUICtrlSetColor($jLabID[24][0],0x008000)
    GUICtrlSetColor($jLabID[25][0],0x008000)

    GUICtrlSetBkColor($jTitID[1], 0xFFFFE1)
    GUICtrlSetBkColor($jTitID[2], 0xFFFFE1)
    GUICtrlSetBkColor($jTitID[3], 0xFFFFE1)
    GUICtrlSetBkColor($jTitID[4], 0xFFFFE1)
    GUICtrlSetBkColor($jTitID[5], 0xB9D1EA)
    GUICtrlSetBkColor($jTitID[10], 0xC0DCC0)
    GUICtrlSetBkColor($jTitID[11], 0xD4D0C8)
    GUICtrlSetBkColor($jTitID[12], 0xF4F7FC)
    GUICtrlSetBkColor($jTitID[13], 0xF4F7FC)
    GUICtrlSetBkColor($jTitID[14], 0xF4F7FC)

    GUICtrlSetFont($jTitID[0], 12, 800, 0, "Verdana")
	For $i = 2 To UBound($jLabID, 1) -1
        GUICtrlSetFont($jLabID[$i][0], 9, 800, 0, "Verdana")
    Next
	For $i = 0 To UBound($jLabID, 1) -1
        If $i = 4 Or $i = 6 Then ContinueLoop
		GUICtrlSetCursor($jLabID[$i][0], 0)
    Next
Endfunc

Func _SetCtrlIsPress($iID, $iPr, $iAf)
    GUICtrlSetBkColor($iID, $iAf)
	Sleep(50)
	GUICtrlSetBkColor($iID, $iPr)
Endfunc

Func _SetGUIFadout()
    If WinActive('[TITLE:' & $nTitle  & ';CLASS:AutoIt v3 GUI]') Then
        WinSetTrans($jForm, "", 240)
	Else
        WinSetTrans($jForm, "", 200)
    EndIf
Endfunc

Func _SetCtrlPEIDState($ist = $GUI_ENABLE)
	GUICtrlSetState($jTitID[1], $ist)
	GUICtrlSetState($jTitID[2], $ist)
	GUICtrlSetState($jTitID[3], $ist)
	GUICtrlSetState($jTitID[4], $ist)
	GUICtrlSetState($jLabID[4][0], $ist)
	GUICtrlSetState($jLabID[5][0], $ist)
	GUICtrlSetState($jLabID[6][0], $ist)
	GUICtrlSetState($jLabID[7][0], $ist)
	GUICtrlSetState($jLabID[8][0], $ist)
	GUICtrlSetState($jLabID[9][0], $ist)
Endfunc

Func _SetCtrlComboFolderF($iIdir)
	GUICtrlSetData($jTitID[10], "")
    Local $hRcList = _FileListToArray_mod($iIdir, "*.rcini2")
    If IsArray($hRcList) Then
	    For $i = 1 To $hRcList[0]
            GUICtrlSetData($jTitID[10], $hRcList[$i])
		Next
    EndIf
Endfunc

Func _SetCtrlComboData($iID, $iSe, $if = 0)
    If FileExists($KPEditXi) Then
		GUICtrlSetColor($iID, 0x0000FF)
        Local $itini = IniReadSection($KPEditXi, $iSe)
        If IsArray($itini) Then
		    Local $itts = ""
            For $i = 1 To $itini[0][0]
                If $itini[$i][1] <> "" Then $itts = $itts & $itini[$i][1] & "|"
            Next
		    If $if = 0 Then GUICtrlSetData($iID, $itts)
			If $if = 1 Then GUICtrlSetData($iID, $itts, $itini[1][1])
		EndIf
    EndIf
Endfunc

Func _SetCtrlToolTips()
	; Input ToolTips
    GUICtrlSetTip($jTitID[1], $jTitLng[0], $jLabLng[2], 1, 1)
    GUICtrlSetTip($jTitID[2], $jTitLng[1], $jLabLng[3], 1, 1)
    GUICtrlSetTip($jTitID[3], $jTitLng[2], $jLabLng[4], 1, 1)
    GUICtrlSetTip($jTitID[4], $jTitLng[3], $jLabLng[5], 1, 1)
	GUICtrlSetTip($jTitID[5], $jTitLng[4], $jLabLng[6], 1, 1)
	GUICtrlSetTip($jTitID[12], $jTitLng[5], $jLabLng[11], 1, 1)
	GUICtrlSetTip($jTitID[13], $jTitLng[6], $jLabLng[12], 1, 1)
	GUICtrlSetTip($jTitID[14], $jTitLng[7], $jLabLng[13], 1, 1)
Endfunc

Func _SetCtrlTextLang()
    Select
	    Case StringInStr("0409 0809 0c09 1009 1409 1809 1c09 2009 2409 2809 2c09 3009 3409", @OSLang) ; English by Default
        Case Else
			; Button
		    For $i = 0 To UBound($jLabLng, 1) -1
                $jLabLng[$i] = IniRead($KPEditXi, "PSrLang", "btn" & $i, $jLabLng[$i])
            Next
			; Input Tooltips
		    For $i = 0 To UBound($jTitLng, 1) -1
                $jTitLng[$i] = IniRead($KPEditXi, "PSrLang", "input" & $i, $jTitLng[$i])
            Next
			; Misc ToolTips
		    For $i = 0 To UBound($jTipLng, 1) -1
                $jTipLng[$i] = IniRead($KPEditXi, "PSrLang", "tips" & $i, $jTipLng[$i])
            Next
			; Msgbox Dialog Title
		    For $i = 0 To UBound($jMsgTLng, 1) -1
                $jMsgTLng[$i] = IniRead($KPEditXi, "PSrLang", "imsg" & $i, $jMsgTLng[$i])
            Next
			; Msgbox Dialog One String
		    For $i = 0 To UBound($hMsgCLng, 1) -1
                $hMsgCLng[$i] = IniRead($KPEditXi, "PSrLang", "hmsg" & $i, $hMsgCLng[$i])
            Next
			; Msgbox Dialog Muilt String
		    For $i = 0 To UBound($rMsgSLng, 1) -1
                $rMsgSLng[$i] = IniRead($KPEditXi, "PSrLang", "rmsg" & $i, $rMsgSLng[$i])
            Next
		    For $i = 0 To UBound($sMsgMLng, 1) -1
                $sMsgMLng[$i] = IniRead($KPEditXi, "PSrLang", "smsg" & $i, $sMsgMLng[$i])
            Next
			; Package Progress
		    For $i = 0 To UBound($pPackLng, 1) -1
                $pPackLng[$i] = IniRead($KPEditXi, "PSrLang", "pmic" & $i, $pPackLng[$i])
            Next
			; ContextMenu
		    For $i = 0 To UBound($jToolLng, 1) -1
                $jToolLng[$i] = IniRead($KPEditXi, "PSrLang", "cmenu" & $i, $jToolLng[$i])
            Next
	EndSelect
Endfunc

;-------------------------------------------------
;---WM Message Function---------------------------
;-------------------------------------------------

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg
    Local $hWndFrom, $iIDFrom, $iCode
    $hWndFrom = $ilParam
    $iIDFrom = BitAND($iwParam, 0xFFFF) ; Low Word
    $iCode = BitShift($iwParam, 16) ; Hi Word
    Switch $hWndFrom
		; Combo Control
		Case GUICtrlGetHandle($jTitID[6])
            Switch $iCode
				Case $CBN_SELENDCANCEL, $CBN_SELCHANGE
                    If GUICtrlRead($jTitID[6]) <> "" Then _SetCtrlComboFolderF(@ScriptDir & "\" & GUICtrlRead($jTitID[6]))
		    EndSwitch
        Case GUICtrlGetHandle($jTitID[7])
            Switch $iCode
				Case $CBN_SELENDCANCEL, $CBN_SELCHANGE
					ToolTip($jTipLng[0])
                    ClipPut(GUICtrlRead($jTitID[7]))
		    EndSwitch
        Case GUICtrlGetHandle($jTitID[8])
            Switch $iCode
				Case $CBN_SELENDCANCEL, $CBN_SELCHANGE
					ToolTip($jTipLng[0])
                    ClipPut(GUICtrlRead($jTitID[8]))
		    EndSwitch
        Case GUICtrlGetHandle($jTitID[9])
            Switch $iCode
				Case $CBN_SELENDCANCEL, $CBN_SELCHANGE
					ToolTip($jTipLng[0])
                    ClipPut(GUICtrlRead($jTitID[9]))
			EndSwitch
		; Listbox Control
	    Case GUICtrlGetHandle($jTitID[10])
            Switch $iCode
				Case $LBN_DBLCLK
					Local $lDir = GUICtrlRead($jTitID[6])
					Local $lFil = GUICtrlRead($jTitID[10])
                    If FileExists(@ScriptDir & "\" & $lDir & "\" & $lFil) Then ShellExecute(@ScriptDir & "\" & $lDir & "\" & $lFil)
                Case $LBN_SELCHANGE
					Local $lDir = GUICtrlRead($jTitID[6])
					Local $lFil = GUICtrlRead($jTitID[10])
					If $lDir = "" Then $lDir = "Scripts"
					If $lFil = "" Then Return 0
                    Local $hfile = FileOpen(@ScriptDir & "\" & $lDir & "\" & $lFil, 0)
					Local $hTemp = ""
                    If Not $hfile Then Return
					While 1
						Local $line = FileReadLine($hfile)
						If @error = -1 Then ExitLoop
						$hTemp = $hTemp & $line & @CRLF
					Wend
					GUICtrlSetData($jTitID[11], $hTemp)
					FileClose($hfile)
			EndSwitch
		; Edit Control
	    Case GUICtrlGetHandle($jTitID[11])
            Switch $iCode
				Case $EN_CHANGE
					ToolTip(GUICtrlRead($jTitID[11]), Default, Default, $jTipLng[1])
			EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc

;-------------------------------------------------
;---Analyze Function------------------------------
;-------------------------------------------------

Func _AnalyzeInstallPackage($vFile)
	If FileExists($vFile) Then
		; Check Ext Name

		; Start PEID Analyze
		GUICtrlSetData($jTitID[1], $vFile)
		GUICtrlSetData($jTitID[2], "Loading...")
		GUICtrlSetData($jTitID[3], "Loading...")
		GUICtrlSetData($jTitID[4], "Loading...")
		If FileExists($PEIDexe[0]) And _CRC32ForFile($PSueerx[0]) = $PSueerx[1] Then
			Local $dSnam = '"' & _RegExp_GetFileName($vFile) & '"'
			Local $dSlop = RegRead("HKCU\Software\PEiD", "StayOnTop")
			Local $pTxt1 = "" ; by EntryPoint
			Local $pTxt2 = "" ; by Scan Result
			RegWrite("HKCU\Software\PEiD", "StayOnTop", "REG_DWORD", 0)
			; PEID Analyze
			Run($PEIDexe[0] & ' "' & $vFile & '"', "", @SW_HIDE)
			WinWait("[TITLE:PEiD v0.95; CLASS:#32770]")
			While $pTxt2 = "" Or $pTxt2 = "Scanning..."
				$pTxt1 = ControlGetText("[TITLE:PEiD v0.95; CLASS:#32770]", "", "[CLASS:Edit; INSTANCE:3]")
				$pTxt2 = ControlGetText("[TITLE:PEiD v0.95; CLASS:#32770]", "", "[CLASS:Edit; INSTANCE:2]")
				Sleep(10)
			Wend
			WinClose("[TITLE:PEiD v0.95; CLASS:#32770]", "")
			GUICtrlSetData($jTitID[3], "Unknown")
			GUICtrlSetData($jTitID[4], "")
			; Restore Reg
			If $dSlop Then RegWrite("HKCU\Software\PEiD", "StayOnTop", "REG_DWORD", $dSlop)
			; Check File Type
			Select ; Use FileInfo
				Case StringInstr($pTxt2, "Nullsoft PiMP SFX", 0) ; NSIS
					GUICtrlSetData($jTitID[3], "NSIS (Nullsoft Scriptable Install System)")
					GUICtrlSetData($jTitID[4], $dSnam & " /S")
				Case StringInstr($pTxt2, "CAB SFX", 0) ; CAB SFX
					GUICtrlSetData($jTitID[3], "Microsoft CAB SFX")

				Case StringInstr($pTxt2, "RAR SFX", 0) ; WinRAR
					GUICtrlSetData($jTitID[3], "WinRAR Self-Extract Archive")
					GUICtrlSetData($jTitID[4], $dSnam & " /S")
				Case StringInstr($pTxt2, "UPX", 0) ; UPX

				Case Else
					Switch $pTxt1 ; Use EntryPoint
						Case "" ; NSIS

						Case "0000991C", "000098D8", "00009A54", "00009A58", "00009B24", "000163C4" ; Inno Setup(5.1.1,5.19,5.22,5.23,5.36,5.37,5.38,5.39)
							GUICtrlSetData($jTitID[3], "Inno Setup 5.x")
							GUICtrlSetData($jTitID[4], $dSnam & " /SILENT /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-")
						Case "0001D0CC", "0001D092" , "0001D142" ; 7-Zip(9.10,9.13,9.14);
							GUICtrlSetData($jTitID[3], "7-Zip Self-Extract Archive")
							;GUICtrlSetData($jTitID[4], "")
						Case "00006AF8"	; Microsoft CAB Archive
							GUICtrlSetData($jTitID[3], "MS IExpress x.x - CAB Installer")

						Case Else
							GUICtrlSetData($jTitID[3], "Unknown")
							;GUICtrlSetData($jTitID[4], "")
					EndSwitch
			EndSelect
		Else
			GUICtrlSetData($jTitID[3], "Unknown")
			GUICtrlSetData($jTitID[4], "")
		EndIf
		GUICtrlSetData($jTitID[2], "." & _RegExp_GetFileNameExt($vFile))
		_SetCtrlPEIDState($GUI_ENABLE)
	Else
		_SetCtrlPEIDState($GUI_DISABLE)
		GUICtrlSetData($jTitID[1], "Sorry, file not found!")
		GUICtrlSetData($jTitID[2], "")
		GUICtrlSetData($jTitID[3], "")
		GUICtrlSetData($jTitID[4], "")
	EndIf
EndFunc

;-------------------------------------------------
;---Other Function--------------------------------
;-------------------------------------------------

Func _MyErrFunc()
    Msgbox(0, $nTitle & "Test", "We intercepted a COM Error !"      & @CRLF & @CRLF & _
        "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
        "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
        "err.number is: "         & @TAB & hex($oMyError.number,8)  & @CRLF & _
        "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
        "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
        "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
        "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
        "err.helpcontext is: "    & @TAB & $oMyError.helpcontext, Default, $jForm)
Endfunc

; Get Main Form And Set Child-Form To Center
Func _SetChildWinPos($xM, $yM)
	Local $mFp = WinGetPos('[TITLE:' & $nTitle  & ';CLASS:AutoIt v3 GUI]')
	Local $chP[2] = [-1,-1] ; X,Y
	If IsArray($mFp) Then
		$chP[0] = $mFp[0] + $xM ;160
		$chP[1] = $mFp[1] + $yM ;208
	EndIf
	Return $chP
EndFunc

; Show a menu in a given GUI window which belongs to a given GUI ctrl
Func ShowMenu($hWnd, $CtrlID, $nContextID)
	Local $arPos, $x, $y
	Local $hMenu = GUICtrlGetHandle($nContextID)
	$arPos = ControlGetPos($hWnd, "", $CtrlID)
	$x = $arPos[0]
	$y = $arPos[1] + $arPos[3]
	ClientToScreen($hWnd, $x, $y)
	TrackPopupMenu($hWnd, $hMenu, $x, $y)
EndFunc   ;==>ShowMenu

; Convert the client (GUI) coordinates to screen (desktop) coordinates
Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")
	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)
	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))
	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
	; release Struct not really needed as it is a local
	$stPoint = 0
EndFunc   ;==>ClientToScreen

; Show at the given coordinates (x, y) the popup menu (hMenu) which belongs to a given GUI window (hWnd)
Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
	DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
EndFunc   ;==>TrackPopupMenu