CREATE TABLE IF NOT EXISTS public.ods_rds_transactioninventoryitem(
	transactioninventoryitemid BIGINT  
	,transactionsaleitemid BIGINT
	,saledatetime TIMESTAMP WITHOUT TIME ZONE
	,inventoryitemid BIGINT
    ,storeid BIGINT  
	,businessday TIMESTAMP WITHOUT TIME ZONE  
    ,quantity DOUBLE PRECISION 
	,baseinventoryunitofmeasure VARCHAR(800)
	,inventoryitemcost NUMERIC(19,4)
	,revenuecenterid SMALLINT
	,__$etl_lsn VARCHAR(80)
	,StatusAdj INTEGER
);

COMMIT;


