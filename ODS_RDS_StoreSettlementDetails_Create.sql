CREATE TABLE IF NOT EXISTS public.ODS_RDS_StoreSettlementDetails(
    id BIGINT IDENTITY(1,1) NOT NULL,
    storesettlementid BIGINT,
    storesettlementdetailskey INTEGER,
    storesettlementdetailsid INTEGER,
    storeid BIGINT,
    financialitem VARCHAR(max),
    value NUMERIC(19,4),
    quantity DOUBLE PRECISION,
    businessday TIMESTAMP WITHOUT TIME ZONE,
    financialitemparent VARCHAR(max),
    __$etl_lsn VARCHAR(80),
    PRIMARY KEY (id) 
);

COMMIT;


