'Todo:
'moddability

Const w = 800
Const h = 600

Graphics w,h

AppTitle = "Untitled Sandbox Game"

Global size = 5
Global box_size = Floor((h/size))-10

Global selected_type = 0

Global box[box_size,box_size]
Global ghost_box[box_size,box_size]

Include "loadfiles.bmx"

Global buttons:TList = New TList

Type button
	Field x
	Field y
	Field width
	Field height
	Field img:TImage
	Field selected
	
	Method newbutton(x,y,width,height,img:TImage)
		Self.x = x
		Self.y = y
		Self.width = width
		Self.height = height
		Self.img = img
		
		buttons.addlast(Self)
	EndMethod
	
	Method update()
		SetScale Self.width,Self.height
		SetColor 255,255,255
		
		If MouseX() >= Self.x And MouseX() <= Self.x + (16*Self.width) And MouseY() >= Self.y And MouseY() <= Self.y + (16*Self.height) Then
			DrawImage hovered_img,Self.x,Self.y
			
			If MouseHit(1) Then
				FlushMouse()
				
				For Local b:button = EachIn buttons
					If b <> Self Then
						b.selected = False
					EndIf
					Self.selected = True
				Next
				
			EndIf
		EndIf
		
		If Self.selected = True Then DrawImage hovered_img,Self.x,Self.y
		
		DrawImage Self.img,Self.x,Self.y
		
		SetScale 1,1
	EndMethod
	
	Method IsSelected()
		Return Self.selected
	EndMethod
EndType


Type fire
	Field x
	Field y
	Field lifetime
EndType

Global firelist:TList = New TList



Global fire_button:button = New button
fire_button.newbutton(w-100,30,2,2,fire_img)

Global water_button:button = New button
water_button.newbutton(w-50,30,2,2,water_img)

Global rock_button:button = New button
rock_button.newbutton(w-100,80,2,2,rock_img)

Global sand_button:button = New button
sand_button.newbutton(w-50,80,2,2,sand_img)

While Not KeyDown(KEY_ESCAPE)
	Cls	
		
	DrawParticles()
	UpdateParticles()

	GUI()
	
	Flip
Wend
End

Function GUI()
	SetColor 97,54,11
	drawhollowrect(0,0,box_size*size,box_size*size)
	
	DrawRect w-110,20,100,100
	
	For Local b:button = EachIn buttons
		b.update()
	Next
	
	If fire_button.isSelected() Then 
		selected_type = 1
	ElseIf water_button.isSelected() Then 
		selected_type = 2
	ElseIf rock_button.isSelected() Then 
		selected_type = 3
	ElseIf sand_button.isSelected() Then 
		selected_type = 4
	EndIf
EndFunction

Function UpdateParticles()
	ArrayCopy(box,0,ghost_box,0,box.length)
	
	
	For Local f:fire = EachIn firelist
		f.lifetime = f.lifetime - 1

		If f.y-1 >= 0 And box[f.x,f.y-1] <> 3 And box[f.x,f.y-1] <> 4 And box[f.x,f.y-1] <> 5 Then


			box[f.x,f.y] = 0
			box[f.x,f.y-1] = 1
			
			f.y = f.y - 1
			If box[f.x,f.y-1] = 2 Or box[f.x-1,f.y] = 2 Or box[f.x+1,f.y] = 2 Then
				box[f.x,f.y] = 5
				firelist.remove(f)
			EndIf
		EndIf
		
		If f.lifetime <= 0 Then
			box[f.x,f.y] = 5
			firelist.remove(f)
		EndIf
	Next
	
	For Local x = 0 To box_size-1
		For Local y = 0 To box_size-1
		
			If y-1 >= 0 Then
				If box[x,y] = 5 Then
					If box[x,y-1] = 0 Then
						box[x,y] = 0
						box[x,y-1] = 5
					ElseIf box[x,y+1] = 2 Then
						box[x,y] = 2
					EndIf		
				EndIf
			EndIf
			
			If y+1 <= box_size-1 Then
				If ghost_box[x,y+1] <> 3 Then
					If ghost_box[x,y] = 2 Then
						If box[x,y+1] <> 4 And box[x,y+1] <> 2 Then
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
					If selected_type = 1 And box[x,y] <> selected_type Then
						Local f:fire = New fire
						f.lifetime = Rand(10,30)
						f.x = x
						f.y = y
						
						firelist.addlast(f)
					EndIf
					
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
			ElseIf box[x,y] = 5 Then
				SetColor 211,226,240
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