CREATE TABLE IF NOT EXISTS public.ODS_RDS_InventoryWaste(
    id BIGINT IDENTITY(1,1) NOT NULL,
    inventorywasteid BIGINT,
    storeid BIGINT,
    inventoryitemid BIGINT,
    wastevalue NUMERIC(19,4),
    wasteunits DOUBLE PRECISION,
    applydate TIMESTAMP WITHOUT TIME ZONE,
    employeeid BIGINT,
    createdate TIMESTAMP WITHOUT TIME ZONE,
    reason VARCHAR(800),
    businessday TIMESTAMP WITHOUT TIME ZONE,
    comment VARCHAR(MAX),
    __$etl_lsn VARCHAR(80),
    saleitemid BIGINT,
    saleitemwasteid BIGINT,
    PRIMARY KEY (id)
);

COMMIT;