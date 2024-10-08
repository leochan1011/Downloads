CREATE TABLE IF NOT EXISTS public.ODS_RDS_CustomerInformation (  
  companyid varchar(576) NULL,
  divisionid varchar(576) NULL,
  departmentid varchar(576) NULL,
  customerid varchar(800) NULL,
  accountstatus varchar(576) NULL,
  customername varchar(800) NULL,
  customeraddress1 varchar(800) NULL,
  customeraddress2 varchar(800) NULL,
  customeraddress3 varchar(800) NULL,
  customercity varchar(800) NULL,
  customerstate varchar(800) NULL,
  customerzip varchar(160) NULL,
  customercountry varchar(800) NULL,
  customerphone varchar(800) NULL,
  customerfax varchar(800) NULL,
  customeremail varchar(960) NULL,
  customerwebpage varchar(1280) NULL,
  customerlogin varchar(960) NULL,
  customerfirstname varchar(800) NULL,
  customerlastname varchar(800) NULL,
  customersalutation varchar(160) NULL,
  attention varchar(800) NULL,
  customertypeid varchar(576) NULL,
  taxidno varchar(320) NULL,
  vattaxidnumber varchar(576) NULL,
  vattaxothernumber varchar(576) NULL,
  currencyid varchar(48) NULL,
  glsalesaccount varchar(576) NULL,
  termsid varchar(576) NULL,
  termsstart varchar(160) NULL,
  employeeid varchar(576) NULL,
  taxgroupid varchar(576) NULL,
  pricematrix varchar(576) NULL,
  pricematrixcurrent TIMESTAMP WITHOUT TIME ZONE,
  creditrating varchar(480) NULL,
  creditlimit NUMERIC(19,4) NULL,
  creditcomments varchar(4000) NULL,
  paymentday varchar(160) NULL,
  approvaldate TIMESTAMP WITHOUT TIME ZONE,
  customersince TIMESTAMP WITHOUT TIME ZONE,
  sendcreditmemos varchar(5) NULL,
  senddebitmemos varchar(5) NULL,
  statements varchar(5) NULL,
  statementcyclecode varchar(160) NULL,
  customerspecialinstructions varchar(4080) NULL,
  customershiptoid varchar(576) NULL,
  customershipforid varchar(576) NULL,
  shipmethodid varchar(576) NULL,
  warehouseid varchar(576) NULL,
  routinginfo1 varchar(1600) NULL,
  routinginfo2 varchar(1600) NULL,
  routinginfo3 varchar(1600) NULL,
  routinginfocurrent TIMESTAMP WITHOUT TIME ZONE,
  freightpayment varchar(800) NULL,
  pickticketsneeded varchar(5) NULL,
  packinglistneeded varchar(5) NULL,
  speciallabelsneeded varchar(5) NULL,
  customeritemcodes varchar(5) NULL,
  confirmbeforeshipping varchar(5) NULL,
  backorders varchar(5) NULL,
  usestorenumbers varchar(5) NULL,
  usedepartmentnumbers varchar(5) NULL,
  specialshippinginstructions varchar(4000) NULL,
  routingnotes varchar(3200) NULL,
  applyrebate varchar(5) NULL,
  rebateamount DOUBLE PRECISION,
  rebateglaccount varchar(576) NULL,
  rebateamountnotes varchar(800) NULL,
  applynewstore varchar(5) NULL,
  newstorediscount DOUBLE PRECISION,
  newstoreglaccount varchar(576) NULL,
  newstorediscountnotes varchar(800) NULL,
  applywarehouse varchar(5) NULL,
  warehouseallowance DOUBLE PRECISION,
  warehouseglaccount varchar(576) NULL,
  warehouseallowancenotes varchar(800) NULL,
  applyadvertising varchar(5) NULL,
  advertisingdiscount DOUBLE PRECISION,
  advertisingglaccount varchar(576) NULL,
  advertisingdiscountnotes varchar(800) NULL,
  applymanualadvert varchar(5) NULL,
  manualadvertising DOUBLE PRECISION,
  manualadvertisingglaccount varchar(576) NULL,
  manualadvertisingnotes varchar(800) NULL,
  applytrade varchar(5) NULL,
  tradediscount DOUBLE PRECISION,
  tradediscountglaccount varchar(576) NULL,
  tradediscountnotes varchar(800) NULL,
  specialterms varchar(800) NULL,
  ediqualifier varchar(32) NULL,
  ediid varchar(192) NULL,
  editestqualifier varchar(32) NULL,
  editestid varchar(192) NULL,
  edicontactname varchar(800) NULL,
  edicontactagentfax varchar(480) NULL,
  edicontactagentphone varchar(480) NULL,
  edicontactaddressline varchar(800) NULL,
  edipurchaseorders varchar(5) NULL,
  ediinvoices varchar(5) NULL,
  edipayments varchar(5) NULL,
  ediorderstatus varchar(5) NULL,
  edishippingnotices varchar(5) NULL,
  approved varchar(5) NULL,
  approvedby varchar(576) NULL,
  approveddate TIMESTAMP WITHOUT TIME ZONE,
  enteredby varchar(576) NULL,
  lockedby varchar(576) NULL,
  lockts TIMESTAMP WITHOUT TIME ZONE,
  customerinformationid bigint NULL,
  storeid bigint NULL,
  customermiddlename varchar(800) NULL,
  rewardstype varchar(800) NULL,
  customercell varchar(800) NULL,
  customeroptout INTEGER NULL,
  customertype INTEGER NULL,
  aptermsid bigint NULL,
  currentbalance NUMERIC(19,4) NULL,
  userid bigint NULL,
  customerstatus INTEGER NULL,
  onaccountbalance NUMERIC(19,4) NULL,
  customermailfirstname varchar(800) NULL,
  customermaillastname varchar(800) NULL,
  taxexemptaccountname varchar(800) NULL,
  isactive varchar(5) NULL,
  __$etl_lsn varchar(160) NULL,
  CreateDate TIMESTAMP WITHOUT TIME ZONE
);

COMMIT;