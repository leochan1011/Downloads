CREATE TABLE IF NOT EXISTS public.ODS_RDS_TransactionDiscount(
    id BIGINT IDENTITY(1,1) NOT NULL,
    storeid BIGINT,
    transactionsaleid BIGINT,
    transactiondiscountid BIGINT,
    discounttypeid SMALLINT,
    amount NUMERIC(19,4),
    quantity DOUBLE PRECISION,
    tax NUMERIC(19,4),
    sequenceno INTEGER,
    transactionsaleitemid BIGINT,
    businessday TIMESTAMP WITHOUT TIME ZONE,
    __$etl_lsn VARCHAR(80),
    StatusAdj INTEGER,
    PRIMARY KEY (id) 
);

COMMIT;


