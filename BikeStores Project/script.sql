select ord.order_id,
concat(cus.first_name,' ',cus.last_name) as customer_name,
cus.city,
cus.state,
ord.order_date,
sum(ite.quantity) as 'total_units',
sum(ite.quantity * ite.list_price) as 'revenue',
pro.product_name,
cat.category_name,
bra.brand_name,
sto.store_name,
concat(sta.first_name,' ', sta.last_name) as 'sales_rep' 
from orders ord
join customers cus using (customer_id)
join order_items  ite using (order_id)
join products pro using(product_id)
join categories cat using (category_id)
join stores sto using (store_id)
join staffs sta using (staff_id)
join brands bra using (brand_id)
group by ord.order_id,
concat(cus.first_name,' ',cus.last_name),
cus.city,
cus.state,
ord.order_date,
pro.product_name,
cat.category_name,
sto.store_name,
bra.brand_name,
concat(sta.first_name,' ', sta.last_name) 
order by order_id
