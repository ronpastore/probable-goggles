# probable-goggles

Hello! 

Leaving background here obscure for the sake of the assignment. Some notes below. 

See live example at [probable-goggles.vercel.app](https://probable-goggles.vercel.app/)

## Set up local (tested with Ruby 3.2.2 & Rails 7)
- Set ENV, OPENAI_ACCESS_KEY
- install postgres
- bundle install
- ```rake db:setup```
- start server ```bin/rails s```
- ```cd client && yarn install```
- start client ```yarn start``` (note: select Y to run out of a different port then 3000)

## Deployment
- create a heroku app ```heroku apps:create --stack=heroku-22```, note app name
- set heroku remote repo ```heroku git:remote -a APP_NAME```
- ```git push heroku main```
- ```heroku run rake db:setup```
- Client can use defaults on Vercel, connect github, deploy 

## Regenerate embeddings
- ```rake generate_embeddings```


# Dev notes

## Arch decisions
- Uses webpack and a separate React client, hosted out of the same repository. I did this mostly to reduce time and risk of deployment issues, as I'm not up to speed w/ Rails 7, import maps, etc.  
- React+Typescript app with create-react-app
- SimpleCSS 

## Lessons learned
- Should have set up prod env and deployment earlier in the process to avoid building against cloud provider best-practices, eg. nesting rails apps below the repository root
- I started w/ SQLite, probably should have used Postgres from the beginning for an easier move to Heroku. 

## Caveats, cleanups, etc..
- I'd typically add tests or write them as i code but had to balance time spent.  
- The Rake task to generate embeddings loads everything into memory, it should instead write CSV rows as it parses PDF pages, it might fail on a larger book.
- In the client the API URLS are hard-coded and use window.location to determine if it's local dev or not, this should come from ENV and a build system.