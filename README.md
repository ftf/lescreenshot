lescreenshot
============

shell script for easy and fast uploading of a screenshot 


grabs a screenshot or takes a existing image as input

at first, check if ~/Pictures/lescreenshots exists, if not create it

if script parameter; then 
   is a filename  - don't create a new screenshot (can be more than 1)

   is full        - create a fullscreen screenshot (can be set as default below)
   is partial     - create a paritial screenshot   (can be set as default below)

   i t 			  - take a screenshot with a 5 seconds timer, e.g. usefull for 
                    pulling up menus, etc

   is imgtag      - output a html img tag instead of the raw url
   is bbtag       - as above but with bb img code tag

   is s           - opens image with skitch - what else to use for arrows?
   is p           - opens image with pixelmator

   : parameters can be mixed, buy not with filenames right now

   if you want to use different applications, change the parameter and names below

generate a random filename with uuidgen
create screenshot or copy parameter file to $lefolder; use generated name
upload file with scp
copy remote url to clipboard