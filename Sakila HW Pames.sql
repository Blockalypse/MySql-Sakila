use sakila;

-- 1.a
select first_name, last_name from actor;

-- 1.b
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name`
FROM actor;

-- 2.a 
select actor_id, first_name, last_name from actor where first_name = 'Joe' group by first_name;

-- 2.b 
select first_name, last_name from actor where last_name like '%GEN%';

-- 2.c
select last_name, first_name from actor where last_name like '%LI%' order by last_name, first_name;

-- 2.d
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3.a
ALTER TABLE actor ADD COLUMN description blob;

-- 3.b
alter table actor drop column description;

-- 4.a
select last_name, count(last_name) as 'amount of last names' from actor group by last_name;

-- 4.b
select last_name, count(last_name) as 'amount of last names' from actor 
group by last_name having `amount of last names` >=2;

-- 4.c
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4.d
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO' and last_name = 'WILLIAMS'

-- 5.a
CREATE TABLE address_copy SELECT * FROM address;

-- 6.a
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id = address.address_id;

-- 6.b 
select amount, payment_date from payment;
select staff.first_name, staff.staff_id, staff.last_name, payment.amount, sum(payment.amount) as 'Amount Rung', payment.payment_date
from staff 
inner join payment on 
staff.staff_id = payment.staff_id 
where MONTH(payment.payment_date)=8 and YEAR(payment.payment_date)=2005
group by staff.staff_id;  

-- 6.c
select film.title as 'Movie Title', count(film_actor.actor_id) as 'Actor Count'
from film
inner join film_actor on 
film.film_id = film_actor.actor_id
group by film.title;

-- 6.d
SELECT title as 'Movie Title', (SELECT COUNT(*) FROM inventory WHERE film.film_id = inventory.film_id ) AS 'Number of Copies'
FROM film
where title = 'Hunchback Impossible'
group by title;

-- 6.e
select customer.first_name, customer.last_name, sum(payment.amount) as 'Total'
from customer
inner join payment on
customer.customer_id = payment.customer_id
group by customer.last_name;

-- 7.a
SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%';

-- 7.b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  WHERE film_id IN
  (
    SELECT film_id
    FROM film 
    WHERE title = 'Alone Trip'
  ) 
);

-- 7.c
select customer.first_name, customer.last_name, customer.email
from customer
	inner join address 
		on customer.address_id = address.address_id 
	inner join city
		on city.city_id = address.city_id
	inner join country
		on country.country_id = city.country_id
	where country.country = 'Canada';

-- 7.d 

select title as 'family films', description from film
WHERE film_id IN
(
  SELECT film_id
  FROM film_category
  WHERE category_id IN
  (
    SELECT category_id
    FROM category 
    WHERE name =  'Family'
    ));
    
-- 7.e 
select film.title, count(rental.rental_id) as 'Movies Rented'
from film 
	inner join inventory 
		on film.film_id = inventory.film_id
	inner join rental
		on inventory.inventory_id = rental.inventory_id
			group by film.title
            order by 'Movies Rented' desc;
            
-- 7. f
select store.store_id, sum(payment.amount) as 'Amount Made'
from payment
	inner join rental
		on payment.rental_id = rental.rental_id
	inner join inventory
		on inventory.inventory_id = rental.inventory_id 
	inner join store
		on store.store_id = inventory.store_id
		group by store.store_id;
        
-- 7.g 
select store.store_id, city.city, country.country
from store
	inner join address
		on store.address_id = address.address_id
	inner join city
		on city.city_id = address.city_id
	inner join country
		on country.country_id = city.country_id;
		
-- 7.h 



-- 8.a used example from 7.g to do a view 
create view view_store as 
select store.store_id, city.city, country.country
from store
	inner join address
		on store.address_id = address.address_id
	inner join city
		on city.city_id = address.city_id
	inner join country
		on country.country_id = city.country_id;


-- 8.b used example from 7.g to see it 
select * from view_store;

-- 8.c used example from 7.g to drop it, code is commented 
		-- drop view view_store;
  