package org.example;


import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.annotation.PartitionOffset;
import org.springframework.kafka.annotation.TopicPartition;
import org.springframework.kafka.support.Acknowledgment;

import java.util.List;

@SpringBootApplication
public class SpringConsumerApplication {
    public static Logger logger = LoggerFactory.getLogger(SpringConsumerApplication.class);

    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(SpringConsumerApplication.class);
        application.run(args);
    }

    @KafkaListener(topics = "test", groupId = "test-record-listener")
    public void recordListener(ConsumerRecords<String, String> records, Acknowledgment ack) {
        records.forEach(r -> logger.info(r.toString()));
        ack.acknowledge();
    }


    @KafkaListener(topicPartitions = {
            @TopicPartition(topic = "test01", partitions = {"0", "1"}),
            @TopicPartition(topic = "test02", partitionOffsets = @PartitionOffset(partition = "0", initialOffset = "3"))
        },
        groupId = "test-partition-listener"
    )
    public void partitionListener(ConsumerRecords<String, String> records, Consumer<String, String> consumer) {
        records.forEach(r -> logger.info(r.toString()));
        consumer.commitAsync();
    }
}