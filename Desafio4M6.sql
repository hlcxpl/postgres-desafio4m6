create DATABASE prueba4_modulo6;
\ c prueba4_modulo6 --Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las
--claves primarias, foráneas y tipos de datos. (1 punto)
--Peliculas
create table peliculas(
    id integer,
    nombre varchar(255),
    anno integer,
    PRIMARY key ("id")
);
--tags
create table tags(id integer, tag varchar(32), primary key ("id"));
--pivot
create table pivot(
    pelicula_id integer,
    tag_id integer,
    foreign key ("pelicula_id") references "peliculas"("id"),
    foreign key ("tag_id") references "tags" ("id")
);
-- Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
-- segunda película debe tener dos tags asociados. (1 punto)
insert into peliculas
values(1, 'il padrino', 1980);
insert into peliculas
values(2, 'robocop', 1989);
insert into peliculas
values(3, 'harry potter', 2000);
insert into peliculas
values(4, 'back to the future', 1985);
insert into peliculas
values(5, 'terminator', 1992);
-- insertando tags
insert into tags
values(1, 'suspenso'),
    (2, 'accion futurista'),
    (3, 'aventura'),
    (4, 'ciencia ficcion'),
    (5, 'terror futurista');
-- referenciando en tabla pivote
insert into pivot
values(1, 1),
    (1, 3),
    (1, 5),
    (2, 4),
    (2, 2);
-- Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
-- mostrar 0. (1 punto)
select count(pivot.tag_id) as totaltags,
    peliculas.nombre
from peliculas
    left join pivot on peliculas.id = pivot.pelicula_id
group by peliculas.id;
-- Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
-- datos. (1 punto)
create table preguntas(
    id integer,
    pregunta varchar(255),
    respuesta_correcta varchar,
    primary key ("id")
);
create table usuarios(
    id integer,
    nombre varchar(255),
    edad int,
    primary key ("id")
);
create table respuestas(
    id integer,
    respuesta varchar(255),
    usuario_id int,
    pregunta_id int,
    foreign key (usuario_id) references "usuarios"("id"),
    foreign key (pregunta_id) references "preguntas"("id"),
    primary key ("id")
);
-- Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
-- dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
-- correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.
-- (1 punto)
-- a. Contestada correctamente significa que la respuesta indicada en la tabla
-- respuestas es exactamente igual al texto indicado en la tabla de preguntas.
insert into preguntas
values(1, '¿sabeis programar?', 'si se'),
    (2, '¿que leguajes sabes?', 'python'),
    (3, '¿quereis aprender?', 'si quiero?'),
    (4, '¿hacemos unas paginas?', 'vamos a darle'),
    (5, '¿quieres aprender Node?', 'si');
insert into usuarios
values(1, 'luis', 34),
    (2, 'cristian', 35),
    (3, 'gus', 34),
    (4, 'eugenio', 33),
    (5, 'marcos', 31);
insert into respuestas
values(1, 'si se', 2, 1),
    (2, 'si se', 1, 1),
    (3, 'python', 5, 2),
    (4, 'ok chiquillos', 4, 4),
    (5, 'pa que si soy fullstack', 3, 3);
-- Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
-- pregunta). (1 punto)
select count(preguntas.respuesta_correcta) as cant_correctas,
    usuarios.nombre
from usuarios
    left JOIN respuestas on usuarios.id = respuestas.usuario_id
    LEFT JOIN preguntas on respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY usuarios.id
ORDER BY cant_correctas DESC;
-- Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
-- respuesta correcta. (1 punto)
select count(respuestas.respuesta)as cant_corectas, preguntas.pregunta
from preguntas
    left join respuestas on preguntas.respuesta_correcta = respuestas.respuesta
    left join usuarios on respuestas.usuario_id = usuarios.id
group by preguntas.id ORDER BY cant_corectas DESC;

-- Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
-- primer usuario para probar la implementación. (1 punto)

\d usuarios

ALTER TABLE respuestas DROP CONSTRAINT "respuestas_usuario_id_fkey", ADD FOREIGN KEY
("usuario_id") REFERENCES "usuarios"("id") ON DELETE CASCADE;

delete from usuarios where id = 1;

-- Crea una restricción que impida insertar usuarios menores de 18 años en la base de
-- datos. (1 punto)

alter table usuarios add constraint mayoria_de_edad CHECK(edad>=18);

insert INTO usuarios (id, nombre, edad) VALUES(6,'karla',17);

-- Altera la tabla existente de usuarios agregando el campo email con la restricción de
-- único. (1 punto)

alter table usuarios add column email varchar(255), add constraint Luis unique(email);

insert into usuarios (id, email) values (7, 'luis@gmail.com');