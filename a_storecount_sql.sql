DECLARE @BusinessDate DATE = '2015-12-30';
-- DECLARE @BusinessDate DATE = ?;

SELECT BusinessDate
	, DataType
	, sum(MainStoreCount) AS MainStoreCount
	, sum(McCafeStoreCount) AS McCafeStoreCount
	, sum(MdsStoreCount) AS MdsStoreCount
	, sum(KioskStoreCount) AS KioskStoreCount
	, sum(Hr24StoreCount) AS Hr24StoreCount
	, sum(BreakfastStoreCount) AS BreakfastStoreCount
FROM (
	SELECT @BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, count(StoreNo) AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate = @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Main'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, 0 AS MainStoreCount
		, count(StoreNo) AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate = @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'McCafe'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, count(StoreNo) AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate = @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'MDS'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, count(StoreNo) AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate = @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Dessert'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, count(StoreNo) AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate = @BusinessDate
		AND IsOpen = 1
		AND IsHr24 = 1
		AND BrandExtension = 'Main'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'Daily' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, count(StoreNo) AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate = @BusinessDate
		AND IsOpen = 1
		AND IsBreakfast = 1
		AND BrandExtension = 'Main'
	
	UNION ALL
	
	--------------
	SELECT @BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, count(StoreNo) AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Main'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, 0 AS MainStoreCount
		, count(StoreNo) AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'McCafe'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, count(StoreNo) AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'MDS'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, count(StoreNo) AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Dessert'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, count(StoreNo) AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND IsHr24 = 1
		AND BrandExtension = 'Main'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'MTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, count(StoreNo) AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(month, DATEDIFF(month, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND IsBreakfast = 1
		AND BrandExtension = 'Main'
	
	UNION ALL
	
	--------------
	SELECT @BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, count(StoreNo) AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(yy, DATEDIFF(yy, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Main'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, 0 AS MainStoreCount
		, count(StoreNo) AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(yy, DATEDIFF(yy, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'McCafe'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, count(StoreNo) AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(yy, DATEDIFF(yy, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'MDS'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, count(StoreNo) AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(yy, DATEDIFF(yy, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND BrandExtension = 'Dessert'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, count(StoreNo) AS Hr24StoreCount
		, 0 AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(yy, DATEDIFF(yy, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND IsHr24 = 1
		AND BrandExtension = 'Main'
	
	UNION ALL
	
	SELECT @BusinessDate AS BusinessDate
		, 'YTD' AS DataType
		, 0 AS MainStoreCount
		, 0 AS McCafeStoreCount
		, 0 AS MdsStoreCount
		, 0 AS KioskStoreCount
		, 0 AS Hr24StoreCount
		, count(StoreNo) AS BreakfastStoreCount
	FROM F_StoreCount
	WHERE 1 = 1
		AND BusinessDate >= DATEADD(yy, DATEDIFF(yy, 0, @BusinessDate), 0)
		AND BusinessDate <= @BusinessDate
		AND IsOpen = 1
		AND IsBreakfast = 1
		AND BrandExtension = 'Main'
	) a
GROUP BY BusinessDate
	, DataType
