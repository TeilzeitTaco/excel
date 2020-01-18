#Include Once "SHA512+.bi"
#Include Once "function.bi"

#Define build_password "BE97075F6E97E042271A636398032D4446E1D2FAFE50EFB48476F97E446D89377A03B57A5663505E4F7185917ED5D25CF2C4C316FDBB0A7B4E908626B7F0C1F3"

Const version = "0.1a"

If createSHA512(Environ("tool-password")) <> build_password Then
	? "Please activate the tool!"
	End
EndIf

Select Case Command(1)
	Case "hash"
		? createSHA512(Command(2))

	Case "hex"
		Select Case Command(2)
			Case "encode"
				? encode_hex(Command(3), TRUE)

			Case "decode"
				? encode_hex(Command(3), FALSE)

			Case Else
				? "Unknown mode!"
		End Select

	Case "magic"
		? make_magic_number(Command(2))
		
	Case "info"
		? "Tool version: "; version

	Case Else
		? "Unknown command!"
End Select
