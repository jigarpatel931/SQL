# SQL
Project portfolio

Introduction: This file contain the SQL queries to solve certain business problems from airlines industry.

## Data

There are 2 tables in database: Flight and Booking

Flight: 
![image](https://user-images.githubusercontent.com/50954720/196920078-be310d93-9073-4d7b-bc5c-8a8625306592.png)

Booking: 
![image](https://user-images.githubusercontent.com/50954720/196920244-b31bf2ec-4217-44a6-9bc6-0e1b73b00402.png)


# Table creation in MySQL

![image](https://user-images.githubusercontent.com/50954720/196929096-2a6cd801-90cf-4d04-9704-7c76c06da9a4.png)

Flight:
![image](https://user-images.githubusercontent.com/50954720/196929647-d2b5d4ff-c2ba-425b-9eb5-cd8edcebab41.png)

Booking:
![image](https://user-images.githubusercontent.com/50954720/196929767-190df165-a541-46b9-8de7-151d48afe595.png)


# Business Problems and solutions

Problem 1: Write a single query that calculates the total fare paid in the last 7 days.

select 
sum(fare) as "total fare for last 7 days" 
from booking 
where booking_date > now()-interval 7 day;

Problem 2: Write a single query that calculates the average fare paid per booking for each  origin/destination flown in Jan 2019 

Select 
origin, 
destination, 
round(avg(fare),2) as "Avg fare paid per booking"
from booking join flight on booking.flight_id= flight.flight_id 
where flight.status="flown" and year(flight_date)=2019 and month(flight_date)=01 
group by origin, destination;


Q.3 Write a single query that calculates the average fare paid per flight for each origin/destination  flown in Jan 2019 

Select 
origin, 
destination,
round(sum(fare),2)/count(distinct(flight.flight_id)) as " Avg fare paid per flight" 
from flight join booking on booking.flight_id= flight.flight_id 
where flight.status="flown" and year(flight.flight_date)=2019 and month(flight.flight_date)=01 
group by origin, destination;

Q.4 Write a single query that returns each customer, and # of flights they booked in their first 365  days 

Select 
ac.customer_id, 
count(td.booking_id) as "number of flights booked",
ac.d as " First booking date" from booking as td right join 
(select customer_id, min(booking_date) as d from booking group by customer_id) as ac
on td.customer_id=ac.customer_id and td.booking_date between ac.d and date_add(ac.d,interval 365 day) group by ac.customer_id



