#!/bin/bash

# Set some sensible defaults
# export CORE_CONF_fs_defaultFS=${CORE_CONF_fs_defaultFS:-hdfs://`hostname -f`:8020}

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

echo -e "\nHDFS_NAMENODE_USER=root \nHDFS_DATANODE_USER=root \nHDFS_SECONDARYNAMENODE_USER=root \nYARN_RESOURCEMANAGER_USER=root \nYARN_NODEMANAGER_USER=root \nexport JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.262.b10-0.el7_8.x86_64" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
addProperty $HADOOP_HOME/etc/hadoop/core-site.xml hadoop.tmp.dir file:/usr/local/hadoop/tmp
addProperty $HADOOP_HOME/etc/hadoop/core-site.xml fs.defaultFS hdfs://`hostname -f`:9000
addProperty $HADOOP_HOME/etc/hadoop/hdfs-site.xml dfs:replication 1
addProperty $HADOOP_HOME/etc/hadoop/hdfs-site.xml dfs.namenode.name.dir file:/usr/local/hadoop/tmp/dfs/name
addProperty $HADOOP_HOME/etc/hadoop/hdfs-site.xml dfs.datanode.data.dir file:/usr/local/hadoop/tmp/dfs/data

mkdir -p $HADOOP_HOME/input
mkdir -p $HADOOP_HOME/tmp

/usr/sbin/sshd

$HADOOP_HOME/sbin/start-dfs.sh

function wait_for_it()
{
    local serviceport=$1
    local service=${serviceport%%:*}
    local port=${serviceport#*:}
    local retry_seconds=5
    local max_try=100
    let i=1

    nc -z $service $port
    result=$?

    until [ $result -eq 0 ]; do
      echo "[$i/$max_try] check for ${service}:${port}..."
      echo "[$i/$max_try] ${service}:${port} is not available yet"
      if (( $i == $max_try )); then
        echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
        exit 1
      fi
      
      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      let "i++"
      sleep $retry_seconds

      nc -z $service $port
      result=$?
    done
    echo "[$i/$max_try] $service:${port} is available."
}

for i in ${SERVICE_PRECONDITION[@]}
do
    wait_for_it ${i}
done

exec $@
