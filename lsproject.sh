#!/bin/bash
    echo "1.Sign Up"
    echo "2.Sign In"
    echo "3.Exit"
    echo -n "Please enter the option:"                                 #Enter option to Sign up,Sign and Exit
    read   option
    case $option in
        1)

            user=(`cat user.csv`)                                      #Get all the user name in user array
            password=(`cat password.csv`)                              #Get all the password in password array
            echo "<-----------------------------------------------Sign Up--------------------------------------------------->"
            count=1
            while [ $count -eq 1 ]
            do
                count=0
                echo -n "Enter user name:"                             #Enter user name
                read username
                for i in ${user[@]}                                    #use for loop to get user name one by one
                do
                    if [ $username = $i ]                              #compare present user name and entersd new user name
                    then
                        echo "Username is Already Exist,Please enter other user nmae"  #if username present ask to enter user name again
                        count=1
                    fi
                done
            done
                    echo $username >> user.csv                     #move the ebterd user name to file user.csv
                

            ch=1                                                       
            while [ $ch -eq 1 ]
            do
                ch=0
                echo  "Enter password:"                               #Enter password
                read -s passwd
                echo "Enter confirm password"                         #Enter confirm password
                read -s confirmpasswd 

                if [ $confirmpasswd != $passwd ]                     #check for password is same as confirm password or not
                then
                    echo "Password does not Match"                  #if password not same ask to enter password again
                    ch=1
                else
                    echo "$passwd" >> password.csv                   #move password to password.csv
                    echo "Sign Up Successfully"
                fi  
            done

            ;;
        2)
            user=(`cat user.csv`)                                    #Get all user name from file to array user
            #echo ${user[@]}
            password=(`cat password.csv`)                            #Get all user password into password array
            echo "<----------------------------------------Log In--------------------------------------------------->"
            count=1
            while [ $count -eq  1 ]
            do
                count=0
                echo -n "Enter user name:"                               #Enter user name for login
                read username
                for i in `seq 0 $((${#user[@]}-1))`
                do
                    if [ $username = ${user[$i]} ]                                    #Check for username present in file or not
                    then
                        echo -n "Enter password:"                                   #if present ask to enter password
                        read -s password 

                        if [ $password  != ${password[$i]} ]                            #if password is same as tat for user name
                        then
                            echo "password wrong"                                      #if not same ask to print again user name
                            count=1
                        else
                            echo "login successfull"                                    #Login successful
                            echo "1.Take Test"
                            echo "2.Exit"
                            read -p "Enter the option:" option                           # choose option to enter take test/exit
                            case $option in
                                1)
                                    sed -i '/^[[:blank:]]*$/d' questionbooklet.txt      #Get all the question from question booklet 
                                    TotalLine=(`wc -l < questionbooklet.txt`)           #Count total number of lines of file
                                    No_of_Que=$(($TotalLine/5))
                                    #echo $No_of_Que

                                    for i in `seq 5 5 $TotalLine`                      #for loop for getting each question one by one
                                    do
                                        head -$i questionbooklet.txt | tail -5         #Command to get each question and option
                                        for i in `seq 10 -1 1`                         #COnt for 10sec
                                        do
                                            echo -n -e "\rEnter the Option:$i \c"         #Enter option
                                            read -t 1  option                             #read option correct answer
                                            if [ -n "$option" ]                           #check is user enter any option
                                            then
                                                break
                                            else
                                                option='e' >> userAnswer.txt          #if user not answered Answer will be set to timeout 
                                            fi
                                        done
                                      
                                        if [ $(($i/5)) -eq 1 ]
                                            then
                                               echo $option > userAnswer.txt                #Move option to user Answer.txt
                                           fi

                                             echo $option >> userAnswer.txt
                                         
                                    

                                    done
                                    cat userAnswer.txt
                                    echo " --------------------------------------------------Result Page ------------------------------------------------------"
                                    CorrectAns=(`cat answer.txt`)                          #get all the Answer into CorrectAns array 
                                    UserAns=(`cat userAnswer.txt`)                         #Get all the user answer into UserAns array
                                    marks=0                                                #Initilize marks variable as 0 to count marks      

                                    for i in `seq 5 5 $TotalLine`
                                    do
                                        head -$i questionbooklet.txt | tail -5              #print each question one by one

                                        echo "User Answer= ${UserAns[$((($i/5)-1))]}"        #print user answer
                                        echo "CorrectAnswer=${CorrectAns[$((($i/5)-1))]}"    #print correct answer
                                        if [ ${UserAns[$((($i/5)-1))]} = ${CorrectAns[$((($i/5)-1))]} ]   
                                        then                                                 #check for user answer and corect answer
                                            marks=$(($marks+1))                              #if user answer correct count mark
                                            echo "Correct"
                                        elif [ ${UserAns[$((($i/5)-1))]} = 'e' ]             #if user not entred the answer 
                                        then
                                            echo "TimeOut"                                   #print it as Time out
                                        else
                                            echo "Incorrect"                #if user answer nnot equal to correct ans print as Incorrect
                                        fi

                                        echo
                                    done
                                      echo "Total=$marks/$No_of_Que"                        #Finally get Total marks obtained by user
                                      count=0
                                    ;;
                                2)
                                    ;;
                            esac
                        fi
                    fi

                done
            done
            ;;
        3)
            ;;

        esac

 # rm  userAnswer.txt                    #it will delete the userAnswer.txt file here for next user it will be created during redirection.



