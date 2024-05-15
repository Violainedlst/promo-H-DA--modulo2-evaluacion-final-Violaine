-- Ejercicio Final Módulo 2 --
-- Usando la base de datos Sakilla, el ejercicio final consiste en responder en 25 preguntas (dos de la cuales bonus).

#Ejercicio 1 - Selecciona todos los nombres de las películas sin que aparezcan duplicados.
-- Dentro de la tabla film, selecciono el nombre de la película con un distint para eliminar duplicados

SELECT DISTINCT title FROM film;

#Ejercicio 2 - Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
/* Dentro de la tabla film, selecciono el titulo y la clasificación de las películas y obtengo solamente las PG-13 gracias al LIKE con un distict para
asegurarme de que no salgan duplicados tampoco.*/
SELECT DISTINCT title, rating 	
	FROM film
    WHERE rating LIKE "PG-13";
    
#Ejercicio 3 - Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
/* Dentro de la tabla film, selecciono el nombre y la descripción de la película, y busco gracias al LIKE una description que contenga amazing dentro.
Lo busco con unos %% para no sea solamente esta palabra*/

SELECT title, description 
	FROM film
	WHERE description LIKE '%amazing%'; 

#Ejercicio 4 - Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
-- Dentro de la tabla film, selecciono el titulo y la duración de las películas seleccionando solamente las de mas de 120 minutos.

SELECT title,length
	FROM film
	WHERE length >= 120;
    
#Ejercicio 5 - Recupera los nombres de todos los actores.
-- Dentro de la tabla actor, selecciono nombre y apellido de los actores

SELECT first_name,last_name FROM actor;

#Ejercicio 6 - Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
-- Dentro de la tabla actor, uso los %% para buscar los apellidos que contengan Gibson y no sean solamente la palabra Gibson

SELECT first_name,last_name FROM actor
WHERE last_name LIKE "%Gibson%";

#Ejercicio 7 - Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
-- Pongo un filtro BETWEEN para obtener los ID entre 10 y 20 incluidos.

SELECT first_name, actor_id FROM actor
WHERE actor_id BETWEEN 10 AND 20;

#Pregunta 8 - Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
/* Uso el NOT IN para excluir todas las películas que no sean R o PG-13. 
En este caso no uso not like porque hay que excluir dos categorias diferentes, habria que poner un AND y el codigo seria mas largo */

SELECT title, rating 	
	FROM film
    WHERE rating NOT IN ("R","PG-13");

/*SELECT title,rating
	FROM film
    WHERE rating NOT LIKE "R" AND rating NOT LIKE "PG-13";*/

#Pregunta 9 - Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
/* Calculo gracias a un alias cuantas pelis diferentes hay para cada clasificación y luego lo agrupo por clasificación*/

SELECT rating, COUNT(title) AS count_rating
	FROM film
	GROUP BY rating;
    
#Pregunta 10 - Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
/* Necesito unir las tablas rental, donde tengo el rental_id y el customer_id con la tabla customer que tambien tiene la columna customer_id y los nombres, 
apellidos y id de los clientes. Calculo cuantos rental_id hay por cliente y lo agrupo por los ID de los clientes*/

SELECT customer.customer_id, customer.first_name, customer.last_name, COUNT(rental_id) AS movies_rented
	FROM customer 
	INNER JOIN rental
	ON rental.customer_id = customer.customer_id
	GROUP BY customer_id;
    
#Pregunta 11 - Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
/* Entiendo que empiezo con la columna category (ya que necesito la columna nombre) y que tengo que llegar hasta la tabla rental (para poder contar cuantas veces 
se han alquilado). Itero y busco en las tablas que columnas tienen datos en común. 

- tabla category = category_id, name // Primero el nombre de las categorias para mi tabla y su id
- tabla film_category = film_id,category_id // 
- tabla inventory = inventory_id,film_id
- tabla rental = rental_id,customer_id,inventory_id */

SELECT category.name, COUNT(rental.rental_id) AS movies_rented
	FROM category
    INNER JOIN film_category ON category.category_id = film_category.category_id
    INNER JOIN film ON film_category.film_id = film.film_id
	INNER JOIN inventory ON film.film_id = inventory.film_id
	INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
	GROUP BY category.name;
    
    
#Pregunta 12 - Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
/* Dentro de la tabla calculo la media de duración y lo agrupo por la columna de clasificación */

SELECT rating, AVG(length) AS media_duracion
FROM film
GROUP by rating;
    
# Ejercicio 13 - Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
/* Empiezo con la tabla film, donde tengo mi filtro para el nombre de la peli y tengo que llegar hacia actor. 
film = title, film_id
film_actor = film_actor = actor_id,film_id
actor = actor_id,first_name,last_name */
SELECT actor.first_name,actor.last_name
	FROM film
    INNER JOIN film_actor ON film.film_id = film_actor.film_id
    INNER JOIN actor ON film_actor.actor_id = actor.actor_id
		WHERE film.title = 'Indian Love';
    
#Pregunta 14 - Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
-- Busco dentro de la description de las pelis si estan incluidas las palabras dog or cat

SELECT title, description 
	FROM film
	WHERE description LIKE '%dog%' OR '%cat%'; 
    
#Pregunta 15 - Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
-- Empezamos con la tabla actor donde tengo las columnas que me interesan para el select, y luego itero hacia film_actor para buscar si hay una pelicula que
-- no tenga ningun actor_id

SELECT actor.first_name, actor.last_name, actor.actor_id
	FROM actor
	INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
	WHERE film_actor.actor_id IS NULL AND film_actor.film_id IS NOT NULL;
    -- no hay ningun actor que no aparezca en ninguna pelí
    
#Pregunta 16 - Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
-- Tengo toda la información dentro de la misma tabla, necesito poner un between para obtener las fechas de salidas entre 2005 y 2010

SELECT title, release_year FROM film
WHERE release_year BETWEEN 2005 AND 2010;

#Pregunta 17 - Encuentra el título de todas las películas que son de la misma categoría que "Family".
/* Empiezo con la tabla category ya que tengo mi filtro dentro y itero hasta la tabla film, buscando similitudes en las columnas.
category = category_id,name
film =  film_id, title
film_category = film_id, category_id */

SELECT film.title, category.name
	FROM category
    INNER JOIN film_category ON film_category.category_id = category.category_id
    INNER JOIN film ON film_category.film_id = film.film_id
    WHERE category.name = 'Family';

#Pregunta 18 - Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
/* Necesito dos tablas, la de actor donde tengo los nombres y la de film_actor donde tengo los ID de las pelis. Necesito un filtro COUNT para obtener solamente
los nombres de actores que estan en mas de 10 peli_id.
actor = first_name, last_name, actor_id
film_actor = actor_id, film_id */

SELECT actor.first_name, actor.last_name, COUNT(actor.actor_id) AS actors_in_movies
	FROM actor
    INNER JOIN film_actor ON actor.actor_id = film_actor.actor_id
    GROUP BY actor.actor_id
    HAVING COUNT(actor.actor_id) >10;


#Pregunta 19 - Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
/* Esta toda la información que necesito dentro de la misma tabla, el titulo, la duración y el rating. Añado un AND y no un OR porque 
tienen que cumplir los dos filtros */
    
SELECT title, length, rating
		FROM film
		WHERE rating = "R" AND length >= 120;
    
#Pregunta 20 - Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría 
-- junto con el promedio de duración.
    /* Selecciono nombre de category y la duración de la peli. Empiezo desde la tabla film ya que es donde tengo el HAVING y AVG.
film = avg(length), title, film_id
film_category = film_id
category = film_id, name */ 
    
SELECT category.name, AVG(film.length) as average_length
	FROM film
    INNER JOIN film_category ON film_category.film_id = film.film_id
    INNER JOIN category ON category.category_id = film_category.category_id
    GROUP BY category.name
    HAVING AVG(film.length) > 120;
    
#Pregunta 21 - Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.
/*
actor = actor_id, first_name, last_name
film_actor = actor_id, film_id
film = film_id, title
group by film_id 
count actor_id in film_actor
 */ 
 
SELECT actor.first_name, actor.last_name, COUNT(film_actor.actor_id) AS actor_in_movies
	FROM actor
    INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id
    INNER JOIN film ON film_actor.film_id = film.film_id
    GROUP BY film_actor.actor_id
    HAVING COUNT(film_actor.actor_id) > 5
    ORDER BY actor_in_movies ASC
    ;

/*Pregunta 22 - Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una
subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona
las películas correspondientes.*/
/* Empiezo con la tabla film, por su columna title, y itera hasta llegar a rental, donde tengo las fechas de alquiler. Dentro de la tabla rental,
hago una subconsulta ya que solamente busco las de mas de 5 días.
film = film_id, title
inventory = inventory_id,film_id
rental = rental_id,rental_date,inventory_id,return_date */
SELECT title
	FROM film
		INNER JOIN inventory ON film.film_id = inventory.film_id
		INNER JOIN (SELECT inventory_id 
						FROM rental
						WHERE DATEDIFF(return_date,rental_date) > 5) AS medium_rent
                        ON inventory.inventory_id = medium_rent.inventory_id
                        GROUP BY film.title;
                        
                        /* hacer comprobación */

/*Pregunta 23 - Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la
categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en
películas de la categoría "Horror" y luego exclúyelos de la lista de actores. */
/* 
actor = actor_id, first_name, last_name
film_actor = actor_id, film_id
film_category = film_id, category_id
category = category_id, name
 */
 
SELECT actor.actor_id, actor.first_name, actor.last_name AS actor_names
FROM actor
WHERE actor.actor_id NOT IN (
	SELECT film_actor.actor_id
    FROM film_actor
    INNER JOIN film_category ON film_actor.film_id = film_category.film_id
    INNER JOIN category ON film_category.category_id = category.category_id
    WHERE category.name = 'Horror'
    );
            

/*BONUS: Pregunta 24 - Encuentra el título de las películas que son comedias y tienen una duración mayor a 180
minutos en la tabla film. 
film = film_id, title
film_category = film_id, category_id
category = category_id, name
*/
SELECT title,length
	FROM film
	INNER JOIN film_category ON film.film_id = film_category.film_id
    INNER JOIN category ON film_category.category_id = category.category_id
    WHERE category.name = 'comedy' AND film.length > 180;

/* */