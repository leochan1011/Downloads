-- SELECT *, CEILING(((ROW_NUMBER() OVER (PARTITION BY Edmid ORDER BY Email ASC)-1)/10000)+1) AS BatchNo 
-- FROM(Select top 200 * FROM Temp_MailSend_Batch) user_query
-- TRUNCATE TABLE STG_Edm_EmailList

-- INSERT INTO STG_Edm_EmailList(Email, CustomerID)
-- SELECT * FROM (SELECT 'picspeaks@gmail.com' as email, 222222 as CustomID) STG


-- UPDATE STG_Edm_EmailList SET IsExcluded = COALESCE(IsExcluded, 'N');

-- Select * FROM STG_Edm_EmailList
-- where FileName = '';


-- TRUNCATE TABLE STG_Edm_EmailList;

-- SELECT Count(1) FROM STG_Edm_EmailList
-- Group By CampaignName;


-- SELECT *, CEILING(((ROW_NUMBER() OVER (PARTITION BY FileName,CampaignName ORDER BY Email ASC)-1)/1000)+1) AS BatchNo 
-- FROM(SELECT * FROM STG_Edm_EmailList) user_query;

-- WITH batch (IsExcluded) as 
-- (SELECT IsExcluded FROM STG_Edm_EmailList
-- WHERE IsExcluded = 'N')
--     SELECT *, CEILING(((ROW_NUMBER() OVER (PARTITION BY FileName,CampaignName ORDER BY Email ASC)-1)/1000)+1) AS BatchNo 
--     FROM STG_Edm_EmailList,batch
--     WHERE STG_Edm_EmailList.IsExcluded = batch.IsExcluded;


-- WITH CTE AS (
--     SELECT *, CEILING(((ROW_NUMBER() OVER (PARTITION BY FileName,CampaignName ORDER BY Email ASC)-1)/1000)+1) AS UpdateBatchNo
--     FROM STG_Edm_EmailList
--     WHERE IsExcluded = 'N')
-- UPDATE CTE
-- SET BatchNo = UpdateBatchNo

-- SELECT * FROM STG_Edm_Personalization 

-- insert into STG_Edm_Personalization (EdmId, BatchNo,EdmType,Email, UserId, TemplateId, EdmFieldName, EdmFieldValue,CreatedBy,CreatedDate)
-- select h.EdmId, 
-- d.BatchNo, 
-- d.EdmType, 
-- d.ToEmail AS Email, 
-- d.UserId, 
-- h.TemplateId, 
-- val.EdmFieldName, 
-- val.EdmFieldValue,
-- 'IICS ETL' AS CreatedBy,
-- GETDATE() AS CreatedDate
-- from CTL_Edm_Schedule_Header h inner join CTL_Edm_Schedule_Detail d on h.edmId = d.edmId and h.batchNo = d.batchNo and h.ApiStatus='Pending' and h.EdmType = d.EdmType
-- inner join ({$DBDataSQL}) val on val.EdmId = h.EdmId and val.templateId = h.templateId {$Condition} --AND val.CustomerID = d.UserId

-- select distinct UserID from CTL_Edm_Schedule_Detail a  
-- inner join CTL_Edm_Schedule_Header b 
-- on a.EdmID=b.EdmID and a.BatchNo = b.BatchNo where a.ApiStatus = 'Pending' and a.EdmID = 15

-- SELECT * FROM CTL_Edm_Schedule_Detail
-- where EdmId = 15 AND TemplateId = 'd-93a172dcf55d430cac69e269000f217a';

SELECT a.EdmId, a.TemplateId, x.CustomerID, x.FirstName FROM M_Customer x
INNER JOIN ((CTL_Edm_Schedule_Detail))
WHERE CustomerID IN (select distinct UserID from CTL_Edm_Schedule_Detail a 
inner join CTL_Edm_Schedule_Header b on a.EdmID=b.EdmID and a.BatchNo = b.BatchNo where a.ApiStatus = 'Pending' and a.EdmID = 15);
