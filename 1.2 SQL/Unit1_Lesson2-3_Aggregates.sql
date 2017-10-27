-- Drill: Using SQL to pull aggregated data from the Bay Area Bikeshare dataset 

-- 1. What was the hottest day in our data set? Where was that?
-- 2. How many trips started at each station?
-- 3. What's the shortest trip that happened? 
-- 4. What is the average trip duration, by end station?

-- 1. The day with the highest mean temperature (94F) was September 11th, 2015, at zipcode 94063. 
--The "hottest day" could also be interpreted as the day with the highest maximum temperature, 
--in which case the hottest day was November 17th, 2015 at 94063, with a maximum temperature of 134F. 
--(This value is suspect, since a temperature of 134F during autumn in the Bay Area is unlikely!)

SELECT
    date,
	ZIP,
	MAX(MeanTemperatureF) MeanTemperatureF
FROM
    weather

-- Returns: "2015-09-11"	"94063"	"94"

SELECT
    date,
	ZIP,
	MAX(MaxTemperatureF) MaxTemperatureF
FROM
    weather

--Returns: "2015-11-17"	"94063"	"134"

-- 2. The query below returns the number of trips started at each station. 
--There were 80 unique stations, and the number of trips per station ranges from 1 to 23,591.

SELECT
    COUNT(*) AS num_trips_started, 
	start_station
FROM
    trips
GROUP by start_station

-- 3. The shortest trip duration is 60 seconds. 

SELECT
    *,
	MIN(CAST(duration as integer)) as duration
FROM
    trips
    
-- Returns:
-- "1011650"	"60"

-- 4. The average trip duration, aggregated by end station, ranges from 257 to 4710.9. 
--(There are 80 stations, so the complete results are not reproduced here.)

SELECT
    end_station,
	AVG(duration) as mean_duration
FROM
    trips
GROUP BY end_station
ORDER BY mean_duration DESC 