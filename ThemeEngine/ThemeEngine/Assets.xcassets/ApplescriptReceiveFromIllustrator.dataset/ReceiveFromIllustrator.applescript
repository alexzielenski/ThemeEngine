on Export(myFilename)
	set filename to (myFilename as POSIX file) as string
	
	tell application "%@"
		try
			set theDocument to current document
			set myOptions to {class:PDF save options, preserve editability:true}
			save theDocument in file filename as pdf with options myOptions with copying
			
		on error errorText
			return "error: " & errorText
		end try
	end tell
end Export

on GetFile()
	
	tell application "%@"
		try
			set doc to current document
			return name of current document
		on error errorText
			return "error: " & errorText
		end try
	end tell
end GetFile

GetFile()