'Load files

AutoImageFlags FILTEREDIMAGE|MASKEDIMAGE

Global fire_img:TImage = LoadImage2("graphic\fire.png",MIPMAPPEDIMAGE)
Global rock_img:TImage = LoadImage2("graphic\rock.png")
Global sand_img:TImage = LoadImage2("graphic\sand.png")
Global water_img:TImage = LoadImage2("graphic\water.png")
Global hovered_img:TImage = LoadImage2("graphic\hovered.png")

Function LoadImage2:TImage(url:Object,flags = -1)
	If LoadImage(url,flags) <> Null Then
		Print("Loaded image "+String(url))
		Return LoadImage(url,flags)
	Else
		Print("Couldn't load image '"+String(url)+"', file not found")
		Return LoadImage("assets\tile\missing.png")
	EndIf
EndFunction

Function LoadAnimImage2:TImage(url:Object,cell_width,cell_height,first_cell,cell_count,flags = -1)
	If LoadAnimImage(url,cell_width,cell_height,first_cell,cell_count,flags) <> Null Then
		Print("Loaded image "+String(url))
		Return LoadAnimImage(url,cell_width,cell_height,first_cell,cell_count,flags)
	Else
		Print("Couldn't load image '"+String(url)+"', file not found")
	EndIf
EndFunction

Function LoadImageFont2:TimageFont(url:Object,size,style = SMOOTHFONT)
	If LoadImageFont(url:Object,size,style = SMOOTHFONT) <> Null Then
		Print("Loaded font "+String(url))
		Return LoadImageFont(url:Object,size,style = SMOOTHFONT)
	Else
		Print("Couldn't load font '"+String(url)+"', file not found")
	EndIf
EndFunction