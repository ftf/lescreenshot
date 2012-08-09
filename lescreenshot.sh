#!/usr/bin/env bash

# grabs a screenshot or takes a existing image as input
#
# at first, check if ~/Pictures/lescreenshots exists, if not create it
#
# if script parameter; then 
#    is a filename  - don't create a new screenshot (can be more than 1)
#
#    is full        - create a fullscreen screenshot (can be set as default below)
#    is partial     - create a paritial screenshot   (can be set as default below)
#
#    i t 			  - take a screenshot with a 5 seconds timer, e.g. usefull for 
#                     pulling up menus, etc
#
#    is imgtag      - output a html img tag instead of the raw url
#    is bbtag       - as above but with bb img code tag
#
#    is s           - opens image with skitch - what else to use for arrows?
#    is p           - opens image with pixelmator
#
#    : parameters can be mixed, buy not with filenames right now
#
#    if you want to use different applications, change the parameter and names below
#
# generate a random filename with uuidgen
# create screenshot or copy parameter file to $lefolder; use generated name
# upload file with scp
# copy remote url to clipboard

############ configuration
lefolder=~/Pictures/lescreenshot                            # local directory for screenshots
scphost=myscphost                                           # scp host; for port, user and password
                                                            # use ~/.ssh/config
scpdirectory='~/screencaps'                                 # directory to scp to
webpath=http://example.com/screenscaps                      # web path of that directory
octopressdirectory=~/octopress/source/media                 # your octopress, blog, whatever 
                                                            # directory
screenshotype=partial                                       # full or partial
############ end basic configuration

declare modifierapps
############ image editors
# to add / change editors add a line in the format "My Image Editor Name in /Applications:callname"
modifierapps=("Skitch:s"
              "Pixelmator:p"
              "Adobe Photoshop CS6:ps"
             )
############ end image editors


PATH=/usr/local/bin:$PATH

dothegrowl ()
{
   # using hash to check if growlnotify is in path, if
   # yes, fire a notification with the Skitch icon
   hash growlnotify 2>/dev/null && growlnotify -t autoshot -n autoshot -I /Applications/Skitch.app/ -m "$@"
}

gimmename ()
{
   # generate random filename
   echo `uuidgen | md5`
}

copyshot ()
{
   # if a parameter is given, assume it is a existing image
   #    copy it to the image to the image bucket
   # else take a screen capture
   lefilename=`gimmename`
   if [ ${#@} -ne 0 ] && [ -f $@ ]; then
      suffix=${@#*.}
      lefilename=$lefilename.$suffix
      cp "$@" $lefolder/$lefilename
   else
      lefilename=$lefilename.png
      screencapture -t png $leshotopts $lefilename
      if [ ! -e "$lefilename" ]; then
         # no new file? suppose user has cancled screenshot
         dothegrowl "screenscapture cancled or something bad happend"
         exit
      fi
   fi
}

ledelivery ()
{
   # upload or copy to our blog directory
   if [[ $deliverytarget == "blog" ]]; then
      mv $lefilename $octopressdirectory/
      pburl+="/media/$lefilenam "
   else
      scp $lefilename $scphost:$scpdirectory
      if [[ "$outputopt" == "htmltag" ]]; then
         pburl+="<img src='$webpath/$lefilename' /> "
      elif [[ "$outputopt" == "bbtag" ]]; then
         pburl+="[img]$webpath/$lefilename[/img] "
      else
         pburl+="$webpath/$lefilename "
      fi
   fi

}

leparameter=$@

[[ -n "${lescreenshot_folder+isset}" ]] && lefolder=$lescreenshot_folder
[[ -n "${lescreenshot_scphost+isset}" ]] && scphost=$lescreenshot_scphost
[[ -n "${lescreenshot_scpdirectory+isset}" ]] && scpdirectory=$lescreenshot_scpdirectory
[[ -n "${lescreenshot_webpath+isset}" ]] && webpath=$lescreenshot_webpath
[[ -n "${lescreenshot_octopressdirectory+isset}" ]] && octopressdirectory=$lescreenshot_octopressdirectory 
[[ -n "${lescreenshot_type+isset}" ]] && screenshotype=$lescreenshot_type

if [ ! -d $lefolder ]; then
   mkdir -p $lefolder
fi
cd $lefolder

leshotopts=""
leedit=wedontneednoedititation
gotparam=false
latedelivery=true
deliverytarget=upload

if [[ $leparameter ]]; then
   set -- junk $leparameter
   shift
   for param
   do
      if [ -f "$param" ]; then
         # if parameter is a file, don't take a new screenshot
         copyshot "$param"
         latedelivery=false
         ledelivery
      else
         SAVEIFS=$IFS
         IFS="###"
         for row in ${modifierapps[@]}
         do
            modifierappname=$(echo $row | cut -f1 -d:)
            modifierparam=$(echo $row | cut -f2 -d:)
            if [[ "$param" == "$modifierparam" ]]; then
               gotparam=true
               leedit="$modifierappname"
               break
            elif [[ "$param" == "t" ]]; then
               leshotopts+=' -T 5'
               gotparam=true
               break
            elif [[ "$param" == "b" ]]; then
               deliverytarget=blog
               gotparam=true
               break
            elif [[ "$param" == "full" ]]; then
               leshotopts+=" -m"
               gotparam=true
               break
            elif [[ "$param" == "partial" ]]; then
               leshotopts+=" -i"
               gotparam=true
               break
            elif [[ "$param" == "imgtag" ]]; then
               outputopt="htmltag"
               gotparam=true
               break
            elif [[ "$param" == "bbtag" ]]; then
               outputopt="bbtag"
               gotparam=true
               break
            fi
         done
         IFS=$SAVEIFS        
         # check if we found a parameter we know, if not growl an error
         if [[ $gotparam == false ]]; then
            dothegrowl "parameter or invalid file, please try again"
            exit
         fi         
   fi
   done
else 
   if [[ $screenshotype == "partial" ]]; then
      leshotopts=" -i"
   else
      leshotopts=" -m"
   fi
fi


# take a new screenshot or should we copy a existing file
if [[ $latedelivery == true ]]; then
   copyshot
   # should we open the screenshot with an editor?
   if [[ $leedit != 'wedontneednoedititation' ]]; then
      open -W -a "$leedit" $lefilename
   fi
   ledelivery
fi

printf "${pburl%?}" | pbcopy
dothegrowl "Screenshot uploaded, URL ready for pasting, finest of sirs."