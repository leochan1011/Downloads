CREATE TABLE IF NOT EXISTS public.ods_rds_transactionsale(
    transactionsaleid BIGINT,
    saledatetime TIMESTAMP WITHOUT TIME ZONE,
    storeid BIGINT,
    saleitemcount DOUBLE PRECISION,
    amount NUMERIC(19,4),
    tax NUMERIC(19,4),
    rounding NUMERIC(19,4),
    businessday TIMESTAMP WITHOUT TIME ZONE,
    saletypeid SMALLINT,
    servicetypeid SMALLINT,
    postransactionid BIGINT,
    clerkkey BIGINT,
    registernumber INTEGER,
    customerinformationid BIGINT,
    covers DOUBLE PRECISION,
    transactioncount SMALLINT,
    revenuecentreid SMALLINT,
    nonsales NUMERIC(19,4),
    __$etl_lsn VARCHAR(80),
    additionalinfo1 VARCHAR(1600),
    additionalinfo2 VARCHAR(1600),
    additionalinfo3 VARCHAR(1600),
    orderchannel INTEGER,
    StatusAdj INTEGER
);

COMMIT;