WITH datelist AS
(
  SELECT DATE,
         dateadd(DAY,-60,DATE) AS startdate,
         DATE AS enddate
  FROM DM_D_Date
  WHERE DATE BETWEEN '2024-01-24' AND '2024-01-25'
),
bd AS
(
  SELECT l.enddate AS ParameterDate,
         s.businessday,
         s.storeid,
         s.posdayclose,
         s.lockdate,
         RANK() OVER (PARTITION BY ParameterDate,storeid ORDER BY s.businessday DESC) AS rn
  FROM mrms.public.storebusinessdaylock s
    JOIN datelist l
      ON businessday BETWEEN l.startdate
     AND l.enddate
  WHERE posdayclose < '2099-01-01'
)
SELECT cbd.businessday AS BusinessDate,
       S.storenumber AS StoreNo,
       cbd.posdayclose AS PosClose,
       cbd.lockdate AS MrmsClose,
       pbd.businessday AS LastBusinessDate,
       pbd.posdayclose AS LastPosClose,
       pbd.lockdate AS LastMrmsClose,
       rn
FROM (SELECT businessday,
             storeid,
             posdayclose,
             lockdate
      FROM mrms.public.storebusinessdaylock s
      WHERE s.businessday BETWEEN '2024-01-24' AND '2024-01-25'
      AND   posdayclose < '2099-01-01') cbd
  LEFT JOIN (SELECT ParameterDate,
                    businessday,
                    storeid,
                    posdayclose,
                    lockdate,
                    rn
             FROM bd
             WHERE rn = 2) pbd ON cbd.storeid = pbd.storeid
  LEFT JOIN mrms.public.store S ON cbd.storeid = s.storeid
WHERE storeno = 99991


  --storeno = 3281

WITH datelist AS
(
  SELECT DATE,
         dateadd(DAY,-60,DATE) AS startdate,
         DATE AS enddate
  FROM DM_D_Date
  WHERE DATE BETWEEN '2024-01-24' AND '2024-01-25'
),
bd AS
(
  SELECT l.enddate AS ParameterDate,
         s.businessday,
         s.storeid,
         s.posdayclose,
         s.lockdate,
         RANK() OVER (PARTITION BY ParameterDate,storeid ORDER BY s.businessday DESC) AS rn
  FROM mrms.public.storebusinessdaylock s
    JOIN datelist l
      ON businessday BETWEEN l.startdate AND l.enddate
  WHERE posdayclose < '2099-01-01'
),
wd as (
SELECT s.businessday AS BusinessDate,
       s.posdayclose AS PosClose,
       s.lockdate AS MrmsClose,
       s.storeid
       FROM mrms.public.storebusinessdaylock s
       WHERE BusinessDate BETWEEN '2024-01-24' AND '2024-01-25'
       AND s.posdayclose < '2099-01-01'
)
SELECT BusinessDate,
       S.storenumber AS StoreNo,
       PosClose,
       MrmsClose,
       pbd.businessday AS LastBusinessDate,
       pbd.posdayclose AS LastPosClose,
       pbd.lockdate AS LastMrmsClose
FROM wd
  LEFT JOIN (SELECT ParameterDate,businessday,storeid,posdayclose,lockdate,rn FROM bd
             WHERE rn = 2) pbd ON wd.storeid = pbd.storeid
  LEFT JOIN mrms.public.store S ON wd.storeid = s.storeid
WHERE BusinessDate = ParameterDate

