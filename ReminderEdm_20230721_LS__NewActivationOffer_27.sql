select a.CustomerID 
from F_CustomerLifeStage a
inner join 
M_Customer b
on a.customerid = b.customerid
where a.SnapshotDate = left(convert(varchar, dateadd(day, -1, getdate()), 121),10)  and LifeStage = 'New'
and LastPurchaseDate is null
and b.digitalmemberstartdate = left(convert(varchar, dateadd(day, -21, getdate()), 121),10)
and b.isactive = 1
and b.digitalmemberstartdate > '20230706'


----- Test Account
/*
union
select
CustomerID 
from M_Customer 
where CustomerID in (
5287927,
5317166,
5822599,
6563069,
8492856,
8505215,
8505465,
8517332,
8551439,
8963078,
9588354,
9777968,
9840483,
9934334,
9936855,
10305933
)
*/