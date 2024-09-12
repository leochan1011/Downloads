CREATE TABLE IF NOT EXISTS public.ODS_RDS_TransactionTender(
	saledatetime TIMESTAMP WITHOUT TIME ZONE,
	transactionsaleid BIGINT,
	transactiontenderid BIGINT,
	storeid BIGINT,
	tendertypeid SMALLINT,
	amount NUMERIC(19,4),
	sequenceno INTEGER,
	businessday TIMESTAMP WITHOUT TIME ZONE,
	quantity DOUBLE PRECISION
);

COMMIT;

