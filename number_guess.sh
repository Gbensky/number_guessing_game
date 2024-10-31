#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

SECRET_NUMBER=$((1 + $RANDOM % 1000))

echo -e "Enter your username:"
read USERNAME
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
if [[ $USER_ID ]]
then
  NO_OF_USER_GAMES=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id='$USER_ID'")
  USER_BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id='$USER_ID'")
  echo -e "Welcome back, $USERNAME! You have played $NO_OF_USER_GAMES games, and your best game took $USER_BEST_GAME guesses."
else
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
fi

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
I=0

GUESS_NUMBER(){
  if [[ $1 ]]
    then
    echo -e "\n$1"
  fi
  I=$((I + 1))
  read GUESS
  if [[ ! $GUESS  =~ ^[0-9]+$ ]]
  then
  GUESS_NUMBER "That is not an integer, guess again:"
  elif [[ $GUESS -lt $SECRET_NUMBER ]]
  then
  GUESS_NUMBER "It's higher than that, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
  then
  GUESS_NUMBER "It's lower than that, guess again:"
  else
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(number_of_guesses, user_id) VALUES($I, $USER_ID)")
  echo -e "You guessed it in $I tries. The secret number was $SECRET_NUMBER. Nice job!"
  fi
}

echo -e "Guess the secret number between 1 and 1000:"

GUESS_NUMBER