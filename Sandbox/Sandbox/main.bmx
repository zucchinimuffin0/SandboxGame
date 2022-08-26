'Todo:
'moddability

Const w = 800
Const h = 600

Graphics w,h

 
AppTitle = "Untitled Sandbox Game"

Global size = 10
Global box_size = Floor((h/size))-10

Global selected_type = 0

Global box[box_size,box_size]
Global ghost_box[box_size,box_size]

Include "console.bmx"
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

Include "mats.bmx"


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

	If KeyHit(KEY_TILDE) Or KeyHit(41) Then 
		FlushKeys()
		consoleopen = Not consoleopen
	EndIf

	''player_draw()

		
	If consoleopen Then
		console()
		drawconsole()
	EndIf

	
	Flip
Wend
End

Function findchar:String(strin:String,count)
	Return(Right(Left(strin,count),1))
EndFunction


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



Function ArraysEqual(ar1[,],ar2[,])
	For Local x = 0 To box_size-1
		For Local y = 0 To box_size-1
			If ar1[x,y] <> ar2[x,y] Then Return False
		Next
	Next
	Return True
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