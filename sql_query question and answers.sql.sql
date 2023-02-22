#1)Total Quantity sold for each product category?
SELECT sum(qty) as total_qty_sold
FROM balanced_tree.sales;

#2)Total Revenue generated for each product category? (Before discount)
select sum(balanced_tree.sales.qty*balanced_tree.sales.price) as revenue, balanced_tree.product_details.category_name
from balanced_tree.sales
join balanced_tree.product_details
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id
group by balanced_tree.product_details.category_name;

#3)Total Revenue generated for each product category? (After discount)
select round(sum(balanced_tree.sales.qty*balanced_tree.sales.price*((100 - balanced_tree.sales.discount) /100)),2) as revenue, balanced_tree.product_details.category_name
from balanced_tree.sales
join balanced_tree.product_details
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id
group by balanced_tree.product_details.category_name;

#4) Total discount amount for all as well as each product?
select balanced_tree.product_details.product_name, balanced_tree.sales.discount, sum(balanced_tree.sales.discount) as total_discount
from balanced_tree.sales
join balanced_tree.product_details
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id
group by balanced_tree.product_details.product_name;

#5)Transactions split between member and non-member purchases?
select(select sum(balanced_tree.sales.qty*balanced_tree.sales.price) as revenue_of_womens
from balanced_tree.sales
join balanced_tree.product_details
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id
where member_1 = 'f') as revenue_of_womens ,sum(balanced_tree.sales.qty*balanced_tree.sales.price) as revenue_of_mens
from balanced_tree.sales
join balanced_tree.product_details
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id
where member_1 = 't';

##Product Analysis: -
#1)top 3 selling products by qty and by revenue before discount?
select sum(balanced_tree.sales.qty * balanced_tree.sales.price) as revenue, sum(balanced_tree.sales.qty) as total_qty, balanced_tree.product_details.product_name
from balanced_tree.sales
join balanced_tree.product_details
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id
group by 3
order by 1 desc
limit 3;

#2)What is the top selling product for each segment?
select sum(balanced_tree.sales.qty * balanced_tree.sales.price) as revenue, sum(balanced_tree.sales.qty) as total_qty, balanced_tree.product_details.product_name, balanced_tree.product_details.segment_name
from balanced_tree.sales
join balanced_tree.product_details
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id
group by balanced_tree.product_details.segment_name;

#3)top 3 selling products by qty and by revenue after discount?
select sum(balanced_tree.sales.qty * balanced_tree.sales.price * (balanced_tree.sales.discount/100)) as revenue, sum(balanced_tree.sales.qty) as total_qty, balanced_tree.product_details.product_name
from balanced_tree.sales
join balanced_tree.product_details
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id
group by 3
order by 1 desc
limit 3;

#4)top 3 selling products by quantity?
select balanced_tree.product_details.product_name, sum(balanced_tree.sales.qty) as total_qty
from balanced_tree.sales
join balanced_tree.product_details
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id
group by 1
order by 2 desc
limit 3;

#5)what is the total quantity, revenue and discount for each category?
select sum(balanced_tree.sales.qty) as total_qty, sum(balanced_tree.sales.qty * balanced_tree.sales.price) as revenue, balanced_tree.sales.discount, balanced_tree.product_details.category_name
from balanced_tree.sales
join balanced_tree.product_details
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id
group by balanced_tree.product_details.category_name;

#6)how many unique transactions were there?
select count(distinct(txn_id)) as unique_transaction_id
from balanced_tree.sales;

#7)what was the total discount amount for all products?
select sum((qty*price)*(discount/100)) as total_discount
from balanced_tree.sales;

#8)Revenue generated in each segment for each month?
with joined_balance as (select balanced_tree.sales.qty, balanced_tree.sales.price, balanced_tree.product_details.segment_name , month(balanced_tree.sales.start_txn_time) as mon
from balanced_tree.product_details
join balanced_tree.sales
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id)
select mon, segment_name, sum(qty*price) as revenue
from joined_balance
group by 1, 2
order by 2,1 asc;

#9)Revenue generated in each segment for each month convert (numerical months into object months for (1= Jan)?
with joined_balance as (select balanced_tree.sales.qty, balanced_tree.sales.price, balanced_tree.product_details.segment_name , 
Case 
when month(balanced_tree.sales.start_txn_time) = 1 then "Jan"
    When month(balanced_tree.sales.start_txn_time) = 2 then "Feb"
    When month(balanced_tree.sales.start_txn_time) = 3 then "Mar"
End as mon
from balanced_tree.product_details
join balanced_tree.sales
on balanced_tree.sales.prod_id = balanced_tree.product_details.product_id)
select mon, segment_name, sum(qty*price) as revenue
from joined_balance
group by 1, 2
order by 2,1 asc;
