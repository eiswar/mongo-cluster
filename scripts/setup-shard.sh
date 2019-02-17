#!/bin/bash

function wait_for_mongo_server()
{
	mongo_server="${1}"
	mongo_version=$(mongo --host ${mongo_server} --eval "db.version()")
	while [ $? -ne 0 ];
	do
	        echo "Waiting for ${mongo_server}..."
        	sleep 5
		mongo_version=$(mongo --host ${mongo_server} --eval "db.version()")
	done
}

# Check and make sure that mongo config server is up
wait_for_mongo_server "mongocfg1"

# Initiate the config server replica set
echo "rs.initiate({_id: \"config\",configsvr: true, members: [{ _id : 0, host : \"mongocfg1\" }]})" | mongo --host mongocfg1

wait_for_mongo_server "mongocfg2"

echo "rs.add(\"mongocfg2\")" | mongo --host mongocfg1

echo "rs.status()" | mongo --host mongocfg1

# Check and make sure that mongo config server is up
wait_for_mongo_server "shard1"

# Initiate the shard replica set
echo "rs.initiate({_id : \"rs1\", members: [{ _id : 0, host : \"shard1\" }]})" | mongo --host shard1
wait_for_mongo_server "shard2"
echo "rs.add(\"shard2\")" | mongo --host shard1
echo "rs.status()" | mongo --host shard1

# Check and make sure that mongo router is up
wait_for_mongo_server "mongos1"

# Add the shared to the router
echo "sh.addShard(\"rs1/shard1\")" | mongo --host mongos1
echo "sh.status()" | mongo --host mongos1

# Open Bash for troubleshooting
/bin/bash

