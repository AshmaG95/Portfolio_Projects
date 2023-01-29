/*
Food order Data exploration
Skills used: Joins, CTE's,Update, Aggregate Functions

*/
SELECT *
FROM foodOrder

--Which cuisine type is popular?

SELECT cuisine_type,COUNT(*)as PopularCuisine
FROM foodOrder
GROUP BY cuisine_type
ORDER BY PopularCuisine DESC

--Average orders by cuisine type

SELECT cuisine_type, AVG(orders) as AverageOrder
FROM (
    SELECT cuisine_type, restaurant_name, COUNT(*) as orders
    FROM foodOrder
    GROUP BY cuisine_type, restaurant_name
) as average
GROUP BY cuisine_type
ORDER BY AverageOrder DESC

--Average rating per cuisine type

SELECT cuisine_type, ROUND(AVG(rating),2) as AverageRating
FROM foodOrder
GROUP BY cuisine_type
ORDER BY AverageRating DESC

-- How many restaurants by cuisine type

SELECT cuisine_type, COUNT(DISTINCT restaurant_name) as NumRestaurants
FROM foodOrder
GROUP BY cuisine_type
ORDER BY NumRestaurants DESC

--Popular restaurant 

SELECT TOP 5 cuisine_type, restaurant_name,COUNT(*)as PopularRestaurant
FROM foodOrder
GROUP BY restaurant_name,cuisine_type
ORDER BY PopularRestaurant DESC

--Weekday vs Weekend

SELECT day_of_the_week, COUNT(*) as NumOfDay
FROM foodOrder
GROUP BY day_of_the_week
ORDER BY NumOfDay

-- Most popular cuisine on weekends and weekday

WITH Weekends AS (
    SELECT cuisine_type, COUNT(*) as count
    FROM foodOrder
    WHERE day_of_the_week = 'Weekend'
    GROUP BY cuisine_type
), Weekdays AS (
    SELECT cuisine_type, COUNT(*) as count
    FROM foodOrder
    WHERE day_of_the_week = 'Weekday'
    GROUP BY cuisine_type
)
SELECT Weekends.cuisine_type, Weekends.count as Weekends_count, Weekdays.count as Weekdays_count
FROM Weekends
JOIN Weekdays
ON Weekends.cuisine_type = weekdays.cuisine_type
ORDER BY Weekends.count DESC

--Max and min cost of the order

SELECT MAX(cost_of_the_order) as MaxOrder ,MIN(cost_of_the_order) as MinOrder
FROM foodOrder

--Maximum cost of order by cuisine type

SELECT cuisine_type,MAX(cost_of_the_order) as MaximumCost
FROM foodOrder
GROUP BY cuisine_type
ORDER BY MaximumCost DESC

--Average cost by cuisine type

SELECT cuisine_type, ROUND(AVG(cost_of_the_order),2) as AverageDeliveryTime
FROM foodOrder
GROUP BY cuisine_type
ORDER BY AverageDeliveryTime

--Maximum nd minimum food preparation time

SELECT MAX(food_preparation_time) as MaxFoodTime, MIN(food_preparation_time) as MinFoodTime
FROM foodOrder

--Average food preparation time

SELECT AVG(food_preparation_time)
FROM foodOrder

-- Average food preparation time by cuisine type

SELECT cuisine_type, ROUND(AVG(food_preparation_time), 2) as AverageFoodTime
FROM foodOrder
GROUP BY cuisine_type
ORDER BY AverageFoodTime 

-- Maximum and minimum delivery time

SELECT MAX(delivery_time) as MaxTime,MIN(delivery_time) as MinTime
FROM foodOrder

-- Average delivery time by cuisine type

SELECT cuisine_type, ROUND(AVG(delivery_time),2) as AverageDeliveryTime
FROM foodOrder
GROUP BY cuisine_type
ORDER BY AverageDeliveryTime

--Adding another column 'order_completion_time' and updating the column with the sum of 'food_preparation_time' and 'delivery_time'

ALTER TABLE foodOrder
ADD order_completion_time FLOAT NULL

UPDATE foodOrder
SET order_completion_time = food_preparation_time + delivery_time
WHERE order_completion_time IS NOT NULL

--min and max order completion time by cuisine type

SELECT cuisine_type,MIN(order_completion_time) as MinComplete,MAX(order_completion_time) as MaxComplete
FROM foodOrder
GROUP BY cuisine_type
ORDER BY MinComplete,MaxComplete

 -- Updating the restaurant_name column which has some errors

UPDATE foodOrder
SET restaurant_name = CASE restaurant_name
    WHEN  'Big Wong Restaurant ÂŒ_Â¤Â¾Ã‘Â¼' THEN 'Big Wong Restaurant'
    WHEN  'Empanada Mama (closed)' THEN 'Empanada Mama'
    WHEN  'Chipotle Mexican Grill $1.99 Delivery' THEN 'Chipotle Mexican Grill'
	WHEN  'CafÃŒÂ© China' THEN  'Cafe China'
	WHEN  'Dirty Bird To Go (archived)' THEN 'Dirty Bird to Go'
	WHEN  'Joe''s Shanghai ÂŽ_Ã€ÂŽÃ¼Â£Â¾Ã·Â' THEN 'Joe''s Shanghai'
    ELSE restaurant_name
END