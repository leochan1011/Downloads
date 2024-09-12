with dr as (
select date from dm_d_date
-- where date between '2023-11-01' and '2023-11-02'
WHERE date BETWEEN '$$vStartDate' AND '$$vEndDate'
),
sm as (
select b.date,a.storeno,a.sapsiteno,a.Hr24OpenDate,a.Hr24CloseDate,a.BreakfastMenu,a.UsSiteNo,a.McCafeType
from m_store a
join dr b on b.date between a.effectivedate and a.expirydate
),
be as (
select b.date,a.sapsiteno,a.OpenDate,a.CloseDate,a.becode,a.BeTypeByProductDesc as BrandExtension,a.IsSecondKiosk
from m_brandextension a
join dr b on b.date between a.effectivedate and a.expirydate
),
mccafe as (
select distinct b.date,a.sapsiteno
from m_brandextension a
join dr b on b.date between a.effectivedate and a.expirydate
where a.BeTypeByProductDesc = 'McCafe'
),
mds as (
select distinct b.date,a.sapsiteno
from m_brandextension a
join dr b on b.date between a.effectivedate and a.expirydate
where a.BeTypeByProductDesc = 'MDS'
),
Dessert as (
select distinct b.date,a.sapsiteno
from m_brandextension a
join dr b on b.date between a.effectivedate and a.expirydate
where a.BeTypeByProductDesc = 'Dessert'
)
select 
s.date AS BusinessDate
,S.StoreNo
,S.SapSiteNo
,S.UsSiteNo
,Be.BeCode
,Be.BrandExtension
,CASE WHEN Be.IsSecondKiosk = 'Y'
			THEN 1
		WHEN Be.IsSecondKiosk = 'N'
			THEN 0
		ELSE 0
		END AS IsSecondKiosk
	,CASE WHEN S.BreakfastMenu = 'Y'
			THEN 1
		WHEN S.BreakfastMenu = 'N'
			THEN 0
		ELSE 0
		END AS IsBreakfast
	,CASE WHEN S.Hr24OpenDate <= s.date
			AND (
				S.Hr24CloseDate >= s.date
				OR S.Hr24CloseDate IS NULL
				)
			THEN 1
		ELSE 0
		END AS IsHr24
,CASE WHEN Be.OpenDate <= be.date
			AND Be.CloseDate >= be.date
			THEN 1
		ELSE 0
		END AS IsOpen
,CASE WHEN McCafe.SapSiteNo = S.SapSiteNo and S.McCafeType = 0 OR S.McCafeType IS NULL OR S.McCafeType ='' -- 0/NULL/blank
			THEN 1
		WHEN McCafe.SapSiteNo is null 
			THEN 0
		ELSE 0
		END AS IsMcCafeStore
,CASE WHEN Mds.SapSiteNo = S.SapSiteNo
			THEN 1
		WHEN Mds.SapSiteNo is null 
			THEN 0
		ELSE 0
		END AS IsMdsStore
,CASE WHEN Dessert.SapSiteNo = S.SapSiteNo
			THEN 1
		WHEN Dessert.SapSiteNo is null 
			THEN 0
		ELSE 0
		END AS IsKioskStore 
from sm s
left join be be on s.sapsiteno = be.sapsiteno and s.date = be.date
left join mccafe McCafe on s.sapsiteno = McCafe.sapsiteno and s.date = McCafe.date
left join mds Mds on s.sapsiteno = Mds.sapsiteno and s.date = Mds.date
left join Dessert Dessert on s.sapsiteno = Dessert.sapsiteno and s.date = Dessert.date