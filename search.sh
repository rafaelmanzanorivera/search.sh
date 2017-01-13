#!/bin/bash

#AUTHOR Rafael Manzano Rivera

#BASH_VERSION
#4.3.46(1)-release

#Ubuntu 16.04.1 LTS

# Parsing list of arguments 

# Usage: script <dir> <criteria> <actiona>
# 
# Criteria: [-t|-n|-c|-p]

# File type selection: -t [f|d] (f for files, d for dirs) 

# Name selection: -n <string>  (objects matching the string on name)
# Contain string selection: -c <string> (files that contain the specified string)
# Name selection and contain string selection are exclusive between them


# Perms selection: -p [ r-- | rw- | r-x | rwx ] (use like ls -l output)

# Actions: 
#       PRINT      -print ------------> Print items matching criteria
#       PIPE       -pipe[command]-----> Passes the final matching list to another program
#       EXEC       -exec[command] ----> Executes a program for each item in matching list
#       RECURSIVE  -r ----------------> Makes the script call itself in each of the subdirectories
#                                           with the same parameters


declare -a ALL_NAMES        #Stores the name of every item in dir
declare -a NAME_MATCHES     #Stores the name of items matching type and name or string
declare -a ITEM_PERMS       #Stores permissions in octal format of every item in name matches
declare -a OWNERS_COL       #Stores the owner of each item in name matches
declare -a GROUPS_COL       #Stores the group of the owner of each item in name matches
declare -a ALL_MATCH        #Stores the items matching all parameters



####################################################################################
#########################                               ############################
#########################    ERROR CHECKING FUNCTIONS   ############################
#########################                               ############################
####################################################################################


#########################################################################
#                                                                       #
#                              SHOW ERROR                               # 
#                                                                       #
#                     Shows the different errors                        #
#                                                                       #
#########################################################################


function showError 
{
  echo "$0: Error($1), $2"
}



###################################################################
#                                                                 #
#                   CHECK PARAMETER ERRORS                        #
#                                                                 #
#             Check errors in the parameters given:               #
#                -All necesary options specified                  #
#                -Compatible options selected                     #
#                                                                 #
###################################################################


function checkParameterErrors
{
    if [[ -z "$NAME"  && -z "$STRING" ]]; then
        showError 6 "Specify name of file/directory (-n) or string(-c) to search for"
        usageAndExit
        exit 6
    fi

    if [[ -z "$PERM" ]]; then
        showError 4 "Specify permissions to search for"
        usageAndExit
        exit 4
    fi

    if [[ -z "$TYPE" ]]; then
        showError 2 "Specify type to search for"
        usageAndExit
        exit 2
    fi

    if [[ "$TYPE" == "d" && ! -z "$STRING" ]]; then
        showError 7 "Cannot use string search for directories, change type (-t) to files (f)"
        usageAndExit
        exit 7
    fi

    prog=$0
    if [[ $RECURSIVE == "-r" &&  ${prog:0:1} == "."  ]]; then 
        showError 11 "Using recursive you must run the script specifying absolute path"
        exit 11
    fi

}



########################################################################
#                                                                      # 
#                          CHECK DIRECTORY                             #
#                                                                      #
#           Check if specified directory is readable, if not           #
#           show error and exit                                        #
#                                                                      #
########################################################################


function checkDirectory
{

    if [ ! -r $DIR ]; then
        showError 1 "Cannot read '$DIR'"
        exit 1
    fi

}




#########################################################################
#                                                                       #
#                              USAGE AND EXIT                           #
#                                                                       #
#                     Shows how to use the command                      #
#                                                                       #
#########################################################################


function usageAndExit 
{
  echo "Usage: search <dir> <criteria> <action>"
  echo "DIR: absobute or relative"
  echo "CRITERIA:  -t[f|d]  +  (-n [string] | -c [string]) + -p [---]"
  echo "ACTIONS: ( -print | -r | -pipe [command] | -exec [command]) "
  exit 0
}



#########################################################################
#                                                                       #
#                        CHECK COMMAND EXISTANCE                        #
#                                                                       #
#       Parses the first word of the parameter given as command         #
#       and checks if it is available in the machine                    #                                                                                   
#                                                                       #
#########################################################################


function checkCommandExistance
{
    [[ ${1} =~ \ *([^\ ]*) ]]
    finalcommand=${BASH_REMATCH[1]}

    if ! command -v $finalcommand > /dev/null 2>&1; then
        showError 14 "Cannot continue, $finalcommand is not a valid command"
        exit 14
    fi
}




####################################################################################
#########################                               ############################
#########################      PRINCIPAL FUNCTIONS      ############################
#########################                               ############################
####################################################################################

# In order of appearance in main




###################################################################
#                                                                 #
#                      FIND BY TYPE AND NAME                      #
#                                                                 #
#        Get items in DIR matching TYPE and NAME                  #
#        save them in array NAME_MATCHES                          #
#                                                                 #
###################################################################

function findByTypeNName
{
    case $TYPE in

        #Directories

        d)

        IFS=$'\n'
        e=0

        for file in "$DIR"/*; do 

            this=${file##*/}
            ALL_NAMES[e++]="${this}"

        done

        for ((i=0; i<=${#ALL_NAMES[@]}; i++)); do 

            string="${ALL_NAMES[i]}"
            substring="$NAME"

            if [[ "${string/$substring}" != "$string" && -d "${ALL_NAMES[i]}" ]] ; then
                NAME_MATCHES+=("${ALL_NAMES[i]}")
            fi

        done
        ;;


        # Files

        f)

        IFS=$'\n'
        e=0

        for file in "$DIR"/*; do 
            this=${file##*/}
            ALL_NAMES[e++]="${this}"
        done

        for ((i=0; i<=${#ALL_NAMES[@]}; i++)); do 

            string="${ALL_NAMES[i]}"
            substring="$NAME"

            if [[ "${string/$substring}" != "$string" &&  -f "${ALL_NAMES[i]}" ]] ; then
                NAME_MATCHES+=("${ALL_NAMES[i]}")
            fi

        done
        ;;


        # Unknown

        *)
        showError 3 "Not valid tyoe option: $TYPE"
        exit 3
        ;;

    esac

}

###################################################################
#                                                                 #
#                     FIND BY TYPE AND STRING                     #
#                                                                 #
#        Get items in DIR matching STRING                         #
#        save them in array NAME_MATCHES                          #
#                                                                 #
###################################################################

function findByTypeNString
{
        IFS=$'\n'
        e=0
        for file in "$DIR"/*; do 
            this=${file##*/}
            ALL_NAMES[e++]="${this}"
        done

        for ((i=0; i<=${#ALL_NAMES[@]}; i++)); do 

            if [ -f "${ALL_NAMES[i]}" ] ; then # if is file,
                
                if [ -r ${ALL_NAMES[i]} ] ; then # is readable,

                    string=$(cat "${ALL_NAMES[i]}")
                    substring="$STRING"

                    if [ "${string/$substring}" != "$string" ] ; then # and content matches STRING
                        NAME_MATCHES+=("${ALL_NAMES[i]}")
                    fi
                else 
                    showError 10 "No se puede leer el archivo ${ALL_NAMES[i]}"
                fi
            fi


        done

}



###################################################################
#                                                                 #
#                            GET PERMS                            # 
#                                                                 # 
#     Get perms of each item in NAME_MATCHES in octal format,     #
#     saves them in array  ITEM_PERMS                             #
#                                                                 #
###################################################################

function getPerms
{
    for i in ${!NAME_MATCHES[@]}
    do
      #echo "Perms of ${NAME_MATCHES[i]} are $(stat -c "%a %n" "$DIR"/"${NAME_MATCHES[i]}" | head -n1 | cut -d " " -f1)"
      ITEM_PERMS+=($(stat -c "%a %n" "$DIR"/"${NAME_MATCHES[i]}" | head -n1 | cut -d " " -f1))
    done

}


####################################################################
#                                                                  #
#                        GET OWNER AND GROUP                       #
#                                                                  #
#       Get owners and groups of each item in NAME_MATCHES,        #
#       saves them in two arrays OWNERS_COL and GROUPS_COL         #
#                                                                  #
####################################################################

function getOwnerAndGroup
{
    for i in ${!NAME_MATCHES[@]}
    do
        #echo "The owner of ${NAME_MATCHES[i]} is $(stat -c "%U" "$DIR"/"${NAME_MATCHES[i]}")"
         OWNERS_COL+=($(stat -c "%U" "$DIR"/"${NAME_MATCHES[i]}"))
    done
    #echo

    for e in ${!NAME_MATCHES[@]}
    do
        #echo "The group of ${NAME_MATCHES[e]} is $(stat -c "%G" "$DIR"/"${NAME_MATCHES[e]}")"
         GROUPS_COL+=($(stat -c "%G" "$DIR"/"${NAME_MATCHES[e]}"))
    done
    #echo
}



#####################################################################
#                                                                   #
#                      PARSE PERMISSION INPUT                       #
#                                                                   #
#    Converts PERM user input to permissions octal format,          #
#                                                                   #
#####################################################################

function parsePermissionInput
{
    case $PERM in

    rwx)
    octal_perm_searched=7
    ;;

    rw-)
    octal_perm_searched=6
    ;;

    r-x)
    octal_perm_searched=5
    ;;

    r--)
    octal_perm_searched=4
    ;;

    ---)
    octal_perm_searched=0
    ;;

    *)
    showError 5 "Perms option not valid: $PERM"
    exit 5
    ;;

esac
}


#####################################################################
#                                                                   #
#                           PERMS COMPARE                           #
#                                                                   #
#   This part of the code performs the last comparison,             #
#                                                                   #
#                                                                   #
#   then finds what group of permissions is applied to the USER     #
#   comparing $USER running the program and the corresponding file  #
#   owner/group.                                                    #
#                                                                   #
#   if file permissions for that user matches the input parameters  #
#   that file name is saved on final results array ALL_MATCH        #
#                                                                   #
#                                                                   #
#####################################################################

function permsCompare
{
    for t in ${!NAME_MATCHES[@]}
    do
        strperms=${ITEM_PERMS[t]}

        case "$USER" in


            "${OWNERS_COL[t]}")

                #echo "You have owner perms for ${NAME_MATCHES[t]}"
                #echo ${strperms:0:1}

                if [ "${strperms:0:1}" == "${octal_perm_searched}" ]; then
                    ALL_MATCH+=("${NAME_MATCHES[t]}")
                    #echo "${NAME_MATCHES[t]} matches all parameters"
                fi
            ;;




            "${GROUPS_COL[t]}")

                #echo "You have group perms for ${NAME_MATCHES[t]}"
                #echo ${strperms:1:1}

                if [ "${strperms:1:1}" == "${octal_perm_searched}" ]; then
                    ALL_MATCH+=("${NAME_MATCHES[t]}")
                    #echo "${NAME_MATCHES[t]} matches all parameters"
                fi
            ;;



                
            "root")
                #echo "You have root permissions"
            ;;


            
            *)
                #echo "You have everyone perms for ${NAME_MATCHES[t]}"
                #echo ${strperms:2:2}

                if [ "${strperms:2:2}" == "${octal_perm_searched}" ]; then
                    ALL_MATCH+=("${NAME_MATCHES[t]}")
                    #echo "${NAME_MATCHES[t]} matches all parameters"
                fi
            ;;


        esac
    done

}


#####################################################################
#                                                                   #
#                        PRINT FINAL MATCHES                        # 
#                                                                   #
#           Print final matches with all the parameters             #
#                                                                   #
#####################################################################


function printFinalMatches
{
    if [ "$RECURSIVE" == "-r" ]; then
        for i in ${!ALL_MATCH[@]}
        do
            echo $(pwd)/"${ALL_MATCH[i]}"
        done
    else 
        for i in ${!ALL_MATCH[@]}
        do
            echo "${ALL_MATCH[i]}"
        done
    fi
}




######################################################################
#                                                                    #
#                           RECURSIVE                                #
#                                                                    #
#        The script calls itself with the same initial               #
#        parameters in each of the subdirectories                    #
#                                                                    #
#                                                                    #
######################################################################

function recursive
{

        declare -a ALL_ITEMS
        declare -a DIRECTORIES

        now_pwd=$(pwd)
        thisa=$0

        IFS=$'\n'
        e=0

        # Get subdirectories

            for file in "$DIR"/*; 
            do 
                this=${file##*/}
                ALL_ITEMS[e++]="${this}"
            done

            e=0
            for ((i=0; i<=${#ALL_ITEMS[@]}; i++)); do 
                
                if [ -d "${ALL_ITEMS[i]}" ] ; then
                    app="${ALL_ITEMS[i]}"
                    DIRECTORIES[e++]="${app}"
                fi
            done


        # Build script call using subdirectories and given parameters

        for ((i=0; i<${#DIRECTORIES[@]}; i++)); do 

            cmd="$thisa "

            abs_dir=$now_pwd/${DIRECTORIES[i]}
            cmd+=$abs_dir

            if  [ -z "$NAME" ]; then
                cmd+=" -t ${TYPE} -c ${STRING} -p ${PERM}" 
            else
                cmd+=" -t ${TYPE} -n ${NAME} -p ${PERM}" 
            fi 

            if [ "$PRINT" == "-print" ]; then
                cmd+=" -print"
            fi

            if [ "$RECURSIVE" == "-r" ]; then
                cmd+=" -r"
            fi

            if [ ! -z "$PIPE" ]; then
                cmd+=" -pipe ${PIPE}"
            fi

            if [ ! -z "$EXEC" ]; then
                cmd+=" -exec ${EXEC}"
            fi

            final=$cmd
            eval $final

        done
}


#######################################################################
#                                                                     #
#                          PASS THROUGH PIPE                          #
#                                                                     # 
#            PIPE: Passes result list to another program              #
#                                                                     #
#                                                                     #
#######################################################################

function passThroughPipe
{
    checkCommandExistance "$PIPE"

    str=$(for l in ${ALL_MATCH[@]}; do 
    echo "$l"| tr ' ' '_'
    done)
    echo $str | tr ' ' '\n' | eval "$PIPE"
}


#########################################################################
#                                                                       #
#                               EXECUTE                                 # 
#                                                                       #
#       Executes a child process for each file matching criteria.       #
#       If execution takes more than the specified in the               #
#       environment variable $TIMEOUT kills child process               #
#                                                                       #
#########################################################################

function execute
{
    checkCommandExistance $EXEC

    if [ -z $TIMEOUT ]; then
        showError 13 "TIMEOUT environment variable not setted, use from shell: export TIMEOUT=VALUE"
        exit 13
    fi
    

    for i in ${!ALL_MATCH[@]}
    do
        eval "$EXEC" \'"$DIR"/"${ALL_MATCH[i]}"\' & PID=$!
        sleep $TIMEOUT

        es=$(ps -p $PID | tr ' ' '\n' | grep $PID)

        if [ ! -z $es ]; then
            kill $PID
            showError 12 "Timeout"
        fi

    done
}









#######################################################################################
#######################################################################################
######                                                                          #######
######                                                                          #######
######                                  MAIN                                    #######
######                                                                          #######
######                                                                          #######
#######################################################################################
#######################################################################################

# Check number of parameters
if [[ $# -lt 4 ]]; then
    usageAndExit
fi
 

    # Get parameters

    DIR=$1




    
    NAME=""
    STRING=""

    while [[ $1 != '' ]]
    do
        key="$1" 

        case $key in

            -t|--type)
            TYPE="$2"
            shift 
            ;;

            -n|--name)
            NAME="$2"
            shift 
            ;;

            -p|--perms)
            PERM="$2"
            shift
            ;;

            -c|--string)
            STRING="$2"
            shift
            ;;

            -print)
            PRINT="$1"
            ;;

            -pipe)
            while [ $# -gt 1 ] ; do
                if [[ ! $2 == "-exec" ]]; then
                    PIPE+=" $2"
                else
                    showError 8 "Cannot use -exec and -pipe at the same time"
                    exit 8
                fi
                shift
            done
            ;;

            -exec)
            while [ $# -gt 1 ] ; do
                if [[ ! $2 == "-pipe" ]]; then
                    EXEC+=" $2"
                else
                    showError 8 "Cannot use -exec and -pipe at the same time"
                    exit 8
                fi
                shift
            done
            ;;

            -r)
            RECURSIVE="$1"
            ;;

            *)
            # unknown option
            ;;

        esac
        shift

    done

    if [[ -n $1 ]]; then
        showError 9 "Last line of file specified as non-opt/last argument:"
        tail -1 $1
    fi




checkParameterErrors
 
checkDirectory
    
cd "$DIR"



# Call findByName or findByTypeNString

if  [ -z "$NAME" ]; then
    # Get items matching type and string 
    findByTypeNString
else
    # Get items matching type and name 
    findByTypeNName
fi


# Get perms of the items selected
getPerms

# Get owner and group of the items selected
getOwnerAndGroup


# Parse -p
parsePermissionInput

# From the items selected in findByTypeNString or findByTypeNName,
# get the ones matching permissions
permsCompare




if  [ "$PRINT" == "-print" ]; then
    printFinalMatches
fi

if [ ! -z "$PIPE" ]; then
    passThroughPipe
fi

if [ ! -z "$EXEC" ]; then
    execute
fi

if  [ "$RECURSIVE" == "-r" ]; then
    recursive
fi


