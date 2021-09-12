#!/usr/bin/env bash

if [[ ! -d public/assets ]]; then
	echo "Assets Precompile..."
	bundle exec rails assets:precompile RAILS_ENV=production
	bundle exec rails gitlab:assets:compile RAILS_ENV=production
fi

if [[ ! -d public/assets/webpack ]]; then
	echo "Webpack Compile..."
	bundle exec rails webpack:compile RAILS_ENV=production
fi

sleep 10

echo "Check database..."
if echo "\c gitlab; \dt;" | psql -U git -h db.local -p 5432 | grep schema_migrations 2>&1 >/dev/null; then
    echo "\c gitlab; \dt" | psql -U git -h db.local -p 5432
else
    echo "Initialize Database..."
    echo "CREATE EXTENSION IF NOT EXISTS pg_trgm;" | psql -U git -d template1
    bundle exec rails db:create db:migrate RAILS_ENV=production
fi

echo "Sidekiq start..."
RAILS_ENV=production bin/background_jobs start

echo "Start unicorn..."
bundle exec unicorn -c config/unicorn.rb -E production
