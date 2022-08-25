Const w = 800
Const h = 600

Graphics w,h

AppTitle = "Untitled Sandbox Game"

Global size = 5
Global box_size = Floor((h/size))-10

Global selected_type = 2

Global box[box_size,box_size]
Global ghost_box[box_size,box_size]

Type water
	Field x
	Field y
	Field dir
EndType

Global waterparticles:TList = New TList

While Not KeyDown(KEY_ESCAPE)
	Cls	

	DrawParticles()
	UpdateParticles()
	
	SetColor 97,54,11
	drawhollowrect(0,0,box_size*size,box_size*size)
	
	If KeyHit(KEY_1) Then
		selected_type = 1
	ElseIf KeyHit(KEY_2) Then
		selected_type = 2
	ElseIf KeyHit(KEY_3) Then
		selected_type = 3		
	ElseIf KeyHit(KEY_4) Then
		selected_type = 4
	ElseIf KeyHit(KEY_0) Then
		selected_type = 0
	EndIf
	
	Flip
Wend
End

Function UpdateParticles()
	ArrayCopy(box,0,ghost_box,0,box.length)

	For Local x = 0 To box_size-1
		For Local y = 0 To box_size-1
		
			Local xpos = x*size
			Local ypos = y*size
			
			If y-1 > 0 Then
				If box[x,y] = 1 Then
					box[x,y] = 0
					box[x,y-1] = 1
				EndIf
			EndIf

		
			If y+1 <= box_size-1 Then
				If ghost_box[x,y+1] <> 3 Then
					If ghost_box[x,y] = 2 Then
						If ghost_box[x,y+1] <> 4 And ghost_box[x,y+1] <> 2 Then
							box[x,y] = 0
							box[x,y+1] = 2
						EndIf
					ElseIf ghost_box[x,y] = 4 Then
						If ghost_box[x,y+1] = 0 Then
							box[x,y] = 0
							box[x,y+1] = 4
						ElseIf ghost_box[x,y+1] = 2 Then
							box[x,y] = 2
							box[x,y+1] = 4
						EndIf			
					EndIf
				EndIf
			EndIf		
		
			If y = box_size-1 Or box[x,y+1] = 2 Or box[x,y+1] = 3 Or box[x,y+1] = 4 Then
				If box[x,y] = 2 Then
					If Rand(0,1) = 0 Then
						If x-1 >= 0 Then
							If box[x-1,y] <> 2 And box[x-1,y] <> 3 And box[x-1,y] <> 4 Then
								box[x,y] = 0
								box[x-1,y] = 2
							EndIf
						Else
							If box[x+1,y] <> 2 And box[x+1,y] <> 3 And box[x+1,y] <> 4 Then
								box[x,y] = 0
								box[x+1,y] = 2
							EndIf						
						EndIf
					Else
						If  x+1 <= box_size-1 Then
							If box[x+1,y] <> 2 And box[x+1,y] <> 3 And box[x+1,y] <> 4 Then
								box[x,y] = 0
								box[x+1,y] = 2
							EndIf	
						Else
							If box[x-1,y] <> 2 And box[x-1,y] <> 3 And box[x-1,y] <> 4 Then
								box[x,y] = 0
								box[x-1,y] = 2
							EndIf					
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	Next
EndFunction

Function ArraysEqual(ar1[,],ar2[,])
	For Local x = 0 To box_size-1
		For Local y = 0 To box_size-1
			If ar1[x,y] <> ar2[x,y] Then Return False
		Next
	Next
	Return True
EndFunction

Function DrawParticles()
	For Local x = 0 To box_size-1
		For Local y = 0 To box_size-1
		
			Local xpos = x*size
			Local ypos = y*size
			
			If MouseInCell(x,y) Then
				If MouseDown(1) Then	
					box[x,y] = selected_type
				EndIf
			EndIf
			
			
			Rem
			
			PARTICLE TYPES
			
			1 = Fire
			2 = Water
			3 = Rock
			4 = Sand
			
			
			EndRem
			
			If box[x,y] = 1 Then
				SetColor Rand(120,255),Rand(50,255),20
			ElseIf box[x,y] = 2 Then
				SetColor 10,4,255
			ElseIf box[x,y] = 3 Then
				SetColor 128,128,128
			ElseIf box[x,y] = 4 Then
				SetColor 255,247,92
			EndIf
			
			If box[x,y] <> 0 Then DrawRect xpos,ypos,size,size
		Next
	Next
EndFunction

Function MouseInCell(x,y)
	Local xpos = x*size
	Local ypos = y*size
	
	Return(MouseX() >= xpos And MouseX() < xpos+size And MouseY() >= ypos And MouseY() < ypos+size)
EndFunction

Function DrawHollowRect(x,y,width,height)
	DrawLine x,y,x+width,y
	DrawLine x,y,x,y+height
	DrawLine x,y+height,x+width,y+height
	DrawLine x+width,y+height,x+width,y
EndFunction