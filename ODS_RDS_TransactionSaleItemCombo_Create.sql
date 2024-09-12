CREATE TABLE IF NOT Exists ODS_RDS_TransactionSaleItemCombo (  
    storeid bigint,  
    businessday TIMESTAMP WITHOUT TIME ZONE,  
    transactionsaleid bigint,  
    transactionsaleitemid bigint,  
    saledatetime TIMESTAMP WITHOUT TIME ZONE,  
    parentid bigint,  
    notionalprice numeric(19,4),  
    notionalcost numeric(19,4),  
    StatusAdj INTEGER 
    );

Commit;