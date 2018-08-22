#!/bin/sh
OPT=""
DONE="no"
FOLDER=""
#--------------------------------------------------
BASE_DIR=`pwd` # Where you are sitting
PROJ_DIR="/Users/kimkitchen/Documents/workspace"
#--------------------------------------------------
# Set Base URL on GitHub (Where GitHub stores your projects)
GIT_URL=https://github.com/kim-cloudconversion
PROJECT=""
FOLDER=""
USER=""
PASS=""
GITPATH=""
INI_FILE="gitmenu.dat"
OLDDIR=`pwd`
REPO="origin"
DEBUG=0
MAX_PROJECTS=20
INDEX=0
# PROJECT1="xxx"
BOLD=$(tput bold)
NORM=$(tput sgr0)

################################################################
# Sub-functions must be declared first (Main function later)
################################################################
header() {
  echo "+ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- +"
  echo "|  ${BOLD}GitMenu${NORM} - v1.00a - Git Project Manager Script        |"
  echo "+ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- +"
  if [ "$DEBUG" == "1" ]
     then 
     echo " -- Debug is Enabled."
     echo " -- Currently in $PWD"
     fi
}
################################################################
add_all() {
  if [ "$DEBUG" = "1" ]
    then
    echo "PROJ_DIR=$PROJ_DIR"
    echo "PROJECT=$PROJECT"
    echo "FOLDER=$FOLDER"
    echo "USER=$USER"
    echo "PASS=$PASS"
    echo "GITPATH=$GITPATH"
    echo "Current Dir: `pwd`"
    pause
    fi
  echo "Adding All Files to GIT Index ..."
  git add --all
  echo "Done !"
  pause
}
################################################################
add_one() {
  echo "Please Enter Filename (relative to $FOLDER) ->\c"
  read FILENAME
  echo "Adding $FILENAME to GIT Index ..."
  git add $FILENAME
  echo "Done !"
  pause
}
################################################################
commit() {
  echo "Commit Changes to $PROJECT ..."
  echo "$PWD"
  echo "Please Enter your Descriptive Commit Message"
  read MESG
  git commit -a -m '$MESG'
  pause
}
################################################################
push() {
  YN=
  BRANCH=
  echo "Are you SURE you want to PUSH $PROJECT up to GITHUB (Y/N) ? \c"
  read YN
  if [ "$YN" = "y" ] ; then
    echo ""
    echo "D) Development Branch"
    echo "M) Master Branch"
    echo "Select Branch to PUSH ->\c"; read B
    case $B in
      d|D) BRANCH="development";;
      m|M) BRANCH="master";;
      *) echo "No Branch Selected, PUSH Cancelled";pause;;
    esac
    if [ "$BRANCH" != "" ] ; then
      echo "Pushing $PROJECT $BRANCH Branch up to GITHUB ..."
      # URL="https://$USER:$PASS@github.com/$GITPATH/$PROJECT.git"
      git push --tags $REPO HEAD:$BRANCH
      # git push --tags $URL HEAD:$BRANCH
      echo "Done !"
      pause
    fi
  fi
}

################################################################
pull() {
  YN=
  BRANCH=
  echo "Are you SURE you want to PULL $PROJECT down from GITHUB (Y/N) ? \c"
  read YN
  if [ "$YN" = "y" ] ; then
    echo ""
    echo "D) Development Branch"
    echo "M) Master Branch"
    echo "Select Branch to PUSH ->\c"; read B
    case $B in
      d|D) BRANCH="development";;
      m|M) BRANCH="master";;
      *) echo "No Branch Selected, PUSH Cancelled";pause;;
    esac
    if [ "$BRANCH" != "" ] ; then
      echo "Pulling $PROJECT $BRANCH Branch down from GITHUB ..."
      # URL="https://$USER:$PASS@github.com/$GITPATH/$PROJECT.git"
      git pull --tags $REPO $BRANCH
      # git push --tags $URL HEAD:$BRANCH
      echo "Done !"
      pause
    fi
  fi
}

################################################################
project_menu() {
  if [ "$DEBUG" = "1" ]
    then
    echo "PROJ_DIR=$PROJ_DIR"
    echo "PROJECT=$PROJECT"
    echo "FOLDER=$FOLDER"
    echo "USER=$USER"
    echo "PASS=$PASS"
    echo "GITPATH=$GITPATH"
    pause
    fi
  cd $PROJ_DIR/$FOLDER
  DONE2=no
  while [ "$DONE2" = "no" ]
    do
      clear
      header
      echo "  Curent Project: ${BOLD}$PROJECT${NORM}"
      echo "+ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- +"
      echo "  A) Add ALL Files to the GIT Index                   "
      echo "  O) Add ONE File to the GIT Index"
      echo "  C) Commit changed files to local repository "
      echo "  L) Pull files from remote repo to local     "
      echo "  P) Push files from local repo to remote     "
      echo "  B) Branch - Change Local Files to a Specific Branch"
      echo "  R) Refresh from Remote Repository"
      echo "  S) Show Status (files changed not committed)"
      echo "  U) Update Remote Repository (View/Add/Remove)"
      echo "  D) Salesforce DX Menu."
      echo "  Q or X) Quit (Exit)                         "
      echo ""
      echo "Please Select ->\c"
      read OPT2
      case $OPT2 in
          a|A) add_all;;
          o|O) add_one;;
          c|C) commit;;
          p|P) push;;
          l|L) pull;;
          r|R) refresh;;
          b|B) branch;;
          s|S) git status; pause;;
          e|E) edit_project;;
          u|U) update;;
          d|D) sfdx_menu;;
          q|Q|x|X) DONE2="yes";;
	  *) echo "You Chose '$OPT2'"
             echo "Press [Enter] to continue \c";read JUNK;;
      esac
   done
   cd ..
}
################################################################
remote_repo() {
  echo "Remote_Repo Function is not active yet"
  pause 
}
################################################################
pause() {
  printf "Press [Enter] to Continue ";read JUNK
}
################################################################
setvar() {
  ${!1}=$2
}
################################################################
add_project() {
  clear
  header
  echo "Add a New Project ..."
  echo "Please Enter the Project Name ->\c";read TEMP1
  echo "Please Enter the Project Folder ->\c";read TEMP2
  echo "Please Enter your GIT Username ->\c";read TEMP3
  echo "Please Enter your GIT Password ->\c";read TEMP4
  echo "Please Enter the GIT Path ->\c";read TEMP5
  if [ "$TEMP1" != "" ] && [ "$TEMP2" != "" ]
    then
    NEXT=
    for i in `seq 1 $MAX_PROJECTS`; do
      VAR="PROJECT$i"
      # echo "i=$i, $VAR=${!VAR}, NEXT=$NEXT"
      if [ "${!VAR}" == "" ] && [ "$NEXT" == "" ] ; then NEXT=$i; fi
    done 
    if [ "$DEBUG" = "1" ] ; then echo "Next Index = $NEXT";pause; fi
    declare PROJECT$NEXT=$TEMP1
    declare FOLDER$NEXT=$TEMP2
    declare USER$NEXT=$TEMP3
    declare PASS$NEXT=$TEMP4
    declare GITPATH$NEXT=$TEMP5
    echo "Save This New Project (Y/N) ? \c";read YN
    if [ "$YN" = "y" ] ; then 
      save_ini; 
      if [ ! -d $TEMP2 ] ; then
	echo "Creating Folder $TEMP2 ..."
        mkdir $TEMP2;
        chmod 777 $TEMP2
        fi
      cd $TEMP2
      if [ ! -d .git ]
        then
        echo "Initializing GIT Repository ..."
        git init
        echo "Done !"
        fi
      cd ..
      if [ ! -f packages.txt ]
        then
        echo "Add packages.txt (Y/N) ? \c"; read YN2
        if [ "$YN2" == "y" ] ; then
          echo "04tA00000003FAY         ECS V16.93" > packages.txt;
          echo "04t80000000ciLdAAI      eCommSource V13.96" >> packages.txt
          echo "ECS and eCommSource Packages added to packages.txt"
          echo "packages.txt" >> .forceignore
          echo "packages.txt added to .forceignore file"
          fi 
        fi
      fi
  fi
pause
}
################################################################
edit_project() {
  echo "Edit $PROJECT Project (#$INDEX) Settings ..."
  echo "Project Name should match GITHUB Repository Name"
  echo "Enter Project Name ->\c";read TEMP1
  echo 
  echo "FOLDER (relative to $PROJ_DIR) is your local Project Folder"
  echo "FOLDER=$FOLDER"
  echo "Enter FOLDER ->\c"; read TEMP2
  echo 
  echo "USER is your GITHUB Username"
  echo "USER=$USER"
  echo "Enter GITHUB Username ->\c"; read TEMP3
  echo 
  echo "PASS = your GITHUB Password."
  echo "PASS=$PASS"
  echo "Enter GITHUB Password ->\c"; read TEMP4
  echo
  echo "GITPATH is the Github Repository Path."
  echo "GITPATH=$GITPATH"
  echo "Enter GITPATH ->\c"; read TEMP5
  if [ "$TEMP1" != "" ] ; then PROJECT=$TEMP1 ; fi
  if [ "$TEMP2" != "" ] ; then FOLDER=$TEMP2 ; fi
  if [ "$TEMP3" != "" ] ; then USER=$TEMP3 ; fi
  if [ "$TEMP4" != "" ] ; then PASS=$TEMP4 ; fi
  if [ "$TEMP5" != "" ] ; then GITPATH=$TEMP5 ; fi
  set PROJECT$INDEX=$PROJECT
  setFOLDER$INDEX=$FOLDER
  set USER$INDEX=$USER
  set PASS$INDEX=$PASS
  set GITPATH$INDEX=$GITPATH
  echo "PROJECT=$PROJECT"
  echo "FOLDER=$FOLDER"
  echo "USER=$USER"
  echo "PASS=$PASS"
  echo "GITPATH=$GITPATH"
  
  YN=
  echo "Save These Changes (Y/N) ? \c"; read YN
  if [ "$YN" == "y" ] ; then save_ini ; else echo "Project Not Saved !" ; fi
  pause
}
################################################################
delete_project() {
    clear
    header
    echo "  DELETE A Saved Project"
    echo "  Choose a Project to Delete..."
    for i in `seq 1 $MAX_PROJECTS`; do 
      VAR="PROJECT$i"
      VAL=${!VAR}
      if [ "${!VAR}" != "" ]; then echo "  $i) ${!VAR}"; fi
      done
    echo "  Q or X) Quit (Without Deleting)"
    echo ""
    echo "Please Select ->\c"
    read OPT5
    case $OPT5 in
	q|Q|x|X) DONE5="yes";;
	*) VAR="PROJECT$OPT5"
           VAL=${!VAR}
           if [ "$VAL" != "" ]; then
             echo "  Are you SURE you want to DELETE PROJECT $VAL (Y/N) ? \c";
             read YN1;
             if [ "$YN1" == "y" ] ; then
               VAR="FOLDER$OPT5"
               VAL=${!VAR}
               echo "  FOLDER $VAL will be left intact."
               unset PROJECT$OPT5
               unset FOLDER$OPT5
               unset USER$OPT5
               unset PASS$OPT5
               unset GITPATH$OPT5
               save_ini
               pause
             else
               echo "  Project $VAL WAS NOT Deleted !"
               pause
               fi
           else
             echo "You Chose '$OPT5'"
             echo "Press [Enter] to continue /c";read JUNK
             fi ;;
    esac
  
}
################################################################
save_ini() {
  DT=`date +"%D %T"`
  # INI_FILE2="gitmenu2.dat"
  cd $BASE_DIR
  echo "#= gitmenu.dat - $DT - Saved Projects for gitmenu script" > $INI_FILE
  echo "BASE_DIR=$BASE_DIR" >> $INI_FILE
  echo "PROJ_DIR=$PROJ_DIR" >> $INI_FILE
  j=1;
  for i in `seq 1 $MAX_PROJECTS`; do
    VAR="PROJECT$i"
    VAL=${!VAR}
    if [ "$VAL" != "" ]  ; then 
      echo "#= Project #$j -------------------" >> $INI_FILE
      echo "PROJECT$j=$VAL" >> $INI_FILE
      VAR="FOLDER$i"; VAL=${!VAR}; echo "FOLDER$j=$VAL" >> $INI_FILE
      VAR="USER$i"; VAL=${!VAR}; echo "USER$j=$VAL" >> $INI_FILE
      VAR="PASS$i"; VAL=${!VAR}; echo "PASS$j=$VAL" >> $INI_FILE
      VAR="GITPATH$i"; VAL=${!VAR}; echo "GITPATH$j=$VAL" >> $INI_FILE 
      j=$((j + 1))  
    fi
  done 
  echo "$INI_FILE Saved Successfully !"
}

################################################################
settings() {
  echo "Edit Master Settings ..."
  echo "BASE_DIR is where this script and $INI_FILE resides."
  echo "BASE_DIR=$BASE_DIR"
  echo "Enter New BASE_DIR ->\c";read TEMP1
  echo ""
  echo "PROJ_DIR is where your project folders reside."
  echo "PROJ_DIR=$PROJ_DIR"
  echo "Enter New PROJ_DIR ->\c";read TEMP2
  if [ "$TEMP1" != "" ] ; then BASE_DIR=$TEMP1 ; fi
  if [ "$TEMP2" != "" ] ; then PROJ_DIR=$TEMP2 ; fi
  echo
  echo "BASE_DIR=$BASE_DIR"
  echo "PROJ_DIR=$PROJ_DIR"
  YN=
  echo "Save These Values (Y/N) ? \c";read YN
  if [ "$YN" == "y" ] ; then save_ini ; else echo "Settings Not Saved !" ; fi
  pause
}
################################################################
update() {
  DONE3="no"
  while [ "$DONE3" == "no" ]
    do
    clear
    header
    echo "Update Remote Repositories ..."
    git remote -v
    echo
    echo "  A) Add New GIT Remote. "
    echo "  R) Remove a GIT Remote. "
    echo "  I) Initialize Local GIT Repository."
    echo "  Q or X) Quit (Exit)."
    echo "Please Select ->\c"; read OPT3
    case $OPT3 in
      a|A) echo "Please Enter a Remote Name (origin) ->\c";read TEMP1
           if [ "$TEMP1" == "" ] ; then TEMP1="origin"; fi
           git remote add $TEMP1 --tags https://github.com/$GITPATH/$PROJECT.git
           pause ;;
      r|R) echo "Please Enter the Remote Name to Remove (origin) ->\c";read TEMP1
           if [ "$TEMP1" == "" ] ; then TEMP1="origin"; fi
           YN=
           echo "Are you SURE you want to REMOVE $TEMP1 (Y/N) ? \c";read YN
           if [ "$YN" == "y" ]
             then
             git remote remove $TEMP1
           else echo "Remote Not Removed !"; 
           fi
           pause ;;
      i|I) git init
           echo "Git Repository Initialized !";pause;;
      q|Q|x|X) DONE3="yes";;
      *) echo "$OPT3 is not a valid option.";pause;;
    esac
  done 
}
################################################################
sfdx_menu() {
  DONE4="no"
  while [ "$DONE4" == "no" ]
    do
    clear
    header
    echo "  Salesforce DX Menu ..."
    echo "  Curent Project: ${BOLD}$PROJECT${NORM}"
    echo "+ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- +"
    echo "  O) Open Salesforce DX DevHub (browser)."
    echo "  L) List Salesforce DX Orgs."
    echo "  C) Create a Scratch Org."
    echo "  D) Delete a Scratch Org."
    echo "  E) Export Data from Scratch Org."
    echo "  I) Import Data into Scratch Org."
    echo "  P) Push Source to a Scratch Org."
    echo "  U) Pull Source from a Scratch Org."
    echo "  V) View Latest Push/Pull Errors."
    echo "  A) Add Prerequisite Packages."

    echo "  Q or X) Quit (Exit SFDX Menu)"
    echo "Please Select ->\c"; read OPT4
    case $OPT4 in
        o|O) sfdx force:org:list
             echo "Please Enter Org Alias to Open ->\c";read ORGNAME
	     sfdx force:org:open -u "$ORGNAME" ; pause ;;
        l|L) sfdx force:org:list; pause ;;
        c|C) echo "Please Enter a Unique Name for this scratch org ->\c";read ORGNAME
             echo "Creating $ORGNAME Scratch Org ..."
             sfdx force:org:create -a "$ORGNAME" -d 30 -s -v $USER edition=Developer
             echo "NOTE: Please Copy the Username above ..."
             pause
             if [ -f packages.txt ] ; then
               echo "Install Prerequisite Packages (Y/N) ? \c";read YN4B
               if [ "$YN4B" == "y" ] ; then
                 for PKG in `cut -f 1 packages.txt`
                   do
                   # sfdx force:package:install --package $PKG -u Spree-Dev
                   NAME=`grep $PKG packages.txt | cut -f 2,3,4`
                   echo "Installing $NAME ...\c"
                   RESULT=`sfdx force:package:install --package $PKG -u $ORGNAME`
                   CMD=`echo $RESULT | cut -f 13-18 -d ' '`
                   echo "CMD=$CMD"
                   echo "waiting on package install ...\c";
                   STAT=
                   while [ "$STAT" == "" ]
                     do
                     sleep 5
                     echo ".\c"
                     TEMP=`eval "$CMD"`
                     STAT1=`echo $TEMP | grep Successfully`
                     STAT2=`echo $TEMP | grep ERROR`
                     if [ "$STAT1" != "" -a "$STAT2" == "" ] ; then STAT=$STAT1; fi
                     if [ "$STAT1" == "" -a "$STAT2" != "" ] ; then STAT=$STAT2; fi
                     done
                   if [ "$STAT2" != "" ]
                     then
                     echo "$NAME: $STAT2"
                     break;
                     fi
                   echo " Done!"
                   done
                 echo "All Packages Installed !"
                 fi
               fi
             echo "Push This Project to $ORGNAME (Y/N) \c";read YESNO4
             if [ "$YESNO4" == "y" ] ; then 
               echo "Pushing $PROJECT Source to $ORGNAME org (This may take a while) ..."
               DT=`date`
               echo "Push Request to $ORGNAME - $DT" > pull_errors.txt
               sfdx force:source:push -u $ORGNAME >> push_errors.txt
               cat push_errors.txt
               pause
               for FILE in *.json
                 do
                 YN4C=
                 NAME=`echo $FILE | cut -f 1 -d '.'`
                 if [ "$NAME" != "sfdx-project" ] ; then
                   echo "Push $NAME Data to $ORGNAME (Y/N) ? \c";read YN4C
                   if [ "$YN4C" == "y" ] ; then
                     sfdx force:data:tree:import -f $FILE -u $ORGNAME
                     fi
                   fi
                 done
             fi 
             echo "Open this org in your browser (Y/N) ? \c";read YN4A
             if [ "$YN4A" == "y" ] ; then sfdx force:org:open -u "$ORGNAME" ; fi
             ;;
        d|D) sfdx force:org:list
             echo "Please Enter Org to Delete ->\c";read ORGNAME
             echo "Are you SURE you want to DELETE $ORGNAME (Y/N) \c";read YN4
             if [ "$YN4" == "y" ] ; then
               sfdx force:org:delete -u $ORGNAME -p
               pause
             fi ;;
        e|E) echo "Export Tata from Scratch Org (to Import into another Scratch Org)"
             ORGNAME=
             echo "Please Enter Org to Export From ->\c";read ORGNAME
             if [ "$ORGNAME" != "" ] ; then
               echo "Please Enter your SOQL Query:";read QUERY
               if [ "$QUERY" != "" ] ; then
                 RESP=`sfdx force:data:tree:export -q "$QUERY" -u $ORGNAME`
                 echo $RESP
                 FILE=`echo $RESP | cut -f 5 -d ' '`
                 TEMP=`grep $FILE .forceignore`
                 if [ "$TEMP" == "" ] ; then
                   echo $FILE >> .forceignore
                   echo "$FILE Added to .forceignore"
                   fi
                 pause
                 fi
               fi
             ;;
        i|I) echo "Import Data into a Scratch Org:"
             ORGNAME=
             echo "Please Enter Org to Import Into ->\c";read ORGNAME
             if [ "$ORGNAME" != "" ] ; then
               for FILE in *.json
                 do
                 YN4C=
                 NAME=`echo $FILE | cut -f 1 -d '.'`
                 if [ "$NAME" != "sfdx-project" ] ; then
                   echo "Push $NAME Data to $ORGNAME (Y/N) ? \c";read YN4C
                   if [ "$YN4C" == "y" ] ; then
                     sfdx force:data:tree:import -f $FILE -u $ORGNAME
                     fi
                   fi
                 done
               pause
               fi
             ;;
        p|P) sfdx force:org:list
             echo "Please Enter Org to Push to ->\c";read ORGNAME
             echo "Are you SURE you want to PUSH to $ORGNAME (Y/N) \c";read YN4
             if [ "$YN4" == "y" ] ; then
               echo "Pushing $PROJECT Source to $ORGNAME org (This may take a while) ..."
               DT=`date`
               echo "Push Request to $ORGNAME - $DT" > pull_errors.txt
               sfdx force:source:push -u $ORGNAME >> push_errors.txt
               cat push_errors.txt
               pause
             fi ;;
        u|U) sfdx force:org:list
             echo "Please Enter Org to Pull From ->\c";read ORGNAME
             echo "Are you SURE you want to PULL FROM $ORGNAME (Y/N) \c";read YN4
             if [ "$YN4" == "y" ] ; then
               echo "Pulling $PROJECT Source from $ORGNAME org (This may take a while) ..."
               DT=`date`
               echo "Pull Request from $ORGNAME - $DT" > pull_errors.txt
               sfdx force:source:pull -u $ORGNAME >> pull_errors.txt
               cat pull_errors.txt
               pause
             fi ;;
        v|V) echo "View Latest Push/Pull Errors:"
             echo "  P) View Latest PUSH Errors."
             echo "  L) View Latest PULL Errors."
             echo "Please Choose ->\c";read PP
             case $PP in
               p|P) cat push_errors.txt; pause;;
               l|L) cat pull_errors.txt; pause;;
               *) ;;
             esac ;;
        a|A) echo "Add Prerequisite Packages to deploy when creating Scratch Orgs:"
             echo "Existing Packages (packages.txt):"
             cat packages.txt
             PKGID=
             echo "Please Enter Package ID (04t...) ->\c"; read PKGID;
             if [ "$PKGID" != "" ] ; then
               TEMP=`grep $PKGID packages.txt`
               if [ "$TEMP" != "" ] ; then
                 echo "Please Enter Package Name/Version ->\c"; read PKGNAME
                 if [ "$PKGNAME" != "" ] ; then
                   echo "$PKGID\t$PKGNAME" >> packages.txt
                   echo "$PKGNAME ($PKGID) Added."
                   pause
                 else
                   echo "Cancelled because you didn't enter a Package Name."
                   pause
                   fi
               else
                 echo "Package $PKGID Already Exists in packages.txt"
                 pause
                 fi
             else
               echo "Cancelled because you didn't enter a Package ID."
               fi 
             ;;
      	q|Q|x|X) DONE4="yes";;
      	*) echo "$OPT4 is not a valid option.";pause;;
    esac
  done	
}
################################################################
################################################################
################################################################
################################################################
# Main Function
################################################################
# load_ini
# pause
while [ "$DONE" == "no" ]
  do
    #------ Load the ini file ---------`
    if [ -f $INI_FILE ]
      then
      TEMP=`grep BASE_DIR $INI_FILE | cut -f 2 -d =`

      if [ "$TEMP" != "" ]; then BASE_DIR=${TEMP//[$'\t\n\r']}; fi
      TEMP=`grep PROJ_DIR $INI_FILE | cut -f 2 -d =`
      if [ "$TEMP" != "" ]; then PROJ_DIR=${TEMP//[$'\t\n\r']}; fi
      CDPATH=$PROJ_DIR
      for i in `seq 1 $MAX_PROJECTS`; do 
        TEMP1=`grep PROJECT$i $INI_FILE | cut -f 2 -d =`
        if [ "$TEMP1" != "" ]
          then
          declare PROJECT$i=${TEMP1//[$'\t\n\r']}
          TEMP2=`grep FOLDER$i $INI_FILE | cut -f 2 -d =`
          declare FOLDER$i=${TEMP2//[$'\t\n\r']}
          TEMP3=`grep USER$i $INI_FILE | cut -f 2 -d =`
          declare USER$i=${TEMP3//[$'\t\n\r']}
          TEMP4=`grep PASS$i $INI_FILE | cut -f 2 -d =`
          declare PASS$i=${TEMP4//[$'\t\n\r']}
          TEMP5=`grep GITPATH$i $INI_FILE | cut -f 2 -d =`
          declare GITPATH$i=${TEMP5//[$'\t\n\r']}
          CDPATH=$CDPATH:$PROJ_DIR/$TEMP2
          fi
       done
      fi
    # -------- ini file loaded, run the main menu --------
    
    cd $PROJ_DIR
    clear
    header
    echo "  Choose a Saved Project ..."
    for i in `seq 1 $MAX_PROJECTS`; do 
      VAR="PROJECT$i"
      VAL=${!VAR}
      if [ "${!VAR}" != "" ]; then echo "  $i) ${!VAR}"; fi
      done
    echo "   "
    echo "  A) Add a New Project"
    echo "  D) Delete a Saved Project"
    echo "  S) Edit Master Settings"
    echo "  Q or X) Quit (Exit) "
    echo ""
    echo "Please Select ->\c"
    read OPT
    case $OPT in
        a|A)  add_project;;
        d|D)  delete_project;;
        s|S) settings;;
	q|Q|x|X) DONE="yes";;
        z|Z) if [ "$DEBUG" = "1" ]; then DEBUG=0; else DEBUG=1; fi ;;
        c|C) clear; set; pause;;
	*) VAR="PROJECT$OPT"
           VAL=${!VAR}
           if [ "$VAL" != "" ]; then
             INDEX=$OPT
             PROJECT=$VAL
             VAR="FOLDER$OPT"
             FOLDER=${!VAR}
             VAR="USER$OPT"
             USER=${!VAR}
             VAR="PASS$OPT"
             PASS=${!VAR}
             VAR="GITPATH$OPT"
             GITPATH=${!VAR}
             project_menu
           else
             echo "You Chose '$OPT'"
             echo "Press [Enter] to continue /c";read JUNK
             fi ;;
    esac
  done
echo "Bye!"
exit 0
