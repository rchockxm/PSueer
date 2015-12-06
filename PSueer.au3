#pragma compile(Console, False)
#pragma compile(x64, False)
#pragma compile(ExecLevel, RequireAdministrator)
#pragma compile(Compatibility, Win10)
#pragma compile(UPX, True)
#pragma compile(AutoItExecuteAllowed, False)
#pragma compile(Stripper, True)
#pragma compile(FileVersion, 2.0.1.0)
#pragma compile(ProductVersion, 2.0.1.0)
#pragma compile(ProductName, PSueer)
#pragma compile(FileDescription, Silence Unlimited)
#pragma compile(LegalCopyright, Rchockxm)
#pragma compile(OriginalFilename, psueer.exe)
#pragma compile(Comments, Rchockxm PSueer 2.0.1 (Build 151206))

#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Rchockxm PSueer 2.0.1 (Build 151206)
#AutoIt3Wrapper_Res_Description=Silence Unlimited
#AutoIt3Wrapper_Res_Fileversion=2.0.1.0
#AutoIt3Wrapper_Res_LegalCopyright=Rchockxm
#AutoIt3Wrapper_Res_Language=1028
#AutoIt3Wrapper_Res_Field=OriginalFilename|PSueer
#AutoIt3Wrapper_Res_Field=ProductName|PSueer (x86)
#AutoIt3Wrapper_Res_Field=ProductVersion|2.0.1.0
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
	Auto Install GUI Loader (x86)

#ce ----------------------------------------------------------------------------


#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIEx.au3>
#include "Include\UDF\PSueerAPI.au3"
#include "Include\Busy\Busy.au3"

Opt('GUICloseOnESC', 0)
Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
Opt("TrayAutoPause", 0)
Opt("MustDeclareVars", 1)
Opt("SendKeyDelay", 1)
Opt("SendKeyDownDelay", 1)
Opt("MouseClickDelay", 5)
Opt("MouseClickDownDelay", 5)
Opt("MouseClickDragDelay", 150)
Opt("WinTitleMatchMode", 2)
Opt("WinDetectHiddenText", 1)

If @OSType = "WIN32_WINDOWS" Then Exit

;-------------------------------------------------
;---Global Var------------------------------------
;-------------------------------------------------

Global Const $nTitle     = "PSueer"
Global Const $nFullTitle = "PSueer 2.0.1 Build151206"
Global Const $nAuthor    = "Rchockxm"
Global Const $nEMail     = "rchockxm.silver@gmail.com"
Global Const $nWeb       = "http://rchockxm.com"

Global $oMyError = ObjEvent("AutoIt.Error","_MyErrFunc")

OnAutoItExitRegister("_ExitThread")
HotKeySet("{ESC}", "_ExitThread")

Global $gFuncline[1]  ; Global All Function Line
Global $gFuncArray[5] ; Global Current Record Args
Global $gStep = 1, $gExitLoop = 0

; File Path and Crc32 Hash
;If @OSArch = "X86" Then
    ;Dim $SterDll32[2] = [@ScriptDir & "\Dll\sciter-x-x86.dll","7E1EEF18"] ; x32
;Else
    ;Dim $SterDll64[2] = [@ScriptDir & "\Dll\sciter-x-x64.dll","4D93B75B"] ; x64
;EndIf
Dim $7Zipexe[2] = [@ScriptDir & "\Tools\7zr.exe","2C27B9BF"] ; 9.14
;Dim $7ZSSsfx[2] = [@ScriptDir & "\Tools\7zS.sfx","826C75A7"]
Dim $7ZSSsfx[2] = [@TempDir & "\PSueer\7zS.sfx","02455B72"] ; 9.14
Dim $ResHack[2] = [@ScriptDir & "\Tools\ResHacker.exe","06920E3A"]
Dim $NirCexe[2] = [@TempDir & "\PSueer\nircmd.exe","B9AFD933"]

DirCreate(@TempDir & "\PSueer")
FileInstall("Tools\7zS.sfx", @TempDir & "\PSueer\7zS.sfx", 1)
FileInstall("Tools\nircmd.exe", @TempDir & "\PSueer\nircmd.exe", 1)

; Config File Path
Global $KPSueerXi = @ScriptDir & "\Theme\PsueerX.ini"
;Global $KPSueerMi = @ScriptDir & "\Theme\Menu\PSueerMenu.ini"
;Global $KPSueerGi = @ScriptDir & "\Theme\GUI\PSueerGUI.ini"
;Global $KPSueerPi = @ScriptDir & "\Theme\Progress\settings.ini"

Global $KRcPath = @ScriptDir & "\Scripts"
Global $KInPath = @ScriptDir & "\Install"

; Script arg var
;Dim $kRcini2[1]
Global $kIsType = "progress", $kIauthor = $nAuthor, $kIaemail = $nEMail, $kIaweb = $nWeb, $kIguiW = 600, $kIguiH = 380, $kIguiTitle = $nTitle, $kIsmenutype = "select", $kIsdebug = "false"
;Global $kMBtn0 = "Exit(&X)", $kMBtn1 = "Select Install", $kMBtn2 = "Start Install(&A)", $kMBtn3 = "Start Installer..."
Global $kIsSystem = "all", $kIsReg = "none", $kIsProce = "none", $kIsWinTitle = "none"

Global $kPSIcons = @ScriptDir & "\Theme\PSueer.ico"

; Menu: Tray Menu Global
;Global $sMeEnable = false, $sMeiType, $sMeiItem

; GUI: Html GUI Global
;Global $sHtEnable = false, $sHand, $sHtml, $sLohtm = @ScriptDir & "\Theme\GUI\theme.htm"

; Progress GUI Global
Global $sThePath = @TempDir & "\PSueer"

; Check All File Crc32 Hash and Existed
;If @OSArch = "X86" Then
    ;If Not FileExists($SterDll32[0]) And _CRC32ForFile($SterDll32[0]) <> $SterDll32[1] Then $SterDll32 = 0 ; x32
;Else
    ;If Not FileExists($SterDll64[0]) And _CRC32ForFile($SterDll64[0]) <> $SterDll64[1] Then $SterDll64 = 0 ; x64
;EndIf
If Not FileExists($7Zipexe[0]) Or _CRC32ForFile($7Zipexe[0]) <> $7Zipexe[1] Then $7Zipexe = 0
If Not FileExists($7ZSSsfx[0]) Or _CRC32ForFile($7ZSSsfx[0]) <> $7ZSSsfx[1] Then $7ZSSsfx = 0
If Not FileExists($ResHack[0]) Or _CRC32ForFile($ResHack[0]) <> $ResHack[1] Then $ResHack = 0
If Not FileExists($NirCexe[0]) Or _CRC32ForFile($NirCexe[0]) <> $NirCexe[1] Then $NirCexe[0] = 0
If Not FileExists($KPSueerXi) Then $KPSueerXi = 0
;If Not FileExists($KPSueerMi) Then $KPSueerMi = 0

;-------------------------------------------------
;---Change PSueer Arg Var-------------------------
;-------------------------------------------------

; Read 'Theme\PSueerX.ini Section' to var
; [PSueerX]
; -- IsType=gui                        (Default:gui["none","progress","menu","gui"])
; -- Iauthor=rchockxm                  (Default:rchockxm)
; -- Iaemail=rchockxm.silver@gmail.com (Default:rchockxm.silver@gmail.com)
; -- Iaweb=http://rchockxm.pp.ru       (Default:http://rchockxm.pp.ru)
; -- IguiW=300                         (Default:300)
; -- IguiH=180                         (Default:180)
; -- IguiTitle=PSUeer                  (Default:PSUeer)
; -- Ismenutype=select                 (Default:select["none","select"])
; -- Isdebug=false                     (Default:false["true","false"])
If FileExists(@ScriptDir & "\Theme\PsueerX.ini") Then $KPSueerXi = @ScriptDir & "\Theme\PsueerX.ini"
If FileExists(@ScriptDir & "\PsueerX.ini") Then $KPSueerXi = @ScriptDir & "\PsueerX.ini"
If IsString($KPSueerXi) And FileExists($KPSueerXi) Then
    $kIsType = IniRead($KPSueerXi, "PSueerX", "IsType", "progress")
    $kIauthor = IniRead($KPSueerXi, "PSueerX", "Iauthor", $nAuthor)
    $kIaemail = IniRead($KPSueerXi, "PSueerX", "Iaemail", $nEMail)
    $kIaweb = IniRead($KPSueerXi, "PSueerX", "Iaweb", $nWeb)
    $kIguiW = IniRead($KPSueerXi, "PSueerX", "IguiW", 600)
	$kIguiH = IniRead($KPSueerXi, "PSueerX", "IguiH", 380)
    $kIguiTitle = IniRead($KPSueerXi, "PSueerX", "IguiTitle", $nTitle)
    $kIsmenutype = IniRead($KPSueerXi, "PSueerX", "Ismenutype", "select")
	$kIsdebug = IniRead($KPSueerXi, "PSueerX", "Isdebug", "false")
	If $kIsType <> "none" And $kIsType <> "menu" And $kIsType <> "progress" And $kIsType <> "gui" Then $kIsType = "progress"
	If IsString($kIguiW) Then $kIguiW = 600
	If IsString($kIguiH) Then $kIguiH = 380
    If $kIsmenutype <> "none" And $kIsmenutype <> "select" Then $kIsmenutype = "select"
	If $kIsdebug <> "true" And $kIsmenutype <> "false" Then $kIsdebug = "false"
EndIf

; Read 'Theme\GUI\PSueerGUI.ini Section' to var

#cs
; Read 'Theme\Menu\PSueerMenu.ini Section' to var
; -- mbtn0ti=Exit(&X)
; -- mbtn1ti=Select Install
; -- mbtn2ti=Start Install(&A)
; -- mbtn3ti=Start Installer...
If FileExists(@ScriptDir & "\Theme\Menu\PSueerMenu.ini") Then $KPSueerMi = @ScriptDir & "\Theme\Menu\PSueerMenu.ini"
If FileExists(@ScriptDir & "\PSueerMenu.ini") Then $KPSueerMi = @ScriptDir & "\PSueerMenu.ini"
If IsString($KPSueerMi) And FileExists($KPSueerMi) Then
    $kMBtn0 = IniRead($KPSueerMi, "PSueerMenuX", "mbtn0ti", "Exit(&X)")
    $kMBtn1 = IniRead($KPSueerMi, "PSueerMenuX", "mbtn1ti", "Select Install")
	$kMBtn2 = IniRead($KPSueerMi, "PSueerMenuX", "mbtn2ti", "Start Install(&A)")
	$kMBtn3 = IniRead($KPSueerMi, "PSueerMenuX", "mbtn3ti", "Start Installer...")
EndIf
#ce

;-------------------------------------------------
;---Start by Command Line (Arg-Cmdline)-----------
;-------------------------------------------------

Global $dCmdt = false
If $cmdline[0] = 1 Then
	$dCmdt = True
    If Not _ReadScriptFunc_LoopFile($cmdline[1], "Code2") Then Exit
    Exit
ElseIf $cmdline[0] >= 2 Then
    $dCmdt = True
    If Not IsArray($cmdline) Then Exit
    If Not _ReadScriptFunc_Enginee($cmdline, "") Then Exit
	Exit
EndIf

;-------------------------------------------------
;---Start by Script Func (Pre-Code)---------------
;-------------------------------------------------

If FileExists($KPSueerXi) Then _ReadScriptFunc_LoopFile($KPSueerXi, "PSPre")

;-------------------------------------------------
;---Start by Script Func (Double-Click)-----------
;-------------------------------------------------

; Read 'Theme\Menu\PSueerMenu.ini Section' (Create Menu Tray)
#cs
_CreateTrayMenu()
Func _CreateTrayMenu()
    If $sMeEnable = true And $kIsType = "menu" And FileExists($KPSueerMi) Then
	    Dim $hMutex = DllCall("kernel32.dll", "hwnd", "OpenMutex", "int", 0x1F0001, "int", False, "str", "PSueerEXM")
        If $hMutex[0] Then Exit
        Dim $iMutex = DllCall("kernel32.dll", "hwnd", "CreateMutex", "int", 0, "int", False, "str", "PSueerEXM")
        If @error Then Exit
	    $sHtEnable = false
        $sMeiType = IniReadSectionNames($KPSueerMi)
        If IsArray($sMeiType) Then
		    Local $sDefSect = _ArraySearch($sMeiType, "PSueerMenuX", 0, 0, 0, 1)
            If $sDefSect Then
                If _ArrayDelete($sMeiType, $sDefSect) Then
                    For $i = 1 To $sMeiType[0]

				    Next
			    EndIf
            EndIf
        EndIf
    ;$sMeiItem[1]
    EndIf
EndFunc
#ce

; Read Html Dll Interface (Create GUI)
#cs
_CreateGuiMenu()
Func _CreateGuiMenu()
    If $kIsType = "gui" Then
		Dim $hMutex = DllCall("kernel32.dll", "hwnd", "OpenMutex", "int", 0x1F0001, "int", False, "str", "PSueerEXG")
        If $hMutex[0] Then Exit
        Dim $iMutex = DllCall("kernel32.dll", "hwnd", "CreateMutex", "int", 0, "int", False, "str", "PSueerEXG")
        If @error Then Exit
        If @OSArch = "X86" Then
	        If IsArray($SterDll32) And FileExists($sLohtm) Then ; If _StStartup($SterDll32[0])
                If _StStartup($SterDll32[0]) Then $sHtEnable = true
	        EndIf
        Else
	        If IsArray($SterDll64) And FileExists($sLohtm) Then ; If _StStartup($SterDll64[0])
                If _StStartup($SterDll64[0]) Then $sHtEnable = true
	        EndIf
        EndIf
	    If $sHtEnable = true Then
	        $sHand = _StCreate(-1, -1, $KIguiW, $KIguiH, 1, $KIguiTitle)
	        $sHtml = FileRead($sLohtm)
			If $sHtml Then
	            _StLoadHtml($sHand, $sHtml)
	            _StWindowAttachEventHandler($sHand, "_HtmlCallback", $HANDLE_ALL)
			EndIf
        EndIf
    EndIf
EndFunc
#ce

;-------------------------------------------------
;---Process Script Function-----------------------
;-------------------------------------------------

; Read Rcini2 Script (Run Script)
If FileExists(@ScriptDir & "\Scripts\*.rcini2") Then $kRcPath = @ScriptDir & "\Scripts\"
If FileExists(@ScriptDir & "\Install\*.rcini2") Then $kRcPath = @ScriptDir & "\Install\"
If FileExists(@ScriptDir & "\*.rcini2") Then $kRcPath = @ScriptDir & "\"
If Not FileExists($kRcPath & "*.rcini2") Then $kRcPath = 0

_ReadScriptFunc_LoadFile($kRcPath)

; Rcini2 Script (Run Function)
Func _ReadScriptFunc_LoadFile($g = $kRcPath)
	$g = _ExpandPsEnvStr($g)
	;If Not FileExists($g) Then Return 0
    If IsString($g) Then
	    Local $hRcList = _FileListToArray_mod($g, "*.rcini2")
        If IsArray($hRcList) Then
			; Run Muilt Script
            For $i = 1 To $hRcList[0]
                _ReadScriptFunc_LoopFile($g & "\" & $hRcList[$i], "Code2")
		    Next
	    Else
            ; Run Single Script
            _ReadScriptFunc_LoopFile($g, "Code2")
        EndIf
    EndIf
EndFunc

Func _ReadScriptFunc_LoopFile($fPath, $fSect = "Code2")
	If Not StringRight($fPath, 7) = ".rcini2" And Not FileExists($fPath) Then Return
    $fPath = _ExpandPsEnvStr($fPath)
	Local $cPath = _RegExp_GetFileName($fPath)
    If Not FileExists($fPath) Then Return 0
    ; Read 'Code1 Section' to var
    ; -- IsSystem=all     (Default:all["winxp","winvista","win7","all"])
    ; -- IsReg=none       (Default:none["hklm\software\psueer,value1,value2","none"])
    ; -- IsProce=none     (Default:none["explorer.exe","none"])
	; -- IsWinTitle=none  (Default:none["Un - notepad","none"])
    $kIsSystem = IniRead($fPath, "Code1", "IsSystem", "all")
    $kIsReg = IniRead($fPath, "Code1", "IsReg", "none")
	$kIsProce = IniRead($fPath, "Code1", "IsProce", "none")
	$kIsWinTitle = IniRead($fPath, "Code1", "IsWinTitle", "none")
    ; Return Value 1 Then Exit
    If _CheckEndScript_Sys($kIsSystem) Then Return 1   ; End Script
    If _CheckEndScript_Reg($kIsReg) Then Return 1      ; End Script
	If _CheckEndScript_Proc($kIsProce) Then Return 1   ; End Script
    If _CheckEndScript_Win($kIsWinTitle) Then Return 1 ; End Script
	; Create Progress
	If $kIsType = "progress" Then
	    ;_Busy_Start()
        _Busy_Create("initialize...", $BUSY_PROGRESS)
	EndIf
    ; Read 'Code2 Section' to var
    Local $ire = IniReadSection($fPath, $fSect)
    If IsArray($ire) Then
        For $i = 1 To $ire[0][0]
			If $kIsType = "progress" Then _Busy_Update($cPath, ($i/$ire[0][0])*100)
			If Not _ReadScriptFunc_Enginee($ire[$i][0], $ire[$i][1]) Then _ReadScriptFunc_Debug($fPath, $i, $ire[$i][0] & "=" & $ire[$i][1])
			If _WinAPI_EmptyWorkingSet(@AutoItPID) Then ContinueLoop
        Next
    Else
		If $fSect = "PSPre" Or $fSect = "PSEnd" Then Return 0
		Local $ill = 0
        Local $ide = FileOpen($fPath, 0)
		If $ide Then
            While 1
				$ill += 1
				If $kIsType = "progress" Then _Busy_Update($cPath, $ill*7)
                Local $icf = FileReadLine($ide)
                If @error = -1 Then ExitLoop
				$icf = StringStripWS($icf, 3) ; Strip First Space
                ; Strip [section] Code
	            Local $ild = StringRegExp($icf, '(\[)(\])', 0)
	            If $ild Then ExitLoop
	            If $icf = "" Then ContinueLoop
				; Strip ";" Section
                If StringLeft($icf, 1) = ";" Then ContinueLoop
				; Input Line Code to var
                If Not _ReadScriptFunc_Enginee($icf, "") Then _ReadScriptFunc_Debug($fPath, $ill, $icf)
                If _WinAPI_EmptyWorkingSet(@AutoItPID) Then ContinueLoop
			WEnd
			If $kIsType = "progress" Then _Busy_Update($cPath, 100)
			FileClose($ide)
		Else
			Return 0
		EndIf
    EndIf
    ; Close Progress
	If $kIsType = "progress" Then
		_Busy_Close()
	    ;_Busy_Stop()
	EndIf
	Return 1
EndFunc

Func _ReadScriptFunc_Enginee($zCtype, $zCarg)
	Local $wType = $zCtype, $wArgs = $zCarg
	; Command Line Mode
	If IsArray($zCtype) Then
        $wType = $zCtype[1]
		_ArrayDelete($zCtype, 1)
		$zCtype[0] = UBound($zCtype, 1) -1
        $wArgs = $zCtype
		$zCarg = $zCtype
	EndIf
    ; Script Mode
    If Not IsArray($zCarg) Then
		If $zCarg = "" Then
            Local $spr = StringSplit($zCtype, "=")
            If $spr[0] = 1 Then Return 0
			$wType = $spr[1]
			$wArgs = $spr[2]
		EndIf
		$wArgs = StringSplit($wArgs, ",")
		;If $wArgs[0] = 1 Then Return 0
	EndIf
    ; Strip ' ' or " "
    $wArgs = _StripQuote($wArgs)
    ; Check Function Type: '$wType=run,runwait,etc' '$wArgs[0]=num,$wArgs[1]=c1,$wArgs[2]=c2,etc'
    Switch $wType
		Case "psautorecord", "psreadscript", "pscompress"
            If Not _PSxFunction_CmdLine($wType, $wArgs) Then Return 0
		Case "run", "runwait", "runshell" , "runshellwait", "runbyreg", "runbyclipboard", "runcmd", "rundll32"
            If Not _PSxFunction_Run($wType, $wArgs) Then Return 0
        Case "filedelete", "filecopy", "filemove", "filerename", "filesetattrib"
            If Not _PSxFunction_File($wType, $wArgs) Then Return 0
		;Case "dircreate", "dircopy", "dirmove", "dirdelete"
        Case "send", "sendbyreg", "sendbyclipboard", "sendwinbycontrol", "sendwinbyclick", "sendbymouse", "sendclose"
            If Not _PSxFunction_Send($wType, $wArgs) Then Return 0
		Case "nircmd"
			If Not _PSxFunction_Nircmd($wType, $wArgs) Then Return 0
		Case "dllinstall", "dlluninstall"
			If Not _PSxFunction_Dll($wType, $wArgs) Then Return 0
	    Case Else
		    Return 0
    EndSwitch
    Return 1
EndFunc

Func _ReadScriptFunc_Debug($qf = "Command Line", $ql = "0", $qc = "")
    If $kIsdebug = "false" Then Return 0
	If $kIsdebug = "true" Then
		Local $hf = FileOpen(@HomeDrive & "\" & $nTitle & "_Debug.txt", 1)
		If $hf = -1 Then Return 0
		FileWriteLine($hf, ">" & $qf)
        FileWriteLine($hf, "Exit Line: " & "'" & $ql & "'" & @TAB & "Code: " & "'" & $qc & "'")
		FileClose($hf)
    EndIf
	Return 1
EndFunc

;-------------------------------------------------
;---Check Script Var------------------------------
;-------------------------------------------------

; Return 1 Then Exit
Func _CheckEndScript_Sys($t = $kIsSystem)
	If $t = "all" Or $t = "" Then Return 0
	Local $cs = @OSVersion
    Switch $t
		Case "winxp"
			If $cs = "WIN_XP" Then Return 0
		Case "winvista"
            If $cs = "WIN_VISTA" Then Return 0
		Case "win7"
            If $cs = "WIN_7" Then Return 0
		Case Else
            Return 1
	EndSwitch
	Return 1
EndFunc

Func _CheckEndScript_Reg($t = $kIsReg)
	If $t = "none" Or $t = "" Then Return 0
    Local $sr = StringSplit($t, ",")
    If $sr[0] = 1 Then
        Return 0
	ElseIf $sr[0] = 2 Then
		If RegRead($sr[1], $sr[2]) Then Return 1
    ElseIf $sr[0] = 3 Then
        Local $dd = RegRead($sr[1], $sr[2])
		If $dd = $sr[3] Then Return 1
	Else
		Return 0
    EndIf
	Return 1
EndFunc

Func _CheckEndScript_Proc($t = $kIsProce)
    If $t = "none" Or $t = "" Then Return 0
    If $t <> "none" And ProcessExists($t) Then Return 0
	Return 1
EndFunc

Func _CheckEndScript_Win($t = $kIsWinTitle)
    If $t = "none" Or $t = "" Then Return 0
    If $t <> "none" And WinExists($t) Then Return 0
	Return 1
EndFunc

;-------------------------------------------------
;---Loop Function---------------------------------
;-------------------------------------------------
#cs
If $sMeEnable = true Or $sHtEnable = true Then
    While 1
        Sleep(100)
	    If _WinAPI_EmptyWorkingSet(@AutoItPID) Then ContinueLoop
    WEnd
EndIf
#ce

If FileExists($KPSueerXi) Then _ReadScriptFunc_LoopFile($KPSueerXi, "PSEnd")

#cs
Func _MenuStartInstall()

EndFunc

Func _MenuExitInstall()

EndFunc

Func _MenuCallback()
    If $sMeEnable = false Then Return
EndFunc

Func _HtmlCallback($kev, $kad)
	If $sHtEnable = false Then Return
	If $kev = $HANDLE_KEY Then
		If $kad[0] = 0 Then
			Local $el = $kad[1], $code = $kad[2]
			If $code = 27 Then Exit
		EndIf
	EndIf
	If $kev = $HANDLE_BEHAVIOR_EVENT Then
		Local $bh = $kad[0]
		If $bh = $BUTTON_PRESS Then
			;If _StGetAttributeByName($kad[1], "id") = "window-install" Then
			;If _StGetAttributeByName($kad[1], "id") = "window-manual" Then
			;If _StGetAttributeByName($kad[1], "id") = "window-maximize" Then Exit
			If _StGetAttributeByName($kad[1], "id") = "window-close" Then Exit
		ElseIf $bh = $CONTEXT_MENU_REQUEST Then
			$sHtml = FileRead($sLohtm)
			If $sHtml Then _StLoadHtml($sHand, $sHtml)
		EndIf
	EndIf
EndFunc

Func _HtmlSetText($kr = "body div", $ki = "id", $kif = "status", $kstr = "")
    Local $root = _StGetRootElement($sHand)
    Local $aEl = _StSelectElements($root, $kr)
	If $root And IsArray($aEl) Then
	    For $i = 1 To $aEl[0]
            Local $stxt = _StGetAttributeByName($aEl[$i], $ki)
			If $stxt = $kif Then
			    If Not _StSetElementText($aEl[$i], $kstr) Then Return 0
				ExitLoop
			EndIf
	    Next
		Return 1
	EndIf
EndFunc

Func _HtmlSetAttValue($kr = "body progress", $katt = "value", $kval = "10")
    Local $root = _StGetRootElement($sHand)
    Local $aEl = _StSelectElements($root, $kr)
	If $root And IsArray($aEl) Then
        If Not _StSetAttributeByName($aEl[1], $katt, $kval) Then Return 0
	EndIf
	_WinAPI_RedrawWindow($sHand)
	Return 1
EndFunc

#ce
Func _ExitThread()
    If $kIsType = "progress" Then
		_Busy_Close()
	    ;_Busy_Stop()
	EndIf
	DirRemove($sThePath, 1)
    Exit
EndFunc

;-------------------------------------------------
;---Main Function---------------------------------
;-------------------------------------------------

Func _IsParTrue($pI, $pL, $pR = 0)
    If Not IsArray($pL) Then Return Default
    For $i = $pR To UBound($pL, 1) -1
        If $pI = $pL[$i][0] Then Return $pL[$i][1]
	Next
    Return $pL[UBound($pL, 1) -1][1]
EndFunc

Func _IWriteLinePsFuncName($pd, $pt = "")
	If Not IsArray($pt) Then Return 0
    Local $wf = FileOpen($pd, 1)
    If $wf Then
 	    For $i = 0 To UBound($pt) -1
	        FileWriteLine($wf, $pt[$i])
        Next
	EndIf
    FileClose($pt)
	If @error Then Return 0
	Return 1
EndFunc

Func _IsHotkeyPressF2() ; Get Mouse Pos
	If _ArrayAdd($gFuncline, 'sendbymouse="' & $gFuncArray[3] & '","' & $gFuncArray[4] & '","' & $gFuncArray[0] & '","' & $gFuncArray[1] & '","' & $gFuncArray[2] & '"') Then $gStep +=1
EndFunc

Func _IsHotkeyPressF3() ; Get Input String
	If _ArrayAdd($gFuncline, 'sendwinbycontrol="' & $gFuncArray[1] & '","' & $gFuncArray[0] & '","","' & $gFuncArray[2] & '"') Then $gStep +=1
EndFunc

Func _IsHotkeyPressF4() ; Get Keyboard
	If _ArrayAdd($gFuncline, 'sendwinbyclick="' & $gFuncArray[0] & '","' & $gFuncArray[1] & '","' & $gFuncArray[2] & '"') Then $gStep +=1
EndFunc

Func _IsHotkeyPressF5() ; Back Step
	If $gStep > 1 And _ArrayDelete($gFuncline, $gStep) Then $gStep -=1
EndFunc

Func _IsHotkeyPressF6() ; Exit
	$gExitLoop =1
EndFunc

Func _PSxFunction_CmdLine($vT, $vA)
	If Not IsArray($vA) Then Return 0
	;If $dCmdt <> True Then Return 0
    Switch $vT
		Case "psautorecord"
	        $vA[1] = _ExpandPsEnvStr($vA[1])
			If Not FileExists($vA[1]) Then Return 0
			Local $rt = Run($vA[1])
            If Not $rt Then $rt = ShellExecute($vA[1])
			If Not $rt Then Return 0
            ; Record Script
			Opt("MouseCoordMode", 0)
			Dim $gWPid = _RegExp_GetFileName($vA[1])
			Local $gPath = @ScriptDir & "\Scripts" & "\" & _RegExp_GetFileNameWithoutExt($vA[1]) & ".rcini2"
            $gFuncline[0] = 'run="' & $vA[1] & '"'
            ; Set Hotkey
            HotKeySet("{F2}", "_IsHotkeyPressF2")
            HotKeySet("{F3}", "_IsHotkeyPressF3")
			HotKeySet("{F4}", "_IsHotkeyPressF4")
            HotKeySet("{F5}", "_IsHotkeyPressF5")
            HotKeySet("{F6}", "_IsHotkeyPressF6")
            ProcessWait($rt)
            While ProcessExists($gWPid)
                Local $wti = WinGetTitle("", "") ; Win Title
				Local $wgp = WinGetPos($wti)
				Local $mgp = MouseGetPos() ; Mouse Pos
				Local $wfu = ControlGetFocus($wti) ; ControlID (CLASSNN)
                Local $wgt = ControlGetText($wti, "", "[CLASSNN:" & $wfu & "]") ; keyword
				Local $wpc = WinGetProcess($wti)
				If StringLen($wgt) >= 60 Then $wgt = StringMid($wgt, 1, 10) & "..."
				Local $winpos[2] = [0,0]
				If IsArray($wgp) Then $winpos[0] = $wgp[0]
				If IsArray($wgp) Then $winpos[1] = $wgp[1]
				; Set Args to Global Array
				$gFuncArray[0] = $wti ; Win Title
				$gFuncArray[1] = $wgt ; keyword
				$gFuncArray[2] = $wfu ; ControlID (CLASSNN)
				$gFuncArray[3] = $mgp[0] ; Mouse Posx
				$gFuncArray[4] = $mgp[1] ; Mouse Posy
                Local $ttinfo = "[F2-GetMouse] [F3-GetString] [F4-GetKey] [F5-BackStep] [F6-Exit] [TAB-Switch]" & @CR & "Control :  [" & $wfu & "]  Text :  [" & $wgt & "]  Mouse : [" & $mgp[0] & "," & $mgp[1] & "]"
				ToolTip($ttinfo, Default, Default, "Step :  [" & $gStep & "] Title :  [" & $wti & "] [" & $winpos[0] & "," & $winpos[1] & "]", 0, 4)
                If $gExitLoop = 1 Then ExitLoop
				Sleep(25)
				If _WinAPI_EmptyWorkingSet(@AutoItPID) Then ContinueLoop
			WEnd
			ToolTip("")
			; Write Script To Line
			If Not _IWriteLinePsFuncName($gPath, $gFuncline) Then Return 0
			Opt("MouseCoordMode", 1)
		Case "psreadscript"
            $vA[1] = _ExpandPsEnvStr($vA[1])
			If Not FileExists($vA[1]) Then Return 0
            If Not _ReadScriptFunc_LoopFile($vA[1], "Code2") Then Return 0
		Case "pscompress"
            Local $harg1[2] = [@DesktopDir & "\PSueer_Output\Example.exe",$kPSIcons] ; Output path, Icon Path
            If $vA[0] = 1 And $vA[1] <> "-none" Then $harg1[0] = _ExpandPsEnvStr($vA[1])
            If $7Zipexe = 0 Or $7ZSSsfx = 0 Or $7ZSSsfx = 0 Then Return 0
	        ; Create Progress
            ;_Busy_Start()
            _Busy_Create("initialize...", $BUSY_PROGRESS)
            ; Prepare Paxkage File
            _Busy_Update("Prepare Config File", 5)
			Local $tsscon = @TempDir & "\PSueer\Rc_Config.txt"
            Local $iCFx = FileOpen($tsscon, 2)
			If $iCFx Then
                FileWrite($iCFx, ';!@Install@!UTF-8!' & @CRLF)
                FileWrite($iCFx, 'Title=' & '"' & $nFullTitle & '"' & @CRLF)
                FileWrite($iCFx, 'ExecuteFile=' & '"' & @ScriptName & '"'  & @CRLF)
                FileWrite($iCFx, ';!@InstallEnd@!' & @CRLF)
                FileClose($iCFx)
				If @error Then Return 0
            Else
                Return 0
            EndIf
			Sleep(1000)
			; Compress to Temp
            _Busy_Update("Prepare Package File", 10)
			;Local $aOutDir = DirCreate(_RegExp_GetPathDir($harg1[0]))
			;If $aOutDir = @error Then Return 0
			If Not DirCreate(_RegExp_GetPathDir($harg1[0])) Then Return 0
			Local $aTempf = @TempDir & "\PSueer\RchockxmTemp.7z"
			Local $iInclude = '"' & @ScriptDir & "\*.*" & '" "' & @ScriptDir & "\Install\" & '" "' & @ScriptDir & "\Scripts\" & '" "' & @ScriptDir & "\Theme\" & '"'
            If FileExists($7Zipexe[0]) And FileExists($7ZSSsfx[0]) And FileExists($tsscon) Then
				_Busy_Update("Compress to Temp File", 25)
                If FileExists($aTempf) Then FileDelete($aTempf)
				RunWait($7Zipexe[0] & ' a -t7z ' & '"' & $aTempf & '" ' & $iInclude & ' -m0=LZMA2', "", @SW_HIDE)
                Sleep(1000)
				; Combine File with SFX
				_Busy_Update("Generate EXE File", 50)
                If FileExists($aTempf) Then
                    RunWait(@ComSpec & ' /c ' & 'copy /b ' & '"' & $7ZSSsfx[0] & '"' & ' + ' & '"' & $tsscon & '"' & ' + '& '"' & $aTempf & '"' & ' ' & '"' & $harg1[0], "", @SW_HIDE)
                    Sleep(1000)
					_Busy_Update("Success Operation...", 85)
                    ; Add Icons Resources
                    If $vA[0] = 2 Then $harg1[1] = _ExpandPsEnvStr($vA[2])
                    If IsArray($ResHack) And FileExists($harg1[1]) Then
                        _Busy_Update("Add Package Icon", 90)
					    Local $nOf = _RegExp_GetPathDir($harg1[0]) & "\" & _RegExp_GetFileNameWithoutExt($harg1[0]) & "_New.exe"
                        RunWait($ResHack[0] & ' -addoverwrite ' & '"' & $harg1[0] & '","' & $nOf & '","' & $harg1[1] & '","Icon","1",', "", @SW_HIDE)
					    Sleep(1000)
					    If FileExists($nOf) Then FileDelete($harg1[0])
					EndIf
				Else
                    Return 0
                EndIf
            Else
                Return 0
            EndIf
			FileDelete($aTempf)
			FileDelete($tsscon)
            ; Close Progress
			_Busy_Update("Done", 100)
			Sleep(1000)
            _Busy_Close()
	        ;_Busy_Stop()
			DirRemove(@TempDir & "\PSueer", 1)
	EndSwitch
	Return 1
EndFunc

Func _PSxFunction_Run($vT, $vA)
	If Not IsArray($vA) Then Return 0
	;$vA[1] = _ExpandPsEnvStr($vA[1])
	;If Not FileExists($vA[1]) Then Return 0
    Switch $vT
		Case "run", "runwait"
			$vA[1] = _ExpandPsEnvStr($vA[1])
            Local $ar1[4][2] = [["-hide",@SW_HIDE],["-max",@SW_MAXIMIZE],["-min",@SW_MINIMIZE],["-none",Default]]
			Local $harg1 = $ar1[3][1]
			Local $re
			If $vA[0] = 1 Then $harg1 = $ar1[3][1] ; No Parameters
			If $vA[0] = 2 Then $harg1 = _IsParTrue($vA[2], $ar1, 0) ; Parameters 1
            If $vT = "run" Then $re = Run($vA[1], "", $harg1)
            If $vT = "runwait" Then $re = RunWait($vA[1], "", $harg1)
			If $re = 0 Then Return 0
		Case "runshell", "runshellwait"
			$vA[1] = _ExpandPsEnvStr($vA[1])
			Local $ar1[1][2] = [["-none",""]]
			Local $ar2[4][2] = [["-open","open"],["-edit","edit"],["-print","print"],["-properties","properties"]]
            Local $ar3[4][2] = [["-hide",@SW_HIDE],["-max",@SW_MAXIMIZE],["-min",@SW_MINIMIZE],["-none",Default]]
			Local $harg1[3] = ["",$ar2[0][1],$ar3[3][1]]
			Local $re
            If $vA[0] >= 1 Then $harg1[0] = $ar1[0][1] ; No Parameters
            If $vA[0] >= 2 Then $harg1[0] = _IsParTrue($vA[2], $ar1, 0) ; Parameters 1
            If $vA[0] >= 3 Then $harg1[1] = _IsParTrue($vA[3], $ar2, 0) ; Parameters 2
            If $vA[0] >= 4 Then $harg1[2] = _IsParTrue($vA[4], $ar3, 0) ; Parameters 3
            If $vT = "runshell" Then $re = ShellExecute($vA[1], $harg1[0], "", $harg1[1], $harg1[2])
			If $vT = "runshellwait" Then $re = ShellExecuteWait($vA[1], $harg1[0], "", $harg1[1], $harg1[2])
			If $re = 0 Then Return 0
		Case "runbyreg"
            If $vA[0] < 2 Then Return 0 ; No Value Path
			Local $ar1[2] = ["-wait","-none"]
			Local $harg1 = $ar1[0]
			If $vA[0] >= 2 Then $harg1 = $ar1[0]
			If $vA[0] >= 3 Then $harg1 = $vA[3]
			Local $re
            Local $sr = RegRead($vA[1], $vA[2])
			If _FileIsPathValid($sr, 0) = False Then Return 0
            If $harg1 = $ar1[0] Then $re = RunWait($sr)
			If $harg1 = $ar1[1] Then $re = Run($sr)
            If $re = 0 Then Return 0
		Case "runbyclipboard"
			Local $ar1[2] = ["-wait","-none"]
            Local $harg1 = $ar1[0]
			If $vA[1] >= $ar1[0] Then $harg1 = $ar1[0]
			If $vA[1] = $ar1[1] Then $harg1 = $ar1[1]
			Local $re
            Local $sp = StringSplit(ClipGet(), @LF)
            If $sp[0] = 1 Then
				If $harg1 = $ar1[0] Then $re = RunWait(_ExpandPsEnvStr($sp[1]))
				If $harg1 = $ar1[1] Then $re = Run(_ExpandPsEnvStr($sp[1]))
				If $re = 0 Then Return 0
			Else
                For $i = 1 To UBound($sp, 1) -1
				    If $harg1 = $ar1[0] Then $re = RunWait(_ExpandPsEnvStr($sp[$i])) ; bug
				    If $harg1 = $ar1[1] Then $re = Run(_ExpandPsEnvStr($sp[$i]))     ; bug
					If $re = 0 Then ContinueLoop
				Next
				If @error Then Return 0
			EndIf
		Case "runcmd"
			$vA[1] = _ExpandPsEnvStr($vA[1])
			Local $harg1 = ""
			If $vA[0] > 2 Then
                For $i = 1 To UBound($vA, 1) -1
					$harg1 = $harg1 & $vA[$i] & " "
				Next
			Else
				$harg1 = $vA[1]
			EndIf
            If Run(@ComSpec & " /c " & $harg1, "", @SW_HIDE) = 0 Then Return 0
		Case "rundll32"
            If Run("RUNDLL32.EXE " & _ExpandPsEnvStr($vA[1]), "", @SW_HIDE) = 0 Then Return 0
        Case Else
			Return 0
	EndSwitch
	Return 1
EndFunc

Func _PSxFunction_File($vT, $vA)
	If Not IsArray($vA) Then Return 0
	$vA[1] = _ExpandPsEnvStr($vA[1])
    Switch $vT
		Case "filedelete"
            If FileDelete($vA[1]) = @error Then Return 0
		Case "filecopy", "filemove"
			If $vA[0] = 1 Then Return 0 ; No Destination Path
			$vA[2] = _ExpandPsEnvStr($vA[2])
            Local $ar1[2][2] = [["-overwrite",9],["-none",Default]]
            Local $harg1 = $ar1[1][1]
            If $vA[0] >= 2 Then $harg1 = $ar1[1][1] ; No Parameters
			If $vA[0] >= 3 Then $harg1 = _IsParTrue($vA[3], $ar1, 0) ; Parameters 1
			Local $re
			If $vT = "filecopy" Then $re = FileCopy($vA[1], $vA[2], $harg1)
            If $vT = "filemove" Then $re = FileMove($vA[1], $vA[2], $harg1)
			If Not $re Then Return 0
		Case "filerename"
			If $vA[0] = 1 Then Return 0 ; No New File Name
            Local $harg1 = _RegExp_GetFileNameWithoutExt($vA[1]) & "\" & $vA[2] & _RegExp_GetFileNameExt($vA[1])
            If Not FileMove($vA[1], $harg1) Then Return 0
        Case "filesetattrib"
			If $vA[0] = 1 Then Return 0 ; No Attribute To Set
			Local $harg1 = $vA[2]
            If Not FileSetAttrib($vA[1], $harg1) Then Return 0
        Case Else
			Return 0
	EndSwitch
	Return 1
EndFunc

#cs
Func _PSxFunction_Dir($vT, $vA)
	If Not IsArray($vA) Then Return 0
    Switch $vT
		Case ""

		Case ""

        Case Else
			Return 0
	EndSwitch
	Return 1
EndFunc

Func _PSxFunction_Process($vT, $vA)
	If Not IsArray($vA) Then Return 0
    Switch $vT
		Case ""

		Case ""

        Case Else
			Return 0
	EndSwitch
	Return 1
EndFunc

Func _PSxFunction_Windows($vT, $vA)
	If Not IsArray($vA) Then Return 0
    Switch $vT
		Case ""

		Case ""

        Case Else
			Return 0
	EndSwitch
	Return 1
EndFunc
#ce

Func _PSxFunction_Send($vT, $vA)
	If Not IsArray($vA) Then Return 0
    Switch $vT
		Case "send"
            Local $harg1[5] = ["","","","",1]
            If $vA[0] >= 2 And $vA[2] <> "" Then $harg1[0] = $vA[2]      ; Win Title
            If $vA[0] >= 3 And $vA[3] <> "" Then $harg1[1] = $vA[3]      ; KeyWord
            If $vA[0] >= 4 And $vA[4] <> "" Then $harg1[2] = $vA[4]      ; ControlID (CLASSNN)
			If $vA[0] >= 5 And $vA[5] <> "" Then $harg1[3] = Int($vA[5]) ; Win Wait Title Sec
            If $vA[0] >= 6 And $vA[6] <> "" Then $harg1[4] = Int($vA[6]) ; Send Times
            If $harg1[0] <> "" Then WinWait($harg1[0], $harg1[1], $harg1[3])
			If $harg1[0] <> "" And Not WinActive($harg1[0], $harg1[1]) Then WinWaitActive($harg1[0], $harg1[1], $harg1[3])
			If $harg1[0] <> "" And WinGetState($harg1[0]) = 16 Then WinSetState($harg1[0], "", @SW_RESTORE)
			For $i = 1 To $harg1[4]
				If $harg1[0] <> "" Then WinActivate($harg1[0], $harg1[1])
                If $harg1[0] <> "" And $harg1[2] <> "" Then ControlFocus($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]")
				Send($vA[1])
			Next
		Case "sendbyreg"
			If $vA[0] < 2  Then Return 0 ; No Parameters
            Local $harg1[5] = ["","","","",1]
            If $vA[0] >= 3 And $vA[3] <> "" Then $harg1[0] = $vA[3]      ; Win Title
            If $vA[0] >= 4 And $vA[4] <> "" Then $harg1[1] = $vA[4]      ; KeyWord
            If $vA[0] >= 5 And $vA[5] <> "" Then $harg1[2] = $vA[5]      ; ControlID (CLASSNN)
			If $vA[0] >= 6 And $vA[6] <> "" Then $harg1[3] = Int($vA[6]) ; Win Wait Title Sec
            If $vA[0] >= 7 And $vA[7] <> "" Then $harg1[4] = Int($vA[7]) ; Send Times
            If $harg1[0] <> "" Then WinWait($harg1[0], $harg1[1], $harg1[3])
			If $harg1[0] <> "" And Not WinActive($harg1[0], $harg1[1]) Then WinWaitActive($harg1[0], $harg1[1], $harg1[3])
            If $harg1[0] <> "" And WinGetState($harg1[0]) = 16 Then WinSetState($harg1[0], "", @SW_RESTORE)
			Local $ge
			For $i = 1 To $harg1[4]
				If $harg1[0] <> "" Then WinActivate($harg1[0], $harg1[1])
                If $harg1[0] <> "" And $harg1[2] <> "" Then ControlFocus($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]")
				$ge = RegRead($vA[1], $vA[2])
				If $ge Then Send($ge)
			Next
		Case "sendbyclipboard"
			Local $harg1[5] = ["","","","",1]
            If $vA[0] >= 1 And $vA[1] <> "" Then $harg1[0] = $vA[1]      ; Win Title
            If $vA[0] >= 2 And $vA[2] <> "" Then $harg1[1] = $vA[2]      ; KeyWord
            If $vA[0] >= 3 And $vA[3] <> "" Then $harg1[2] = $vA[3]      ; ControlID (CLASSNN)
			If $vA[0] >= 4 And $vA[4] <> "" Then $harg1[3] = Int($vA[4]) ; Win Wait Title Sec
            If $vA[0] >= 5 And $vA[5] <> "" Then $harg1[4] = Int($vA[5]) ; Send Times
            If $harg1[0] <> "" Then WinWait($harg1[0], $harg1[1], $harg1[3])
			If $harg1[0] <> "" And Not WinActive($harg1[0], $harg1[1]) Then WinWaitActive($harg1[0], $harg1[1], $harg1[3])
			If $harg1[0] <> "" And WinGetState($harg1[0]) = 16 Then WinSetState($harg1[0], "", @SW_RESTORE)
			Local $ge = ClipGet()
			For $i = 1 To $harg1[4]
				If $harg1[0] <> "" Then WinActivate($harg1[0], $harg1[1])
                If $harg1[0] <> "" And $harg1[2] <> "" Then ControlFocus($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]")
				If $ge Then Send($ge)
			Next
		Case "sendwinbycontrol"
			If $vA[0] < 3 Then Return 0 ; No Win Title and ControlID
            Local $harg1[5] = ["","","","",1]
			If $vA[0] >= 2 And $vA[2] <> "" Then $harg1[0] = $vA[2]      ; Win Title
            If $vA[0] >= 3 And $vA[3] <> "" Then $harg1[1] = $vA[3]      ; KeyWord
            If $vA[0] >= 4 And $vA[4] <> "" Then $harg1[2] = $vA[4]      ; ControlID (CLASSNN)
			If $vA[0] >= 5 And $vA[5] <> "" Then $harg1[3] = Int($vA[5]) ; Win Wait Title Sec
            If $vA[0] >= 6 And $vA[6] <> "" Then $harg1[4] = Int($vA[6]) ; Send Times
			WinWait($harg1[0], $harg1[1], $harg1[3])
			Local $ge
			For $i = 1 To $harg1[4]
				Local $sta = ControlCommand($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]", "IsEnabled", "")
	            While $sta = 0
		            $sta = ControlCommand($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]", "IsEnabled", "")
                    If $sta = 1 Then ExitLoop
	            Wend
                If $harg1[2] <> "" Then ControlFocus($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]")
				$ge = ControlSend($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]", $vA[1])
				If $ge = @error Then ContinueLoop
			Next
			If Not $ge Then Return 0
		Case "sendwinbyclick"
            If $vA[0] < 3 Then Return 0 ; No Win Title and ControlID
            Local $harg1[5] = ["","","","",1]
			If $vA[0] >= 1 And $vA[1] <> "" Then $harg1[0] = $vA[1]      ; Win Title
            If $vA[0] >= 2 And $vA[2] <> "" Then $harg1[1] = $vA[2]      ; KeyWord
            If $vA[0] >= 3 And $vA[3] <> "" Then $harg1[2] = $vA[3]      ; ControlID (CLASSNN)
			If $vA[0] >= 4 And $vA[4] <> "" Then $harg1[3] = Int($vA[4]) ; Win Wait Title Sec
            If $vA[0] >= 5 And $vA[5] <> "" Then $harg1[4] = Int($vA[5]) ; Send Times
			WinWait($harg1[0], $harg1[1], $harg1[3])
			Local $ge
			For $i = 1 To $harg1[4]
				Local $sta = ControlCommand($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]", "IsEnabled", "")
	            While $sta = 0
		            $sta = ControlCommand($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]", "IsEnabled", "")
                    If $sta = 1 Then ExitLoop
	            Wend
                If $harg1[2] <> "" Then ControlFocus($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]")
				$ge = ControlClick($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]")
				If $ge = @error Then ContinueLoop
			Next
			If Not $ge Then Return 0
		Case "sendbymouse"
            If $vA[0] < 2 Then Return 0 ; No x and y
            Local $harg1[5] = ["","","","",1]
			If $vA[0] >= 3 And $vA[3] <> "" Then $harg1[0] = $vA[3]      ; Win Title
            If $vA[0] >= 4 And $vA[4] <> "" Then $harg1[1] = $vA[4]      ; KeyWord
            If $vA[0] >= 5 And $vA[5] <> "" Then $harg1[2] = $vA[5]      ; ControlID (CLASSNN)
			If $vA[0] >= 6 And $vA[6] <> "" Then $harg1[3] = Int($vA[6]) ; Win Wait Title Sec
            If $vA[0] >= 7 And $vA[7] <> "" Then $harg1[4] = Int($vA[7]) ; Send Times
            If $harg1[0] <> "" Then WinWait($harg1[0], $harg1[1], $harg1[3])
			If $harg1[0] <> "" And Not WinActive($harg1[0], $harg1[1]) Then WinWaitActive($harg1[0], $harg1[1], $harg1[3])
			If $harg1[0] <> "" And WinGetState($harg1[0]) = 16 Then WinSetState($harg1[0], "", @SW_RESTORE)
			If $harg1[2] <> "" Then
			    Local $sta = ControlCommand($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]", "IsEnabled", "")
	            While $sta = 0
		            $sta = ControlCommand($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]", "IsEnabled", "")
                    If $sta = 1 Then ExitLoop
	            Wend
            EndIf
			If $vA[1] = 0 And $vA[2] = 0 And $harg1[2] <> "" Then
				Opt("MouseCoordMode", 2)
			    Local $ps = ControlGetPos($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]")
                If IsArray($ps) Then
					$vA[1] = $ps[0]
					$vA[2] = $ps[1]
				EndIf
				If $harg1[2] <> "" Then ControlFocus($harg1[0], $harg1[1], "[CLASSNN:" & $harg1[2] & "]")
				If Not MouseClick("left", Int($vA[1]), Int($vA[2]),$harg1[4], 0) Then Return 0
			Else
				Opt("MouseCoordMode", 0)
                MouseMove($vA[1], $vA[2], 0)
                MouseDown("left")
                Sleep(5)
                MouseUp("left")
            EndIf
			Opt("MouseCoordMode", 1)
			If @error Then Return 0
		Case "sendclose"
			If $vA[0] = 1 Then Return 0 ; No Parameters
			Local $ar1[2] = ["-proc","-win"]
			Local $ar2[2] = ["-wait","-none"]
			Local $harg2 = $ar2[1]
			If $vA[0] >= 3 And ($vA[3] = $ar2[0] Or $vA[3] = $ar2[1]) And $vA[3] <> "" Then $harg2 = $vA[3] ; Win Wait Title
			Local $re
            If $vA[2] = $ar1[0] Then     ; Process
			    If $harg2 = $ar2[0] Then ProcessWait($vA[1])
				If ProcessExists($vA[1]) Then $re = ProcessClose($vA[1])
			ElseIf $vA[2] = $ar1[1] Then ; Wintitle
			    If $harg2 = $ar2[0] Then WinWait($vA[1])
				If WinExists($vA[1]) Then $re = WinClose($vA[1])
			EndIf
			If Not $re Then Return 0
        Case Else
			Return 0
	EndSwitch
	Return 1
EndFunc

Func _PSxFunction_Nircmd($vT, $vA)
	If Not IsArray($vA) Then Return 0
    Switch $vT
		Case "nircmd"
            If FileExists($NirCexe[0]) Then
                If Run($NirCexe[0] & " " & _ExpandPsEnvStr($vA[1]), "", @SW_HIDE) = 0 Then Return 0
			Else
 				Return 0
			EndIf
        Case Else
			Return 0
	EndSwitch
    Return 1
EndFunc

Func _PSxFunction_Dll($vT, $vA)
	If Not IsArray($vA) Then Return 0
    Switch $vT
		Case "dllinstall"
            If Not _WinAPI_Dllinstall(_ExpandPsEnvStr($vA[1])) Then Return 0
		Case "dlluninstall"
            If Not _WinAPI_DllUninstall(_ExpandPsEnvStr($vA[1])) Then Return 0
        Case Else
			Return 0
	EndSwitch
    Return 1
EndFunc

;-------------------------------------------------
;---Other Function--------------------------------
;-------------------------------------------------

Func _MyErrFunc()
    ConsoleWrite($nTitle & "We intercepted a COM Error !"      & @CRLF  & @CRLF & _
            "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
            "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
            "err.number is: "         & @TAB & hex($oMyError.number,8)  & @CRLF & _
            "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
            "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
            "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
            "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
            "err.helpcontext is: "    & @TAB & $oMyError.helpcontext)
Endfunc
