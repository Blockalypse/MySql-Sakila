use sakila;

-- 1.a Display the first and last names of all actors from the table
select first_name, last_name from actor;

-- 1.b Display the first and last name of each actor in a single column in upper case letters. Name the column
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name`
FROM actor;

-- 2.a Display the Joe's information
select actor_id, first_name, last_name from actor where first_name = 'Joe' group by first_name;

-- 2.b Display actors whose last name contain 'Gen'
select first_name, last_name from actor where last_name like '%GEN%';

-- 2.c Display all actors whose last names contain the letters `LI`
select last_name, first_name from actor where last_name like '%LI%' order by last_name, first_name;

-- 2.d Display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China.
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3.a  Create a column in the table `actor` named `description` and use the data type `BLOB`
ALTER TABLE actor ADD COLUMN description blob;

-- 3.b Delete the `description` column.
alter table actor drop column description;

-- 4.a The last names of actors, as well as how many actors have that last name.
select last_name, count(last_name) as 'amount of last names' from actor group by last_name;

-- 4.b Last names of actors and the count of actors who have that last name
select last_name, count(last_name) as 'amount of last names' from actor 
group by last_name having `amount of last names` >=2;

-- 4.c Write a query to fix the record.
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4.d Write a query to change the record above.
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO' and last_name = 'WILLIAMS'

-- 5.a the schema of the `address` table.

SHOW CREATE TABLE address;

-- 6.a Use the tables `staff` and `address``JOIN` to display the first and last names, as well as the address, of each staff member. 
SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id = address.address_id;

-- 6.b Use tables `staff` and `payment` to display the total amount rung up by each staff member in August of 2005.
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
group by film.title
ORDER BY Actors desc;

-- 6.d Display number of copies of the film `Hunchback Impossible` exist in the inventory system.
SELECT title as 'Movie Title', (SELECT COUNT(*) FROM inventory WHERE film.film_id = inventory.film_id ) AS 'Number of Copies'
FROM film
where title = 'Hunchback Impossible'
group by title;

-- 6.e List the total paid by each customer, Using the tables `payment` and `customer` and the `JOIN` command. 
select customer.first_name, customer.last_name, sum(payment.amount) as 'Total'
from customer
inner join payment on
customer.customer_id = payment.customer_id
group by customer.last_name;

-- 7.a Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%';

-- 7.b Use subqueries to display all actors who appear in the film `Alone Trip`
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

-- 7.c Displayed names and email addresses of all Canadian customers
select customer.first_name, customer.last_name, customer.email
from customer
	inner join address 
		on customer.address_id = address.address_id 
	inner join city
		on city.city_id = address.city_id
	inner join country
		on country.country_id = city.country_id
	where country.country = 'Canada';

-- 7.d Identify all movies categorized as _family_ films

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
    
-- 7.e Display the most frequently rented movies in descending order.
select film.title, count(rental.rental_id) as 'Movies Rented'
from film 
	inner join inventory 
		on film.film_id = inventory.film_id
	inner join rental
		on inventory.inventory_id = rental.inventory_id
			group by film.title
            order by 'Movies Rented' desc;
            
-- 7.f Display how much business, in dollars, each store brought in.
select store.store_id, sum(payment.amount) as 'Amount Made'
from payment
	inner join rental
		on payment.rental_id = rental.rental_id
	inner join inventory
		on inventory.inventory_id = rental.inventory_id 
	inner join store
		on store.store_id = inventory.store_id
		group by store.store_id;
        
-- 7.g Display for each store its store ID, city, and country.
select store.store_id, city.city, country.country
from store
	inner join address
		on store.address_id = address.address_id
	inner join city
		on city.city_id = address.city_id
	inner join country
		on country.country_id = city.country_id;
		
-- 7.h Displayed the top five genres in gross revenue in descending order

SELECT SUM(amount) AS 'Total Sales', c.name AS 'Genre'
  FROM payment p
  INNER JOIN rental r
	ON (p.rental_id = r.rental_id)
  INNER JOIN inventory i
	ON (r.inventory_id = i.inventory_id)
  INNER JOIN film_category fc
	ON (i.film_id = fc.film_id)
  INNER JOIN category c
	ON (fc.category_id = c.category_id)
  GROUP BY c.name
  ORDER BY SUM(amount) DESC;

-- 8.a used example from 7.g to do a view 
  CREATE VIEW top_five_genres AS
  SELECT SUM(amount) AS 'Total Sales', c.name AS 'Genre'
  FROM payment p
  INNER JOIN rental r
	ON (p.rental_id = r.rental_id)
  INNER JOIN inventory i
	ON (r.inventory_id = i.inventory_id)
  INNER JOIN film_category fc
	ON (i.film_id = fc.film_id)
  INNER JOIN category c
	ON (fc.category_id = c.category_id)
  GROUP BY c.name
  ORDER BY SUM(amount) DESC
  LIMIT 5;

-- 8.b Display top five genres
select * from top_five_genres;

