#Include Once "SHA512+.bi"
#Include Once "function.bi"

#Define build_password "7A8E9B31A763905588668B2348F43105F4190F5C0606C55AD230581F8F3167DCF41AA96D5ED0C51DA2255430347D6F3896B13EC9F9BC2E8F38C8B066E8408C4B"

'Version secrets
#Define vs_0_2_a "3fbdf489c004aba3589cff5db5c7e455ae26c77716becbfa018ad56681b3a79e"

#Define tool_version   "0.2a"
#Define target_version "0.2a"

If createSHA512(Environ("tool-password")) <> build_password Then
	? "Please activate the tool!"
	End
EndIf

Select Case Command(1)
	Case "fake"
		Select Case Command(2)
			Case "0.2a"
				? fake_highscore(Command(3), ValInt(Command(4)), vs_0_2_a)

			Case Else
				? "Not available."
		End Select

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

	Case "mac"
		Select Case Command(2)
			Case "0.2a"
				? make_mac(Command(3), vs_0_2_a)

			Case Else
				? "Not available."
		End Select

	Case "magic"
		? "Note: This is unused since version 0.1a."
		? make_magic_number(Command(2))

	Case "info", "help"
		?
		? "Snekcel dev-tool"
		?
		? "Tool version: "; tool_version
		? "Target version: "; target_version
		?
		? "Commands:"
		? Tab(4); "* fake"; Tab(15); "Create a legal submission URL for a given username and score."
		? Tab(4); "* hash"; Tab(15); "Create a SHA512 hash of a provided string."
		? Tab(4); "* help"; Tab(15); "Display this page."
		? Tab(4); "* hex"; Tab(15); "Hex encode or decode a string."
		? Tab(4); "* info"; Tab(15); "Display this page"
		? Tab(4); "* mac"; Tab(15); "Create a MAC for a provided string."
		? Tab(4); "* magic"; Tab(15); "Create a Magic Number for a procided string."

	Case Else
		? "Unknown command!"
End Select
