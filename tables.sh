#!/bin/bash  
NUMOFQUESTIONS=5
USERNAME=""
PASSWORD=""

declare -A STORE_RESULTS # fake 2d array

function login(){
    until [[ $USERNAME =~ ^[[:alnum:]]+$ ]]
    do
        read -p "Enter your username (e.g. fohanlon), lowercase, letters and numbers only: " USERNAME               
        if [[ ! $USERNAME =~ ^[[:alnum:]]+$ ]]
        then
            echo "ERROR: Username must contain letters and numbers only"
        fi
    done

    until ((${#PASSWORD} >= 8)) && [[ $PASSWORD =~ ^[[:alnum:]]+$ ]]
    do
        read -p "Enter your password: " PASSWORD
        if [[ ${#PASSWORD} -lt 8 || ! $PASSWORD =~ ^[[:alnum:]]+$ ]]
        then
            echo "ERROR: Password must be at least eight characters in length and only contain letters and numbers" 
        fi
    done
    echo "logged in as "

# Fix login
    while read LINE 
            do
                USERLINE="$LINE"
            done < <(grep $USERNAME user.txt | grep $PASSWORD )

                USERDETAILS=($USERLINE) # puts Userline details into an array
            if [ ${#USERDETAILS[@]} -eq 0 ] 
            then
                echo "bad"
            else

                FNAME=${USERDETAILS[0]}
                USERNAME=${USERDETAILS[1]}
                PASSWORD=${USERDETAILS[2]}
                LEVEL=${USERDETAILS[3]}
                AGE_GROUP=${USERDETAILS[4]}

                case ${USERDETAILS[3]} in
                    1)	
                            studentOptions
                            ;;

                    2)
                            teacherOptions
                            ;;
                    esac
            fi

}
# echo "login successful." 
# echo "Logged in as $USERNAME"



      
function studentOptions(){
        CHOICE=0
        until [ $CHOICE -ge 1 -a $CHOICE -le 2 ]
        do

            echo "Please choose from student options:"
            echo "1. Learn your 12 times tables."
            echo "2. Take the Tables Quiz."
            echo "3. Quit the Program."
            read CHOICE
            if [ $CHOICE == 1 ]
            then
            echo "You Picked Learn 12 times tables"
            learn
            studentOptions
            elif [ $CHOICE == 2 ]
            then
            echo "You Picked Tables Quiz"
            chooseNumber
            quiz
            studentOptions
            elif [ $CHOICE == 3 ]
            then
            echo "You Picked Quit the program"
            exit
            elif [ $CHOICE -lt 1 -o $CHOICE -gt 3 ]
            then
                echo "Choice must be 1,2 or 3 only"
            fi
        done
}




function studentAgeGroup(){
        AGE_GROUP=0
        until [ $AGE_GROUP -ge 1 -a $AGE_GROUP -le 3 ]
        do

            echo "Please choose from options:"
            echo "1) AGE 5 - 7"
            echo "2) AGE 8 - 10"
            echo "3) AGE 11 - 13"
            read AGE_GROUP
            if [ $AGE_GROUP == 1 ]
            then
            echo "AGE 5 - 7"
            NUMOFQUESTIONS=5
            elif [ $AGE_GROUP == 2 ]
            then
            NUMOFQUESTIONS=10
            echo "AGE 8 - 10"
            elif [ $AGE_GROUP == 3 ]
            then
            NUMOFQUESTIONS=15
            echo "AGE 11 - 13 "
            elif [ $AGE_GROUP -lt 1 -o $AGE_GROUP -gt 3 ]
            then
                echo "Choice must be 1,2 or 3 only"
            fi
        done
}



function chooseNumber(){
	until [ $NUMBER -ge 1 -a $NUMBER -le 20 ]
	do
		echo "enter number between 1 and 20"
		read NUMBER

		if [ $NUMBER -lt 1 -o $NUMBER -gt 20 ]
		then
			echo "number must be between 1 and 20"
		fi
	done
}


function chooseArithOp()
{
    ARITH_OP = 0
	until [ $ARITH_OP -gt 0 -a $ARITH_OP -le 4 ] #until we pick a valid arithmetic operator!
	do
		echo "Pick an operator:"
		echo "1) Addition"
		echo "2) Subtraction"
		echo "3) Multiplication"
		echo "4) Division"
		read ARITH_OP

		if [ $ARITH_OP -lt 1 -o $ARITH_OP -gt 4 ]
		then
			echo "$ARITH_OP is an invalid option, Try Again!"
            chooseArithOp
		fi
	done
}

function learn(){
    studentAgeGroup
    chooseNumber
    chooseArithOp

	for ((i=0;i<$NUMOFQUESTIONS;i++))
	do

		case $ARITH_OP in
			1)	#echo "Addition"
				echo "Question $((i+1)):"
				OPERAND2=$((RANDOM%12+1))
				OPERAND1=$((RANDOM%12+1))
				ANS=$((NUMBER+OPERAND2))
				echo "$NUMBER + $OPERAND2 = ?"
				;;
			2)	#echo "Subtraction"
				echo "Question $((i+1)):"
				OPERAND2=$((RANDOM%12+1))
				OPERAND1=$((OPERAND2+(RANDOM%12+1))) #the random number here has to be +12 on the number so we never get a negative value!
				ANS=$((NUMBER-OPERAND2))
				echo "$NUMBER - $OPERAND2 = ?"
				;;
			3)	
				#echo "Division"
				echo "Question $((i+1)):"
				OPERAND2=$((RANDOM%12+1))
				OPERAND1=$((OPERAND2*(RANDOM%12+1)))
				ANS=$((NUMBER/OPERAND2))
				echo "$NUMBER / $OPERAND2 = ?"
				;;
			4) 	
                #echo "Multiplication"
                echo "Question $((i+1)):"
				OPERAND2=$((RANDOM%12+1))
				OPERAND1=$((RANDOM%12+1))
				ANS=$((NUMBER*OPERAND2))
				echo "$NUMBER * $OPERAND2 = ?"
				;;
		esac

		echo -n "----->: "
		read USER_ANS

		if [ $USER_ANS -eq $ANS ]
		then
            echo "Correct!"
        else
            echo "Incorrect :("
		fi

    done
}

function quiz(){
    studentAgeGroup
    chooseNumber
	for ((i=0;i<$NUMOFQUESTIONS;i++))
	do
		ARITH_OP=$((RANDOM%4+1)) #random number between 1 and 4, the +1 is starting at one

		#echo "Quiz Time!"

		case $ARITH_OP in
			1)	#Addition
				echo "Question $((i+1)):"
				QUIZNUM=$((RANDOM%12+1))
				ANS=$((NUMBER+QUIZNUM))
				echo "$NUMBER + $QUIZNUM = ?"
				;;
			2)	#Subtraction
				echo "Question $((i+1)):"
				QUIZNUM=$((RANDOM%12+1))
				ANS=$((NUMBER-QUIZNUM))
				echo "$NUMBER - $QUIZNUM = ?"
				;;
			3)	#Division
				echo "Question $((i+1)):"
				QUIZNUM=$((RANDOM%12+1))
				ANS=$((NUMBER/QUIZNUM))
				echo "$NUMBER / $QUIZNUM = ?"
				;;
			4) 	#Multiplication
                echo "Question $((i+1)):"
				QUIZNUM=$((RANDOM%12+1))
				ANS=$((NUMBER*QUIZNUM))
				echo "$NUMBER * $QUIZNUM = ?"
				;;
		esac

		echo -n "-----> "
		read USER_ANS

		if [ $USER_ANS -eq $ANS ]
		then
			CORRECT=1 #if they answer correctly we want to flag the question as correct!
            echo "Correct!"
        else
            echo "Incorrect :("
            CORRECT=0
		fi

		#Put our values into our pseudo 2D array!
		STORE_RESULTS[$i,0]=$NUMBER
		STORE_RESULTS[$i,1]=$ARITH_OP
		STORE_RESULTS[$i,2]=$QUIZNUM
		STORE_RESULTS[$i,3]=$ANS
		STORE_RESULTS[$i,4]=$USER_ANS
		STORE_RESULTS[$i,5]=$CORRECT
	done

	write_to_file
}


function write_to_file()
{
   local folder="results/"
   local file=$folder$USERNAME"-"$((RANDOM%999+1))".txt"
   if [ ! -f "$file" ]   # check if the $file exists
   then
       "touch $file"   # if file does not exist, create it now empty
   fi

   >$file    # clear the contents of the file
   echo -ne "NUM     Op     Num2     ANS      USR      TF" >> "$file" # add a newline to the file
   for((i = 0; i < 6; i++))
   do
    echo -ne "\n" >> "$file" # add a newline to the file
     for((j = 0; j < 6; j++))
     do
        echo -ne "${STORE_RESULTS[${i},${j}]}\t" >> "$file"
     done

   done
   echo -ne "\n" >> "$file" # add a newline to the file
    echo -ne "\n" >> "$file" # add a newline to the file

}




function chooseTeacherMenu(){
    CHOICE = 0
	until [ $CHOICE -gt 0 -a $CHOICE -le 4 ] #until we pick a valid arithmetic operator!
	do
		echo "Pick an operator:"
		echo "1) View a students Quiz Results"
		echo "2) View Student Statistics"
		echo "3) Manage Users"
		echo "4) Quit"
		read CHOICE

		if [ $CHOICE -lt 1 -o $CHOICE -gt 4 ]
		then
			echo "$CHOICE is an invalid option, Try Again!"
            chooseTeacherMenu
		fi
	done
}

function teacherOptions(){
      chooseTeacherMenu
      
        case $CHOICE in
        1)	
				echo "You have picked View student quiz results"
                read -p "Enter a students username: " pupilName
                view_student_results "$pupilName" 
				;;

        2)
                echo "Function not available"
                exit
                ;;
        3)
                echo "Function not available"
                exit
                ;;
        4)
                echo "Exiting program"
                exit
                ;;
        esac


}



function view_student_results(){

    echo "searching for files with the username $1 "
    i=0
    while read line 
    do
        matches[i]="$line"
        (( i++ ))
    done < <( find ./results -name "$1*.txt" | cut -d '/' -f 3 )

    r=1
    for n in "${matches[@]}"
    do
        echo "$r $n"
        (( r++ ))
    done
    until [[ $fileChoice =~ ^[[:digit:]]+$ ]]
    do
    read -p "Which quiz would you like to see?: " fileChoice
    if [[ $fileChoice =~ ^[[:digit:]]+$ ]]
    then
        cat "./results/${matches[((fileChoice--))]}"
    else
        echo "$fileChoice contains illegal characters"
    fi
    done
}




# function manage_users(){


# }


teacherOptions

#login
#studentOptions




