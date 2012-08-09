lescreenshot
============

Shell script for easy and fast uploading of a screenshot. (Uses screencapture for taking a screenshot, which is a OS X default tool)

Grabs a screenshot or takes a existing image as input, gives it a nice unique generated name, uploads it and fills the clipboard with the image URL.

Usage
=====

	./lescreenshot
Take a screenshot and upload it, no questions asked.

	./lescreenshot ~/Downloads/animage001.png
Upload an existing image.

	./lescreenshot p
Take a screenshot and open it for further editing in Pixelmator, quit Pixelmator to start the upload.

Paramenters
===========
+ a filename
+ full - create a fullscreen screenshot of the main display (the one with the menubar)
+ partial - select an area of the screen to be photocopied
+ t - gives you 5 seconds before the screenshot is actually taken, e.g. usefull for pulling up menues
+ imgtag - Copy an <img /> tag to your clipboard instead of the raw URL
+ bbtag - as above, but with bb [img] tag
+ Editors:
  + s - Skitch.app (I like the arrows..)
  + ps - Good old Photoshop CS6
  + p - Pixelmator.app
  + Edit the script of different editors.

Parameters can be mixed, but not with filenames right now

Configuration
====
Either edit the variables in the script or set enviroment variables. 

	$lescreenshot_folder
	$lescreenshot_scphost
	$lescreenshot_scpdirectory
	$lescreenshot_webpath
	$lescreenshot_octopressdirectory 
	$lescreenshot_type

Since arrays are a bug of hurt you can set the image editors only inside the script itself.


	modifierapps=("My awesome image editor:awsome_abbr
	 "Skitch:s"
	 "Pixelmator:p"
	 "Adobe Photoshop CS6:ps"
	)

