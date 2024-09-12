CREATE TABLE IF NOT EXISTS public.f_storecount(
	BusinessDate TIMESTAMP WITHOUT TIME ZONE  ENCODE az64,
	StoreNo INTEGER   ENCODE az64,
	SapSiteNo INTEGER   ENCODE az64,
	UsSiteNo VARCHAR(400)  ENCODE lzo,
	BeCode INTEGER   ENCODE az64,
	BrandExtension VARCHAR(200)  ENCODE lzo,
	IsSecondKiosk BOOLEAN ,
    IsBreakfast BOOLEAN ,
    IsHr24 BOOLEAN ,
    IsOpen BOOLEAN ,
    IsMcCafeStore BOOLEAN ,
    IsMdsStore BOOLEAN ,
    IsKioskStore BOOLEAN ,
    CreateDate TIMESTAMP WITHOUT TIME ZONE  ENCODE az64)
DISTSTYLE ALL
;


COMMIT;
