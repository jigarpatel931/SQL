# SQL ❄️
👋 Hi, this repo contain SQL projects portfolio.


## Projects

:one: Airline_SQL: [Airline_SQL](https://github.com/jigarpatel931/SQL/tree/main/Airline_SQL)

<details>
  <summary>Functions, clauses, statements used</summary>
  
  ### List
  1. Create statement/procedures 
  2. Date()
  3. NOW()
  4. Joins
  5. Subquries & CTE
  6. Group by
  7. Aggregrate windows functions
  ### Example Query
  ```js
 select fd.customer_id, count(td.booking_id) as "number of flights booked",
		fd.d as " Fisrt booking date" ,fd.d+ interval 364 day
			from booking as td 
			right join (select customer_id, min(booking_date) as d from booking group by customer_id) as fd
			on td.customer_id=fd.customer_id 
		and td.booking_date between fd.d and date_add(fd.d,interval 365 day)
group by fd.customer_id;
  }
  ```
</details>


<details>
  <summary>Questions</summary>
  
  ### List
  	1. Write a single query that calculates the total fare paid in the last 7 days.
	2. Write a single query that calculates the average fare paid per booking for each origin/destination flown in Jan 2019.
	3. Write a single query that calculates the average fare paid per flight for each origin/destination flown in Jan 2019.
	4. Write a single query that returns each customer, and # of flights they booked in their first 365 days.
  
</details>



:two: SQL week-1 challenge: [SQL week-1 challenge](https://github.com/jigarpatel931/SQL/tree/main/8-week%20challenge)

<details>
  <summary>Functions, clauses, statements used</summary>
  
  ### List
  1. Create statement/procedures 
  2. Joins
  3. Subquries & CTE
  4. Group by & Order by
  5. Aggregrate & Ranking windows functions such as dense_rank(), rank()
  
  ### Example Query
  ```js
  select sales.customer_id, product_id, order_date,members.join_date,
		dense_rank() over (partition by sales.customer_id order by order_date desc ) as rank1_	
	from sales
	join members on sales.customer_id=members.customer_id
where order_date<members.join_date
  }
  ```
</details>

<details>
  <summary>Questions</summary>
  
  ### List
  	1. What is the total amount each customer spent at the restaurant?
	2. How many days has each customer visited the restaurant?
	3. What was the first item from the menu purchased by each customer?
	4. What is the most purchased item on the menu and how many times was it purchased by all customers?
	5. Which item was the most popular for each customer?
	6. Which item was purchased first by the customer after they became a member?
	7. Which item was purchased just before the customer became a member?
	8. What is the total items and amount spent for each member before they became a member?
	9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
	10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
  
</details>

