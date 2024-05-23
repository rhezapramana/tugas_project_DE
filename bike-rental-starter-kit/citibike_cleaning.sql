SELECT
	*
FROM rides
LIMIT 25;

SELECT
	*
FROM date_dim
limit 25;

SELECT
	*
FROM stations
limit 25;

select
	*
FROM trip_demo
LIMIT 25;

SELECT
	*
FROM weather
LIMIT 25;

CREATE VIEW daily_counts AS
	SELECT
		dd.date_key,
		dd.full_date,
		dd.day,
		dd.day_name,
		dd.name_month,
		dd.weekend,
		COUNT(r.id) AS ride_totals,
		COUNT(td.user_type) FILTER (WHERE td.user_type = 'Subscriber') AS subscriber_rides,
		COUNT(td.user_type) FILTER (WHERE td.user_type = 'Customer') AS customer_rides,
		COUNT(td.user_type) FILTER (WHERE td.user_type = 'Unknown') AS unknown_rides,
		COUNT(r.valid_duration) FILTER (WHERE not r.valid_duration) AS late_return
	FROM rides r
	RIGHT JOIN trip_demo td
		ON r.trip_demo = td.id
	LEFT JOIN date_dim dd
		ON r.date_key = dd.date_key
	GROUP BY 1,2,3,4,5,6
	ORDER BY 1;
	
CREATE VIEW daily_data AS
	SELECT
		dc.date_key,
		dc.full_date,
		dc.day,
		dc.day_name,
		dc.name_month,
		dc.ride_totals,
		SUM(dc.ride_totals) OVER (PARTITION BY dc.name_month ORDER BY dc.date_key) AS month_running_total, 
		dc.subscriber_rides,
		dc.customer_rides,
		dc.unknown_rides,
		dc.late_return,
		dc.weekend,
		w.tmin,
		w.tavg,
		w.tmax,
		w.avg_wind,
		w.prcp,
		w.snow_amt,
		w.rain,
		w.snow
	FROM daily_counts dc
	JOIN weather w
		ON dc.date_key = w.date_key;
	
CREATE VIEW monthly_data AS
	SELECT
		ddi.month,
		ddi.name_month,
		ROUND(AVG(dd.ride_totals)) AS avg_daily_rides,
		SUM(dd.ride_totals) AS total_rides,
    	ROUND(AVG(dd.customer_rides)) AS avg_customer_rides,
    	SUM(dd.customer_rides) AS total_customer_rides,
    	ROUND(AVG(dd.subscriber_rides)) AS avg_subscriber_rides,
    	SUM(dd.subscriber_rides) AS total_subscriber_rides,
    	SUM(dd.unknown_rides) AS total_unknown_rides,
    	SUM(dd.late_return) AS total_late_returns,
    	ROUND(AVG(dd.tavg)) AS avg_tavg,
		COUNT(dd.snow) FILTER (WHERE dd.snow) AS days_with_snow,
		COUNT(dd.rain) FILTER (WHERE dd.rain) AS days_with_rain,
		MAX(dd.snow_amt) AS max_snow_amt,
    	MAX(dd.prcp) AS max_prcp
	FROM date_dim ddi
	JOIN daily_data dd
		ON ddi.date_key = dd.date_key
	GROUP BY 1,2
	ORDER BY 1;

CREATE VIEW late_return AS
	SELECT
		dd.full_date,
		r.id,
		r.bike_id,
		(SELECT
			s.station_name
		FROM stations s
		WHERE r.start_station_id = s.id) AS start_location,
		(SELECT
			s.station_name
		FROM stations s
		WHERE r.end_station_id = s.id) AS end_location,
		td.user_type
	FROM rides r
	JOIN date_dim dd
		ON r.date_key = dd.date_key
	JOIN trip_demo td
		ON r.trip_demo = td.id
	WHERE r.valid_duration = False;
	
CREATE VIEW week_summary AS
	SELECT
		d.day_name,
		ROUND(AVG(ride_totals)) AS avg_ride,
		ROUND(AVG(subscriber_rides)) AS avg_subscriber_rides,
		ROUND(AVG(customer_rides)) AS avg_customer_rides
	FROM daily_counts d
	GROUP BY 1;

CREATE VIEW hour_summary AS
	SELECT
		EXTRACT(HOUR FROM start_time) AS start_hour,
		COUNT(*) AS ride_totals
	FROM rides 
	GROUP BY 1
	ORDER BY 2 DESC;

CREATE VIEW trip_demographics AS
	SELECT 
		count(rides.id) AS total_rides,
   		trip_demo.age,
   		trip_demo.gender,
   		trip_demo.user_type
  	FROM rides
    JOIN trip_demo 
		ON rides.trip_demo = trip_demo.id
 	GROUP BY 2,3,4;

