SELECT 
  VendorID,
  SUM(fare_amount) 
FROM 
  `project-taxi-nyc.taxi_data_engineering.fact_table`
GROUP BY VendorID;

SELECT
  ptd.payment_type_name,
  AVG(ft.tip_amount)
FROM 
  `project-taxi-nyc.taxi_data_engineering.fact_table` ft
JOIN
  `project-taxi-nyc.taxi_data_engineering.payment_type_dim` ptd
ON
  ft.payment_type_id = ptd.payment_type_id
GROUP BY 1;

-- find top 10 pickup location based on the number of trips
SELECT
  pickup_location_id,
  trip_distance_id,
  count(*)
FROM 
  `project-taxi-nyc.taxi_data_engineering.fact_table`
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

-- find the total number of trips by passengers count
SELECT
  passenger_count_id,
  trip_distance_id,
  COUNT(*) AS total_trips
FROM 
  `project-taxi-nyc.taxi_data_engineering.fact_table`
GROUP BY 1,2
ORDER BY 3 DESC;

-- find the average fare amount by hour of the day
SELECT
  dd.pick_hour,
  AVG(ft.fare_amount)
FROM 
  `project-taxi-nyc.taxi_data_engineering.fact_table` ft
JOIN 
  `project-taxi-nyc.taxi_data_engineering.datetime_dim` dd
ON 
  ft.datetime_id = dd.datetime_id
GROUP BY 1
ORDER BY 1;