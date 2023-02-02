#!/bin/bash
PSQL="psql --tuples-only --username=freecodecamp --dbname=number_guess -t --no-align -c"
RAND=$(( $RANDOM % 1000 + 1 ))  
ROUND=1
echo "Enter your username:"
read USER
USER_EXIST=$($PSQL "SELECT username FROM users where username='$USER';")
if [[ -z $USER_EXIST ]]
then
  echo "Welcome, $USER! It looks like this is your first time here."
  $PSQL "INSERT INTO users(username, games_played) values('$USER', 0);" | sed 's/Insert 0 1//'
else
  GAMES_PLAYED=$($PSQL "select games_played from users where username='$USER';")
  BEST_GAME=$($PSQL "select best_game from users where username='$USER';")
  echo "Welcome back, $USER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
 #echo "Welcome back, $USER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  
fi

echo "Guess the secret number between 1 and 1000:"
read GUESS
while [[ ! $GUESS =~ ^[0-9]*$ ]]
do
  echo That is not an integer, guess again:
  read GUESS
  ((ROUND++))
done

until [[ $GUESS -eq $RAND ]]
do
  if [[ $GUESS -lt $RAND && $GUESS =~ ^[0-9]*$ ]]
  then
    echo "It's lower than that, guess again:"
    read GUESS
    ((ROUND++))
  elif [[ $GUESS -gt $RAND && $GUESS =~ ^[0-9]*$ ]]
  then
    echo "It's higher than that, guess again:"
    read GUESS
    ((ROUND++))
  else
    echo That is not an integer, guess again:
    read GUESS
    ((ROUND++))
  fi  
done

BEST_GAME=$($PSQL "select best_game from users where username='$USER';")
GAMES_PLAYED=$($PSQL "select games_played from users where username='$USER';")
if [[ $BEST_GAME -gt $ROUND || -z $BEST_GAME ]]
then
  echo $ROUND
  $PSQL "update users set best_game=$ROUND where username='$USER';" | sed "s/UPDATE 1//"
fi
$PSQL "update users set games_played=$GAMES_PLAYED+1 where username='$USER';" | sed "s/UPDATE 1//"
echo "You guessed it in $ROUND tries. The secret number was $RAND. Nice job!"
