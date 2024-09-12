with dr as (
select date,yeardate,yearmonthdate
from dm_d_date
where date between '2023-12-01' and '2023-12-05'
),
daily as (
select BusinessDate,
'Daily' as DataType,
count(case when BrandExtension = 'Main' and IsOpen = 1 then StoreNo else null end) as MainStoreCount,
count(case when BrandExtension = 'McCafe' and IsOpen = 1 then StoreNo else null end) as McCafeStoreCount,
count(case when BrandExtension = 'MDS' and IsOpen = 1 then StoreNo else null end) as MDSStoreCount,
count(case when BrandExtension = 'Dessert' and IsOpen = 1 then StoreNo else null end) as KioskStoreCount,
count(case when BrandExtension = 'Main' and IsOpen = 1 and IsHr24 = 1 then StoreNo else null end) as Hr24StoreCount,
count(case when BrandExtension = 'Main' and IsOpen = 1 and IsBreakfast = 1 then StoreNo else null end) as BreakfastStoreCount
from F_StoreCount
where BusinessDate between '2023-12-04' and '2023-12-05'
group by BusinessDate
),
MTD as (
select b.date as BusinessDate,
'MTD' as DataType,
count(case when BrandExtension = 'Main' and IsOpen = 1 then StoreNo else null end) as MainStoreCount,
count(case when BrandExtension = 'McCafe' and IsOpen = 1 then StoreNo else null end) as McCafeStoreCount,
count(case when BrandExtension = 'MDS' and IsOpen = 1 then StoreNo else null end) as MDSStoreCount,
count(case when BrandExtension = 'Dessert' and IsOpen = 1 then StoreNo else null end) as KioskStoreCount,
count(case when BrandExtension = 'Main' and IsOpen = 1 and IsHr24 = 1 then StoreNo else null end) as Hr24StoreCount,
count(case when BrandExtension = 'Main' and IsOpen = 1 and IsBreakfast = 1 then StoreNo else null end) as BreakfastStoreCount
from F_StoreCount a
join dr b on a.BusinessDate between yearmonthdate and date
group by b.date),
YTD as (
select b.date as BusinessDate,
'YTD' as DataType,
count(case when BrandExtension = 'Main' and IsOpen = 1 then StoreNo else null end) as MainStoreCount,
count(case when BrandExtension = 'McCafe' and IsOpen = 1 then StoreNo else null end) as McCafeStoreCount,
count(case when BrandExtension = 'MDS' and IsOpen = 1 then StoreNo else null end) as MDSStoreCount,
count(case when BrandExtension = 'Dessert' and IsOpen = 1 then StoreNo else null end) as KioskStoreCount,
count(case when BrandExtension = 'Main' and IsOpen = 1 and IsHr24 = 1 then StoreNo else null end) as Hr24StoreCount,
count(case when BrandExtension = 'Main' and IsOpen = 1 and IsBreakfast = 1 then StoreNo else null end) as BreakfastStoreCount
from F_StoreCount a
join dr b on a.BusinessDate between yeardate and date
group by b.date
)
select * 
from Daily
union all
select * from MTD
union all
select * from YTD