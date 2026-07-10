-- Retrieve the total number of orders placed.

select count(order_id) from orders;


-- Calulate the total revenue generated from pizza sales.

select round(sum(order_details.quantity * pizzas.price),2)
 as total_revenue from order_details
 join pizzas on pizzas.pizza_id = order_details.pizza_id;
 
 
 -- Identify the higherst-price pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;


-- Identify the most common pizza size ordered.	

SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;


-- list the top 5 most ordered pizza type along with their quantities. 

SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;


-- join the necessary tables to find the total quantity of each pizza category ordered. 

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC; 


-- Determine the distribution of orders by hour of the day. 

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id)
FROM
    orders AS order_count
GROUP BY HOUR(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) as name from pizza_types group by category;


-- Group the orders by date and calulate the average number of pizzas ordered per day. 

 select orders.order_date, round(sum(order_details.quantity),0) as quantity
 from orders join order_details on orders.order_id = order_details.order_id
 group  by orders.order_date;
 

-- Determine the top 3 most ordered pizza types based on revenue. 

select pizza_types.name, sum(pizzas.price * order_details.quantity) as revenue from pizzas
 join order_details on pizzas.pizza_id = order_details.pizza_id 
 join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id 
 group by pizza_types.name order by revenue desc limit 3 ; 
 
 
 -- Calculate the percentage contribution of each pizza type to total revenue. 


Select pt.name as pizza_type, round(sum(od.quantity*p.price), 2) as revenue,
round(sum(od.quantity*p.price)*100.0/
(select sum(od2.quantity*p2.price) from order_details od2 join pizzas p2 on od2.pizza_id = p2.pizza_id),2) as pct_contribution
from order_details od join pizzas p on od.pizza_id = p.pizza_id join pizza_types pt on p.pizza_type_id = pt.pizza_type_id
group by pt.name order by pct_contribution desc ;
