# search.sh
Command Manual

NAME: 

	search.sh : File and directory search by parameters


SYNOPSIS:

	search.sh <directory> <search criteria> <actions>


DESCRIPTION:

	The command search finds files or directories in the specified directory or in the directory tree rooted at given starting-point by the search criteria, a group 		of parameters specified by user.


EXPRESSION:

	Directory: the starting point to search. Can be absolute or relative.


	
	Search criteria: The parameters used to filter results. All arguments required.

		   Arguments : (  <type: ( -t [f|d] )>  <pattern: ( -n[string] | -c[string] )>  < permissions: –- > )

            Type: 
                -f : files
                -d : directories

            Pattern: 
                  -n [string] : 
                          Files or directories which names contains a match with string.
                  -c [string] : 
                          Files which content matches string.

            Permissions:
                   -p  [ --- | r-- | rw- | r-x | rwx ]:
                          Files which permissions for the user running script matches specified perms.
	
	
	
	Actions:
          -print
                Print items matching criteria
              
          -pipe[command]
                Passes the final matching list to another program
              
          -exec[command]
                Executes a program for each item in matching list.
              
          -r | --recursive 
                Makes the script call itself in each of the subdirectories with the same parameters.


ENVIRONMENT VARIABLES
		
	  TIMEOUT: 	
		      Specifies the maximum amout of time that a child process executed by -exec action can run, if it´ś reached the parent process kills the child and keeps executing the rest of the actions. 
