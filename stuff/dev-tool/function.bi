#Include Once "datetime.bi"

Function make_magic_number(ByVal srcStr As String) As Integer
	Dim magic_number As Integer
	Dim cycles As Integer

	srcStr = srcStr & "0"
	For cycles = 1 To Len(srcStr) - 1
		If Asc(Mid(srcStr, cycles + 1, 1)) Mod 2 <> 0 Then
			magic_number = magic_number + Asc(Mid(srcStr, cycles, 1))
		Else
			magic_number = magic_number - Asc(Mid(srcStr, cycles, 1))
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

Function make_mac(ByVal srcStr As String, ByVal version_secret As String) As String
	Return createSHA512(createSHA512(srcStr) + version_secret)
End Function

Function fake_highscore(ByVal username As String, ByVal score As UInteger, ByVal version_secret As String) As String
	Dim As String fake_json = _
	!"{\"inital_snake_length\":\"10\",\"points_for_moving\":\"1\",\"points_for_fruit\":\"750\"," & _
	!"\"tick_speed_ms\":\"50\",\"movement_speed_cycles\":\"5\",\"growing_speed_steps\":\"10\"," & _
	!"\"increase_coefficients\":\"5000\",\"score\":\"" & str(score) & !"\",\"username\":\"" & username & !"\",\"version\":\"0.2a\"}"

	fake_json = encode_hex(fake_json, TRUE)

	Dim As String url_ending = "/submit_highscore/" & fake_json & "/" & make_mac(fake_json, version_secret) & "/"
	Return url_ending
End Function
