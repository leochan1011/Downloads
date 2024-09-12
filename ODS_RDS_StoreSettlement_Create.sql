CREATE TABLE IF NOT EXISTS public.ODS_RDS_StoreSettlement(
    id BIGINT IDENTITY(1,1) NOT NULL,
    storesettlementid BIGINT,
    storeid BIGINT,
    tax DOUBLE PRECISION,
    settlementcreated TIMESTAMP WITHOUT TIME ZONE,
    grosssales DOUBLE PRECISION,
    netsales DOUBLE PRECISION,
    businessday TIMESTAMP WITHOUT TIME ZONE,
    cashvariance DOUBLE PRECISION,
    status boolean,
    managerid VARCHAR(800),
    cashdrop NUMERIC(19,4),
    varianceexplanation VARCHAR(MAX),
    __$etl_lsn VARCHAR(80),
    PRIMARY KEY (id) 
);

COMMIT;


