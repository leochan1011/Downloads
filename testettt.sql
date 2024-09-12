SELECT *
FROM mrms.public.transactionsale
WHERE businessday BETWEEN '$$vStartDate' AND '$$vEndDate'

--Truncate Table ODS_RDS_TransactionSale with (Partitions($PARTITION.PF_BusinessDate (?)));

Delete from  ODS_RDS_TransactionSale where Businessday = ?;

SELECT *
FROM ODS_RDS_TransactionSale
Order by transactionsaleid, saledatetime, storeid
SELECT *
FROM ODS_RDS_TransactionSaleitem
WHERE businessday BETWEEN '2023-12-01' AND '2023-12-02'

SELECT businessday, storeid, count(4)as saleitemcount, count(5)as amount, count(6) as tax
FROM ODS_RDS_TransactionSale
Group by businessday, storeid
Order by businessday, storeid

SELECT distinct storeid
from ODS_RDS_TransactionSale
Order by  storeid
--3282

select ts.businessday, tsic.*
FROM mrms.PUBLIC.transactionsaleitemcoupon tsic
  inner join (
    select transactionsaleid, businessday
  from mrms.PUBLIC.transactionsale  ts
  WHERE 1=1 and tS.businessday >= '2019-01-14' and tS.businessday <= '2019-01-14'
    ) ts
  on ts.transactionsaleid = tsic.transactionsaleid

SELECT SS.businessday, SSD.*
FROM mrms.PUBLIC.storesettlementdetails ssd
  INNER JOIN (
    select storesettlementid, businessday
  from mrms.PUBLIC.storesettlement ss
  WHERE 1=1 and
    SS.businessday BETWEEN '$$vStartDate' AND '$$vEndDate'
    )SS on SSD.storesettlementid = SS.storesettlementid

DELETE FROM ODS_RDS_StoreSettlementDetails 
where businessday BETWEEN '$$vStartDate' AND '$$vEndDate';

SELECT BusinessDay, StoreSettlementid, Storeid, SUM(Value), sum(quantity)
FROM ODS_RDS_storesettlementdetails
GROUP BY BusinessDay,StoreSettlementid,Storeid
order by businessday, storesettlementid,Storeid

SELECT ts.businessday, td.*
FROM mrms.PUBLIC.transactiondiscount td
  inner join (
    select transactionsaleid, businessday
  from mrms.PUBLIC.transactionsale ts
  WHERE 1=1 and tS.businessday BETWEEN '$$vStartDate' AND '$$vEndDate'
    )ts on ts.transactionsaleid = td.transactionsaleid

SELECT businessDay, storeid, sum(amount), sum(quantity), sum(tax)
FROM ODS_RDS_TransactionDiscount
WHERE businessday between '2023-12-13' AND '2023-12-14'
GROUP BY businessDay, storeid
ORDER BY businessDay, storeid

SELECT f.*
FROM mrms.public.forecastdetail f
WHERE 1=1 and cast([intervalstart] as date) BETWEEN '$$vStartDate' AND '$$vEndDate'

SELECT businessday, storeid, sum(amount), sum(quantity)
FROM ods_rds_transactioncontrolinformation
WHERE businessday between '2023-12-19' AND '2023-12-20'
GROUP BY businessday, storeid
Order By businessday, storeid

SELECT top 100
  *
FROM ods_rds_transactioncontrolinformation
WHERE businessday between '2023-12-19' AND '2023-12-20'
Order by businessday,storeid, transactioncontrolinformationid, transactionsaleid
, controlinformationtypeid

-- Test Summary
SELECT BusinessDate,
  Forecastid,
  storeid,
  StoreNo,
  sum(Rawsalesforecast),
  cast(sum(Rawtransactionforecast )as numeric(19,4)),
  sum(Systemsalesforecast),
  sum(Systemtransactionforecast),
  sum(Usersalesforecast),
  sum(Usertransactionforecast)
FROM ODS_RDS_Forecastdetail
WHERE BusinessDate Between '2023-12-20' AND '2023-12-21'
GROUP BY BusinessDate, storeid, StoreNo, Forecastid
ORDER BY BusinessDate, storeid, StoreNo, Forecastid

SELECT top 100
  *
FROM ODS_RDS_TransactionInventoryItem
WHERE businessday BETWEEN '2023-12-20' AND '2023-12-21'
Order by businessday, storeid, transactioninventoryitemid ,transactionsaleitemid,revenuecenterid

SELECT businessday, storeid, baseinventoryunitofmeasure, sum(quantity), sum(inventoryitemcost)
FROM ODS_RDS_TransactionInventoryItem
WHERE businessday BETWEEN '2023-12-20' AND '2023-12-21'
GROUP BY businessday, storeid, baseinventoryunitofmeasure
Order by businessday, storeid, baseinventoryunitofmeasure


companyid
divisionid
departmentid
customerid
accountstatus
customername
customeraddress1
customeraddress2
customeraddress3
customercity
customerstate
customerzip
customercountry
customerphone
customerfax
customeremail
customerwebpage
customerlogin
customerfirstname
customerlastname
customersalutation
attention
customertypeid
taxidno
vattaxidnumber
vattaxothernumber
currencyid
glsalesaccount
termsid
termsstart
employeeid
taxgroupid
pricematrix
pricematrixcurrent
creditrating
creditlimit
creditcomments
paymentday
approvaldate
customersince
sendcreditmemos
senddebitmemos
statements
statementcyclecode
customerspecialinstructions
customershiptoid
customershipforid
shipmethodid
warehouseid
routinginfo1
routinginfo2
routinginfo3
routinginfocurrent
freightpayment
pickticketsneeded
packinglistneeded
speciallabelsneeded
customeritemcodes
confirmbeforeshipping
backorders
usestorenumbers
usedepartmentnumbers
specialshippinginstructions
routingnotes
applyrebate
rebateamount
rebateglaccount
rebateamountnotes
applynewstore
newstorediscount
newstoreglaccount
newstorediscountnotes
applywarehouse
warehouseallowance
warehouseglaccount
warehouseallowancenotes
applyadvertising
advertisingdiscount
advertisingglaccount
advertisingdiscountnotes
applymanualadvert
manualadvertising
manualadvertisingglaccount
manualadvertisingnotes
applytrade
tradediscount
tradediscountglaccount
tradediscountnotes
specialterms
ediqualifier
ediid
editestqualifier
editestid
edicontactname
edicontactagentfax
edicontactagentphone
edicontactaddressline
edipurchaseorders
ediinvoices
edipayments
ediorderstatus
edishippingnotices
approved
approvedby
approveddate
enteredby
lockedby
lockts
customerinformationid
storeid
customermiddlename
rewardstype
customercell
customeroptout
customertype
aptermsid
currentbalance
userid
customerstatus
onaccountbalance
customermailfirstname
customermaillastname
taxexemptaccountname
isactive
__$etl_lsn
CreateDate

SELECT regexp_replace(additionalinfo3, '\\\\', '') as additionalinfo3
, regexp_replace(additionalinfo2, '\\\\', '') as additionalinfo2
, transactioncontrolinformationid
, transactionsaleid
, storeid
, saledatetime
, registernumber
, quantity
, postransactionid
, controlinformationtypeid
, clerkkey
, businessday
, amount
, additionalinfo1
, __$etl_lsn
FROM mrms.public.transactioncontrolinformation TS
WHERE 1=1 and TS.businessday BETWEEN '$$vStartDate' AND '$$vEndDate'

SELECT BusinessDate, Platform, sum(Amount), sum(Platform_Discount), sum(MCD_Discount)
FROM F_MobilePayment
WHERE businessDate = '2024-01-03'
GROUP BY BusinessDate, Platform
ORDER BY BusinessDate, Platform
---------------------------------------------------------------------------

With dr as
  (
    SELECT distinct DATE
    FROM DM_D_Date
    WHERE DATE BETWEEN '2023-03-30' AND '2023-03-31'
  ),
  TenderMain as
  (
    select * from ( 
      select *, RANK () OVER ( 
			PARTITION BY BusinessDate, StoreNo, PosTransactionId, TicketKey
			ORDER BY TenderAmountMain DESC
		  ) rn
      from (
        select a.BusinessDate, StoreNo, PosTransactionId, TicketKey, Tender as TenderMain, sum(TenderAmount) as TenderAmountMain
        from f_tender a Join dr d on a.BusinessDate = d.DATE
        GROUP BY TicketKey, Tender, a.BusinessDate, StoreNo, PosTransactionId
        )a )a
      WHERE rn=1
  ),
  Tender as
  (
    select a.BusinessDate, StoreNo, PosTransactionId, TicketKey, sum(TenderAmount) as TenderAmount
    from f_tender a Join dr d on a.BusinessDate = d.DATE
    group by TicketKey, a.BusinessDate, StoreNo, PosTransactionId
  )

SELECT tm.*, t.TenderAmount
from TenderMain tm left join Tender t on tm.TicketKey = t.TicketKey

Set-ExecutionPolicy -ExecutionPolicy unrestricted
\\192.168.26.66\infa\BDE\Script\CopyBdeMasterData.ps1 20240111 venues powershell -executionpolicy ByPass -File

C:\IICS\BDE\Script\CopyBdeFactData.ps1 20230905 saleheaders

-------------------------------------------------------------------
C:\IICS\BDE\Script\MoveFile.bat $$vRootPath *_$$vIntDate.csv $$vIntDate C:\IICS\BDE\Filelist\ saleheaders_filelist.txt

C:\IICS\BDE\Script\MoveFile.bat C:\IICS\BDE\Data\saleheaders\ *_20231230.csv 20231230 C:\IICS\BDE\Filelist\ saleheaders_filelist.txt

'"C:\IICS\BDE\Data\saleheaders\","*'||$temp.int_vDate||'*.csv",'||'"C:\IICS\BDE\Filelist\saleheaders_filelist.txt","saleheaders_sample.csv"'



C:\IICS\BDE\Script\FileList.bat C:\IICS\BDE\Data\saleheaders\ *_2023124.csv C:\IICS\BDE\Filelist\saleheaders_filelist.txt saleheaders_sample.csv

@echo off

rem Set parameters
set "file_directory=%1"
set "file_pattern=%2"
set "FileList=%3"
set "SampleFile=%4"
set "SampleObject=C:\IICS\BDE\Filelist\SampleObject\"

rem Check if files exist in the specified directory with the specified pattern
if not exist "%file_directory%%file_pattern%" (
    rem If no files match the pattern, list the sample file
    echo %SampleObject%%SampleFile% > "%FileList%"
) else (
    rem If files exist, list the first file found based on the pattern
    echo %file_directory%%file_pattern% > "%FileList%" 2>nul


IIF( IsNull(ReplaceStr(1, _timeframestartdate_ , '"', ''))=True, NULL, To_Date(ReplaceStr(1, _timeframestartdate_ , '"', '') , 'yyyy-MM-dd"T"HH24:MI:SS.NS"Z"'))

C:\IICS\BDE\Script\FileList.bat $$vRootPath saledetails_$$vIntDate.csv C:\IICS\BDE\Filelist\saledetails_filelist.txt saledetails_sample.csv
C:\IICS\BDE\Script\MoveFile.bat $$vRootPath *_$$vIntDate.csv $$vIntDate C:\IICS\BDE\Filelist\ saledetails_filelist.txt

select COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, 
       NUMERIC_PRECISION, DATETIME_PRECISION, 
       IS_NULLABLE 
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='CNF_PriceList'

SUBSTR(saleid,INSTR(saleid,':'),INSTR(saleid, '-' ) )
SUBSTR(saleid,INSTR(saleid,':')+1,LENGTH( saleid )-INSTR(saleid,':'))

IIF(INSTR(saleid,'-')>0,SUBSTR(saleid,INSTR(saleid,':')+1,INSTR(saleid,'-')-INSTR(saleid,':')-1),SUBSTR(saleid,INSTR(saleid,':')+1,LENGTH( saleid )-INSTR(saleid,':')))

$DateStr = (get-date).AddDays(-1).ToString("yyyyMMdd")