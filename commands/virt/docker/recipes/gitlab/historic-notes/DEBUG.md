```bash
docker netowrk ps

docker run --env RAILS_ENV=production \
        --env DATABASE_URL=postgresql://git:git@db.local/gitlab \
        --network docker_default \
        --link docker_db_1:db.local \
        -v /james/genesis/rookies/gitlab/docker/public:/home/git/gitlab/public \
        -v /james/genesis/rookies/gitlab/docker/log:/home/git/gitlab/log \
        -it docker_app:latest bash
```