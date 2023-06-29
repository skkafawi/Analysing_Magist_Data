/* What categories of tech products does Magist have? */ 
SELECT 
    p.product_category_name,
    pcnt.product_category_name_english,
    COUNT(p.product_id) AS number_of_products_for_each_category
FROM
    products p
		LEFT JOIN
    product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
WHERE
    pcnt.product_category_name_english IN ('computers_accessories' , 'telephony',
        'audio',
        'consoles_games',
        'electronics',
        'computers',
        'tablets_printing_image',
        'pc_gamer')
GROUP BY p.product_category_name , pcnt.product_category_name_english
ORDER BY number_of_products_for_each_category DESC
;

/* how many of those products have been sold */
SELECT 
    COUNT(p.product_id) AS number_of_products_sold_for_each_category
FROM
    products p
       LEFT JOIN
    order_items oi ON p.product_id = oi.product_id
		JOIN
    product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
WHERE
    pcnt.product_category_name_english IN ('computers_accessories' , 'telephony',
        'audio',
        'consoles_games',
        'electronics',
        'computers',
        'tablets_printing_image',
        'pc_gamer')
ORDER BY number_of_products_sold_for_each_category DESC
;



/* what is the percentage of tech sold compared to the all type of products */

SELECT 
    (SELECT 
            COUNT(p.product_id) AS number_of_products_sold_for_each_category
        FROM
            products p
               LEFT JOIN
            order_items oi ON p.product_id = oi.product_id
                JOIN
            product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
        WHERE
            pcnt.product_category_name_english IN ('computers_accessories' , 'telephony',
                'audio',
                'consoles_games',
                'electronics',
                'computers',
                'tablets_printing_image',
                'pc_gamer')) / COUNT(*) * 100 AS Percentage_tech_products_sold
FROM
    order_items;


/* What’s the average price of the products being sold? */
SELECT 
    ROUND(AVG(price))
FROM
    order_items
;
/* Are expensive tech products popular? */
SELECT 
    COUNT(*),
    CASE
        WHEN price < 110 THEN 'low'
        WHEN price >= 110 AND price < 130 THEN 'average'
        ELSE 'high'
    END AS Price_Category
FROM
    order_items
        LEFT JOIN
    products ON order_items.product_id = products.product_id
        LEFT JOIN
    product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE
    product_category_name_english IN ('audio' , 'console_games',
        'electronics',
        'computers',
        'computer_accessories',
        'pc_gamer',
        'telephony',
        'tablet_printing_image')
GROUP BY Price_Category
;
/* In relation to the sellers: */ 
/* how many months is covered with the data */
SELECT 
    TIMESTAMPDIFF(MONTH,
        MIN(order_purchase_timestamp),
        MAX(order_purchase_timestamp)) AS months_of_data
FROM
    orders;

/* How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers? */
SELECT 
    COUNT(*)
FROM
    sellers
;
SELECT 
            COUNT(DISTINCT s.seller_id) AS tech_sellers
        FROM
            sellers s
                LEFT JOIN
            order_items oi ON s.seller_id = oi.seller_id
                INNER JOIN
            products p ON oi.product_id = p.product_id
                INNER JOIN
            product_category_name_translation pt ON pt.product_category_name = p.product_category_name
        WHERE
            product_category_name_english IN ('audio' , 'consoles_games',
                'electronics',
                'computers',
                'computers_accessories',
                'pc_gamer',
                'telephony',
                'tablets_printing_image')
                ;
SELECT 
    (SELECT 
            COUNT(DISTINCT s.seller_id) AS tech_sellers
        FROM
            sellers s
                LEFT JOIN
            order_items oi ON s.seller_id = oi.seller_id
                INNER JOIN
            products p ON oi.product_id = p.product_id
                INNER JOIN
            product_category_name_translation pt ON pt.product_category_name = p.product_category_name
        WHERE
            product_category_name_english IN ('audio' , 'consoles_games',
                'electronics',
                'computers',
                'computers_accessories',
                'pc_gamer',
                'telephony',
                'tablets_printing_image')) * 100 / 3095;


/* What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers? */ 
SELECT 
    ROUND(SUM(price))
FROM
    order_items
;
SELECT 
    
    SUM(price)
FROM
    sellers s
        LEFT JOIN
    order_items oi ON s.seller_id = oi.seller_id
        INNER JOIN
    products p ON oi.product_id = p.product_id
        INNER JOIN
    product_category_name_translation pt ON pt.product_category_name = p.product_category_name
    
WHERE
    product_category_name_english IN ('audio' , 'consoles_games',
        'electronics',
        'computers',
        'computers_accessories',
        'pc_gamer',
        'telephony',
        'tablets_printing_image')
        ;
      
/* Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers? */ 
SELECT 
        YEAR(order_purchase_timestamp) AS Year, 
        MONTH(order_purchase_timestamp) AS Month, ROUND(SUM(price)/COUNT(s.seller_id)) 
      FROM sellers s
      LEFT JOIN order_items oi ON s.seller_id = oi.seller_id
      INNER JOIN orders o ON oi.order_id = o.order_id
      INNER JOIN products p ON oi.product_id = p.product_id
      INNER JOIN product_category_name_translation pt ON pt.product_category_name = p.product_category_name 
      GROUP BY Year, Month
      ORDER BY Year, Month
      ;
      
      SELECT 
        YEAR(order_purchase_timestamp) AS Year, 
        MONTH(order_purchase_timestamp) AS Month, ROUND(SUM(price)/477) as avg_price
      FROM sellers s
      LEFT JOIN order_items oi ON s.seller_id = oi.seller_id
      INNER JOIN orders o ON oi.order_id = o.order_id
      INNER JOIN products p ON oi.product_id = p.product_id
      INNER JOIN product_category_name_translation pt ON pt.product_category_name = p.product_category_name 
    WHERE product_category_name_english IN ('audio', 'consoles_games', 'electronics', 'computers', 'computers_accessories', 'pc_gamer','telephony','tablets_printingimage')
      GROUP BY Year, Month
      ORDER BY Year, Month;
/* In relation to the delivery time: */ 
/* What’s the average time between the order being placed and the product being delivered? */ 
SELECT 
    AVG(TIMESTAMPDIFF(DAY,
        order_purchase_timestamp,
        order_delivered_customer_date)) AS average_delivery_time_in_days
FROM
    orders;
/* How many orders are delivered on time vs orders delivered with a delay? */ 
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1
        ELSE 0
    END) AS on_time_orders,
    COUNT(*) - SUM(CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 1
        ELSE 0
    END) AS delayed_orders
FROM
    orders;
/* Is there any pattern for delayed orders, e.g. big products being delayed more often? */ 



