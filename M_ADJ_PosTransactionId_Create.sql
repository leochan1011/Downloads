CREATE TABLE IF NOT EXISTS M_ADJ_PosTransactionId (  
	BusinessDate TIMESTAMP WITHOUT TIME ZONE NULL ,
	StoreNo INTEGER NULL,
	PosTransactionId bigint NULL,
	IssueType varchar(200) NULL
  );

COMMIT;