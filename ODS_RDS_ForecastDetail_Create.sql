CREATE TABLE IF NOT EXISTS public.ODS_RDS_ForecastDetail(
    id BIGINT IDENTITY(1,1) NOT NULL,
    BusinessDate TIMESTAMP WITHOUT TIME ZONE,
    forecastid BIGINT,
    intervalstart TIMESTAMP WITHOUT TIME ZONE,
    rawsalesforecast NUMERIC(19,4),
    rawtransactionforecast DOUBLE PRECISION,
    systemsalesforecast NUMERIC(19,4),
    systemtransactionforecast DOUBLE PRECISION,
    usersalesforecast NUMERIC(19,4),
    usertransactionforecast DOUBLE PRECISION,
    forecastdetailid BIGINT,
    storeid BIGINT,
    StoreNo INTEGER,
    PRIMARY KEY (id) 
);

COMMIT;


CREATE TABLE IF NOT EXISTS public.ODS_RDS_ForecastDetail_t(
    BusinessDate TIMESTAMP WITHOUT TIME ZONE,
    forecastid BIGINT,
    intervalstart TIMESTAMP WITHOUT TIME ZONE,
    rawsalesforecast NUMERIC(19,4),
    rawtransactionforecast DOUBLE PRECISION,
    systemsalesforecast NUMERIC(19,4),
    systemtransactionforecast DOUBLE PRECISION,
    usersalesforecast NUMERIC(19,4),
    usertransactionforecast DOUBLE PRECISION,
    forecastdetailid BIGINT,
    storeid BIGINT,
    StoreNo INTEGER
);

COMMIT;

