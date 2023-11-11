/* 
Avinash Thapa
Product Sales Data Analysis Project

First step, Translate Google Sheets (List Data) to a Relational Database (MySQL Workbench)
Limit Redundancy and Anomalies (Update, Delete, Insertion)
*/

use Product_Sales;

/* Created the 'category' table (imported data from 'category' table from ***Excel Spreadsheet) */
CREATE TABLE `category` (
  `sub_category` varchar(20) NOT NULL,
  `category` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`sub_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select count(*) from category;							/*  There are 17 total sub_categories */ 


/* Created the 'country' table (imported data from 'country' table from ***Excel Spreadsheet) */ 
CREATE TABLE `country` (
  `country` varchar(50) NOT NULL,
  `market` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`country`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select count(*) from country;							/*  There are 147 total countries */ 


/*  Created the 'customer' table (imported data from 'category' table from ***Excel Spreadsheet) */ 
CREATE TABLE `customer` (
  `customer_id` int NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `c_state` varchar(50) DEFAULT NULL,
  `c_country` varchar(50) DEFAULT NULL,
  `c_segment` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  KEY `c_state_idx` (`c_state`),
  CONSTRAINT `c_state` FOREIGN KEY (`c_state`) REFERENCES `states` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from customer
order by customer_id;

select count(*) from customer;							/* There are 23,352 total customers */ 


/* Created the 'line' table (imported data from 'line' table from ***Excel Spreadsheet) */ 
CREATE TABLE `line` (
  `order_id` varchar(50) NOT NULL,
  `product_id` varchar(17) NOT NULL,
  `sales` double DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `profit` double DEFAULT NULL,
  `shipping_cost` double DEFAULT NULL,
  PRIMARY KEY (`order_id`,`product_id`),
  KEY `product_id_idx` (`product_id`),
  CONSTRAINT `order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `product_id` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*  Initially used this query to double check if there was repitition in order_id, product_id
 Important to remove duplicates as this composite keys were used as primary key */ 
select order_id, product_id, count(*) CNT
from line
group by order_id, product_id
having CNT > 1
order by order_id asc;


/*  Created the 'orders' table (imported data from 'order' table from ***Excel Spreadsheet) */ 
CREATE TABLE `orders` (
  `order_id` varchar(50) NOT NULL,
  `customer_id` int DEFAULT NULL,
  `order_date` varchar(50) DEFAULT NULL,
  `order_priority` varchar(50) DEFAULT NULL,
  `ship_date` varchar(50) DEFAULT NULL,
  `ship_mode` varchar(50) DEFAULT NULL,
  `year` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `customer_id_idx` (`customer_id`),
  CONSTRAINT `customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select count(*) from orders;							/* There are 25,035 total orders placed */ 


/*  Created the 'product' table (imported data from 'product' table from ***Excel Spreadsheet) */ 
CREATE TABLE `product` (
  `product_id` varchar(17) NOT NULL,
  `sub_category` varchar(20) DEFAULT NULL,
  `product_name` text,
  PRIMARY KEY (`product_id`),
  KEY `sub_category_idx` (`sub_category`),
  CONSTRAINT `sub_category` FOREIGN KEY (`sub_category`) REFERENCES `category` (`sub_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select count(*) from product;							/*  There are 10,292 unique total products */  

# Display all the unique sub_category present for the product table (Cross check with category table)
select distinct sub_category from product					
order by sub_category;


/*  Created the 'states' table (imported data from 'state' table from ***Excel Spreadsheet) */ 
CREATE TABLE `states` (
  `state` varchar(50) NOT NULL,
  `country` varchar(50) DEFAULT NULL,
  `region` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`state`),
  KEY `country_idx` (`country`),
  CONSTRAINT `country` FOREIGN KEY (`country`) REFERENCES `country` (`country`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select count(*) from states;							/*  There are 1,094 unique total states */ 


/*  Double checking the highest to lowest sales from the lines table compared to orders table */ 
select * from line
order by sales desc;

select * from orders
order by order_id desc;


/*  There is one more table: returns. In progress to implement completely to the database for data analysis */ 
select * from p_returns;
select count(order_id) from p_returns;							# There is 1173 total rows
select distinct order_id from p_returns;						# There is 1172 total rows

