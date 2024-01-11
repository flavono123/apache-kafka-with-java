package org.example;


import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.annotation.PartitionOffset;
import org.springframework.kafka.annotation.TopicPartition;

@SpringBootApplication
public class SpringConsumerApplication {
    public static Logger logger = LoggerFactory.getLogger(SpringConsumerApplication.class);

    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(SpringConsumerApplication.class);
        application.run(args);
    }

    @KafkaListener(topics = "test", groupId = "test-record-listener")
    public void recordListener(ConsumerRecord<String, String> record) {
        logger.info(record.toString());
    }

    @KafkaListener(topics = "test", groupId = "test-string-listener")
    public void stringListener(String record) {
        logger.info(record);
    }

    @KafkaListener(topics = "test", groupId = "test-property-listener", properties = {"max.poll.interval.ms:60000", "auto.offset.reset:earliest"})
    public void propertyListener(String record) {
        logger.info(record);
    }

    @KafkaListener(topics = "test", groupId = "test-concurrent-listener", concurrency = "3")
    public void concurrentListener(String record) {
        logger.info(record);
    }

    @KafkaListener(topicPartitions = {
            @TopicPartition(topic = "test01", partitions = {"0", "1"}),
            @TopicPartition(topic = "test02", partitionOffsets = @PartitionOffset(partition = "0", initialOffset = "3"))
        },
        groupId = "test-partition-listener"
    )
    public void partitionListener(ConsumerRecord<String, String> record) {
        logger.info(record.toString());
    }
}