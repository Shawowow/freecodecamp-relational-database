#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year && $ROUND != round && $WINNER != winner && $OPPONENT != opponent && $WINNER_GOALS != winner_goals && $OPPONENT_GOALS != opponent_goals ]]
  then
    WINNER_EXIST=$($PSQL "SELECT name FROM teams WHERE name='$WINNER';")
    OPPONENT_EXIST=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT';")
    if [[ -z $WINNER_EXIST ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$WINNER');"
    fi
    if [[ -z $OPPONENT_EXIST ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');"
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    if [[ !(-z $WINNER_ID) && !(-z $OPPONENT_ID) ]]
    then
    $PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID);"
    fi
  fi
done
