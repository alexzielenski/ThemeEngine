on Export(myFilename)
	set filename to (myFilename as POSIX file) as string
	
	tell application "%@"
		try
			set dialogDisplay to (display dialogs)			
			set (display dialogs) to never
			set theDocument to current document
			set myOptions to {class:TIFF save options, image compression:none, byte order:Mac OS, save alpha channels:true, save spot colors:true, embed color profile:true, save layers:false, save image pyramid:false, transparency:true}
			save theDocument in file filename as TIFF with options myOptions appending no extension with copying
			set (display dialogs) to dialogDisplay			
		on error errorText
			set (display dialogs) to dialogDisplay
			return "error: " & errorText
		end try
	end tell
end Export

on GetFile()
	tell application "%@"
		try
			set nam to name of current document
			return nam
		on error errorText
			return "error: " & errorText
		end try
	end tell
	
end GetFile



