-- Truncate Table A_StoreCount_T

WITH date_range AS(
    SELECT
        Date FROM DM_D_Date
        -- WHERE Date BETWEEN '2023-01-01' AND '2023-01-02'
        WHERE Date BETWEEN '$$vStartDate' AND '$$vEndDate'
)
, DR as(SELECT * FROM F_StoreCount a JOIN date_range b on b.Date = a.BusinessDate)
SELECT BusinessDate
	, DataType
	, sum(MainStoreCount) AS MainStoreCount
	, sum(McCafeStoreCount) AS McCafeStoreCount
	, sum(MdsStoreCount) AS MdsStoreCount
	, sum(KioskStoreCount) AS KioskStoreCount
	, sum(Hr24StoreCount) AS Hr24StoreCount
	, sum(BreakfastStoreCount) AS BreakfastStoreCount
FROM (
    SELECT S.BusinessDate As BusinessDate
        ,'Daily' AS DataType
        , count(StoreNo) AS MainStoreCount
        , 0 AS McCafeStoreCount
        , 0 AS MdsStoreCount
        , 0 AS KioskStoreCount
        , 0 AS Hr24StoreCount
        , 0 AS BreakfastStoreCount
    FROM DR S 
    WHERE 1 = 1
            AND BusinessDate = S.BusinessDate
            AND IsOpen = 1
            AND BrandExtension = 'Main'
    GROUP BY S.BusinessDate

    UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, 0 AS MainStoreCount
		, count(StoreNo) AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S 
	WHERE 1 = 1
		AND BusinessDate = S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'McCafe'
    GROUP BY S.BusinessDate

    UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, count(StoreNo) AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate = S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'MDS'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, count(StoreNo) AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate = S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Dessert'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, count(StoreNo) AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate = S.BusinessDate
		AND IsOpen = 1
		AND IsHr24 = 1
		AND BrandExtension = 'Main'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, count(StoreNo) AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate = S.BusinessDate
		AND IsOpen = 1
		AND IsBreakfast = 1
		AND BrandExtension = 'Main'
    GROUP BY S.BusinessDate

	UNION ALL
	
	--------------
	SELECT S.BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, count(StoreNo) AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Main'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, 0 AS MainStoreCount
		, count(StoreNo) AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'McCafe'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, count(StoreNo) AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'MDS'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, count(StoreNo) AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Dessert'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, count(StoreNo) AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND IsHr24 = 1
		AND BrandExtension = 'Main'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, count(StoreNo) AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND IsBreakfast = 1
		AND BrandExtension = 'Main'
    GROUP BY S.BusinessDate

	UNION ALL
	
	--------------
	SELECT S.BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, count(StoreNo) AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(y, DATEDIFF(y, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Main'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, 0 AS MainStoreCount
		, count(StoreNo) AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(y, DATEDIFF(y, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'McCafe'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, count(StoreNo) AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(y, DATEDIFF(y, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'MDS'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, count(StoreNo) AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(y, DATEDIFF(y, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Dessert'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, count(StoreNo) AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(y, DATEDIFF(y, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND IsHr24 = 1
		AND BrandExtension = 'Main'
    GROUP BY S.BusinessDate

	UNION ALL
	
	SELECT S.BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, count(StoreNo) AS BreakfastStoreCount
	FROM DR S
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(y, DATEDIFF(y, '1900-01-01'::timestamp, S.BusinessDate::timestamp), '1900-01-01')
		AND BusinessDate <= S.BusinessDate
		AND IsOpen = 1
		AND IsBreakfast = 1
		AND BrandExtension = 'Main'
    GROUP BY S.BusinessDate
    )a 
GROUP BY BusinessDate, DataType