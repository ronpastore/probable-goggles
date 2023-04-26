# probable-goggles

Hello! 

Leaving background here obscure for the sake of the assignment. Some notes below. 

See live example at [probable-goggles.vercel.app](https://probable-goggles.vercel.app/)

## Set up local (tested with Ruby 3.2.2, Rails 7, PostgreSQL 14.7)
- Set server ENV: OPENAI_ACCESS_KEY, 
- Client env, ```cp client/.env_sample client/.env```
- ```bundle install```
- ```rake db:setup```
- Start server ```bin/rails s```
- ```cd client && yarn install```
- Start client ```yarn start``` Note: select Y to run out of a different port then 3000 (rails default)

## Deployment
- Create a heroku app ```heroku apps:create --stack=heroku-22```, note app name
- Set heroku remote repo ```heroku git:remote -a APP_NAME```
- ```git push heroku main```
- ```heroku run rake db:setup```
- Client can use defaults on Vercel, connect github, deploy 

## Regenerate embeddings
- ```rake generate_embeddings```

# Dev notes

## Arch considerations
- Minimized effort to get a working version.
- Uses webpack and a separate React client, hosted out of the same repository and deployed to Vercel(front) and Heroku(back). Favored more popoular setups to reduce time and risk of unknowns.  I'm also not up to speed w/ Rails 7 import maps, and there doesn't seem like an idiomatic way to work with JSX yet. 
- React+Typescript app with create-react-app
- SimpleCSS 

## Lessons learned
- It would have been easier, albeit less fun, to set up upper-env/deployments earlier in the process, I lost some time backing out of decisions around app structure, db, etc..
- Using embeddings to compose prompts is incredible, makes me want write a lot more. 

## Caveats, cleanups, etc..
- I'd typically add tests or write them as i code but had to balance time spent. 
- The Rake task to generate embeddings loads everything into memory, it should instead write CSV rows as it parses PDF pages, it might fail on a larger book.