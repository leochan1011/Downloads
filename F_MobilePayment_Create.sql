CREATE TABLE IF NOT EXISTS public.f_mobilepayment(
    BusinessDate TIMESTAMP WITHOUT TIME ZONE,
    TID VARCHAR(200),
    OrderTime TIMESTAMP WITHOUT TIME ZONE,
    StoreNo INTEGER,
    StoreName VARCHAR(200),
    PosTransactionId BIGINT,
    Platform VARCHAR(400),
    PlatformBuyerUserId VARCHAR(400),
    Amount NUMERIC(18,6),
    Platform_Discount NUMERIC(18,6),
    MCD_Discount NUMERIC(18,6),
    ZhuiHuOrderId VARCHAR (400),
    CreateDate TIMESTAMP WITHOUT TIME ZONE
);

COMMIT;
