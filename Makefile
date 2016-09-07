WPATH:=$(PWD)
all:
	@echo "make get\n"

download:
	@echo "Downloading Kafka"
	@curl -O http://xenia.sote.hu/ftp/mirrors/www.apache.org/kafka/0.10.0.0/kafka_2.11-0.10.0.0.tgz

remove:
	@echo "Remove downloaded file - cleanup"
	@rm kafka_2.11-0.10.0.0.tgz

uncompress:
	@echo "Uncompressing Kafka"
	@tar -xzf kafka_2.11-0.10.0.0.tgz

get: download uncompress remove

startzookeeper:
	@echo "Starting zookeeper"
	@"$(WPATH)/kafka_2.11-0.10.0.0/bin/zookeeper-server-start.sh" "$(WPATH)/kafka_2.11-0.10.0.0/config/zookeeper.properties" >> "$(WPATH)/ZOOKEEPER.log";
	@echo "Started zookeeper"

startkafka:
	@echo "Starting kafka"
	@"$(WPATH)/kafka_2.11-0.10.0.0/bin/kafka-server-start.sh" "$(WPATH)/kafka_2.11-0.10.0.0/config/server.properties" >> "$(WPATH)/KAFKA.log";
	@echo "Started kafka"

startkafka-2:
	@echo "Starting kafka-2"
	@"$(WPATH)/kafka_2.11-0.10.0.0/bin/kafka-server-start.sh" "$(WPATH)/kafka_2.11-0.10.0.0/config/server-1.properties";

startkafka-3:
	@echo "Starting kafka-3"
	@"$(WPATH)/kafka_2.11-0.10.0.0/bin/kafka-server-start.sh" "$(WPATH)/kafka_2.11-0.10.0.0/config/server-2.properties";

createtesttopic:
	@echo "Create test topic"
	@"$(WPATH)/kafka_2.11-0.10.0.0/bin/kafka-topics.sh" "--create" "--zookeeper" "localhost:2181" "--replication-factor" "1" "--partitions" "1" "--topic" "test";

listexistingtopics:
	@echo "List of existing topics"
	@"$(WPATH)/kafka_2.11-0.10.0.0/bin/kafka-topics.sh" "--list" "--zookeeper" "localhost:2181";

startconsumer:
	@echo "Starting consumer"
	@"$(WPATH)/kafka_2.11-0.10.0.0/bin/kafka-console-consumer.sh" "--zookeeper" "localhost:2181" "--topic" "test" "--from-beginning";

startproducer:
	@echo "Starting producer"
	@"$(WPATH)/kafka_2.11-0.10.0.0/bin/kafka-console-producer.sh" "-broker-list" "localhost:9092" "--topic" "test";

createreplicatedtesttopic:
	@echo "Create replicated test topic"
	@"$(WPATH)/kafka_2.11-0.10.0.0/bin/kafka-topics.sh" "--create" "--zookeeper" "localhost:2181" "--replication-factor" "3" "--partitions" "1" "--topic" "my-replicated-topic";

teststandalone:
	@echo "Create replicated test topic"
	@"$(WPATH)/kafka_2.11-0.10.0.0/bin/connect-standalone.sh" "$(WPATH)/kafka_2.11-0.10.0.0/config/connect-standalone.properties" "$(WPATH)/kafka_2.11-0.10.0.0/config/connect-standalone.properties" "$(WPATH)/kafka_2.11-0.10.0.0/config/connect-file-source.properties" '$(WPATH)/kafka_2.11-0.10.0.0/config/connect-file-sink.properties" >> "$(WPATH)/REPLICATEDTEST.log";
