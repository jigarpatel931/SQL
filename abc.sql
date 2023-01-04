-- this command will show all databases listed on the mysql server--
show databases;

-- Now choose the specific database by using "use"--
use abc;

-- will show all the tables in abc database--
show tables;

create table flight	
	(flight_id bigint,
    flight_date date,
    origin varchar(50),
    destination varchar(50),
    status varchar(50),
    delay_min int,
    primary key (flight_id)
    );
create table booking
	( booking_id bigint,
    flight_id bigint,
    customer_id bigint,
    booking_date date,
    fare float,
    PRIMARY KEY (booking_id),
    FOREIGN KEY (flight_id) REFERENCES flight(flight_id)
);

select * from flight;
select * from booking;
  
select * from booking;
#//Q1. Write a single query that calculates the total fare paid in the last 7 days.//
# or use simply now() function to get today's date

select * from booking 
	where booking_date > date(now())-interval 7 day;



#//Q2. Write a single query that calculates the average fare paid per booking for each origin/destination flown in Jan 2019//
#// step1//
select * from booking 
	join flight on booking.flight_id= flight.flight_id
where flight.status="flown" and year(flight.flight_date)=2019 and month(flight.flight_date)=01;

#//Final ans//
select origin, destination, round(avg(fare),2) as "Avg_fare_paid_per_booking" 
	from booking 
	join flight on booking.flight_id= flight.flight_id 
where flight.status="flown" and year(flight.flight_date)=2019 and month(flight.flight_date)=01 
group by origin, destination;


#//Q3. Write a single query that calculates the average fare paid per flight for each origin/destination flown in Jan 2019//
#// step1//
select * from flight 
	join booking on booking.flight_id= flight.flight_id
where flight.status="flown" and year(flight.flight_date)=2019 and month(flight.flight_date)=01;

#//Final ans//
select origin, destination, round(sum(fare),2)/count(distinct(flight.flight_id)) as " Avg_fare_paid_per_flight" from flight 
	join booking on booking.flight_id= flight.flight_id 
where flight.status="flown" and year(flight.flight_date)=2019 and month(flight.flight_date)=01
group by origin, destination;


#//Q4. Write a single query that returns each customer, and # of flights they booked in their first 365 days//

#//step 1: find first booking date for each customer// 
with ff as
(select customer_id, min(booking_date) as first_booking_date 
from booking 
group by customer_id)

#// step 2: Now add this new column first_booking_date to booking table// 
#// select * from booking as td 
#//		right join ff on td.customer_id=ff.customer_id 
#//		and td.booking_date between ff.first_booking_date and date_add(ff.first_booking_date,interval 365 day);

#// step3: Now get each customer and number of bookings by them in their first year. ("RUN CTE and this step togather")//
select ff.customer_id, count(td.booking_id) as "number of flights booked",ff.first_booking_date
	from booking as td 
    right join ff on td.customer_id=ff.customer_id
	and td.booking_date between ff.first_booking_date and date_add(ff.first_booking_date,interval 365 day)
group by ff.customer_id;

#// Nested syntax//
select ff.customer_id, count(td.booking_id) as "number of flights booked",ff.d as " Fisrt booking date" 
	from booking as td 
    right join (select customer_id, min(booking_date) as d from booking group by customer_id) as ff
	on td.customer_id=ff.customer_id 
    and td.booking_date between ff.d and date_add(ff.d,interval 365 day)
group by ff.customer_id;

#//Q5: Write a single query that returns a daily summary of the following: 
# Flight Date 
#• Total number of flown flights 
#• Total number of flown passengers 
#• Average delay in minutes per flown flight

select * from flight;
select * from booking;
select * from flight left join booking on flight.flight_id=booking.flight_id  where
flight.status="flown" ;


select flight.flight_date,count(distinct (flight.flight_id)) as "Total number of flown flights", 
		count(customer_id) as "Total # of flown pessangers",round(avg(flight.delay_min),2) as "Avg Delay in (mins)" 
	from flight 
	left join booking on flight.flight_id=booking.flight_id  
    where flight.status="flown" 
    group by flight.flight_date;

# delay per customer
select flight.flight_date,count(distinct (flight.flight_id)) as "Total number of flown flights", 
count(customer_id) as "Total # of flown pessangers",(sum(flight.delay_min)/count(distinct (flight.flight_id))) as "Avg Delay in (mins)" from flight 
left join booking on flight.flight_id=booking.flight_id  where
flight.status="flown" group by flight.flight_date;

select date(now()) as today;
select date(now() + interval 1 day) as tomorrow;
select date(now() - interval 1 day) as yesterday;