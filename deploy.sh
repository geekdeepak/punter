git add .
git commit -m "deploy to heroku"
git remote add staging git@heroku.com:punter.git
git push -f staging
