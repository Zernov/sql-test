--1.----------------------------------------------------------------------------
SELECT max_dates.ITEM, initial.SELLING_RETAIL, end_of_period.SELLING_RETAIL FROM
  (SELECT initial_date.ITEM AS ITEM, initial_date.MAX_DATE AS INITIAL_MAX_DATE, end_of_period_date.MAX_DATE AS END_OF_PERIOD_MAX_DATE
  FROM (SELECT ITEM, MAX(ACTION_DATE) AS MAX_DATE FROM rpm_zone_future_retail
  WHERE ZONE = 1 AND ACTION_DATE <= '2011-06-01'
  GROUP BY ITEM) as initial_date
  JOIN (SELECT ITEM, MAX(ACTION_DATE) AS MAX_DATE FROM rpm_zone_future_retail
  WHERE ZONE = 1 AND ACTION_DATE <= '2012-07-20'
  GROUP BY ITEM) AS end_of_period_date
  ON initial_date.ITEM = end_of_period_date.ITEM) AS max_dates
JOIN rpm_zone_future_retail AS initial
ON initial.ITEM = max_dates.ITEM AND initial.ACTION_DATE = max_dates.INITIAL_MAX_DATE AND initial.ZONE = 1
JOIN rpm_zone_future_retail AS end_of_period
ON end_of_period.ITEM = max_dates.ITEM AND end_of_period.ACTION_DATE = max_dates.END_OF_PERIOD_MAX_DATE AND end_of_period.ZONE = 1;
--2.a.--------------------------------------------------------------------------
SELECT location.ITEM FROM rpm_future_retail AS location
JOIN rpm_zone_location AS temp
ON temp.LOCATION = location.LOCATION
RIGHT JOIN rpm_zone_future_retail AS zone
ON zone.ZONE = temp.ZONE AND location.ITEM = zone.ITEM
WHERE zone.SELLING_RETAIL = null
GROUP BY location.ITEM;
--2.b.--------------------------------------------------------------------------
SELECT location.ITEM FROM rpm_future_retail AS location
JOIN rpm_zone_location AS temp
ON temp.LOCATION = location.LOCATION
JOIN rpm_zone_future_retail AS zone
ON zone.ZONE = temp.ZONE AND location.ITEM = zone.ITEM
WHERE zone.SELLING_RETAIL != location.SELLING_RETAIL
GROUP BY location.ITEM;
