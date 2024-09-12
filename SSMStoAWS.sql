--export data
bcp "SELECT * FROM ODS_RDS_StoreSettlement where businessday between '20240301' and '20240430'" queryout "C:\IICS\Historical\ODS_RDS_StoreSettlement_202406.csv" -S 152.141.116.42 -d DWH -U edw_ro -P pass@word1 -c -C 65001 -t,

--upload to S3 Bucket
aws s3 cp "C:\IICS\Historical\ODS_RDS_StoreSettlement_202406.csv" s3://mcd-datahub/Test/

--check loaded date in target table
select distinct businessday from ODS_RDS_StoreSettlement
order by businessday

--copy data from csv to target table
copy public.ODS_RDS_StoreSettlement
from 's3://mcd-datahub/Test/ODS_RDS_StoreSettlement_202406.csv' iam_role 'arn:aws:iam::228616385414:role/informatica-redshift-read-s3' delimiter ',' region 'ap-southeast-1' IGNOREHEADER 0 EXPLICIT_IDS;
commit

--error log
select * from stl_load_errors
order by starttime desc

--row count of target table
SELECT count(1) FROM ODS_RDS_TransactionInventoryItem
WHERE businessday between '2023-12-01' and '2023-12-31' 
                 
--sample check target table
select top 1000 * from ODS_RDS_TransactionInventoryItem
WHERE businessday between '2023-12-01' and '2023-12-31'

bcp "select * from ODS_ADW_Tender where BusinessDate between '2023-02-01' and '2023-02-28'"  queryout C:\IICS\Historical\ODS_ADW_Tender_202302.txt -S 152.141.116.42 -d DWH -U edw_ro -P pass@word1 -c -C 65001 -t """

