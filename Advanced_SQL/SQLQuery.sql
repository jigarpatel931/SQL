create database case_study;
use case_study;
SELECT table_name
FROM INFORMATION_SCHEMA.TABLES;
drop table dbo.Orders;
drop table Dbo.Orders_details;

SELECT table_name
FROM INFORMATION_SCHEMA.TABLES;

CREATE TABLE Orders (
OrderID INT PRIMARY KEY,
CustomerID INT NOT NULL,
OrderDate DATE NOT NULL
);

CREATE TABLE Orders_details (
OrderID INT not null,
productid INT NOT NULL,
unitprice int NOT NULL,
quantity int not null
);

INSERT INTO Dbo.Orders (OrderID, CustomerID, OrderDate)
VALUES 
 (10248,3, '2022-07-04'),
 (10249,1, '2022-07-05'),
 (10250,2, '2022-08-05'),
 (10251,2, '2022-08-09'),
 (10253,2, '2022-07-10'),
 (10274,3, '2022-08-06'),
 (10275,4, '2022-08-07'),
 (10296,5, '2022-09-03');

INSERT INTO dbo.Orders_details
(OrderID, productid, unitprice,quantity)
VALUES 
 (10248,11,14,12),
 (10248,42,9,10),
 (10248,72,34,5),
 (10249,14,18,9),
 (10250,11,49,10),
 (10251,12,3,13),
 (10249,51,42,40),
 (10253,32,10,20),
 (10253,39,14,42),
 (10253,49,16,40),
 (10274,71,17,20),
 (10274,72,27,7),
 (10275,24,3,12),
 (10275,59,44,6),
 (10296,11,16,12),
 (10296,16,13,30);

 select * from dbo.Orders;
 select * from dbo.Orders_details;

 select OrderID, sum(unitprice*quantity) as totalvalue from 
 dbo.Orders_details
 group by OrderID;
 
  /*Q.1*/
  
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
/* Customer with the highest total order value for each year-month */


/*Q.2*/

CREATE TABLE traffic (
id INT primary key,
recordday date NOT NULL,
count int not null
);
select * from traffic;


INSERT INTO dbo.traffic
(id, recordday, count)
VALUES 
 (8949,'2017-01-01',7735),
 (8950,'2017-02-06',9701),
 (8951,'2017-03-02',7135),
 (8051,'2017-03-08',7140),
 (8052,'2017-03-24',7150),
 (8952,'2017-04-03',7935),
 (8953,'2017-05-01',7735),
 (8954,'2017-06-01',7740),
 (8955,'2017-07-01',7735),
 (8956,'2017-08-01',7735),
 (8957,'2017-09-01',7735),
 (8958,'2017-10-01',7721),
 (8959,'2017-11-01',7751),
 (8960,'2018-01-01',7735),
 (8961,'2018-02-01',7735),
 (8962,'2018-02-02',7740),
 (8963,'2018-02-08',7745)
 ;
 select * from traffic;
 INSERT INTO dbo.traffic
(id, recordday, count)
VALUES 
 (8151,'2017-03-14',7140);
 select * from traffic;




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

