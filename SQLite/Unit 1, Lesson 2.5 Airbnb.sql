-- This file contains a set of queries and explanations for exploring the Airbnb database of listings and reviews 
-- for Vancouver, B.C. It addresses a few questions: 

-- 1. What's the most expensive listing? What else can you tell me about the listing?
-- 2. What neighborhoods seem to be the most popular?
-- 3. What time of year is the cheapest time to go to your city? What about the busiest?

-- The first query returns all columns for the row containing the maximum value on price.

SELECT
	MAX(price),
	*
FROM
	listings

-- This returns a listing whose price is $9,999 per night for a 2BR. 
-- Such a high price for an unremarkable two bedroom listing is suspect, 
-- and the 9999 may in fact represent a missing field. The query was then revised to elicit the maximum price less than 9999, which returns a more plausible entry.

SELECT
	MAX(price),
	*
FROM
	listings
WHERE 
	price <9999
  
-- The revised query returns a listing for a "Luxurious 95' yacht w 22'beam" priced at $5,999 per night. 
-- The yacht is located in the Fairview neighborhood and available 364 days per year. 
-- The property has never been reviewed, so we cannot get more information about its popularity by joining the reviews table. 
-- The host, Francesco, has 2 listings, which suggests that the yacht is not his primary residence. 

-- The second query looks into neighborhood popularity. There are a few ways to do this, 
-- but the simplest strategy given the information we have is probably to count the number of bookings per neighborhood. 
-- Following Inside Airbnb's San Francisco model, let's assume a review rate of 50%, 
-- so the number of reviews can serve as a proxy for the number of bookings. 
-- We can then count the number of reviews by neighborhood, and see which neighborhoods have the highest counts. 

SELECT
	neighbourhood,
	SUM(number_of_reviews) total_reviews
FROM
	listings
GROUP BY neighbourhood
ORDER BY total_reviews DESC

-- Not surprisingly, the affluent and touristy Downtown, West End, and Kitsilano neighborhoods are the most popular, 
-- in terms of number of reviews. Tourists visiting the city tend to want to stay in a central location near major attractions.
-- Given their affluence, these areas are also quite densely populated, 
-- so we would expect to find many hosts renting properties that are not their primary residences, 
-- which is common in Airbnb listings. 

-- To find out the cheapest time of year, we might look at the average listing price by month. 
-- First, the type of the price column should be cast as an integer or a double, and the dollar sign removed. 
-- Then, unavailable rentals (where the price field is empty) are excluded to remove the 0 values from the average.

SELECT
	avg(cast(trim(price, '$') as integer)) as avg_price,
	substr(date, 6, 2) as month
FROM
	calendar2
WHERE
	price != ''
GROUP BY month
ORDER BY avg_price DESC

-- On average, the most expensive time to book an AirBnb in Vancouver is August, 
-- with an average listing price of $162.89, followed by July, with an average price of $160.79. 
-- The summer months have higher demand, so it is reasonable that listings are more expensive then.


-- To find out the busiest time of year, we might wish to look at the number of reviews per month, 
-- which is a good proxy for the number of bookings, assuming a review rate of 50%. 
-- We could, as an alternative, look at the month with the fewest available listings, 
-- but unavailability doesn't necessarily indicate that the listing is booked--
-- it could also indicate that the owner is simply not listing the property as available, 
-- so using reviews to measure bookings is more reliable.

SELECT
	substr(date, 6, 2) as month,
	COUNT(*) as total_reviews
FROM
	reviews2
GROUP BY month
ORDER BY total_reviews DESC

-- The result shows the largest number of reviews in August (14,201), 
-- followed by July and September (11,962 and 11,788, respectively). 
-- If the review rate is approximately 50%, then there are roughly 28,000 Airbnb bookigs in Vancouver in August, 
-- the busiest time of year. July-August is the most pleasant time of year in Vancouver, 
-- since its mild climate brings gray cooler weather in the other months. 
-- August is particularly busy, when international visitors from tend to have vacation time. 
