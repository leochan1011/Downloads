CREATE TABLE IF NOT EXISTS public.ODS_RDS_TransactionSaleitemCoupon(
	id BIGINT IDENTITY(1,1) NOT NULL,
    storeid BIGINT,
    transactionsaleid BIGINT,
    transactionsaleitemid BIGINT,
    transactionsaleitemcouponid BIGINT,
    saledatetime TIMESTAMP WITHOUT TIME ZONE,
    coupontypeid SMALLINT,
    amount NUMERIC(19,4),
    quantity DOUBLE PRECISION,
    sequenceno INTEGER,
    businessday TIMESTAMP WITHOUT TIME ZONE,
    taxamount NUMERIC(19,4),
    amountexcltax NUMERIC(19,4),
    __$etl_lsn VARCHAR(80),
    StatusAdj INTEGER,
    PRIMARY KEY (id) 
);

COMMIT;

