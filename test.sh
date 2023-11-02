#!/bin/bash

echo -n "Enter the statement :  "
read -r ans 
temp_file=$(mktemp)
export RES="$ans"

python - << EOF

import os
import openai

openai.api_key = os.getenv("OPENAI_API_KEY")
user_command = os.getenv("RES")

completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages=[
      {"role": "system", "content": "you are a tech genius which helps users convert statements into bash commands,you dont reply anything except bash statments requested by the user, i repeat, you only reply with bash commands  "},
    {"role": "user", "content": user_command}
  ]
)

result = completion['choices'][0]['message']['content']

with open('$temp_file', 'w') as f:
    f.write(result)
EOF

result=$(cat $temp_file)

# Clean up the temporary file
rm $temp_file
echo "$result"
echo "Press 'y or ENTER ' to continue or 'n' to exit."
 
read -s -n 1 key  # -s: do not echo input character. -n 1: read only 1 character (separate with space)

# double brackets to test, single equals sign, empty string for just 'enter' in this case...
# if [[ ... ]] is followed by semicolon and 'then' keyword
if [[ $key = "" ]]; then 
	eval "$result"
fi

case $key in
    y|Y)
        eval "$result"
	;;
n|N)
        echo "You pressed 'n'. Exiting..."
        exit 1
        ;;
*)
        ;;
esac

