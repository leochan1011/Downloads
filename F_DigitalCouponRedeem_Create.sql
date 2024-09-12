CREATE TABLE IF NOT EXISTS public.F_DigitalCouponRedeem(
    BusinessDate TIMESTAMP WITHOUT TIME ZONE NULL,
    StoreNo INTEGER NULL,
    CouponTransactionId VARCHAR(400) NULL,
    RegisterNo INTEGER NULL,
    ItemNo INTEGER NULL,
    RedeemDate TIMESTAMP WITHOUT TIME ZONE NULL,
    RedeemQuantity NUMERIC(19,4) NULL,
    PriceOriginal NUMERIC(19,4) NULL,
    PriceDiscount NUMERIC(19,4) NULL,
    Paid NUMERIC(19,4) NULL,
    StoreName VARCHAR(200) NULL,
    VendorCode VARCHAR(200) NULL,
    VendorName VARCHAR(200) NULL,
    CouponCode VARCHAR(200) NULL,
    ActivityCode VARCHAR(200) NULL,
    ActivityName VARCHAR(200) NULL,
    ProductCode VARCHAR(200) NULL,
    ProductName VARCHAR(200) NULL,
    Remain NUMERIC(19,4) NULL,
    CouponState VARCHAR(200) NULL,
    CouponType VARCHAR(200) NULL,
    ValidDate TIMESTAMP WITHOUT TIME ZONE NULL,
    OrderId VARCHAR(200) NULL,
    BatchDate TIMESTAMP WITHOUT TIME ZONE NULL,
    CreateDate TIMESTAMP WITHOUT TIME ZONE NULL 
);

COMMIT;