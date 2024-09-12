USE [OCP_DWH]
GO
/****** Object:  StoredProcedure [dbo].[usp_D_Account]    Script Date: 8/15/2024 2:55:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_D_Account]
    @StartDate DATE
	,@TotalRowCount int  output
AS
BEGIN
   WITH
    Account_Status
    AS
    (
        Select A.AccountID
	, try_convert(date, right(D.MaskData,10), 103) as ExpiryDate
	, CASE
		WHEN (D.MaskData is null or D.MaskData = '') THEN 99
		WHEN try_convert(date, right(D.MaskData,10), 103) > CAST(GETDATE() as date) THEN 1
		WHEN try_convert(date, right(D.MaskData,10), 103) <= CAST(GETDATE() as date) THEN 0
    ELSE 99
	END AS AccountStatus
        from ODS_DATA_Account A with(nolock)
            inner join ODS_DATA_DmgData D with(nolock) on D.Fkey = A.AccountId
            inner join ODS_CNF_DmgCategory dmg with(nolock) on A.DmgCategoryId = dmg.DmgCategoryId
        where (dmg.DmgCategoryCode = 'CORPORATE' or dmg.DmgCategoryCode like '%Account%')
            and D.DmgType = 1
            and ObjType = 504
    ),
    as_max
    AS  
    (
        SELECT AccountID, ExpiryDate, AccountStatus, ROW_NUMBER() OVER(PARTITION BY AccountID ORDER BY ExpiryDate DESC) as ordering
        FROM Account_Status
    ),
    acstatus
    AS  
    (
        SELECT AccountID, AccountStatus
        FROM as_max
        where ordering =1
    ),
    Account_type
    AS
    (
        SELECT A.AccountId
        , CASE
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
        FROM ODS_DATA_Account A inner join ODS_CNF_DmgCategory dmg with(nolock) on A.DmgCategoryId = dmg.DmgCategoryId
    ),
    Optinout
    AS
    (select *
     from (
		select
            aaa.AccountId
		  , aaa.EmailAddress1
		  , aaa.HomePhone
		  , aaa.MobilePhone
		  , aaa.BusinessPhone
		  , aaa.UpdDateTime
		  , aaa.Description as CustomerType
		  , aaa.OptinOut
		  , case when dd.DmgDataId is not null and OptinOut='optin' then 1 
		        when len(isnull(dd.DmgDataId,''))=0 and OptinOut='optout' then 0
		  end as OptinOut_1
                from
                    (SELECT
                        dmt.DataMaskId
		   , dmt.FieldName
		   , a.AccountId
		   , CASE
					  WHEN dmt.FieldName LIKE '%DO NOT%'
							 THEN 'optout'
					  WHEN dmt.FieldName LIKE '%agree%'
							 THEN 'optin'
			   END AS OptinOut
		   , a.EmailAddress1
		   , a.MobilePhone
		   , a.HomePhone
		   , a.BusinessPhone
		   , a.UpdDateTime
		   , dmg.Description
		   , dm.ObjType
                    --INTO #Raw
                    FROM ODS_CNF_DataMaskTranslation dmt WITH (NOLOCK)
                        INNER JOIN ODS_CNF_DataMask dm WITH (NOLOCK)
                        ON dm.DataMaskId = dmt.DataMaskId
                        INNER JOIN ODS_CNF_DmgCategory2Mask dmg2m WITH (NOLOCK)
                        ON dmg2m.MaskId = dm.MaskId
                        INNER JOIN ODS_CNF_DmgCategory dmg WITH (NOLOCK)
                        ON dmg2m.DmgCategoryId = dmg.DmgCategoryId
                        INNER JOIN ODS_DATA_Account a WITH (NOLOCK)
                        ON a.DmgCategoryId = dmg.DmgCategoryId
                    WHERE dmt.LanguageId = 1
                        AND dmt.FieldName LIKE '%market%'
                        AND a.EmailAddress1 NOT LIKE '%xxx%'
		) as aaa left join ODS_DATA_DmgData dd WITH (NOLOCK)
                    ON aaa.AccountId = dd.FKey --------------------------------- in out check
                        AND aaa.ObjType = dd.ObjType ------------------- in out check

                where  OptinOut = 'optin' or OptinOut = 'optout'
	) as bbb-- datamaskid
            WHERE bbb.OptinOut_1 = 1
                and OptinOut='optin'

        union

            select
                aaa.AccountId
		  , aaa.EmailAddress1
		  , aaa.HomePhone
		  , aaa.MobilePhone
		  , aaa.BusinessPhone
		  , aaa.UpdDateTime
		  , aaa.Description as CustomerType
		  , aaa.OptinOut
		  , case when dd.DmgDataId is not null and OptinOut='optin' then 1 
		        when dd.DmgDataId is null and OptinOut='optout' then 0
		  end as OptinOut_1
            --,dd.DmgDataId
            from
                (SELECT
                    dmt.DataMaskId
		   , dmt.FieldName
		   , a.AccountId
		   , CASE
					  WHEN dmt.FieldName LIKE '%DO NOT%'
							 THEN 'optout'
					  WHEN dmt.FieldName LIKE '%agree%'
							 THEN 'optin'
			   END AS OptinOut
		   , a.EmailAddress1
		   , a.MobilePhone
		   , a.HomePhone
		   , a.BusinessPhone
		   , a.UpdDateTime
		   , dmg.Description
		   , dm.ObjType
                --INTO #Raw
                FROM ODS_CNF_DataMaskTranslation dmt WITH (NOLOCK)
                    INNER JOIN ODS_CNF_DataMask dm WITH (NOLOCK)
                    ON dm.DataMaskId = dmt.DataMaskId
                    INNER JOIN ODS_CNF_DmgCategory2Mask dmg2m WITH (NOLOCK)
                    ON dmg2m.MaskId = dm.MaskId
                    INNER JOIN ODS_CNF_DmgCategory dmg WITH (NOLOCK)
                    ON dmg2m.DmgCategoryId = dmg.DmgCategoryId
                    INNER JOIN ODS_DATA_Account a WITH (NOLOCK)
                    ON a.DmgCategoryId = dmg.DmgCategoryId
                WHERE dmt.LanguageId = 1
                    AND dmt.FieldName LIKE '%market%'
                    AND a.EmailAddress1 NOT LIKE '%xxx%'
		) as aaa left join ODS_DATA_DmgData dd WITH (NOLOCK)
                ON aaa.AccountId = dd.FKey --------------------------------- in out check
                    AND aaa.ObjType = dd.ObjType ------------------- in out check

            where  (OptinOut = 'optin' or OptinOut = 'optout')
                and OptinOut = 'optout'
    ),
	Userfile
	AS
	(SELECT * FROM ODS_UF_AccountMaster
	where EffectiveEndDate = '2999-12-31'
	)

SELECT
    a.AccountID, b.AccountStatus, actype.AccountType, opt.OptinOut_1 as OptinOut, a.DisplayName, a.FirstName, a.SurName, dmg.DmgCategoryCode, dmg.Description as DmgDescription, dmg.RecursiveName as DmgRecursiveName, uf.PIC, uf.Market, uf.Country as B2BCountry, uf.Region, uf.Entity, uf.Sector, a.Address1, a.ZipCode, a.City, a.State, a.Country, a.HomePhone, a.BusinessPhone, a.Fax, a.MobilePhone, a.EmailAddress1
    into #tmp_account
	FROM ODS_DATA_Account as a
    LEFT JOIN (SELECT AccountId, AccountStatus FROM acstatus) b on b.AccountId = a.AccountId
    LEFT JOIN (SELECT AccountId, AccountType FROM Account_type ) actype on actype.AccountId = a.AccountId
    LEFT JOIN (SELECT AccountId, OptinOut_1 FROM Optinout) opt on opt.AccountId = a.AccountId
	LEFT JOIN Userfile uf on uf.AccountId = a.AccountId
    INNER JOIN ODS_CNF_DmgCategory dmg on dmg.DmgCategoryId = a.DmgCategoryId;

	Update t
	SET AccountType = uf.B2BAccountCategory
	FROM #tmp_account t
	INNER JOIN ODS_UF_AccountMaster uf on uf.AccountId = t.AccountId

declare 
@UpdateRowCount int =0,
@InsertUpdateRowCount int =0,
@InsertRowCount int =0,
@DayofStart DATE = '1900/01/01',
@DayofEnd DATE = '2999/12/31'

 INSERT INTO D_Account 
SELECT GetDate() AS ETL_Update_Datetime, @DayofStart AS RecStartDate, @DayofEnd AS RecEndDate, b.AccountID, b.DisplayName, b.FirstName, b.SurName, b.AccountStatus, b.AccountType, b.DmgCategoryCode, b.DmgDescription, b.DmgRecursiveName, b.PIC, b.Market, b.B2BCountry, b.Region, b.Entity, b.Sector, b.OptinOut, b.Address1, b.ZipCode, b.City, b.State, b.Country, b.HomePhone, b.BusinessPhone, b.Fax, b.MobilePhone, b.EmailAddress1
    FROM #tmp_account as b
    LEFT JOIN D_Account as a on a.AccountId = b.AccountId and a.RecEndDate = '2999-12-31'
    WHERE a.AccountId IS NULL
set @InsertRowCount = @@rowcount;



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
		OR b.DmgCategoryCode <> a.DmgCategoryCode
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

INSERT INTO D_Account
    SELECT GetDate() AS ETL_Update_Datetime, @StartDate AS RecStartDate, @DayofEnd AS RecEndDate, b.AccountID, b.DisplayName, b.FirstName, b.SurName, b.AccountStatus, b.AccountType, b.DmgCategoryCode, b.DmgDescription, b.DmgRecursiveName, b.PIC, b.Market, b.B2BCountry, b.Region, b.Entity, b.Sector, b.OptinOut, b.Address1, b.ZipCode, b.City, b.State, b.Country, b.HomePhone, b.BusinessPhone, b.Fax, b.MobilePhone, b.EmailAddress1
FROM #tmp_account as b
    INNER JOIN D_Account as a on a.AccountId = b.AccountId
WHERE (b.DisplayName <> a.DisplayName
        OR b.FirstName <> a.FirstName
        OR b.SurName <> a.SurName
        OR b.AccountStatus <> a.AccountStatus
        OR b.AccountType <> a.AccountType
		OR b.DmgCategoryCode<> a.DmgCategoryCode
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

select 'ADM_Gate2AccessConfiguration' as Table_name, count(1) as Record_count from ADM_Gate2AccessConfiguration 
union all
select 'CNF_Attribute' as Table_name, count(1) as Record_count from CNF_Attribute 
union all
select 'CNF_AttributeSet' as Table_name, count(1) as Record_count from CNF_AttributeSet 
union all
select 'CNF_AttributeSetDetail' as Table_name, count(1) as Record_count from CNF_AttributeSetDetail 
union all
select 'CNF_AttributeTemplate' as Table_name, count(1) as Record_count from CNF_AttributeTemplate 
union all
select 'CNF_CostCenter' as Table_name, count(1) as Record_count from CNF_CostCenter 
union all
select 'CNF_CostCenter_Validity' as Table_name, count(1) as Record_count from CNF_CostCenter_Validity 
union all
select 'CNF_DataMask' as Table_name, count(1) as Record_count from CNF_DataMask 
union all
select 'CNF_DataMaskTranslation' as Table_name, count(1) as Record_count from CNF_DataMaskTranslation 
union all
select 'CNF_DmgCategory' as Table_name, count(1) as Record_count from CNF_DmgCategory 
union all
select 'CNF_DmgCategory2Mask' as Table_name, count(1) as Record_count from CNF_DmgCategory2Mask 
union all
select 'CNF_EnvelopeCapacity' as Table_name, count(1) as Record_count from CNF_EnvelopeCapacity 
union all
select 'CNF_Event' as Table_name, count(1) as Record_count from CNF_Event 
union all
select 'CNF_Lookup' as Table_name, count(1) as Record_count from CNF_Lookup 
union all
select 'CNF_LookupTable' as Table_name, count(1) as Record_count from CNF_LookupTable 
union all
select 'CNF_MatrixCell' as Table_name, count(1) as Record_count from CNF_MatrixCell 
union all
select 'CNF_MatrixSheet' as Table_name, count(1) as Record_count from CNF_MatrixSheet 
union all
select 'CNF_OperatingArea' as Table_name, count(1) as Record_count from CNF_OperatingArea 
union all
select 'CNF_Performance' as Table_name, count(1) as Record_count from CNF_Performance 
union all
select 'CNF_ProductValidity' as Table_name, count(1) as Record_count from CNF_ProductValidity 
union all
select 'CNF_PriceList' as Table_name, count(1) as Record_count from CNF_PriceList 
union all
select 'CNF_Promotion' as Table_name, count(1) as Record_count from CNF_Promotion 
union all
select 'CNF_PromotionItem' as Table_name, count(1) as Record_count from CNF_PromotionItem 
union all
select 'CNF_PromotionItemRule' as Table_name, count(1) as Record_count from CNF_PromotionItemRule 
union all
select 'CNF_PromotionProduct' as Table_name, count(1) as Record_count from CNF_PromotionProduct 
union all
select 'CNF_PromotionValidity' as Table_name, count(1) as Record_count from CNF_PromotionValidity 
union all
select 'CNF_SpaceStructure' as Table_name, count(1) as Record_count from CNF_SpaceStructure 
union all
select 'CNF_StatisticalGroup' as Table_name, count(1) as Record_count from CNF_StatisticalGroup 
union all
select 'CNF_StatisticalGroupValidity' as Table_name, count(1) as Record_count from CNF_StatisticalGroupValidity 
union all
select 'CNF_User' as Table_name, count(1) as Record_count from CNF_User 

select 'DATA_Account' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_Account where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all 
select 'DATA_DmgData' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_DmgData where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_Media' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_Media where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_Payment' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_Payment where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_PaymentCredit' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_PaymentCredit where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_Reservation' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_Reservation where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_Sale' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_Sale where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_SaleCoupon' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_SaleCoupon where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_SaleItem' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_SaleItem where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_SaleItem2Performance' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_SaleItem2Performance where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_SaleItem2Ticket' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_SaleItem2Ticket where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_Ticket' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_Ticket where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_Ticket2Media' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_Ticket2Media where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_Transaction' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_Transaction where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_Transaction2Ticket' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_Transaction2Ticket where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_TransactionItem' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_TransactionItem where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'DATA_TicketUsage' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from DATA_TicketUsage where LogTimeStamp between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 



select 'ODS_ADM_Gate2AccessConfiguration' as Table_name, count(1) as Record_count from ODS_ADM_Gate2AccessConfiguration 
union all
select 'ODS_CNF_Attribute' as Table_name, count(1) as Record_count from ODS_CNF_Attribute 
union all
select 'ODS_CNF_AttributeSet' as Table_name, count(1) as Record_count from ODS_CNF_AttributeSet 
union all
select 'ODS_CNF_AttributeSetDetail' as Table_name, count(1) as Record_count from ODS_CNF_AttributeSetDetail 
union all
select 'ODS_CNF_AttributeTemplate' as Table_name, count(1) as Record_count from ODS_CNF_AttributeTemplate 
union all
select 'ODS_CNF_CostCenter' as Table_name, count(1) as Record_count from ODS_CNF_CostCenter 
union all
select 'ODS_CNF_CostCenter_Validity' as Table_name, count(1) as Record_count from ODS_CNF_CostCenter_Validity 
union all
select 'ODS_CNF_DataMask' as Table_name, count(1) as Record_count from ODS_CNF_DataMask 
union all
select 'ODS_CNF_DataMaskTranslation' as Table_name, count(1) as Record_count from ODS_CNF_DataMaskTranslation 
union all
select 'ODS_CNF_DmgCategory' as Table_name, count(1) as Record_count from ODS_CNF_DmgCategory 
union all
select 'ODS_CNF_DmgCategory2Mask' as Table_name, count(1) as Record_count from ODS_CNF_DmgCategory2Mask 
union all
select 'ODS_CNF_EnvelopeCapacity' as Table_name, count(1) as Record_count from ODS_CNF_EnvelopeCapacity 
union all
select 'ODS_CNF_Event' as Table_name, count(1) as Record_count from ODS_CNF_Event 
union all
select 'ODS_CNF_Lookup' as Table_name, count(1) as Record_count from ODS_CNF_Lookup 
union all
select 'ODS_CNF_LookupTable' as Table_name, count(1) as Record_count from ODS_CNF_LookupTable 
union all
select 'ODS_CNF_MatrixCell' as Table_name, count(1) as Record_count from ODS_CNF_MatrixCell 
union all
select 'ODS_CNF_MatrixSheet' as Table_name, count(1) as Record_count from ODS_CNF_MatrixSheet 
union all
select 'ODS_CNF_OperatingArea' as Table_name, count(1) as Record_count from ODS_CNF_OperatingArea 
union all
select 'ODS_CNF_Performance' as Table_name, count(1) as Record_count from ODS_CNF_Performance 
union all
select 'ODS_CNF_ProductValidity' as Table_name, count(1) as Record_count from ODS_CNF_ProductValidity 
union all
select 'ODS_CNF_PriceList' as Table_name, count(1) as Record_count from ODS_CNF_PriceList 
union all
select 'ODS_CNF_Promotion' as Table_name, count(1) as Record_count from ODS_CNF_Promotion 
union all
select 'ODS_CNF_PromotionItem' as Table_name, count(1) as Record_count from ODS_CNF_PromotionItem 
union all
select 'ODS_CNF_PromotionItemRule' as Table_name, count(1) as Record_count from ODS_CNF_PromotionItemRule 
union all
select 'ODS_CNF_PromotionProduct' as Table_name, count(1) as Record_count from ODS_CNF_PromotionProduct 
union all
select 'ODS_CNF_PromotionValidity' as Table_name, count(1) as Record_count from ODS_CNF_PromotionValidity 
union all
select 'ODS_CNF_SpaceStructure' as Table_name, count(1) as Record_count from ODS_CNF_SpaceStructure 
union all
select 'ODS_CNF_StatisticalGroup' as Table_name, count(1) as Record_count from ODS_CNF_StatisticalGroup 
union all
select 'ODS_CNF_StatisticalGroupValidity' as Table_name, count(1) as Record_count from ODS_CNF_StatisticalGroupValidity 
union all
select 'ODS_CNF_User' as Table_name, count(1) as Record_count from ODS_CNF_User 

select 'ODS_DATA_Account' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_Account where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all 
select 'ODS_DATA_DmgData' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_DmgData where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_Media' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_Media where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_Payment' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_Payment where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_PaymentCredit' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_PaymentCredit where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_Reservation' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_Reservation where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_Sale' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_Sale where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_SaleCoupon' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_SaleCoupon where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_SaleItem' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_SaleItem where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_SaleItem2Performance' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_SaleItem2Performance where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_SaleItem2Ticket' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_SaleItem2Ticket where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_Ticket' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_Ticket where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_Ticket2Media' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_Ticket2Media where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_Transaction' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_Transaction where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_Transaction2Ticket' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_Transaction2Ticket where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_TransactionItem' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_TransactionItem where Last_DateTime_Log between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 
union all
select 'ODS_DATA_TicketUsage' as Table_name, '2024-09-09 06:00:00 to 2024-09-10 06:00:00' as date, count(1) as Record_count from ODS_DATA_TicketUsage where LogTimeStamp between '2024-09-09 06:00:00.000' and '2024-09-10 06:00:00.000' 

