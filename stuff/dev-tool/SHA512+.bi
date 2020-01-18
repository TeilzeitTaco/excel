'SHA512Checksum - .bi-Version - mit Namespaces

Namespace SHA512Hash
	'Initialisierungskonstanten
	#Define SHA512_H0 &H6a09e667f3bcc908ULL
	#Define SHA512_H1 &Hbb67ae8584caa73bULL
	#Define SHA512_H2 &H3c6ef372fe94f82bULL
	#Define SHA512_H3 &Ha54ff53a5f1d36f1ULL
	#Define SHA512_H4 &H510e527fade682d1ULL
	#Define SHA512_H5 &H9b05688c2b3e6c1fULL
	#Define SHA512_H6 &H1f83d9abfb41bd6bULL
	#Define SHA512_H7 &H5be0cd19137e2179ULL

	'*******************************************************

	#Define SHA512_Ch(x,y,z) ((x And y) Xor ((Not x) And z))
	#Define SHA512_Maj(x,y,z) ((x And y) Xor (x And z) Xor (y And z))

	#Define SHA512_Sum0(x) (ROTR(28,x) Xor ROTR(34,x) Xor ROTR(39,x))
	#Define SHA512_Sum1(x) (ROTR(14,x) Xor ROTR(18,x) Xor ROTR(41,x))

	#Define SHA512_Sig0(x) (ROTR( 1,x) Xor ROTR( 8,x) Xor SHRR( 7,x))
	#Define SHA512_Sig1(x) (ROTR(19,x) Xor ROTR(61,x) Xor SHRR( 6,x))

	'*******************************************************

	Function SHRR(ByVal n As ULongInt, ByVal x As ULongInt) As ULongInt
		Return (x Shr n)
	End Function

	Function ROTR(ByVal y As ULongInt, ByVal x As ULongInt) As ULongInt
		Return ((x Shr y) Or (x Shl (64 - y)))
	End Function

	'*******************************************************

	Type SHA512Checksum
		Public:
		Declare Constructor()
		Declare Destructor()

		Declare Sub Transform(ByVal inpt As UByte Ptr)
		Declare Sub Update(ByVal dat As UByte Ptr, ByVal length As UInteger)
		Declare Function Final() As String

		Private:
		As ULongInt state(8)
		As UInteger count(4)
		As UByte buf(128)
	End Type


	#Ifndef memcpy
	Function memcpy(ByVal destination As UByte Ptr, ByVal source As UByte Ptr, ByVal num As UInteger) As UByte Ptr
		'Ersatz f?r "crt/string.bi"
		'Pr?ft nicht nach der Gr??e von Destination
		For i As Integer = 0 To num - 1
			destination[i]  = source[i]
		Next
		Return destination
	End Function
	#EndIf

	Constructor SHA512Checksum
	state(0) = SHA512_H0
	state(1) = SHA512_H1
	state(2) = SHA512_H2
	state(3) = SHA512_H3
	state(4) = SHA512_H4
	state(5) = SHA512_H5
	state(6) = SHA512_H6
	state(7) = SHA512_H7
	End Constructor

	Destructor SHA512Checksum

	End Destructor

	Sub SHA512Checksum.Transform(ByVal inpt As UByte Ptr)
		Dim As ULongInt a, b, c, d, e, f, g, h, T1, T2
		Dim As ULongInt w(80)
		Dim As ULongInt K(80) => { _
		&H428a2f98d728ae22ULL, &H7137449123ef65cdULL, &Hb5c0fbcfec4d3b2fULL, _
		&He9b5dba58189dbbcULL, &H3956c25bf348b538ULL, &H59f111f1b605d019ULL, _
		&H923f82a4af194f9bULL, &Hab1c5ed5da6d8118ULL, &Hd807aa98a3030242ULL, _
		&H12835b0145706fbeULL, &H243185be4ee4b28cULL, &H550c7dc3d5ffb4e2ULL, _
		&H72be5d74f27b896fULL, &H80deb1fe3b1696b1ULL, &H9bdc06a725c71235ULL, _
		&Hc19bf174cf692694ULL, &He49b69c19ef14ad2ULL, &Hefbe4786384f25e3ULL, _
		&H0fc19dc68b8cd5b5ULL, &H240ca1cc77ac9c65ULL, &H2de92c6f592b0275ULL, _
		&H4a7484aa6ea6e483ULL, &H5cb0a9dcbd41fbd4ULL, &H76f988da831153b5ULL, _
		&H983e5152ee66dfabULL, &Ha831c66d2db43210ULL, &Hb00327c898fb213fULL, _
		&Hbf597fc7beef0ee4ULL, &Hc6e00bf33da88fc2ULL, &Hd5a79147930aa725ULL, _
		&H06ca6351e003826fULL, &H142929670a0e6e70ULL, &H27b70a8546d22ffcULL, _
		&H2e1b21385c26c926ULL, &H4d2c6dfc5ac42aedULL, &H53380d139d95b3dfULL, _
		&H650a73548baf63deULL, &H766a0abb3c77b2a8ULL, &H81c2c92e47edaee6ULL, _
		&H92722c851482353bULL, &Ha2bfe8a14cf10364ULL, &Ha81a664bbc423001ULL, _
		&Hc24b8b70d0f89791ULL, &Hc76c51a30654be30ULL, &Hd192e819d6ef5218ULL, _
		&Hd69906245565a910ULL, &Hf40e35855771202aULL, &H106aa07032bbd1b8ULL, _
		&H19a4c116b8d2d0c8ULL, &H1e376c085141ab53ULL, &H2748774cdf8eeb99ULL, _
		&H34b0bcb5e19b48a8ULL, &H391c0cb3c5c95a63ULL, &H4ed8aa4ae3418acbULL, _
		&H5b9cca4f7763e373ULL, &H682e6ff3d6b2b8a3ULL, &H748f82ee5defb2fcULL, _
		&H78a5636f43172f60ULL, &H84c87814a1f0ab72ULL, &H8cc702081a6439ecULL, _
		&H90befffa23631e28ULL, &Ha4506cebde82bde9ULL, &Hbef9a3f7b2c67915ULL, _
		&Hc67178f2e372532bULL, &Hca273eceea26619cULL, &Hd186b8c721c0c207ULL, _
		&Heada7dd6cde0eb1eULL, &Hf57d4f7fee6ed178ULL, &H06f067aa72176fbaULL, _
		&H0a637dc5a2c898a6ULL, &H113f9804bef90daeULL, &H1b710b35131c471bULL, _
		&H28db77f523047d84ULL, &H32caab7b40c72493ULL, &H3c9ebe0a15c9bebcULL, _
		&H431d67c49c100d4cULL, &H4cc5d4becb3e42b6ULL, &H597f299cfc657e2aULL, _
		&H5fcb6fab3ad6faecULL, &H6c44198c4a475817ULL}

		Dim As Integer i

		For i = 0 To 15
			Dim As ULongInt temp = inpt[(8*i)]
			temp Shl= 8
			temp Or= inpt[(8*i) + 1]
			temp Shl= 8
			temp Or= inpt[(8*i) + 2]
			temp Shl= 8
			temp Or= inpt[(8*i) + 3]
			temp Shl= 8
			temp Or= inpt[(8*i) + 4]
			temp Shl= 8
			temp Or= inpt[(8*i) + 5]
			temp Shl= 8
			temp Or= inpt[(8*i) + 6]
			temp Shl= 8
			temp Or= inpt[(8*i) + 7]
			w(i) = temp
		Next

		For i = 16 To 79
			w(i) = SHA512_Sig1(w(i-2)) + w(i-7) + SHA512_Sig0(w(i-15)) + w(i-16)
		Next

		a = state(0)
		b = state(1)
		c = state(2)
		d = state(3)
		e = state(4)
		f = state(5)
		g = state(6)
		h = state(7)

		For i = 0 To 79
			T1 = h + SHA512_Sum1(e) + SHA512_Ch(e,f,g) + K(i) + w(i)
			T2 = SHA512_Sum0(a) + SHA512_Maj(a,b,c)
			h = g
			g = f
			f = e
			e = d + T1
			d = c
			c = b
			b = a
			a = T1 + T2
		Next

		state(0) += a
		state(1) += b
		state(2) += c
		state(3) += d
		state(4) += e
		state(5) += f
		state(6) += g
		state(7) += h
	End Sub

	Sub SHA512Checksum.Update(ByVal dat As UByte Ptr, ByVal length As UInteger)
		Dim As UInteger i, index, part_len

		index = Cast(UInteger, (count(0) Shr 3) And &H7f)

		count(0) += (length Shl 3)
		If (count(0) < (length Shl 3)) Then
			count(1) += 1
			If (count(1) < 1) Then
				count(2) += 1
				If (count(2) < 1) Then
					count(3) += 1
				EndIf
			EndIf
		EndIf
		count(1) += (length Shr 29)

		part_len = 128 - index

		If (length >= part_len) Then
			memcpy(@buf(index), dat, part_len)

			Transform(@buf(0))

			i = part_len
			While i + 127 < length
				Transform(@dat[i])
				i += 128
			Wend

			index = 0
		Else
			i = 0
		EndIf

		memcpy(@buf(index), @dat[i], length - i)
	End Sub

	Function SHA512Checksum.Final() As String
		Dim As UByte PADDING(128) => {&H80}
		Dim As UByte bits(16)
		Dim As UInteger index, pad_len, t
		Dim As Integer i

		t = count(0)
		bits(15) = t:t Shr= 8
		bits(14) = t:t Shr= 8
		bits(13) = t:t Shr= 8
		bits(12) = t
		t = count(1)
		bits(11) = t:t Shr= 8
		bits(10) = t:t Shr= 8
		bits( 9) = t:t Shr= 8
		bits( 8) = t
		t = count(2)
		bits( 7) = t:t Shr= 8
		bits( 6) = t:t Shr= 8
		bits( 5) = t:t Shr= 8
		bits( 4) = t
		t = count(3)
		bits( 3) = t:t Shr= 8
		bits( 2) = t:t Shr= 8
		bits( 1) = t:t Shr= 8
		bits( 0) = t

		index = Cast(UInteger, (count(0) Shr 3) And &H7f)
		pad_len = IIf(index < 112, (112 - index), (240 - index))
		Update(@PADDING(0), pad_len)

		Update(@bits(0), 16)

		Dim As String ret
		For i = 0 To 7
			ret += Hex(state(i), 16)
		Next

		Return ret
	End Function
End Namespace

Function createSHA512(ByVal text As String) As String
	Dim As UInteger nLength = Len(text)
	If nLength = 0 Then
		Return "Error - Empty string!"
	EndIf

	Dim As UByte buffer(16384)
	For i As Integer = 1 To nLength
		buffer(i - 1) = Asc(Mid(text, i ,1))
	Next

	Dim As SHA512Hash.SHA512Checksum SHA512
	SHA512.Update(@buffer(0), nLength)

	Return SHA512.Final()
End Function

Function createFileSHA512(ByVal file As String) As String
	Dim As UInteger nLength = Len(file)
	If nLength = 0 Then
		Return "Error - No filename given!"
	EndIf

	Dim As Integer FFF = FreeFile
	If Open(file For Binary Access Read As #FFF) <> 0 Then
		Return "Error - File not found/readable!"
	EndIf

	Dim As UInteger fileLength = Lof(FFF)
	If fileLength = 0 Then
		Close #FFF
		Return "Error - Empty file!"
	EndIf

	Dim As UByte buffer(16384)
	Dim As UInteger toBuffer
	Dim As SHA512Hash.SHA512Checksum SHA512
	Do Until fileLength = 0
		If fileLength >= 16384 Then
			fileLength -= 16384
			toBuffer = 16384
		Else
			toBuffer = fileLength
			fileLength = 0
		EndIf
		Get #FFF, , buffer(0), toBuffer
		SHA512.Update(@buffer(0), toBuffer)
	Loop
	Close #FFF

	Return SHA512.Final()
End Function

Assert(createSHA512("Intercontinental ballistic missile") = "71E4E9945D491F1B849D29C9324C815BA5F672FEC3EAFE214D08845BA91C8A5B7738A701C3F0A0B0F62AD4107A0F2F81CEB1234EAB46C64F56ACCF5158B6A33C")
