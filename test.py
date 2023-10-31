
import os
import openai

openai.api_key = os.getenv("OPENAI_API_KEY")
user_commnad = input("Enter your statement ")

completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages=[
      {"role": "system", "content": "you are a tech genius which helps users convert statements into bash commands,you dont reply anything except bash statments requested by the user "},
    {"role": "user", "content": user_commnad}
  ]
)

print(completion.choices[0].message.content)


