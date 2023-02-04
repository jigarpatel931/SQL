# Advanced SQL Queries.
👋 Hi, this folder contains Solution for Advanced SQL business questions



## Q.1 Write Query to get the Customer with the highest total order value for each year-month?

Result should include the columns year, month, customerid, total_monhtly_order_value.
Output should be ordered by year and month in ascending order.
Note: In case there are 2 customer with quale highest total order value, return the one with a Lower Customerid.

### 2 tables. Orders and Orders_details
![image](https://user-images.githubusercontent.com/50954720/213547288-f69a314d-7c03-4875-a416-2d54f180eca8.png) ![image](https://user-images.githubusercontent.com/50954720/213547583-222b0d2b-5c82-4903-91ba-db41dd4917b7.png)

### sample data

![image](https://user-images.githubusercontent.com/50954720/213548338-6ea30e69-1622-4543-9869-d807754964b2.png)

### ANSWER
<details>
  <summary>Functions, clauses, statements used</summary>
  
  ### List
  1. Create statement/procedures 
  2. Date()
  3. Joins
  4. Subquries & CTE
  5. Group by
  6. Aggregrate windows functions
</details>

Query:
```
 /* find total_value for each order. */
 with abc (orderid,totalvalue)as
 (
 select OrderID, sum(unitprice*quantity) from 
 dbo.Orders_details
 group by OrderID
 )
, 
/* find total_value for each customer for each month-year. */
 abc1 (customerid,year1,month1,totalvalue)as
 (select Orders.CustomerID, year(Orders.OrderDate),month(Orders.OrderDate),sum(abc.totalvalue) from
 dbo.Orders
 join
 abc
 on
 dbo.Orders.OrderID=abc.orderid
 group by Orders.CustomerID,year(Orders.OrderDate),month(Orders.OrderDate) )
 ,
 /* find max total_value for each customer for each month-year. */
OrderValue as(
 select year1 as year2,month1 as month2,max(abc1.totalvalue) as totaval,customerid
 from abc1
 group by (abc1.year1),(abc1.month1),abc1.customerid)

,
/* Customer with the highest total order value for each year-month */
ordervalue1 (customerid,year,month,totalvalue,rank1)as
(
 SELECT 
    OrderValue.customerid,
    OrderValue.year2,
    OrderValue.month2,
    OrderValue.totaval,
	ROW_NUMBER() OVER(PARTITION BY OrderValue.year2, OrderValue.month2 ORDER BY OrderValue.totaval DESC, OrderValue.customerid ASC) 
FROM OrderValue
)

select ordervalue1.customerid, ordervalue1.year,ordervalue1.month,ordervalue1.totalvalue 
from ordervalue1 
WHERE ordervalue1.rank1=1
order by ordervalue1.year,ordervalue1.month;

```
 ![image](https://user-images.githubusercontent.com/50954720/213549948-6d890dc9-0cb0-48ae-b0e2-8b8d16d124c2.png)
 
 
## Q.2 Write query to get median for each month-year?
Traffic on a Website was recorded on multiple days over 2 years, 2017-2018. Create a Query that, for each month, will return a row with the month number,meadian for that month in 2017, in 2018. Order the result by month. 

### traffic table
![image](https://user-images.githubusercontent.com/50954720/213551519-916cdb05-658e-4502-8d04-f51e99eb3c9b.png)

### sample table
![image](https://user-images.githubusercontent.com/50954720/213551717-190ba05f-b6b1-4516-b27b-54160ed39aca.png)

step1. ![image](https://user-images.githubusercontent.com/50954720/213552270-f7b6d6f5-796a-4dbc-94e6-eea43ccbe31c.png)

### Result

<details>
  <summary>Functions, clauses, statements used</summary>
  
  ### List
  1. Create statement/procedures 
  2. DATEPART()
  3. Joins
  4. Subquries & CTE
  5. Group by
  6. Aggregrate windows functions, ROW_NUMBER
</details>

Query
```

/*Solution: This part will get month,year,count, row_num for each month-year, total rows for each-month*/
WITH DataByMonth AS (
    SELECT 
        DATEPART(month, recordday) as month,
        DATEPART(year, recordday) as year,
        count,
        ROW_NUMBER() OVER (PARTITION BY DATEPART(month, recordday), DATEPART(year, recordday) ORDER BY count) as row_num,
        COUNT(*) OVER (PARTITION BY DATEPART(month, recordday), DATEPART(year, recordday)) as total_rows
    FROM traffic
    WHERE DATEPART(year, recordday) IN (2017, 2018)
)
/*second part will get month,year in cloumns, find median value for each month-year using 
where condition applied on row_num and total_rows*/
SELECT 
    DataByMonth.month,
    AVG(CASE WHEN DataByMonth.year = 2017 THEN DataByMonth.count END) as median_2017,
    AVG(CASE WHEN DataByMonth.year = 2018 THEN DataByMonth.count END) as median_2018
FROM DataByMonth
WHERE (DataByMonth.row_num - 1) * 2 <= DataByMonth.total_rows AND DataByMonth.row_num * 2 >= DataByMonth.total_rows
GROUP BY DataByMonth.month
ORDER BY DataByMonth.month;
```

![image](https://user-images.githubusercontent.com/50954720/213552658-29b424fe-55a2-4f69-bf42-3f21be3c2e93.png)


___ end of case study
