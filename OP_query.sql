select top 1000 * from D_PromotionMaster with (nolock) 



/* Creating a encrypt for password */
select * FROM cnf_user_test
SELECT * FROM sys.symmetric_keys;
GO

CREATE MASTER KEY  ENCRYPTION BY PASSWORD ='OCP@internal8929' ;


-- drop key
-- drop certificate encrypt;
-- drop master key;.

-- Create a certificate for AES_256 can read it on sys.symmetric_keys
 CREATE CERTIFICATE MyEncryptionCert  
   WITH SUBJECT = 'Data Encryption Certificate';  
GO  
-- Create a symmetric key contain with certificate
CREATE SYMMETRIC KEY TableKey01  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE MyEncryptionCert;  
GO  
-- Add a new column
ALTER TABLE dbo.CNF_User_test  
    ADD EncryptedPassword varbinary(256); 
GO  

-- Open the symmetric key with which to encrypt the data.  
-- Encrypt the value in column NationalIDNumber with symmetric   
-- key SSN_Key_01. Save the result in column EncryptedNationalIDNumber.  
OPEN SYMMETRIC KEY TableKey01  
   DECRYPTION BY CERTIFICATE MyEncryptionCert;  

UPDATE dbo.CNF_User_test 
SET EncryptedPassword = EncryptByKey(Key_GUID('TableKey01'), userpassword);  
GO  


----------------------------------------
-- Load Date
--((DT_WSTR, 4) DATEPART( "yy", @[User::vCurrentDate]  ))+ "-" + ((DT_WSTR, 2) DATEPART( "mm", @[User::vCurrentDate]  )) + "-" +((DT_WSTR, 2) DATEPART( "dd", @[User::vCurrentDate]  ))

CREATE PROCEDURE usp_D_Account
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    WITH Account_Status AS (
    Select A.AccountID
        ,try_convert(date, right(D.MaskData,10), 103) as ExpiryDate
        ,CASE
            WHEN (D.MaskData is null or D.MaskData = '') THEN 99
            WHEN try_convert(date, right(D.MaskData,10), 103) > CAST(GETDATE() as date) THEN 1
            WHEN try_convert(date, right(D.MaskData,10), 103) <= CAST(GETDATE() as date) THEN 0
        ELSE 99
        END AS AccountStatus
        from zBackup_ODS_DATA_Account A with(nolock) 
    inner join zBackup_ODS_DATA_DmgData D with(nolock) on D.Fkey = A.AccountId
    inner join ODS_CNF_DmgCategory dmg with(nolock) on A.DmgCategoryId = dmg.DmgCategoryId
    where (dmg.DmgCategoryCode = 'CORPORATE' or dmg.DmgCategoryCode like '%Account%')
    and D.DmgType = 1
    and ObjType = 504
    ), as_groupby as (
    SELECT AccountID, max(ExpiryDate) as ExpiryDate, AccountStatus
        FROM Account_Status
        Group by AccountID, AccountStatus
    ), as_max as(
    SELECT AccountID, ExpiryDate, AccountStatus, ROW_NUMBER() OVER(PARTITION BY AccountID ORDER BY ExpiryDate DESC) as ordering 
        FROM as_groupby
    ), acstatus as(
    SELECT AccountID, AccountStatus FROM as_max where ordering =1)
    ,Account_type AS (
    SELECT A.AccountId
            ,CASE
                WHEN (dmg.DmgCategoryCode ='REGB2C') THEN 'B2C'
                WHEN (dmg.DmgCategoryCode in ('SCHOOL','WINCAMP24A')) THEN 'Education (School)'
                WHEN (dmg.DmgCategoryCode in ('EDUSTD','EDUTEACH')) THEN 'Education (Individual)'
                WHEN (dmg.DmgCategoryCode in ('PASS01','WWSPPASS','REGMULTIAO','REGMULTICO','REGMULTISO','REGMULTI','REGMULTICH','REGMULTIST','REGMULTIR','WWMULTIAD','WWMULTICH','WWMULTIST')) THEN 'Membership'
                WHEN (dmg.DmgCategoryCode in ('PASS05','PASS03','PASS02')) THEN 'Non-Sales'
                WHEN (dmg.DmgCategoryCode = 'STAFF') THEN 'OP Staff'
                WHEN (dmg.DmgCategoryCode in ('EDAE001N','EDAE018N','EDAE011N','EDAE016N','EDAE013N','EDAE015N','EDAE021N','EDSNK01N')) THEN 'PAYG – animal program'
                WHEN (dmg.DmgCategoryCode ='PAYG') THEN 'PAYG – non animal program'
                ELSE NULL
            END AS AccountType
            FROM  zBackup_ODS_DATA_Account A inner join ODS_CNF_DmgCategory dmg with(nolock) on A.DmgCategoryId = dmg.DmgCategoryId
    ), Optinout AS (
        select *  from (
            select 
            aaa.AccountId
            ,aaa.EmailAddress1
            ,aaa.HomePhone
            ,aaa.MobilePhone
            ,aaa.BusinessPhone
            ,aaa.UpdDateTime
            ,aaa.Description as CustomerType
            ,aaa.OptinOut
            ,case when dd.DmgDataId is not null and OptinOut='optin' then 1 
                    when len(isnull(dd.DmgDataId,''))=0  and OptinOut='optout' then 0
            end as OptinOut_1
            from 
            (SELECT
                dmt.DataMaskId
            ,dmt.FieldName
            ,a.AccountId
            ,CASE
                        WHEN dmt.FieldName LIKE '%DO NOT%'
                                THEN 'optout'
                        WHEN dmt.FieldName LIKE '%agree%'
                                THEN 'optin'
                END AS OptinOut
            ,a.EmailAddress1
            ,a.MobilePhone
            ,a.HomePhone
            ,a.BusinessPhone
            ,a.UpdDateTime
            ,dmg.Description
            ,dm.ObjType
                --INTO #Raw
            FROM ODS_CNF_DataMaskTranslation dmt WITH (NOLOCK)
            INNER JOIN ODS_CNF_DataMask dm WITH (NOLOCK)
                ON dm.DataMaskId = dmt.DataMaskId
            INNER JOIN ODS_CNF_DmgCategory2Mask dmg2m WITH (NOLOCK)
                ON dmg2m.MaskId = dm.MaskId
            INNER JOIN ODS_CNF_DmgCategory dmg WITH (NOLOCK)
                ON dmg2m.DmgCategoryId = dmg.DmgCategoryId
            INNER JOIN zbackup_ODS_DATA_Account a WITH (NOLOCK)
                ON a.DmgCategoryId = dmg.DmgCategoryId
            WHERE dmt.LanguageId = 1
                AND dmt.FieldName LIKE '%market%'
                AND a.EmailAddress1 NOT LIKE '%xxx%'
            ) as aaa left join zbackup_ODS_DATA_DmgData dd WITH (NOLOCK)
            ON aaa.AccountId = dd.FKey  --------------------------------- in out check
                        AND aaa.ObjType = dd.ObjType ------------------- in out check

            where  OptinOut = 'optin' or OptinOut = 'optout'
        ) as bbb-- datamaskid
        WHERE bbb.OptinOut_1 = 1 
        and OptinOut='optin'

        union

        select 
            aaa.AccountId
            ,aaa.EmailAddress1
            ,aaa.HomePhone
            ,aaa.MobilePhone
            ,aaa.BusinessPhone
            ,aaa.UpdDateTime
            ,aaa.Description as CustomerType
            ,aaa.OptinOut
            ,case when dd.DmgDataId is not null and OptinOut='optin' then 1 
                    when dd.DmgDataId is null and OptinOut='optout' then 0
            end as OptinOut_1
            --,dd.DmgDataId
            from 
            (SELECT
                dmt.DataMaskId
            ,dmt.FieldName
            ,a.AccountId
            ,CASE
                        WHEN dmt.FieldName LIKE '%DO NOT%'
                                THEN 'optout'
                        WHEN dmt.FieldName LIKE '%agree%'
                                THEN 'optin'
                END AS OptinOut
            ,a.EmailAddress1
            ,a.MobilePhone
            ,a.HomePhone
            ,a.BusinessPhone
            ,a.UpdDateTime
            ,dmg.Description
            ,dm.ObjType
                --INTO #Raw
            FROM ODS_CNF_DataMaskTranslation dmt WITH (NOLOCK)
            INNER JOIN ODS_CNF_DataMask dm WITH (NOLOCK)
                ON dm.DataMaskId = dmt.DataMaskId
            INNER JOIN ODS_CNF_DmgCategory2Mask dmg2m WITH (NOLOCK)
                ON dmg2m.MaskId = dm.MaskId
            INNER JOIN ODS_CNF_DmgCategory dmg WITH (NOLOCK)
                ON dmg2m.DmgCategoryId = dmg.DmgCategoryId
            INNER JOIN zbackup_ODS_DATA_Account a WITH (NOLOCK)
                ON a.DmgCategoryId = dmg.DmgCategoryId
            WHERE dmt.LanguageId = 1
                AND dmt.FieldName LIKE '%market%'
                AND a.EmailAddress1 NOT LIKE '%xxx%'
            ) as aaa left join zbackup_ODS_DATA_DmgData dd WITH (NOLOCK)
            ON aaa.AccountId = dd.FKey  --------------------------------- in out check
                        AND aaa.ObjType = dd.ObjType ------------------- in out check

            where  (OptinOut = 'optin' or OptinOut = 'optout')
            and OptinOut = 'optout'
        )
    INSERT INTO D_Account_Test (AccountID, AccountStatus, AccountType, OptinOut, ETL_Update_Datetime, DisplayName, FirstName, SurName, DmgDescription, DmgRecursiveName, Address1, ZipCode, City, State, Country, HomePhone, BusinessPhone, Fax, MobilePhone, EmailAddress1)
    SELECT
        a.AccountID, b.AccountStatus, '1900-01-01' as RecStartDate, '2999-12-31' as RecEndDate, actype.AccountType, opt.OptinOut_1 as OptinOut, GetDate() as ETL_Update_Datetime, a.DisplayName, a.FirstName, a.SurName, dmg.Description as DmgDescription, dmg.RecursiveName as DmgRecursiveName, a.Address1, a.ZipCode, a.City, a.State, a.Country, a.HomePhone, a.BusinessPhone, a.Fax, a.MobilePhone, a.EmailAddress1
    FROM zBackup_ODS_DATA_Account as a
    LEFT JOIN (SELECT AccountId, AccountStatus FROM acstatus) b on b.AccountId = a.AccountId
    LEFT JOIN (SELECT AccountId, AccountType FROM Account_type ) actype on actype.AccountId = a.AccountId
    LEFT JOIN (SELECT AccountId, OptinOut_1 FROM Optinout) opt on opt.AccountId = a.AccountId
    INNER JOIN ODS_CNF_DmgCategory dmg on dmg.DmgCategoryId = a.DmgCategoryId
END;

    -- Encrypt the data
    --SET @EncryptedData = EncryptByKey(Key_GUID('YourEncryptionKey'), @DataToEncrypt);

CREATE PROCEDURE usp_D_Account
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    INSERT INTO D_Account_Test (AccountId, ETL_Update_Datetime, RecStartDate, RecEndDate, DisplayName, FirstName, SurName, AccountStatus)
    SELECT
        A.AccountId,
        GETDATE() AS ETL_Update_Datetime,
        '1900-01-01' AS ResStartDate,
        '2999-12-31' AS RecEndDate
        ,A.DisplayName
        ,A.FirstName
        ,A.SurName
        , CASE
            WHEN (D.MaskData is null or D.MaskData = '') THEN 99
            WHEN try_convert(date, right(D.MaskData,10), 103) > CAST(GETDATE() as date) THEN 1
            WHEN try_convert(date, right(D.MaskData,10), 103) <= CAST(GETDATE() as date) THEN 0
            ELSE 99
        END AS AccountStatus
        , NULL as AccountType
        , NULL AS OptinOut
    FROM zBackup_ODS_DATA_Account A
    inner join zBackup_ODS_DATA_DmgData D with(nolock) on D.Fkey = A.AccountId
    inner join ODS_CNF_DmgCategory dmg with(nolock) on A.DmgCategoryId = dmg.DmgCategoryId where (dmg.DmgCategoryCode = 'CORPORATE' or dmg.DmgCategoryCode like '%Account%')
    and D.DmgType = 1
    and ObjType = 504
END;

SELECT A.AccountId
        ,CASE
            WHEN (dmg.DmgCategoryCode ='REGB2C') THEN 'B2C'
            WHEN (dmg.DmgCategoryCode in ('SCHOOL','WINCAMP24A')) THEN 'Education (School)'
            WHEN (dmg.DmgCategoryCode in ('EDUSTD','EDUTEACH')) THEN 'Education (Individual)'
            WHEN (dmg.DmgCategoryCode in ('PASS01','WWSPPASS','REGMULTIAO','REGMULTICO','REGMULTISO','REGMULTI','REGMULTICH','REGMULTIST','REGMULTIR','WWMULTIAD','WWMULTICH','WWMULTIST')) THEN 'Membership'
            WHEN (dmg.DmgCategoryCode in ('PASS05','PASS03','PASS02')) THEN 'Non-Sales'
            WHEN (dmg.DmgCategoryCode = 'STAFF') THEN 'OP Staff'
            WHEN (dmg.DmgCategoryCode in ('EDAE001N','EDAE018N','EDAE011N','EDAE016N','EDAE013N','EDAE015N','EDAE021N','EDSNK01N')) THEN 'PAYG – animal program'
            WHEN (dmg.DmgCategoryCode ='PAYG') THEN 'PAYG – non animal program'
            ELSE NULL
        END AS AccountType
        FROM  zBackup_ODS_DATA_Account A inner join ODS_CNF_DmgCategory dmg with(nolock) on A.DmgCategoryId = dmg.DmgCategoryId

CREATE PROCEDURE InsertOrUpdateEncryptedData
    @PrimaryKey INT,
    @DateCondition DATE
AS
BEGIN
    -- Declare variables to hold the data
    DECLARE @DataToEncrypt NVARCHAR(MAX);
    DECLARE @EncryptedData VARBINARY(MAX);

    -- Select data from the source table
    SELECT @DataToEncrypt = DataColumn
    FROM SourceTable
    WHERE PrimaryKeyColumn = @PrimaryKey AND DateColumn = @DateCondition;

    -- Encrypt the data
    SET @EncryptedData = EncryptByKey(Key_GUID('YourEncryptionKey'), @DataToEncrypt);

    -- Use MERGE to insert or update the record in the destination table
    MERGE DestinationTable AS target
    USING (SELECT @PrimaryKey AS PrimaryKeyColumn, @EncryptedData AS EncryptedColumn) AS source
    ON (target.PrimaryKeyColumn = source.PrimaryKeyColumn)
    WHEN MATCHED THEN
        UPDATE SET EncryptedColumn = source.EncryptedColumn
    WHEN NOT MATCHED THEN
        INSERT (PrimaryKeyColumn, EncryptedColumn)
        VALUES (source.PrimaryKeyColumn, source.EncryptedColumn);
END;

CREATE PROCEDURE InsertOrUpdateD_Account
AS
BEGIN
    -- Declare variables for current date and next date
    DECLARE @CurrentDate DATE = GETDATE();
    DECLARE @NextDate DATE = DATEADD(DAY, 1, @CurrentDate);

    -- Update existing records' RecEndDate to current date
    UPDATE D_Account
    SET RecEndDate = @CurrentDate
    WHERE AccountId IN (
        SELECT AccountId
        FROM ODS_DATA_Account
        WHERE Last_DateTime_log BETWEEN '2024-01-01' AND '2024-01-02'
    );

    -- Insert new records with RecStartDate as current date plus one
    INSERT INTO D_Account (ETL_Update_Datetime, RecStartDate, RecEndDate, AccountId)
    SELECT 
        @CurrentDate AS ETL_Update_Datetime,  -- Current datetime for ETL_Update_Datetime
        @NextDate AS RecStartDate,            -- Current date plus one for RecStartDate
        '2999-12-31' AS RecEndDate,           -- Static value for RecEndDate
        AccountId                             -- AccountId from the source table
    FROM 
        ODS_DATA_Account
    WHERE 
        Last_DateTime_log BETWEEN '2024-01-01' AND '2024-01-02';
END;


SELECT dim.AccountID as 'Account ID', RTRIM(cast(replace(dim.DisplayName, '"', '""')as NCHAR(200))) as 'Company Name', dim.RecStartDate as 'Effective Start Date', dim.RecEndDate as 'Effective End Date', dim.AccountType as 'B2B Account Category'
, dim.PIC, dim.Market,dim.Country, dim.Region, dim.Entity, dim.Sector, Case WHEN (dim.AccountStatus ='1') THEN 'Inactive' WHEN (dim.AccountStatus ='0') THEN 'Active' WHEN(dim.AccountStatus ='99') THEN 'Invalid'  ELSE NULL  END AS 'Active Status'
FROM D_Account dim
INNER JOIN ODS_DATA_Account a on a.AccountId = dim.AccountId
WHERE dim.DmgCategoryCode IN ('CORPORATE','ACCOUNT', 'ACCOUNT01', 'ACCOUNT02', 'SCHOOL', 'WINCAMP24A')
order by dim.DisplayName