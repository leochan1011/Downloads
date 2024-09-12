WITH date_range AS (
SELECT 
   date FROM DM_D_Date
   WHERE date BETWEEN '$$vStartDate' AND '$$vEndDate'
--    WHERE date between '2023-11-01' and '2023-11-02'
    )
,SM as (
    select b.date,a.storeno,a.sapsiteno,a.Hr24OpenDate,a.Hr24CloseDate,a.BreakfastMenu,a.UsSiteNo,a.McCafeType
    from m_store a
    join date_range b on b.date between a.effectivedate and a.expirydate
    )
,be as (
    select b.date,a.sapsiteno,a.OpenDate,a.CloseDate,a.becode,a.BeTypeByProductDesc as BrandExtension,a.IsSecondKiosk
    from M_BrandExtension a
    join date_range b on b.date between a.effectivedate and a.expirydate
)
,mccafe as (
    select distinct b.date,a.sapsiteno
    from M_BrandExtension a
    join date_range b on b.date between a.effectivedate and a.expirydate
    where a.BeTypeByProductDesc = 'McCafe'
)
,mds as (
    select distinct b.date,a.sapsiteno
    from M_BrandExtension a
    join date_range b on b.date between a.effectivedate and a.expirydate
    where a.BeTypeByProductDesc = 'MDS'
)
,Dessert as (
    select distinct b.date,a.sapsiteno
    from M_BrandExtension a
    join date_range b on b.date between a.effectivedate and a.expirydate
    where a.BeTypeByProductDesc = 'Dessert'
)
SELECT S.Date AS BusinessDate, 
    S.StoreNo, 
    S.SapSiteNo, 
    S.UsSiteNo, 
    Be.BeCode, 
    Be.BrandExtension
    ,CASE 
        WHEN BE.IsSecondKiosk = 'Y'
            THEN 1
        WHEN BE.IsSecondKiosk = 'N'
            THEN 0
        ELSE 0
        END AS IsSecondKiosk
    ,CASE
        WHEN S.BreakfastMenu = 'Y'
            THEN 1
        WHEN S.BreakfastMenu = 'N'
            THEN 0
        ELSE 0
        END AS IsBreakfast
    ,CASE 
        WHEN S.Hr24OpenDate <= s.Date
            AND (
                S.Hr24CloseDate >= s.Date
                OR S.Hr24CloseDate IS NULL
            ) THEN 1
        ELSE 0
        END AS IsHr24
    ,CASE 
		WHEN BE.OpenDate <= BE.Date 
			AND BE.CloseDate >= BE.Date 
			THEN 1
		ELSE 0
		END AS IsOpen
    ,CASE 
		WHEN McCafe.SapSiteNo = S.SapSiteNo 
        AND (S.McCafeType = 0 OR S.McCafeType IS NULL OR S.McCafeType ='') -- 0/NULL/blank
			THEN 1
		WHEN McCafe.SapSiteNo is null 
			THEN 0
		ELSE 0
		END AS IsMcCafeStore
    ,CASE 
		WHEN Mds.SapSiteNo = S.SapSiteNo
			THEN 1
		WHEN Mds.SapSiteNo is null 
			THEN 0
		ELSE 0
		END AS IsMdsStore
	,CASE 
		WHEN Dessert.SapSiteNo = S.SapSiteNo
			THEN 1
		WHEN Dessert.SapSiteNo is null 
			THEN 0
		ELSE 0
		END AS IsKioskStore
FROM SM s
left join be be on s.sapsiteno = be.sapsiteno and s.date = be.date
left join mccafe McCafe on s.sapsiteno = McCafe.sapsiteno and s.date = McCafe.date
left join mds Mds on s.sapsiteno = Mds.sapsiteno and s.date = Mds.date
left join Dessert Dessert on s.sapsiteno = Dessert.sapsiteno and s.date = Dessert.date
