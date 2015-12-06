#include-once
#include "WinAPIEx.au3"

; 32-Bit / 64-Bit
Global Const $HKU  = "HKEY_USERS"
Global $HKCU       = "HKEY_CURRENT_USER"
Global $HKLM       = "HKEY_LOCAL_MACHINE"
Global Const $HKCR = "HKEY_CLASSES_ROOT"
Global Const $HKCC = "HKEY_CURRENT_CONFIG"

If @OSArch <> "X86" Then
    $HKCU &= "64"
    $HKLM &= "64"
EndIf

;-------------------------------------------------
;---PSueer Path and Conver Env--------------------
;-------------------------------------------------

Func _ExpandPsEnvStr($jPath)
	$jPath = _IsPsEnv(_WinAPI_ExpandEnvironmentStrings($jPath))
    If _FileIsPathValid($jPath, 0) = False Then Return $jPath
    Return _StripQuote($jPath)
Endfunc

;Func _IsPath($jPath)
	;Return StringRegExp($jPath, "[\\/:><\|]|(?s)\A\s*\z", 0)
;Endfunc

Func _IsPsEnv($jPath)
    ; Custom Env Var
    ; -- @PsPath          ; PSueer.exe's Path
    ; -- @PsDirPath       ; PSueer.exe's Dir Path
	Dim $iPsEnv[2][2] = [["@PsPath", @ScriptFullPath], ["@PsDirPath", @ScriptDir]]
	For $i = 0 To UBound($iPsEnv, 1) - 1
        If StringInStr($jPath, $iPsEnv[$i][0]) Then $jPath = StringReplace($jPath, $iPsEnv[$i][0], $iPsEnv[$i][1])
	Next
    Return $jPath
Endfunc

Func _StripQuote($gr)
	Local $st = $gr
    If IsArray($gr) Then
        For $i = 0 To UBound($gr, 1) -1
			$st = _StripQuote($gr[$i])
            If $st <> $gr[$i] Then $gr[$i] = $st
		Next
		Return $gr
	Else
		$st = StringRegExp($gr, '[""|''](.*?)[""|'']', 1)
		If IsArray($st) Then Return $st[0]
	EndIf
	Return $gr
Endfunc

Func _RegExp_GetFileName($sPath)
    Local $nRe = StringRegExpReplace($sPath, "^.*[\\|/](.+\..+)$", "$1")
    If @error Or Not $nRe Then Return $sPath
    Return $nRe
EndFunc

Func _RegExp_GetFileNameWithoutExt($sPath)
    Local $nRe = StringReplace(_RegExp_GetFileName($sPath), "." & _RegExp_GetFileNameExt($sPath), "")
	If @error Or Not $nRe Then Return $sPath
	Return $nRe
EndFunc

Func _RegExp_GetFileNameExt($sPath)
    Local $nRe = StringRegExpReplace($sPath, '^.*\.', '')
    If @error Or Not $nRe Then Return $sPath
    Return $nRe
EndFunc

Func _RegExp_GetPathDir($sPath)
    Local $nRe = StringRegExpReplace($sPath, '\\[^\\|/]*$', '')
    If @error Or Not $nRe Then Return $sPath
    Return $nRe
EndFunc

Func _RegExp_IsFileNameWithExt($sPath)
    Local $nRe = StringRegExp($sPath, '^.*[\\|/](.+\..+)$', 0)
    If @error Or Not $nRe Then Return $sPath
    Return 0
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _FileIsPathValid
; Description ...: checks if a File/Directory Path is Valid
; Syntax.........: _FileIsPathValid($Path, $Verbose = 0)
; Parameters ....: $Path - File/Directory Path to work with
;                  $Verbose  - OutPut (ConsoleWrite) additional information of invalidity of Path
;				   |0 - No OutPut
;				   |1 - OutPut to Console if Not Compiled
;				   |1 - OutPut to Console Always
; Return values .: Success - True
;                  Failure - False
; Author ........: Shafayat (sss13x@yahoo.com)
; Example .......: Yes
; ===============================================================================================================================

Func _FileIsPathValid($Path, $Verbose = 0)
	Local $PathOri = $Path
	Local $Excluded[8] = [7, "\\", "?", "*", '"', "<", ">", "|"] ;List of invalid characters
	Local $Alphabet = StringSplit("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "")
	Local $Reasons = ""
	Local $Valid = True
	; Lenght Check
	If StringLen($Path) < 4 Then
		$Reasons = $Reasons & @CRLF & "LENGTH: Entire Pathname must be more than 3 characters (including drive)."
		$Valid = False
	EndIf
	; Drive Check
	Local $pos = StringInStr($Path, ":\")
	If $pos <> 2 Then
		$Reasons = $Reasons & @CRLF & 'STRUCTURE: Drive letter must be one chars long and must be followed by ":\".'
		$Valid = False
	Else
		Local $chrdrv = StringUpper(StringLeft($Path, 1))
		Local $found = 0
		For $i = 0 To $Alphabet[0]
			If $chrdrv = $Alphabet[$i] Then
				$found = 1
			EndIf
		Next
		If $found = 0 Then
			$Reasons = $Reasons & @CRLF & "ILLEGAL CHARACTER: Illegal character used as drive letter."
			$Valid = False
		EndIf
	EndIf
	$Path = StringTrimLeft($Path, 3)
	; Path + Name Check
	For $i = 0 To $Excluded[0]
		If StringInStr($Path, $Excluded[$i]) <> 0 Then
			$Reasons = $Reasons & @CRLF & "ILLEGAL CHARACTER: " & $Excluded[$i]
			$Valid = False
		EndIf
	Next

	If $Verbose = 2 And $Valid = False Then ConsoleWrite(@CRLF & "Invalid Path: " & $PathOri & $Reasons & @CRLF)
	If $Verbose = 1 And $Valid = False And @Compiled = False Then ConsoleWrite(@CRLF & "=============" & @CRLF & "Invalid Path: " & $PathOri & $Reasons & @CRLF)
	Return $Valid
EndFunc

Func _FileListToArray_mod($sPath, $sFilter = "*", $iFlag = 0)
	Local $hSearch, $sFile, $sFileList, $sFolderList, $sDelim = "|"
	$sPath = StringRegExpReplace($sPath, "[\\/]+\z", "") & "\" ; ensure single trailing backslash
	If Not FileExists($sPath) Then Return SetError(1, 1, "")
	If StringRegExp($sFilter, "[\\/:><\|]|(?s)\A\s*\z") Then Return SetError(2, 2, "")
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then Return SetError(3, 3, "")
	$hSearch = FileFindFirstFile($sPath & $sFilter)
	If @error Then Return SetError(4, 4, "")
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If @extended Then
			$sFolderList &= $sDelim & $sFile
		Else
			$sFileList &= $sDelim & $sFile
		EndIf
	WEnd
	FileClose($hSearch)
	$sFileList = $sFolderList & $sFileList
	If Not $sFileList Then Return SetError(4, 4, "")
	Return StringSplit(StringTrimLeft($sFileList, 1), "|")
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........: _CRC32ForFile
; Description ...: Calculates CRC32 value for the specific file.
; Syntax.........: _CRC32ForFile ($sFile)
; Parameters ....: $sFile - Full path to the file to process.
; Return values .: Success - Returns CRC32 value in form of hex string
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - CreateFile function or call to it failed.
;                  |2 - CreateFileMapping function or call to it failed.
;                  |3 - MapViewOfFile function or call to it failed.
;                  |4 - RtlComputeCrc32 function or call to it failed.
; Author ........: trancexx
;
;==========================================================================================
Func _CRC32ForFile($sFile)
    Local $a_hCall = DllCall("kernel32.dll", "hwnd", "CreateFileW", _
            "wstr", $sFile, _
            "dword", 0x80000000, _ ; GENERIC_READ
            "dword", 3, _ ; FILE_SHARE_READ|FILE_SHARE_WRITE
            "ptr", 0, _
            "dword", 3, _ ; OPEN_EXISTING
            "dword", 0, _ ; SECURITY_ANONYMOUS
            "ptr", 0)

    If @error Or $a_hCall[0] = -1 Then Return SetError(1, 0, "")

    Local $hFile = $a_hCall[0]
    $a_hCall = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", _
            "hwnd", $hFile, _
            "dword", 0, _ ; default security descriptor
            "dword", 2, _ ; PAGE_READONLY
            "dword", 0, _
            "dword", 0, _
            "ptr", 0)

    If @error Or Not $a_hCall[0] Then
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
        Return SetError(2, 0, "")
    EndIf
    DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)

    Local $hFileMappingObject = $a_hCall[0]
    $a_hCall = DllCall("kernel32.dll", "ptr", "MapViewOfFile", _
            "hwnd", $hFileMappingObject, _
            "dword", 4, _ ; FILE_MAP_READ
            "dword", 0, _
            "dword", 0, _
            "dword", 0)

    If @error Or Not $a_hCall[0] Then
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(3, 0, "")
    EndIf

    Local $pFile = $a_hCall[0]
    Local $iBufferSize = FileGetSize($sFile)
    Local $a_iCall = DllCall("ntdll.dll", "dword", "RtlComputeCrc32", _
            "dword", 0, _
            "ptr", $pFile, _
            "int", $iBufferSize)

    If @error Or Not $a_iCall[0] Then
        DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(4, 0, "")
    EndIf
    DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
    DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)

    Local $iCRC32 = $a_iCall[0]
    Return SetError(0, 0, Hex($iCRC32))
EndFunc   ;==>_CRC32ForFile