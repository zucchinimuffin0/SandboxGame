Type fire
	Field x
	Field y
	Field lifetime
EndType

Global firelist:TList = New TList

Function DrawParticles()
	For Local x = 0 To box_size-1
		For Local y = 0 To box_size-1
		
			Local xpos = x*size
			Local ypos = y*size
			
			If MouseInCell(x,y) Then
				If Mousedown(1) Then					
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
						If x+1 <= box_size-1 Then
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
				ElseIf box[x,y] = 4 Then
					If y+1 <= box_size-1 Or box[x,y+1] = 3 Then
						If box[x,y] = 4 And box[x,y+1] = 4 Then
							If x-1 >= 0 And x+1 <= box_size-1 Then
								If box[x-1,y+1] = 0 And box[x+1,y+1] = 0 Then
									box[x,y] = 0
									Select Rand(0,1)
										Case 0
											box[x-1,y] = 4
										Case 1
											box[x+1,y] = 4
									EndSelect
								ElseIf box[x-1,y+1] = 0 And box[x+1,y] = 4 Then
									box[x,y] = 0
									box[x-1,y] = 4
								ElseIf box[x+1,y+1] = 0 And box[x-1,y] = 4
									box[x,y] = 0
									box[x+1,y] = 4
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	Next
EndFunction