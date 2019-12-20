SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=1000;
SET hive.exec.max.dynamic.partitions.pernode=1000;

--Staging table for external HDFS file location.
CREATE EXTERNAL TABLE stage_table
(txn_date STRING, user_id STRING, amount BIGINT, txn_id BIGINT, modification_date STRING)
LOCATION "hdfs://loation_here";

--Partition table (actual table to load information).
CREATE EXTERNAL TABLE out_1_v1
(amount BIGINT, txn_id BIGINT, modification_date STRING)
PARTITIONED BY (txn_date STRING, user_id STRING)
LOCATION "hdfs://loation_here";

--Using dynamic partitioning
INSERT OVERWRITE TABLE out_1_v1 PARTITION (txn_date, user_id)
SELECT id, fname, lname, dt FROM stage_table;
--This will organize data.
