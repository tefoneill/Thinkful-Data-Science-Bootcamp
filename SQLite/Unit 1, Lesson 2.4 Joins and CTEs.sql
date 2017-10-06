-- Drills: Using Joins and CTEs

-- 1. What are the three longest trips on rainy days?
-- 2. Which station is empty most often?
-- 3. Return a list of stations with a count of number of trips start at that station but ordered by dock count.
-- 4. (Challenge) What's the third longest trip for each day it rains anywhere?


-- 1. I'm going to interpret this question as, "What are the three longest trips out of all the trips that took place on rainy days?" To complete this query, I need to join the tables on date (extracting a substring from the start_date series), where the Events column contains "Rain", and take the three longest durations in the resulting table. By trip ID, the three longest rainy-day trips are: 1210487, 1244903, 1011634.

SELECT
	trips.duration,
	trips.trip_id,
	trips.start_date,
	weather.Events,
	weather.date
FROM
	trips
JOIN 
	weather
ON
	SUBSTR(trips.start_date, 1, 10) = weather.date
WHERE 
	weather.Events like "%Rain%"
GROUP BY trips.trip_id
ORDER BY trips.duration DESC
LIMIT 3

--Result: 
--"83915"	"1210487"	"94301"	"Rain"	"94301"
--"81687"	"1244903"	"94301"	"Rain"	"94301"
--"81484"	"1011634"	"94063"	"Rain"	"94063"

--2. The status table records the hourly status of each station, noting how many bikes are available, and how many docks are available. The query below creates an 'empty' case where there are no bikes available, then counts how often 'empty' occurs, grouped by station id. The three most frequently empty stations are stations 62, 45, and 63.

SELECT
	bikes_available,
	COUNT(*) as empty_freq,
	station_id
FROM status
WHERE bikes_available = 0
GROUP BY station_id
ORDER BY empty_freq DESC
LIMIT 3

--"empty"	"20646"	"62"
--"empty"	"15318"	"45"
--"empty"	"13927"	"63"

--3. The query below returns the number of trips that started at each station, ordered by the number of docks at each station. Although there are 67 stations in the stations table, the join returns only 63 rows. There may be an issue with the query, or perhaps trips were not started at 4 of the stations. If there is a problem with the query, then maybe an intermediate join with a table recording counts of start_station needs to be used.

SELECT
	trips.start_station,
    COUNT(*) trip_count,
	stations.name,
	stations.dockcount
FROM
    trips
JOIN 
	stations
ON
	trips.start_station = stations.name
GROUP BY stations.name
ORDER BY stations.dockcount

--4. To extract the third longest trip for each rainy day, two CTEs are needed, which can then be joined on date. The first CTE pulls the set of rainy days from the weather table, and the second CTE pulls the third longest trip for each day from the trips table. Finally, the two tables are joined on date, returning the third longest trip for each rainy day. 

WITH 
	rainy
AS (
SELECT
	weather.date,
	weather.Events
FROM
	trips
WHERE 
	weather.Events like "%Rain%"
Group by weather.date
),
	third_longest
AS(
SELECT 
	trips.duration,
	trips.trip_id,
	SUBTR(trips.start_date, 1, 10)
FROM
	trips
GROUP BY start_date
ORDER BY duration DESC
LIMIT 1
OFFSET  2 
)
JOIN
    rainy
ON
    rainy.date = trips.start_date
