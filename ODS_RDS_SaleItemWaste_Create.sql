CREATE TABLE IF NOT EXISTS public.ODS_RDS_SaleItemWaste(
    id BIGINT IDENTITY(1,1) NOT NULL,
    saleitemwasteid bigint NULL,
	storeid bigint NULL,
	businessday TIMESTAMP WITHOUT TIME ZONE NULL,
	wastedate TIMESTAMP WITHOUT TIME ZONE NULL,
	saleitemid bigint NULL,
	unitid smallint NULL,
	unitcost DOUBLE PRECISION NULL,
	wasteqty DOUBLE PRECISION NULL,
	wastevalue DOUBLE PRECISION NULL,
	comment varchar(max) NULL,
	wasteqty1 DOUBLE PRECISION NULL,
	wasteqty2 DOUBLE PRECISION NULL,
	wasteqty3 DOUBLE PRECISION NULL,
	wasteunit1id smallint NULL,
	wasteunit2id smallint NULL,
	transactionsaleid bigint NULL,
	source varchar(800) NULL,
	__$etl_lsn varchar(80) NULL,
    PRIMARY KEY (id)
);

COMMIT;

