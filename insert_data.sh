#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games");
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    #get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    #if not found
    if [[ -z $WINNER_ID ]]
    then
      #insert team in teams
      INSERT_WINNER="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
      if [[ $INSERT_WINNER == "INSERT 0 1" ]]
      then
        echo "Inserted winner: $WINNER"
      fi
      #get the id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi
    #get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert team in teams
      INSERT_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
      if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
      then
        echo "Inserted opponent: $OPPONENT"
      fi
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi
    #insert record into games
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    if [[ $INSERT_GAME == "INSERT 0 1" ]]
    then
      echo "Inserted game: $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
    fi
  fi
done
