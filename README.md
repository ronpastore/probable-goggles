# probable-goggles

Using OpenAI embeddings and completions to ask questions about a book's contents.

See live example at [probable-goggles.vercel.app](https://probable-goggles.vercel.app/)

## Set up local (tested with Ruby 3.2.2, Rails 7, PostgreSQL 14.7)
- Set server ENV: OPENAI_ACCESS_KEY, 
- Client env, ```cp client/.env_sample client/.env```
- ```bundle install```
- ```rake db:setup```
- Start server ```bin/rails s```
- ```cd client && yarn install```
- Start client ```yarn start``` Note: select Y to run out of a different port then 3000 (rails default)

## Deployment (vercel & heroku)
- Create a heroku app ```heroku apps:create --stack=heroku-22```, note app name
- Set heroku remote repo ```heroku git:remote -a APP_NAME```
- ```git push heroku main```
- ```heroku run rake db:setup```
- Set ENV vars: Heroku (OPENAI_ACCESS_KEY), Vercel (REACT_APP_API_HOST)
- Client can use defaults on Vercel, connect github, deploy 

## Generating embeddings
NOTE: Sample book is small enough to fit in git, CSV and PDF are already there, only do this if you want to change contents
- ```rake generate_embeddings```
