with dr as(
    SELECT distinct businessDay FROM public.ODS_RDS_TransactionSale 
    -- WHERE businessday between '2023-11-10' AND '2023-11-11'
    WHERE businessday between '$$vStartDate' AND '$$vEndDate'
),
ADJ as(
    SELECT b.BusinessDay as BusinessDate, S.storeno AS StoreNo, AP.PosTransactionId, TS.transactionsaleid as TransactionSaleId, TSI.transactionsaleitemid as TransactionSaleItemId
    FROM public.ODS_RDS_TransactionSale TS
    LEFT JOIN public.M_RDS_Store S ON S.storeid = TS.storeid
    AND ts.businessday >= S.StartDate
		AND (
			ts.businessday < s.EndDate
			OR S.EndDate IS NULL
			)
    JOIN public.M_ADJ_PosTransactionId AP on TS.businessday = AP.BusinessDate AND S.storeno = AP.StoreNo AND ts.postransactionid = AP.PosTransactionId
    JOIN dr b on TS.businessDay = b.businessDay
    Join (select transactionsaleid,transactionsaleitemid from public.ODS_RDS_TransactionSaleItem TSI 
    -- where TSI.businessday BETWEEN '2023-11-10' AND '2023-11-11'
    where TSI.businessday BETWEEN '$$vStartDate' AND '$$vEndDate' ) TSI on TS.transactionsaleid = TSI.transactionsaleid
)

---------------------------------------------------------
-- Delete ODS_RDS_Transactionsaleitemcoupon

UPDATE ODS_RDS_TransactionSaleItemCoupon Set StatusAdj = -1
where businessday BETWEEN '$$vStartDate' AND '$$vEndDate'
and transactionsaleid in (select distinct transactionsaleid from ADJ)

---------------------------------------------------------
-- Delete ODS_RDS_TransactionSaleItemCombo

UPDATE ODS_RDS_TransactionSaleItemCombo Set StatusAdj = -1
where businessday BETWEEN '$$vStartDate' AND '$$vEndDate'
and transactionsaleid in (select distinct transactionsaleid from ADJ)

---------------------------------------------------------
-- Delete ODS_RDS_TransactionDiscount

UPDATE ODS_RDS_TransactionDiscount Set StatusAdj = -1
where businessday BETWEEN '$$vStartDate' AND '$$vEndDate'
and transactionsaleid in (select distinct transactionsaleid from ADJ)

---------------------------------------------------------
-- Delete ODS_RDS_TransactionControlInformation

UPDATE ODS_RDS_TransactionControlInformation Set StatusAdj = -1
where businessday BETWEEN '$$vStartDate' AND '$$vEndDate'
and transactionsaleid in (select distinct transactionsaleid from ADJ)

---------------------------------------------------------
-- Delete ODS_RDS_TransactionInventoryItem

UPDATE ODS_RDS_TransactionInventoryItem Set StatusAdj = -1
where businessday BETWEEN '$$vStartDate' AND '$$vEndDate'
and transactionsaleitemid in (select distinct transactionsaleitemid from ADJ)

---------------------------------------------------------
-- Delete ODS_RDS_TransactionSaleItem

UPDATE ODS_RDS_TransactionSaleItem Set StatusAdj = -1
where businessday BETWEEN '$$vStartDate' AND '$$vEndDate'
and transactionsaleid in (select distinct transactionsaleid from ADJ)

---------------------------------------------------------
-- Delete ODS_RDS_TransactionSale
with dr as(
    SELECT distinct businessDay FROM public.ODS_RDS_TransactionSale 
    WHERE businessday BETWEEN '$$vStartDate' AND '$$vEndDate'
),
ADJ as (
    select b.BusinessDay as BusinessDate, S.storeno AS StoreNo, AP.PosTransactionId, TS.transactionsaleid as TransactionSaleId
    FROM public.ODS_RDS_TransactionSale TS 
    LEFT JOIN public.M_RDS_Store S ON S.storeid = TS.storeid
    AND ts.businessday >= S.StartDate
        AND (
            ts.businessday < s.EndDate
            OR S.EndDate IS NULL
            )
    inner join public.M_ADJ_PosTransactionId AP on TS.businessday = AP.BusinessDate and S.storeno = AP.StoreNo and ts.postransactionid = AP.PosTransactionId
    JOIN dr b on TS.businessDay = b.businessDay
)

UPDATE ODS_RDS_TransactionSale Set StatusAdj = -1
where businessday BETWEEN '$$vStartDate' AND '$$vEndDate'
and transactionsaleid in (select distinct transactionsaleid from ADJ)