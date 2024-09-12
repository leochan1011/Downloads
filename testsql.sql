SELECT sum(CAST(IsSecondKiosk As int )), sum(CAST(IsBreakfast As int )), sum(CAST(IsHr24 As int )), sum(CAST(IsOpen As int )), sum(CAST(IsMcCafeStore As int )), sum(CAST(IsMdsStore As int )), sum(CAST(IsKioskStore As int )) from F_StoreCount WHERE STORENO NOT BETWEEN 365 AND 369 
SELECT sum(IsSecondKiosk ), sum(IsBreakfast ), sum(IsHr24 ), sum(IsOpen ), sum(IsMcCafeStore ), sum(IsMdsStore ), sum(IsKioskStore ) from F_StoreCount WHERE STORENO NOT BETWEEN 365 AND 369 
SELECT businessDate, storeNo, SapSiteNo, UssiteNo,Becode, BrandExtension, Isbreakfast FROM f_storecount where businessdate BETWEEN '2023-01-01' AND '2023-01-02' AND isbreakfast =1 AND STORENO NOT BETWEEN 365 AND 369 AND storeno =7 

SELECT businessdate, storeno, brandextension, sum(CAST(IsSecondKiosk AS int) ), sum(CAST(IsBreakfast AS int) ), sum(CAST(IsHr24 AS int) ), sum(CAST(IsOpen AS int) ), sum(CAST(IsMcCafeStore AS int) ), sum(CAST(IsMdsStore AS int) ), sum(CAST(IsKioskStore AS int) ) FROM F_storecount 
where businessdate between '2023-12-04' AND '2023-12-05' Group by businessdate, storeno, brandextension 
Order By businessdate, storeno, upper(brandextension)


'"C:\IICS\DailyJob\Script\CopyFreemud.ps1",'||'"'||$temp.Str_vDate||'",'||'"'||$input.RootPath||'\"'
C:\IICS\data_upload\Freemud

'"'||$input.RootPath ||'\","*'||$temp.Str_vDate ||'*.csv",'||'"C:\IICS\DailyJob\mobilepayment.txt","Mcd_HK_Sample.csv"'

C:\IICS\DailyJob\Script\CopyFreemud2.ps1 2024-01-11 C:\IICS\data_upload\Freemud\Coupon_Redeem\
<rest:RESTResponse xmlns:rest="http://schemas.activebpel.org/REST/2007/12/01/aeREST.xsd"
                   statusCode="200">
   <rest:headers>
      <rest:header name="Connection" value="keep-alive"/>
      <rest:header name="Content-Length" value="-1"/>
      <rest:header name="Content-Security-Policy" value="upgrade-insecure-requests"/>
      <rest:header name="Content-Type" value="application/json"/>
      <rest:header name="Date" value="Tue, 09 Jan 2024 03:41:48 GMT"/>
      <rest:header name="Server" value="nginx/1.14.0"/>
      <rest:header name="Transfer-Encoding" value="chunked"/>
      <rest:header name="X-AE-HTTP-EXECUTION-TIME-IN-MILLIS" value="336"/>
      <rest:header name="X-AE-HTTP-RESPONSE-PARSING-TIME-IN-MILLIS" value="1"/>
      <rest:header name="X-AE-REDIRECTION-COUNT" value="0"/>
   </rest:headers>
   <rest:payload contentType="application/json">{"app_access_token":"DXsa8iMcxyfEdpWt","expires_in":7200}</rest:payload>
</rest:RESTResponse>

CREATE TABLE F_Tender_T (  
PosTransactionId bigint NULL,
PosTransactionTime timestamp NULL,
BusinessDate timestamp NULL,
CalendarDate timestamp NULL,
OrderTime timestamp NULL,
CompletedTime timestamp NULL,
SalesHour timestamp NULL,
SalesTime timestamp NULL,
Channel nvarchar(400) NULL,
StoreNo int NULL,
RegisterNo int NULL,
ServiceType nvarchar(1200) NULL,
CustomerId int NULL,
PromotionId bigint NULL,
Tender nvarchar(800) NULL,
TenderDetails nvarchar(800) NULL,
TenderAmount numeric(18,4) NULL,
TenderUserId nvarchar(800) NULL,
CreateDate timestamp NULL,
TicketKey nvarchar(800) NULL,
IsMember boolean NULL,
IsCouponSales boolean NULL,
IsCouponSalesDigital boolean NULL,
ChannelOrder nvarchar(400) NULL,
ChannelPayment nvarchar(400) NULL,
OriginalAmount numeric(18,4) NULL,
MerchantOrderID nvarchar(1024) NULL )

WITH datelist AS(
  SELECT DATE,
         dateadd(DAY,-60,DATE) AS startdate,
         DATE AS enddate
  FROM DM_D_Date
  WHERE DATE BETWEEN '2024-01-24' AND '2024-01-25'
),bd AS(
  SELECT d.enddate AS ParameterDate,
         s.businessday,
         s.storeid,
         s.posdayclose,
         s.lockdate,
         RANK() OVER (PARTITION BY s.storeid ORDER BY s.businessday DESC) AS rn
  FROM mrms.public.storebusinessdaylock s
    JOIN datelist d
      ON s.businessday BETWEEN d.startdate AND d.enddate
  WHERE posdayclose < '2099-01-01'
)
SELECT ParameterDate,
       businessday,
       storeid,
       posdayclose,
       lockdate,
       rn
FROM bd
WHERE rn = 2 ORDER BY ParameterDate

