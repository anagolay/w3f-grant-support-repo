# w3f-grant-support-repo
All the stuff needed for the people to run certain services for the W3F grants

## First time setup
```
docker-compose -f local-docker-compose.yml up -d

docker-compose exec ipfs ipfs bootstrap rm --all 
docker-compose -f local-docker-compose.yml restart ipfs 

```
