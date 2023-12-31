api_key=$OPENAI_API_KEY
if [ "$SHELL" = "/bin/bash" ];then
    if grep -q "alias cogni='$HOME/cognisyn-bash/test.sh'" ~/.bashrc; then
        echo " "    
    else
        echo "alias cogni='$HOME/cognisyn-bash/test.sh'" >> ~/.bashrc 
        source ~/.bashrc
        echo "alias added , use 'cogni' to invoke the script "
    fi
elif [ "$SHELL" = "/bin/zsh" ];then 
    if grep -q "alias cogni='$HOME/cognisyn-bash/test.sh'" ~/.zshrc; then
        echo " "    
    else
        echo "alias cogni='$HOME/cognisyn-bash/test.sh'" >> ~/.zshrc 
        source ~/.zshrc
        echo "alias added , use 'cogni' to invoke the script "
    fi
fi 


if [ "$SHELL" = "/bin/bash" ];then
    if [[ -z "$api_key" ]]; then
        echo "Error : openai api key is required"
        echo "you can get your api key here : https://platform.openai.com/account/api-keys"
        echo -n "Enter Your API KEY here : "
        read -r key1
        echo "export OPENAI_API_KEY='$key1'" >> ~/.bashrc 
        echo "open new terminal after adding your key "
        source ~/.bashrc 
        exit 1
    fi

elif [ "$SHELL" = "/bin/zsh" ];then 
    if [[ -z "$api_key" ]]; then
        echo "Error : openai api key is required"
        echo "you can get your api key here : https://platform.openai.com/account/api-keys"
        echo -n "Enter Your API KEY here : "
        read -r key2
        echo "export OPENAI_API_KEY='$key2'" >> ~/.zshrc 
        echo "open new terminal after adding your key"
        source ~/.zshrc 
        exit 1
    fi
fi
echo -n "Enter the statement :  "
read -r ans 
temp_file=$(mktemp)
export RES="$ans"



python - << EOF
import os
import sys 
import subprocess
name = "openai"

if name not in sys.modules:
    try:
        subprocess.check_call(["python", "-m", "pip", "install", name], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except subprocess.CalledProcessError as e:
        print(f"Error installing {name}: {e}")

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
read -s -n 1 key
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

