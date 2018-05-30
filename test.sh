#!/bin/bash
echo "Michael Hannebery"
echo "Student Number : 28159454"
echo "Fit5202 : Assessment 2 - Question 1"
#
# remove hdfs folder & files
#
hadoop fs -rm -R /tmp/28159454/
#
# Download CSV files into current directory and unzip
#
#rm *.csv
#wget http://spatialkeydocs.s3.amazonaws.com/FL_insurance_sample.csv.zip
#unzip *.zip
#rm *.zip
#rm -R __MACOSX
echo
echo "Script Assumptions"
echo "=================="
echo
echo "Please ensure that the source CSV file is located in the same directory as the script file"
echo
echo "1. Create a folder on the HDFS and name it after your student number: /tmp/<student no>"
echo 
echo "hadoop fs -mkdir -p /tmp/28159454"
echo 
#
# Create directory for storing CSV work files
#
hadoop fs -mkdir -p /tmp/28159454
echo
echo "2. Copy downloaded CSV file to HDFS folder"
echo 
#
# Copy downloaded CSV file to HDFS folder
#
echo "hadoop fs -put *.csv /tmp/28159454"
hadoop fs -put *.csv /tmp/28159454
echo
echo "3. Create insurance table with 3 column families - location,cost & house"
echo
#
# Create hbase table called insure with 3 column families - location,cost & house
#
echo -e "disable 'insurance'" | hbase shell -n
echo -e "drop 'insurance'" | hbase shell -n
echo "hbase >create 'insurance','location','cost','house'"
echo -e "create 'insurance','location','cost','house'" | hbase shell -n
echo "describe 'insurance'"
echo -e "describe 'insurance'" | hbase shell -n
echo 
echo "4. Import CSV file into hbase using ImportTsv function"
echo 
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.columns='HBASE_ROW_KEY,location:statecode,location:county,cost:eq_site_limit,
cost:hu_site_limit,cost:fl_site_limit,cost:fr_site_limit,cost:tiv_2011,cost:tiv_2012,cost:eq_site_deductible,cost:hu_site_deductible,
cost:fl_site_deductible,cost:fr_site_deductible,location:point_latitude,location:point_longitude,house:line,house:construction,
house:point_granularity' -Dimporttsv.separator=',' insurance /tmp/28159454/FL_insurance_sample.csv
echo -e "deleteall 'insurance','policyID'" | hbase shell -n
echo
echo "5. Detect number of rows in Insurance"
echo "count 'insurance',INTERVAL=> 10000"
echo -e "count 'insurance',INTERVAL=> 10000" | hbase shell -n
echo 
echo "6. Add one row to Insurance"
echo
echo -e "put 'insurance','999999','house:line','Tree House'" | hbase shell -n
echo -e "count 'insurance',INTERVAL=> 10000" | hbase shell -n
echo
echo "7. Display added row in insurance table"
echo -e "get 'insurance', '999999'" | hbase shell -n
echo
echo "8. Scan table to find added row"
echo -e "scan 'insurance', {FILTER => \"RowFilter(=, 'binary:999999')\"}"  | hbase shell -n
echo
echo "9. Change value of added row"
echo -e "put 'insurance','999999','house:line','Dolls House'" | hbase shell -n
echo -e "scan 'insurance', {FILTER => \"RowFilter(=, 'binary:999999')\"}"  | hbase shell -n
echo 
echo "10. Disable insurance table"
#echo -e "disable 'insurance'" | hbase shell -n
echo 
echo "11. Delete insurance table"
#echo -e "drop 'insurance'" | hbase shell -n
echo "==============="
echo "Script finished"
