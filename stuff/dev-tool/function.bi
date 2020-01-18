#Include Once "datetime.bi"

Function make_magic_number(ByVal src As String) As Integer
	Dim magic_number As Integer
	Dim cycles As Integer

	src = src & "0"
	For cycles = 1 To Len(src) - 1
		If Asc(Mid(src, cycles + 1, 1)) Mod 2 <> 0 Then
			magic_number = magic_number + Asc(Mid(src, cycles, 1))
		Else
			magic_number = magic_number - Asc(Mid(src, cycles, 1))
		End If

		magic_number = magic_number Xor Hour(Now())
	Next

	Return Abs(magic_number)
End Function

Function encode_hex(ByVal srcStr As String, ByVal mode As Boolean) As String
	Dim As String outStr

	If (mode = TRUE) Then
		For cycles As UInteger = 1 To Len(srcStr)
			outStr += Hex(Asc(Mid(srcStr, cycles, 1)), 2)
		Next
	Else
		For cycles As UInteger = 1 To Len(srcStr) Step 2
			outStr += Chr(Val("&h" & Mid(srcStr, cycles, 2)))
		Next
	EndIf

	Return outStr
End Function
