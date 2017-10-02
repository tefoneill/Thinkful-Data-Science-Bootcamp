/*
Drill: Write SQL queries to extract information from the Bay Area Bikeshare dataset.

1. The IDs and durations for all trips of duration greater than 500, ordered by duration.
2. Every column of the stations table for station id 84.
3. The min temperatures of all the occurrences of rain in zip 94301.
*/

--1. The IDs and durations for all trips of duration greater than 500, ordered by duration. (Note here that the duration column appears to be a string, so the result is ordered accordingly.)
SELECT
		trip_id,
		duration
FROM
		trips
WHERE
		duration >500
ORDER BY duration DESC


--2. Every column of the stations table for station id 84.
SELECT
		*
FROM
		stations
WHERE
		station_id = 84


--3. The min temperatures of all the occurrences of rain in zip 94301. (Note that if we wanted to include fog-rain Events, we could add OR Events like 'fog-rain' to the end of the query.)
SELECT
		MinTemperatureF
FROM
		weather
WHERE
		ZIP = '94301' AND
		Events like '%Rain%'
