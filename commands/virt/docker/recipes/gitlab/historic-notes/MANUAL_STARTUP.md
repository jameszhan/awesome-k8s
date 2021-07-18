```bash
git clone git@github.com:jameszhan/gitlabhq.git gitlab

cd gitlab

git remote add upstream https://github.com/gitlabhq/gitlabhq.git

git pull
git fetch upstream
git checkout master
git merge upstream/master

git checkout 11-0-stable
git merge upstream/11-0-stable

git pull --all
git push --tags
```

```bash
./gitlab_init.rb init

psql -d template1 -c "CREATE USER git CREATEDB;"
psql -d template1 -c "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
psql -d template1 -c "CREATE DATABASE gitlabhq_production OWNER git;"
psql -d template1 -c "GRANT ALL PRIVILEGES ON DATABASE gitlabhq_production to git;"
```

```bash
# 通过账户设置添加用户组 james
sudo chown -R james:james /james/apps/git/repositories
chmod -R ug+rwX,o-rwx /james/apps/git/repositories
chmod -R ug-s /james/apps/git/repositories
chmod 700 /james/apps/git/gitlab/public/uploads
```

```bash
bundle update
bundle exec rails gitlab:check RAILS_ENV=production

bundle exec rails gitlab:shell:install SKIP_STORAGE_VALIDATION=true RAILS_ENV=production

bundle exec rails db:migrate RAILS_ENV=production

RAILS_ENV=production bin/background_jobs start
```

```bash
psql -d template1 -c "GRANT ALL PRIVILEGES ON DATABASE gitlabhq_development to git;"
```



```bash
brew install re2


gsed -i "s/https:\/\/rubygems.org/https:\/\/gems.ruby-china.org/g" Gemfile
RAILS5=true bundle update
```



```bash
docker run -v /james/var/docker/redis/6379:/data -p 6379:6379 redis:alpine
docker run -v /james/var/docker/redis/6380:/data -p 6380:6379 redis:alpine
docker run -v /james/var/docker/redis/6381:/data -p 6381:6379 redis:alpine
docker run -v /james/var/docker/redis/6382:/data -p 6382:6379 redis:alpine
```

## Install GitLab Shell

```bash
git clone https://github.com/gitlabhq/gitlab-shell.git
cd gitlab-shell
git checkout v7.1.5 -b deploy_7_1_5

cp config.yml.example config.yml
gsed -i "s/user: git/user: james/g" config.yml
gsed -i "s/\/home\/git/\/Users\/james/g" config.yml

bin/install
bin/compile
```


