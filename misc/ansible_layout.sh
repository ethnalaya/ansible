#!/bin/bash
BASE_DIRECTORY=$1
#Check for correct arguments
if [ "$#" -ne 1 ]; then
  echo "Usage : $0 BASE_DIRECTORY" >&2
  exit 1
fi

func_create_directory() {
  if [ ! -e $1 ]; then
    echo "Creating Directory : $1" 
    mkdir -p $1
  fi
}
func_create_file() {
  if [ ! -e $1 ]; then
    echo "Creating Fiile     : $1"
    touch $1
  fi
  if [ ! -f $1 ]; then
    echo "$1 is not a file !!!" >&2
    exit 1
  fi
}
#########################
##Configuration Section##
#########################
L1_DIRECTORIES="group_vars host_vars library filter_plugins roles environments misc"
L1_FILES="site.yml"

ROLES="base server1 tinypm tracgit icinga"
ROLES_DIRECTORIES="tasks handlers vars files templates defaults meta"
ROLES_DEFAULT_FILE="main.yml"
ROLES_NULL_DIRECTORIES="files templates"
#######################
## Execution section ##
#######################
#Create base directory if not exists
func_create_directory $BASE_DIRECTORY

for EACH_DIR in $L1_DIRECTORIES; do
  func_create_directory "$BASE_DIRECTORY/$EACH_DIR"
done

for EACH_FILE in $L1_FILES; do
  func_create_file "$BASE_DIRECTORY/$EACH_FILE"
done

for EACH_DIR in $ROLES; do
  CURRENT_ROLE_BASE="$BASE_DIRECTORY/roles/$EACH_DIR"
  func_create_directory $CURRENT_ROLE_BASE
  for EACH_ROLE_DIR in $ROLES_DIRECTORIES; do
    func_create_directory "$CURRENT_ROLE_BASE/$EACH_ROLE_DIR"
    if [ "$EACH_ROLE_DIR" != "files" ] && [ "$EACH_ROLE_DIR" != "templates" ]; then
      func_create_file "$CURRENT_ROLE_BASE/$EACH_ROLE_DIR/$ROLES_DEFAULT_FILE"
    fi
  done
done
