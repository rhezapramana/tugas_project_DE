CREATE OR REPLACE TABLE `project-taxi-nyc.taxi_data_engineering.tbl_analytics` AS (
SELECT
  ft.VendorID,
  dd.tpep_pickup_datetime,
  dd.tpep_dropoff_datetime,
  pcd.passenger_count,
  tdd.trip_distance,
  rcd.rate_code_name,
  pld.pickup_latitude,
  pld.pickup_location_id,
  dld.dropoff_latitude,
  dld.dropoff_longitude,
  ptd.payment_type_name,
  ft.fare_amount,
  ft.extra,
  ft.mta_tax,
  ft.tip_amount,
  ft.tolls_amount,
  ft.improvement_surcharge,
  ft.store_and_fwd_flag
FROM
  `project-taxi-nyc.taxi_data_engineering.fact_table` as ft
JOIN 
  `project-taxi-nyc.taxi_data_engineering.datetime_dim` as dd
ON
  ft.datetime_id = dd.datetime_id
JOIN 
  `project-taxi-nyc.taxi_data_engineering.passenger_count_dim` as pcd
ON
  ft.passenger_count_id = pcd.passenger_count_id
JOIN 
  `project-taxi-nyc.taxi_data_engineering.dropoff_location_dim` as dld
ON
  ft.dropoff_location_id = dld.dropoff_location_id
JOIN 
  `project-taxi-nyc.taxi_data_engineering.payment_type_dim` as ptd
ON
  ft.payment_type_id = ptd.payment_type_id
JOIN 
  `project-taxi-nyc.taxi_data_engineering.pickup_location_dim` as pld
ON
  ft.pickup_location_id = pld.pickup_location_id
JOIN 
  `project-taxi-nyc.taxi_data_engineering.rate_code_dim` as rcd
ON
  ft.rate_code_id = rcd.rate_code_id
JOIN 
  `project-taxi-nyc.taxi_data_engineering.trip_distance_dim` as tdd
ON
  ft.trip_distance_id = tdd.trip_distance_id);



