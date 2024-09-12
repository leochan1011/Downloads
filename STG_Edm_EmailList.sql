--ReminderEmail & RecurringEdmz
SELECT 
EmailAddress, 
B.CustomerID,
{$Filename} AS FileName,
{$CampaignName} AS CampaignName,
'N' AS IsExcluded
FROM M_Customer A
INNER JOIN ({$SQL}) B
ON A.CustomerID = B.CustomerID

--BlastCoupon
Select CustomerId, EmailAddress as Email 
from
(select UserId from ODS_OCE_SegmentDetails where Segment_Id in(
select psv_segment_id from F_OCE_Campaign_Mapping where ecp_campaign_id = (SELECT DISTINCT ecp_campaign_id
FROM STG_OCE_CampaignCreation_New
WHERE FileName = {$FileName} AND CampaignName = {$CampaignName})
)) a
inner join (Select CustomerID, EmailAddress from M_Customer) b
on a.UserId = b.CustomerID

SELECT *, CEILING(((ROW_NUMBER() OVER (PARTITION BY FileName,CampaignName ORDER BY Email ASC)-1)/100)+1) AS BatchNo 
FROM(SELECT * FROM STG_Edm_EmailList) user_query;

SELECT count(*) FROM STG_Edm_EmailList WHERE IsExcluded ='N'

-- UPDATE STG_Edm_EmailList
SET
    STG_Edm_EmailList.BatchNo = (SELECT CEILING(((ROW_NUMBER() OVER (PARTITION BY FileName,CampaignName ORDER BY Email ASC)-1)/1000)+1) 
    FROM(SELECT * FROM STG_Edm_EmailList) user_query
    WHERE user_query.IsExcluded = 'N')
    WHERE STG_Edm_EmailList.CustomerID = user_query.CustomerID

WITH CTE AS (
    SELECT *, CEILING(((ROW_NUMBER() OVER (PARTITION BY FileName,CampaignName ORDER BY Email ASC)-1)/1000)+1) AS UpdateBatchNo
    FROM STG_Edm_EmailList
    WHERE IsExcluded = 'N')
UPDATE CTE
SET BatchNo = UpdateBatchNo

Select top 5 * from Temp_MailSend_Batch
select * from F_CustomerLifeStage where SnapshotDate = left(convert(varchar, dateadd(day, -1, getdate()), 121),10)  and LifeStage in ( 'Lapsed')

------------------------------------------------
INSERT INTO STG_Edm_Personalization (EdmId, BatchNo,EdmType,Email, UserId, TemplateId, EdmFieldName, EdmFieldValue,CreatedBy,CreatedDate)
--RecurringEdm Free text data
select 
a.RecurringEdmId AS EdmId, 
b.BatchNo,
b.EdmType,
b.ToEmail AS Email, 
b.UserId, 
b.TemplateId, 
FieldName as EdmFieldName, 
FieldValue as EdmFieldValue,
'IICS ETL' AS CreatedBy,
GETDATE() AS CreatedDate
from F_Recurring_Edm_Field a 
inner join CTL_Edm_Schedule_Detail b 
on a.RecurringEdmId = b.EdmId 
where b.EdmType='RecurringEdm' and ApiStatus='Pending'
UNION ALL
--ReminderEdm / BlastCoupon Free Text Data
select 
b.EdmId, 
b.BatchNo,
b.EdmType,
b.ToEmail AS Email, 
b.UserId, 
b.TemplateId, 
FieldName as EdmFieldName, 
FieldValue as EdmFieldValue,
'IICS ETL' AS CreatedBy,
GETDATE() AS CreatedDate
from F_Campaign_Edm_Field a 
inner join (
SELECT 
EdmId,
BatchNo,
CASE WHEN EdmType = 'BlastCoupon' THEN 'First Blast Edm'
ELSE EdmType END AS EdmType,
ToEmail,
UserId,
TemplateId,
AppContextIdValue,
AppContextIdName
FROM CTL_Edm_Schedule_Detail
where EdmType in ('ReminderEdm','BlastCoupon') and ApiStatus='Pending') b 
on a.CampaignId = b.AppContextIdValue and b.AppContextIdName='ecp_campaign_id' AND a.EdmType = b.EdmType



------------------------------------------------------------------------------------------------------------------
--DB data (any email type)
---Loop each row of STG_Edm_Personalization_DBData, run the select sql in column "DBDataSQL" as a subquery
---For each iteration
insert into STG_Edm_Personalization (EdmId, BatchNo,EdmType,Email, UserId, TemplateId, EdmFieldName, EdmFieldValue,CreatedBy,CreatedDate)
select h.EdmId, 
d.BatchNo, 
d.EdmType, 
d.ToEmail AS Email, 
d.UserId, 
h.TemplateId, 
val.EdmFieldName, 
val.EdmFieldValue,
'IICS ETL' AS CreatedBy,
GETDATE() AS CreatedDate
from CTL_Edm_Schedule_Header h inner join CTL_Edm_Schedule_Detail d on h.edmId = d.edmId and h.batchNo = d.batchNo and h.ApiStatus='Pending' and h.EdmType = d.EdmType
inner join ({$DBDataSQL}) val on val.EdmId = h.EdmId and val.templateId = h.templateId {$Condition} --AND val.CustomerID = d.UserId
