set -e

yarn run build

cd dist 

git add .

git commit -m 'Deploy'

git push -f git@github.com:silverbeet/fagprove.git master:gh.pages

cd -