-- 1. TAMPILKAN NAMA-NAMA PRODUK BERDASARKAN MEREK DAN KATEGORI
select 	production_products.product_name AS 'PRODUCT NAME',
		production_brands.brand_name AS 'BRAND',
        production_categories.category_name AS 'CATEGORY'
from production_products
join production_brands ON (production_brands.brand_id = production_products.brand_id)
join production_categories ON (production_categories.category_id = production_products.category_id)
order by production_brands.brand_name asc;

-- 2. TAMPILKAN NAMA-NAMA CUSTOMER
select 	CUSTOMER_ID AS 'ID',
		concat(FIRST_NAME, ' ', LAST_NAME) AS 'CUSTOMER',
        EMAIL AS 'EMAIL',
		STREET AS 'STREET',
        CITY AS 'CITY',
        STATE AS 'STATE',
        ZIP_CODE AS 'ZIP CODE'
from sales_customers;

-- 3. TAMPILKAN TABEL SALES ORDERS
select *
from sales_orders;

-- 4. TAMPILKAN TABEL SALES ORDERS ITEM
select *
from sales_order_items;

-- 5. TAMPILKAN NAMA TOKO
select *
from sales_stores;

-- 6. TAMPILKAN STAFF DI SETIAP TOKO
select 	STAFF_ID AS 'ID',
		concat(FIRST_NAME, ' ', LAST_NAME) AS 'NAME',
        sales_stores.store_name AS 'STORE'
from sales_staffs
join sales_stores ON (sales_stores.store_id = sales_staffs.store_id);

-- 7. TAMPILKAN NAMA CUSTOMER BESERTA ORDERANNYA
select 	concat(FIRST_NAME, ' ', LAST_NAME) AS 'CUSTOMER',
		production_products.product_name AS 'PRODUCT NAME',
        production_brands.brand_name AS 'BRAND',
        production_categories.category_name AS 'CATEGORY',
        sales_orders.order_status AS 'ORDER STATUS',
        sales_orders.required_date AS 'REQUIRED DATE',
        sales_orders.shipped_date AS 'SHIPPED DATE',
        sales_stores.store_name AS 'STORE',
        sales_order_items.quantity AS 'QUANTITY',
        production_products.list_price AS 'LIST PRICE'
from sales_customers
join sales_orders ON (sales_orders.customer_id = sales_customers.customer_id)
join sales_order_items ON (sales_order_items.order_id = sales_orders.order_id)
join production_products ON (sales_order_items.product_id = production_products.product_id)
JOIN production_brands ON (production_brands.brand_id = production_products.brand_id)
JOIN production_categories ON (production_categories.category_id = production_products.category_id)
join sales_stores ON (sales_stores.store_id = sales_orders.store_id);

-- 8. TAMPILKAN JUMLAH PRODUK BERDASARKAN MEREK
select	brand_name,	
		count(product_name) AS 'JUMLAH PRODUK'
from production_products
join production_brands ON (production_brands.brand_id = production_products.brand_id)
group by brand_name;

-- 9. TAMPILKAN JUMLAH PRODUK BERDASARKAN KATEGORI 
select 	production_categories.category_name AS 'KATEGORI',
        count(product_name) AS 'JUMLAH PRODUK'
from production_products
join production_categories ON (production_categories.category_id = production_products.category_id)
group by category_name;

-- 10. TAMPILKAN TOTAL REVENUE BERDASARKAN MEREK
select 	production_brands.brand_name AS 'MEREK',
		sum(production_products.list_price * sales_order_items.quantity) AS 'TOTAL REVENUE'
from production_products
join production_brands ON (production_brands.brand_id = production_products.brand_id)
join sales_order_items ON (sales_order_items.product_id = production_products.product_id)
group by production_brands.brand_name
order by sum(production_products.list_price * sales_order_items.quantity) desc;

-- 11. TAMPILKAN TOTAL REVENUE BERDASARKAN TOKO
select 	sales_stores.store_name AS 'TOKO',
		sum(production_products.list_price * sales_order_items.quantity) AS 'TOTAL REVENUE',
        rank() over (order by sum(production_products.list_price * sales_order_items.quantity) desc) as 'rank'
from sales_stores
join sales_orders ON (sales_orders.store_id = sales_stores.store_id)
join sales_order_items ON (sales_order_items.order_id = sales_orders.order_id)
join production_products ON (production_products.product_id = sales_order_items.product_id)
group by sales_stores.store_name;

-- 12. RANGKING MEREK BERDASARKAN TOTAL REVENUE
select 	production_brands.brand_name as 'merk',
		sum(production_products.list_price * sales_order_items.quantity) as 'Total Revenue',
        rank() over (order by sum(production_products.list_price * sales_order_items.quantity) desc) as 'rank'
from production_products
join production_brands on (production_brands.brand_id = production_products.brand_id)
join sales_order_items on (sales_order_items.product_id = production_products.product_id)
group by production_brands.brand_name;

-- 13. TEMUKAN PRODUK DENGAN PENJUALAN TERBANYAK PADA TAHUN 2018
SELECT 	production_products.product_name AS 'PRODUK',
		SUM(sales_order_items.quantity) AS 'JUMLAH_PRODUK',
        ROW_NUMBER () OVER (ORDER BY SUM(sales_order_items.quantity) DESC) AS 'RANK'
FROM production_products
JOIN sales_order_items ON (sales_order_items.product_id = production_products.product_id)
JOIN sales_orders ON (sales_orders.order_id = sales_order_items.order_id)
WHERE YEAR(sales_orders.order_date) = 2018
GROUP BY PRODUK
LIMIT 3;

-- 14. TEMUKAN PRODUK DENGAN PENJUALAN TERBANYAK DI TOKO SANTA CRUZ BIKE PADA TAHUN 2018
SELECT 	production_products.product_name AS 'PRODUK',
		sales_stores.store_name AS 'STORE',
		SUM(sales_order_items.quantity) AS 'JUMLAH_PRODUK',
        ROW_NUMBER () OVER (ORDER BY SUM(sales_order_items.quantity) DESC) AS 'RANK'
FROM production_products
JOIN sales_order_items ON (sales_order_items.product_id = production_products.product_id)
JOIN sales_orders ON (sales_orders.order_id = sales_order_items.order_id)
JOIN sales_stores ON (sales_orders.store_id = sales_stores.store_id)
WHERE YEAR(sales_orders.order_date) = 2017 AND store_name = 'SANTA CRUZ BIKES' 
GROUP BY PRODUK, STORE
LIMIT 3;

-- 15. BIKESTORE US SALES
select 	sales_stores.store_name as 'Toko',
		sales_orders.order_date as 'Tanggal Order',
        year(sales_orders.order_date) as 'Tahun',
        month(sales_orders.order_date) as 'Bulan',
		sales_orders.order_status as 'Status Order',
		sales_stores.city as 'Kota',
        sales_stores.street as 'Jalan',		
        production_products.product_name as 'Nama Produk',
        production_brands.brand_name as 'Merek',
        production_categories.category_name as 'Kategori',
        production_products.model_year as 'Tahun_Model',
        sales_order_items.quantity as 'Jumlah',
        sales_order_items.list_price as 'Harga',
        sales_order_items.discount as 'Diskon'
from sales_customers
join sales_orders on (sales_customers.customer_id = sales_orders.customer_id)
join sales_order_items on (sales_order_items.order_id = sales_orders.order_id)
join sales_stores on (sales_stores.store_id = sales_orders.store_id)
join production_products on (production_products.product_id = sales_order_items.product_id)
join production_brands on (production_brands.brand_id = production_products.brand_id)
join production_categories on (production_categories.category_id = production_products.category_id);






		


