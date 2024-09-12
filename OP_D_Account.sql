WITH Account_Status AS (
-- The first condition for the selecting
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
-- Finding the max date of the each record
), as_max as(
SELECT AccountID, ExpiryDate, AccountStatus, ROW_NUMBER() OVER(PARTITION BY AccountID ORDER BY ExpiryDate DESC) as ordering 
	FROM Account_Status
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
	),
    Userfile
	AS
	(SELECT * FROM ODS_UF_AccountMaster
	where EffectiveEndDate = '2999-12-31'
	)


-- use temp table to do the comparision
SELECT
        a.AccountID, b.AccountStatus, actype.AccountType, opt.OptinOut_1 as OptinOut, a.DisplayName, a.FirstName, a.SurName, dmg.Description as DmgDescription, dmg.RecursiveName as DmgRecursiveName, uf.PIC, uf.Market, uf.Country as B2BCountry, uf.Region, uf.Entity, uf.Sector, a.Address1, a.ZipCode, a.City, a.State, a.Country, a.HomePhone, a.BusinessPhone, a.Fax, a.MobilePhone, a.EmailAddress1
    INTO #tmp_account
	FROM zBackup_ODS_DATA_Account as a
    LEFT JOIN (SELECT AccountId, AccountStatus FROM acstatus) b on b.AccountId = a.AccountId
    LEFT JOIN (SELECT AccountId, AccountType FROM Account_type ) actype on actype.AccountId = a.AccountId
    LEFT JOIN (SELECT AccountId, OptinOut_1 FROM Optinout) opt on opt.AccountId = a.AccountId
    INNER JOIN ODS_CNF_DmgCategory dmg on dmg.DmgCategoryId = a.DmgCategoryId
Update t
SET t.AccountType = uf.B2BAccountCategory
FROM #tmp_account t
JOIN ODS_UF_AccountMaster uf on uf.AccountId = t.AccountId


declare 
@UpdateRowCount int =0,
@InsertUpdateRowCount int =0,
@InsertRowCount int =0,
@DayofStart DATE = '1900/01/01',
@DayofEnd DATE = '2999/12/31'

-- Delta table exists accountId records, D_AccountId not exists records
INSERT INTO D_Account 
SELECT GetDate() AS ETL_Update_Datetime, @DayofStart AS RecStartDate, @DayofEnd AS RecEndDate, b.AccountID, b.DisplayName, b.FirstName, b.SurName, b.AccountStatus, b.AccountType, b.DmgDescription, b.DmgRecursiveName, b.PIC, b.Market, b.B2BCountry, b.Region, b.Entity, b.Sector, b.OptinOut, b.Address1, b.ZipCode, b.City, b.State, b.Country, b.HomePhone, b.BusinessPhone, b.Fax, b.MobilePhone, b.EmailAddress1
    FROM #tmp_account as b
    LEFT JOIN D_Account as a on a.AccountId = b.AccountId and a.RecEndDate = '2999-12-31'
    WHERE a.AccountId IS NULL
set @InsertRowCount = @@rowcount;


-- Step 1 : Using the Delta table compare to d_Account table, check the records wheater changed
-- SELECT AccountId FROM #tmp_account WHERE AccountId IN (
--     SELECT b.Account FROM #tmp_account as b
--     INNER JOIN D_Account_Test as a on a.AccountId = b.AccountId
--     WHERE (b.DisplayName <> a.DisplayName
--             OR b.FirstName <> a.FirstName
--             OR b.SurName <> a.SurName
--             OR b.DmgDescription <> a.DmgDescription
--             OR b.DmgRecursiveName <> a.DmgRecursiveName
--             OR b.Address1 <> a.Address1
--             OR b.ZipCode <> a.ZipCode
--             OR b.City <> a.City
--             OR b.State <> a.State
--             OR b.Country <> a.Country
--             OR b.HomePhone <> a.HomePhone
--             OR b.BusinessPhone <> a.BusinessPhone
--             OR b.Fax <> a.Fax
--             OR b.MobilePhone <> a.MobilePhone
--             OR b.EmailAddress1 <> a.EmailAddress1
--             ) AND a.RecEndDate = '2999-12-31'
-- )

-- Step 2 : Update the end_date of the old data in the target table
-- 	1900-01-01 ~ 2024-08-14
--	2024-08-15 ~ 2999-12-31 <--- latest 
UPDATE D_Account
SET RecEndDate = DATEADD(DD,-1,@StartDate),
    ETL_Update_Datetime = GetDate()
	,@UpdateRowCount = @@rowcount
WHERE AccountId IN (
    SELECT b.AccountId
FROM #tmp_account as b
    INNER JOIN D_Account as a on a.AccountId = b.AccountId
WHERE (b.DisplayName <> a.DisplayName
        OR b.FirstName <> a.FirstName
        OR b.SurName <> a.SurName
        OR b.AccountStatus <> a.AccountStatus
        OR b.AccountType <> a.AccountType
        OR b.DmgDescription <> a.DmgDescription
        OR b.DmgRecursiveName <> a.DmgRecursiveName
        OR b.PIC <> a.PIC
        OR b.Market <> a.Market
        OR b.B2BCountry <> a.B2BCountry
        OR b.Region <> a.Region
        OR b.Entity <> a.Entity
        OR b.Sector <> a.Sector
        OR b.OptInOut <> a.OptInOut
        OR b.Address1 <> a.Address1
        OR b.ZipCode <> a.ZipCode
        OR b.City <> a.City
        OR b.State <> a.State
        OR b.Country <> a.Country
        OR b.HomePhone <> a.HomePhone
        OR b.BusinessPhone <> a.BusinessPhone
        OR b.Fax <> a.Fax
        OR b.MobilePhone <> a.MobilePhone
        OR b.EmailAddress1 <> a.EmailAddress1
        ) AND a.RecEndDate = '2999-12-31'
);

-- Insert the latest record to the target table
INSERT INTO D_Account
    SELECT GetDate() AS ETL_Update_Datetime, @StartDate AS RecStartDate, @DayofEnd AS RecEndDate, b.AccountID, b.DisplayName, b.FirstName, b.SurName, b.AccountStatus, b.AccountType, b.DmgDescription, b.DmgRecursiveName, b.PIC, b.Market, b.B2BCountry, b.Region, b.Entity, b.Sector, b.OptinOut, b.Address1, b.ZipCode, b.City, b.State, b.Country, b.HomePhone, b.BusinessPhone, b.Fax, b.MobilePhone, b.EmailAddress1
FROM #tmp_account as b
    INNER JOIN D_Account as a on a.AccountId = b.AccountId
WHERE (b.DisplayName <> a.DisplayName
        OR b.FirstName <> a.FirstName
        OR b.SurName <> a.SurName
        OR b.AccountStatus <> a.AccountStatus
        OR b.AccountType <> a.AccountType
        OR b.DmgDescription <> a.DmgDescription
        OR b.DmgRecursiveName <> a.DmgRecursiveName
        OR b.PIC <> a.PIC
        OR b.Market <> a.Market
        OR b.B2BCountry <> a.B2BCountry
        OR b.Region <> a.Region
        OR b.Entity <> a.Entity
        OR b.Sector <> a.Sector
        OR b.OptInOut <> a.OptInOut
        OR b.Address1 <> a.Address1
        OR b.ZipCode <> a.ZipCode
        OR b.City <> a.City
        OR b.State <> a.State
        OR b.Country <> a.Country
        OR b.HomePhone <> a.HomePhone
        OR b.BusinessPhone <> a.BusinessPhone
        OR b.Fax <> a.Fax
        OR b.MobilePhone <> a.MobilePhone
        OR b.EmailAddress1 <> a.EmailAddress1
            );
set @InsertUpdateRowCount = @@rowcount;
set @TotalRowCount = @UpdateRowCount + @InsertUpdateRowCount + @InsertRowCount;
select  @TotalRowCount as TotalRowCount;
drop table #tmp_account;

END;

	--compare 
	#tmp vs D_Account where RecEndDate='2999-12-31'
	AccountId -> end of columns
	==> compare any value change

	--matched account id (delta exists accountid, D_Account exists account id)
	a) delta account data exactly = D_Account data (from DisplayName --> EmailAddress1)
	--do nothing

	b) Change detected (e.g.DisplayName changed)
	i) update existing D_Account eg. AccountKey=14, RecEndDate=@StartDate - 1

	ii) insert into D_Account: ods delta for AccountId = 1222922
	RecStartDate=@StartDate, RecEndDate=2999-12-31

	--select columns from ODS delta except (minus)  select columns from D_Account
	=> account id with changes


	--delta exists account id, D_Account id not eixsts ==> insert to D_Account (new account)
	--RecStartDate=1900-01-01 RecEndDate=2999-12-31


    INSERT INTO D_Account 
SELECT GetDate() AS ETL_Update_Datetime, '@DayofStart' AS RecStartDate, '@DayofEnd' AS RecEndDate, b.AccountID, b.DisplayName, b.FirstName, b.SurName, b.AccountStatus, b.AccountType, b.DmgDescription, b.DmgRecursiveName, b.PIC, b.Market, b.B2BCountry, b.Region, b.Entity, b.Sector, b.OptinOut, b.Address1, b.ZipCode, b.City, b.State, b.Country, b.HomePhone, b.BusinessPhone, b.Fax, b.MobilePhone, b.EmailAddress1
    FROM #tmp_account as b
    LEFT JOIN D_Account as a on a.AccountId = b.AccountId and a.RecEndDate = '2999-12-31'
    WHERE a.AccountId IS NULL
set @InsertRowCount = @@rowcount;