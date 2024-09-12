CREATE TABLE IF NOT EXISTS public.ods_rds_transactioncontrolinformation(
	transactioncontrolinformationid BIGINT  
	,transactionsaleid BIGINT 
	,controlinformationtypeid BIGINT  
    ,storeid BIGINT  
	,saledatetime TIMESTAMP WITHOUT TIME ZONE 
	,businessday TIMESTAMP WITHOUT TIME ZONE  
    ,registernumber INTEGER  
    ,clerkkey BIGINT  
	,postransactionid BIGINT    
	,amount NUMERIC(19,4)  
    ,quantity DOUBLE PRECISION 
    ,additionalinfo1 VARCHAR(800) 
	,additionalinfo2 VARCHAR(800) 
	,additionalinfo3 VARCHAR(800)  
    ,"__$etl_lsn" VARCHAR(80) 
	,statusadj INTEGER   
);

COMMIT;


