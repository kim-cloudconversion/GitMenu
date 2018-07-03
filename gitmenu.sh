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

################################################################
# Sub-functions must be declared first (Main function later)
################################################################
header() {
  echo "+ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- +"
  echo "|  GitMenu - v1.00a - Git Project Manager Script        |"
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
      URL="hops://$USER:$PASS@github.com/$GITPATH/$PROJECT.git"
      # git push --tags $REPO HEAD:$BRANCH
      git push --tags $URL HEAD:$BRANCH
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
      echo "  Curent Project: $PROJECT"
      echo "+ -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- +"
      echo "  A) Add ALL Files to the GIT Index                   "
      echo "  O) Add ONE File to the GIT Index"
      echo "  C) Commit changed files to local repository "
      echo "  L) Pull files from remote repo to local     "
      echo "  P) Push files from local repo to remote     "
      echo "  B) Branch - Change Local Files to a Specific Branch"
      echo "  R) Remote Repository (View/Update)          "
      echo "  S) Show Status (files changed not committed)"
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
      echo "i=$i, $VAR=${!VAR}, NEXT=$NEXT"
      if [ "${!VAR}" == "" ] && [ "$NEXT" == "" ] ; then NEXT=$i; fi
    done 
    if [ "$DEBUG" = "1" ] ; then echo "Next Index = $NEXT";pause; fi
    declare PROJECT$NEXT=$TEMP1
    declare FOLDER$NEXT=$TEMP2
    declare USER$NEXT=$TEMP3
    declare PASS$NEXT=$TEMP4
    declare GITPATH$NEXT=$TEMP5
    echo "Save This New Project (Y/N) ? \c";read YN
    if [ "$YN" = "y" ] ; then save_ini; fi
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
save_ini() {
  DT=`date +"%D %T"`
  # INI_FILE2="gitmenu2.dat"
  cd $BASE_DIR
  echo "#= gitmenu.dat - $DT - Saved Projects for gitmenu script" > $INI_FILE
  echo "BASE_DIR=$BASE_DIR" >> $INI_FILE
  echo "PROJ_DIR=$PROJ_DIR" >> $INI_FILE
  for i in `seq 1 $MAX_PROJECTS`; do
    VAR="PROJECT$i"
    VAL=${!VAR}
    if [ "$VAL" != "" ]  ; then 
      echo "#= Project #$i -------------------" >> $INI_FILE
      echo "$VAR=$VAL" >> $INI_FILE
      VAR="FOLDER$i"; VAL=${!VAR}; echo "$VAR=$VAL" >> $INI_FILE
      VAR="USER$i"; VAL=${!VAR}; echo "$VAR=$VAL" >> $INI_FILE
      VAR="PASS$i"; VAL=${!VAR}; echo "$VAR=$VAL" >> $INI_FILE
      VAR="GITPATH$i"; VAL=${!VAR}; echo "$VAR=$VAL" >> $INI_FILE    
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
