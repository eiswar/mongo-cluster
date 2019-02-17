# mongo-cluster
MongoDB Sharded Cluster on Docker

This repository hosts the docker-compose manifest files to setup simple MongoDB sharded cluster using docker.

# Steps to setup the MongoDB cluster

1. For each MongoDB shard server, create a directory in the host and map to the data path of the MongoDB shard container.
2. Update the volume mappings in the docker-compose file.
3. Start the MongoDB cluster using the following command

`docker-compose up`


