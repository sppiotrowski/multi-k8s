# setup github.com
git init
git add .
git c -m Initial commit
git remote -v  # check origin repo
git remote remove origin  # rm origin repo
git remote add origin git@github.com:sppiotrowski/multi-k8s.git
git remote get-url origin # get repo url
git push origin master
git push --set-upstream origin master # allow to use git push

# setup travis-ci.org
# https://travis-ci.org/account/repositories -> sync account & opt-in multi-k8s

# setup console.cloud.google.com
