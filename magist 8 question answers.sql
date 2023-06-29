/* 1- how many order are there in the database */ 
SELECT 
    COUNT(order_id) AS number_of_orders
FROM
    orders
;

/* 2- are oders realy delevred */ 

SELECT 
    COUNT(*), order_status
FROM
    orders
GROUP BY order_status
;

/*  */
SELECT 
    MONTH(order_purchase_timestamp) AS `MONTH`,
    YEAR(order_purchase_timestamp) AS `YEAR`,
    COUNT(customer_id) AS number_of_orders
FROM
    orders
GROUP BY `MONTH` , `YEAR`
ORDER BY `year` , `month` ASC
;

/* 4- number of products */ 
SELECT 
    COUNT(DISTINCT product_id) AS number_of_products
FROM
    products
;

/* 5- wich are the categories with most products */ 
  /*first thing to count how many products in each category */ 
SELECT 
    p.product_category_name,
    pcnt.product_category_name_english,
    COUNT(p.product_id) AS number_of_products_for_each_category
FROM
    products p
       LEFT JOIN
    product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
GROUP BY p.product_category_name , pcnt.product_category_name_english
ORDER BY number_of_products_for_each_category DESC
;
 
 /*second thing to calculate how many product sold in each category) */ 
 SELECT 
    p.product_category_name,
    COUNT(p.product_id) AS number_of_products_sold_for_each_category
FROM
    products p
	JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY number_of_products_sold_for_each_category DESC
;
 

/* 6- how many of those products were present in actual transactions */ 
SELECT 
    COUNT(DISTINCT product_id) AS number_of_products_in_actual_tansactions
FROM
    order_items;
;



/* 7- whats the price of the cheapest and most expensive items */
SELECT 
    MAX(price) AS the_most_expensive_item,
    MIN(price) AS the_cheapest_item
FROM
    order_items
;

/* 8- the highest and the lowest payments */
SELECT 
    MAX(payment_value) AS the_highest_payment,
    MIN(payment_value) AS the_lowest_payment
FROM
    order_payments
;
