Use  8week_sql;
CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
  
  CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
  



# Questions & Asswers

/* Q.1 What is the total amount each customer spent at the restaurant? */
select customer_id, sum(price) as Total_spending 
	from sales join menu
    on sales.product_id=menu.product_id
group by customer_id; 
  
  
/* Q.2 How many days has each customer visited the restaurant? */
select customer_id, count(distinct(order_date)) as visited_count 
	from sales 
    group by customer_id;
 

/* Q.3 What was the first item from the menu purchased by each customer? */

with order_by_customer_rank as (
select customer_id, product_name, order_date,
        dense_rank() OVER(PARTITION BY sales.customer_id ORDER BY sales.order_date) as rank_
	from sales 
    join menu
	on sales.product_id=menu.product_id
        )
select customer_id, product_name ,order_date as first_order_date
		from order_by_customer_rank
	where rank_=1
	GROUP BY customer_id, product_name;
        

/* Q.4 What is the most purchased item on the menu and how many times was it purchased by all customers? */

select product_name, (count(order_date)) as Total_orders
		from menu join sales
		on menu.product_id=sales.product_id
	group by sales.product_id
	order by Total_orders desc 
Limit 1;

/* Q.5 Which item was the most popular for each customer? */

WITH rank_most_item as(
select customer_id, product_id ,count(product_id) as frequent_buy, 
dense_rank() OVER (partition by customer_id order by count(product_id) desc) as rank1_
from sales
group by customer_id,product_id
)
select customer_id, product_name, frequent_buy 
from rank_most_item 
join
menu on
rank_most_item.product_id=menu.product_id
where rank1_=1;

/* Q.6 Which item was purchased first by the customer after they became a member? */
with member_t as 
(
select sales.customer_id, product_id, order_date,members.join_date,
	dense_rank() over (partition by sales.customer_id order by order_date ) as rank1_	
	from sales
	join members 
    on sales.customer_id=members.customer_id
where order_date>=members.join_date
)
select member_t.customer_id,member_t.order_date,product_name 
	from member_t 
    join menu 
    on member_t.product_id=menu.product_id
where rank1_=1;

/* Q.7 Which item was purchased just before the customer became a member? */

with member_t1 as
(
select sales.customer_id, product_id, order_date,members.join_date,
		dense_rank() over (partition by sales.customer_id order by order_date desc ) as rank1_	
	from sales
	join members on sales.customer_id=members.customer_id
where order_date<members.join_date
)
select customer_id,order_date, product_name 
	from member_t1 
    join menu 
    on member_t1.product_id=menu.product_id
    where rank1_=1
order by customer_id;


/* Q.8 What is the total items and amount spent for each member before they became a member? */
with member_t1 as 
(
select sales.customer_id, product_id, order_date,members.join_date,
		dense_rank() over (partition by sales.customer_id order by order_date desc ) as rank1_	
	from sales
	join members 
    on sales.customer_id=members.customer_id
	where order_date<members.join_date
)
select customer_id ,sum(price) as total_sales,count(distinct(member_t1.product_id) ) as total_items 
	from member_t1
	join menu 
	on member_t1.product_id=menu.product_id 
group by customer_id;

/* Q.9 If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have? */

with points as
(
select *, case when product_name='sushi' then price*20 else price*10 end as point_
from menu 
)
select customer_id, sum(point_) from points 
join sales on
sales.product_id=points.product_id
group by customer_id;

/* Q.10 In the first week after a customer joins the program 
(including their join date) they earn 2x points on all items, not just sushi - 
how many points do customer A and B have at the end of January? */

WITH vailidity_d as
(
 select * , date_add(join_date, interval 6 day) as last_day_1week, DATE('2021-01-31') as last_day_jan 
 from members 
 )
 select vailidity_d.customer_id,
		sum(case when product_name='sushi' then price*20
			when order_date>= join_date and order_date<=last_day_1week then price*20 else price*10 end) as ponits_ 
	from sales join vailidity_d on sales.customer_id=vailidity_d.customer_id
	join menu 
    on sales.product_id=menu.product_id
 where order_date<last_day_jan
 group by vailidity_d.customer_id
 order by vailidity_d.customer_id ;
 ________________________________________________________________________________________________
 WITH vailidity_d as
(
 select * , date_add(join_date, interval 6 day) as last_day_1week, DATE('2021-01-31') as last_day_jan from members )
 select 
 *,
 ( case when product_name='sushi' then price*20
 when order_date>= join_date and order_date<=last_day_1week then price*20
 else price*10 end) as ponits_ 
 from sales join vailidity_d on sales.customer_id=vailidity_d.customer_id
 join menu on sales.product_id=menu.product_id
 where order_date<last_day_jan
 ;
 
