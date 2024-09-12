CREATE TABLE IF NOT EXISTS public.A_StoreCount(
	BusinessDate TIMESTAMP WITHOUT TIME ZONE,
	DataType VARCHAR(20),
	MainStoreCount INTEGER,
	McCafeStoreCount INTEGER,
    MdsStoreCount INTEGER,
    KioskStoreCount INTEGER,
    Hr24StoreCount INTEGER,
    BreakfastStoreCount INTEGER,
    CreateDate TIMESTAMP WITHOUT TIME ZONE  )

COMMIT;

CREATE TABLE IF NOT EXISTS public.A_StoreCount_T(
	BusinessDate TIMESTAMP WITHOUT TIME ZONE,
	DataType VARCHAR(20),
	MainStoreCount INTEGER,
	McCafeStoreCount INTEGER,
    MdsStoreCount INTEGER,
    KioskStoreCount INTEGER,
    Hr24StoreCount INTEGER,
    BreakfastStoreCount INTEGER,
    CreateDate TIMESTAMP WITHOUT TIME ZONE )

COMMIT;