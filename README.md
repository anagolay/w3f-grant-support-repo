# w3f-grant-support-repo
All the stuff needed for the people to run certain services for the W3F grants

## First time setup
```sh
# everytimes you recreate the containers run this if you want to remove the bootstrap nodes
docker-compose exec ipfs ipfs bootstrap rm --all 
docker-compose restart ipfs 
```

### Debugging and cleanup 

```sh
# stop and remove all containers and their volumes, very useful when debugging
docker-compose down --volumes

# start all the containers again
docker-compose up -d
```

Attatching to the logs

```sh
# get the logs from the publish service.
docker-compose logs --follow publish
```
