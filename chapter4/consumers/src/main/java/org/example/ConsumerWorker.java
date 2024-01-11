package org.example;

import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.Metric;
import org.apache.kafka.common.MetricName;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.Duration;
import java.util.Arrays;
import java.util.Map;
import java.util.Properties;

public class ConsumerWorker implements Runnable {
    private final static Logger logger = LoggerFactory.getLogger(ConsumerWorker.class);
    private Properties prop;
    private String topic;
    private String threadName;
    private KafkaConsumer<String, String> consumer;

    ConsumerWorker(Properties prop, String topic, int number) {
        this.prop = prop;
        this.topic = topic;
        this.threadName = "consumer-thread-" + number;
    }

    @Override
    public void run() {
        consumer = new KafkaConsumer<>(prop);
        consumer.subscribe(Arrays.asList(topic));
        while (true) {
            for (Map.Entry<MetricName, ? extends Metric> entry : consumer.metrics().entrySet()) {
                if ("records-lag-max".equals(entry.getKey().name()) |
                        "records-lag".equals(entry.getKey().name()) |
                        "records-avg".equals(entry.getKey().name())) {
                    Metric metric = entry.getValue();
                    logger.info("{}: {}", threadName, metric.metricValue());
                }
            }
            consumer.poll(Duration.ofSeconds(1)).forEach(record -> {
                logger.info("{}: {}", threadName, record);
            });
        }
    }
}