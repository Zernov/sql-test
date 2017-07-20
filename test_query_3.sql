--1.----------------------------------------------------------------------------
CREATE TABLE item_zone_price (
  ZONE int,
  ITEM varchar(255),
  DATE date,
  PRICE double
);

INSERT INTO item_zone_price (ZONE, ITEM, DATE, PRICE)
SELECT ZONE, ITEM, ACTION_DATE, SELLING_RETAIL FROM rpm_zone_future_retail
WHERE ITEM = '03020318' AND ZONE = 1 AND ACTION_DATE <= '2012-09-01'
AND ACTION_DATE >= '2011-06-01' AND strftime('%d', ACTION_DATE) = '01';
--2.----------------------------------------------------------------------------
UPDATE rpm_future_retail
SET SELLING_RETAIL = (SELECT rpm_zone_future_retail.SELLING_RETAIL
  FROM rpm_zone_future_retail
  JOIN rpm_zone_location
  ON rpm_zone_future_retail.ZONE = rpm_zone_location.ZONE
  WHERE rpm_zone_future_retail.ITEM = rpm_future_retail.item
  AND rpm_zone_location.LOCATION = rpm_future_retail.LOCATION
  AND rpm_zone_future_retail.ACTION_DATE = rpm_future_retail.ACTION_DATE);
