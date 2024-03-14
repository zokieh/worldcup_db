#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

tail -n +2 games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do

if [[ $YEAR != year ]]
then 
    #get teamid of winner| look if data is already there
    TEAM_WINNER_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")

    #if not found
    if [[ -z $TEAM_WINNER_ID ]]
    then
      #insert teams of all winners
      INSERT_WINNERS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')") 
      
      #insert winner
      if [[ $INSERT_WINNERS == "INSERT 0 1" ]]
      then 
        echo "Inserted $WINNER" 
      fi
    fi 

    #get teamid of opponent
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
  
    #if not found
    if [[ -z $TEAM_OPPONENT_ID ]]
    then
      #insert teams of all opponents
      INSERT_OPPONENTS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      

      if [[ $INSERT_OPPONENTS == "INSERT 0 1" ]]
      then 
        echo "Inserted $OPPONENT" 
      fi
    fi

    #get winner_id 
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    echo $WINNER_ID

    #get oppponent id
    OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
    echo $OPPONENT_ID

    INSERT_FINAL=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
    if [[ $INSERT_FINAL == "INSERT 0 1" ]]
    then 
      echo "Inserted $YEAR" 
    fi


fi
  


done