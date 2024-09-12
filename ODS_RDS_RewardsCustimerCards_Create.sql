CREATE TABLE IF NOT EXISTS ODS_RDS_RewardsCustomerCards (  
    currencyid VARCHAR(48) NULL,
  customerinformationid bigint NULL,
  storeid bigint NULL,
  __$etl_lsn VARCHAR(80) NULL,
  rewardscustomercardsid bigint NULL,
  cardnumber VARCHAR(800) NULL,
  pincode VARCHAR(800) NULL,
  cardstatus VARCHAR(800) NULL,
  dateissued TIMESTAMP WITHOUT TIME ZONE NULL,
  status INTEGER NULL,
  dateexpires TIMESTAMP WITHOUT TIME ZONE NULL,
  statusreason INTEGER NULL,
  dateactivated TIMESTAMP WITHOUT TIME ZONE NULL,
  comment VARCHAR(1024) NULL,
  newloyaltyschemeid bigint NULL,
  balance numeric(19,4) NULL,
  storedvaluecardtype smallint NULL,
  datecancelled TIMESTAMP WITHOUT TIME ZONE NULL,
  cardnumbersuffix VARCHAR(80) NULL,
  isdefault VARCHAR(100) NULL,
  nickname VARCHAR(640) NULL,
  cardtypeid INTEGER NULL,
  CreateDate TIMESTAMP WITHOUT TIME ZONE NULL 
  );

COMMIT;