/*PROCEDIMIENTOS, FUNCIONES, CURSORES */



/*procedure sencillo*/
CREATE OR REPLACE PROCEDURE BUSQUEDA_EMPLE(V_EMP_NO EMPLE.EMP_NO%TYPE)
AS

V_APE EMPLE.APELLIDO%TYPE;
V_SALARIO EMPLE.SALARIO%TYPE;

BEGIN
SELECT APELLIDO, SALARIO INTO V_APE, V_SALARIO
FROM EMPLE WHERE EMP_NO = V_EMP_NO;
DBMS_OUTPUT.PUT_LINE('APELLIDO: '||V_APE||' SALARIO: '||TO_CHAR(V_SALARIO)||' ID: '||V_EMP_NO);


EXCEPTION
WHEN NO_DATA_FOUND THEN
DBMS_OUTPUT.PUT_LINE('ERROR: NINGUN EMPLEADO CON ESE NUMERO DE USUARIO');

END BUSQUEDA_EMPLE;
/


/*procedure sencillo con ROWTYPE*/
CREATE OR REPLACE PROCEDURE mostrar_animal_por_codigo (V_CODIGO ANIMALES.CODIGO%TYPE)
AS
V_ANIMAL ANIMALES%ROWTYPE;
BEGIN
SELECT * INTO V_ANIMAL FROM ANIMALES WHERE CODIGO = V_CODIGO;
DBMS_OUTPUT.PUT_LINE('CODIGO: '||V_ANIMAL.CODIGO||' - NOMBRE: '||V_ANIMAL.NOMBRE);
EXCEPTION
WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('la consulta ha devuelto mas de un resultado');
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('la consulta no ha devuelto ningun resultado');
END;
/


/*procedure con bucle while */
create or replace procedure mostrar_animales
as
cursor c1
is
select * from animales;
v_animal c1%rowtype;
begin
fetch c1 into v_animal;
while c1%found loop
dbms_output.put_line('codigo: '||v_animal.codigo||' nombre: '||v_animal.nombre);
fetch c1 into v_animal;
end loop;
close c1;
end mostrar_animales;
/
 
 /*este metodo de aqui abajo hace lo mismo que el while 
 de aqui arriba, pero con un bucle for 
 que realiza de manera implicita la mayoria de  
 accions de un cursor */

create or replace procedure mostrar_animalesBUCLEFOR
as
cursor c1
is
select * from animales;
begin
for v_animal in c1 loop
dbms_output.put_line('codigo :'||v_animal.codigo||' nombre: '||v_animal.nombre);
end loop;
end mostrar_animalesBUCLEFOR;
/

/*podemos seleccionar toda una columna pero luego solo 
usar los campos que nos 
convengan
en el caso de abajo, no empleamos el campo apellidos 
(aunque podriamos sacarlo por pantalla si quisieramos tamebien) */

create or replace procedure select_usuario_por_id (V_ID USUARIOS.ID%TYPE)
AS
V_USUARIO USUARIOS%ROWTYPE;
BEGIN
SELECT * INTO V_USUARIO FROM USUARIOS WHERE id = V_ID;
dbms_output.put_line('id: '||V_USUARIO.id||' nombre: '||V_USUARIO.apellidos||' password: '||V_USUARIO.password||' email: '||V_USUARIO.email);

dbms_output.put_line(TO_CHAR(sysdate, 'DAY " dia " DD " de " MONTH " de " YYYY " a las " HH24:MM:SS'));

exception
when too_many_rows then dbms_output.put_line('la seleccion ha devuelto mas de un registro');
when no_data_found then dbms_output.put_line('la seleccion no ha devuelto ningun registro');
when others then dbms_output.put_line('error');
end select_usuario_por_id;
/


CREATE OR REPLACE procedure cambiar_nombre_usuario (V_ID USUARIOS.ID%TYPE, V_NUEVO_NOMBRE VARCHAR2)

as
V_NOMBRE_ANTERIOR USUARIOS.NOMBRE%TYPE;
BEGIN
SELECT nombre into V_NOMBRE_ANTERIOR from usuarios where id = V_ID;
UPDATE usuarios set nombre = V_NUEVO_NOMBRE where id = V_ID;
dbms_output.put_line('id: '||V_ID);
dbms_output.put_line('nombre anterior: '||V_NOMBRE_ANTERIOR);
dbms_output.put_line('nuevo nombre: '||V_NUEVO_NOMBRE);
dbms_output.put_line(to_char(sysdate, 'DD / MONTH / YYYY'));
exception
when too_many_rows then dbms_output.put_line('la seleccion ha devuelto mas de un
 registro');

when no_data_found then dbms_output.put_line('la seleccion no ha devuelto ningun
 registro');

when others then dbms_output.put_line('error');
end cambiar_nombre_usuario;


create or replace procedure mostrar_usuarios
as
cursor c1
is
select * from usuarios;
v_usuario c1%rowtype;
begin
open c1;
fetch c1 into v_usuario;
while c1%found loop
dbms_output.put_line('id: '||v_usuario.id||' nombre: '||v_usuario.nombre||' email: '||v_usuario.email);
fetch c1 into v_usuario;
end loop;
close c1;
end mostrar_usuarios;
/

/*este metodo de aqui abajo saca el mismo resultado 
que el del bucle while que hay justo arriba, 
la diferencia es que este de abajo usa un bucle for 
que realiza implicitamente la mayoria de las operaciones 
del cursor */
create or replace procedure mostrar_usuariosBUCLEFOR
as
cursor c1
is
select * from usuarios;
begin
for v_usuario in c1 loop
dbms_output.put_line('id: '||v_usuario.id||' nombre: '||v_usuario.nombre||' email: '||v_usuario.email);
end loop;
end mostrar_usuariosBUCLEFOR;
/




create or replace procedure lista_emple_total
as
cursor c_emple is

select apellido, oficio, salario, comision, salario+nvl(comision, 0) as total
from emple
order by salario desc;

v_emple c_emple%ROWTYPE;

begin
open c_emple;
fetch  c_emple into v_emple.apellido, v_emple.oficio, v_emple.salario, v_emple.comision, v_emple.total;

while c_emple%FOUND loop

dbms_output.put_line('Apellido :'|| v_emple.apellido || ' Oficio: '|| v_emple.oficio|| ' Salario: '||v_emple.salario||' Comision: '|| v_emple.comision||' Total :'||v_emple.total);

fetch c_emple into v_emple.apellido, v_emple.oficio, v_emple.salario, v_emple.comision, v_emple.total;

end loop;
close c_emple;

end lista_emple_total; 
/



create or replace procedure lista_ape_emple_dept(V_DEPT_NO EMPLE.DEPT_NO%TYPE)
AS
CURSOR C1 
IS

SELECT APELLIDO FROM EMPLE 
WHERE DEPT_NO = V_DEPT_NO;


V_EMPLE C1%ROWTYPE;

BEGIN
OPEN C1;
FETCH C1 INTO V_EMPLE.APELLIDO;
WHILE C1%FOUND LOOP
FETCH C1 INTO V_EMPLE.APELLIDO;
DBMS_OUTPUT.PUT_LINE('APELLIDO: '||V_EMPLE.APELLIDO);
END LOOP;
CLOSE C1;
END; 
/


CREATE OR REPLACE PROCEDURE mostrar_apellidos_empleados(V_DEPT_NO EMPLE.DEPT_NO%TYPE)
AS
CURSOR C1
IS
SELECT APELLIDO FROM EMPLE WHERE DEPT_NO = V_DEPT_NO;
V_APELLIDO EMPLE.APELLIDO%TYPE;
BEGIN
OPEN C1;
FETCH C1 INTO V_APELLIDO;
WHILE C1%FOUND LOOP
DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT||'  APELLIDO:  '||V_APELLIDO);
FETCH C1 INTO V_APELLIDO;
END LOOP;
CLOSE C1;
END;


CREATE OR REPLACE PROCEDURE lista_provincias
as
CURSOR C1
IS
SELECT * FROM PROVINCIAS;
V_PROV C1%ROWTYPE;
BEGIN
OPEN C1;
FETCH C1 INTO V_PROV;
WHILE C1%FOUND LOOP
DBMS_OUTPUT.PUT_LINE(C1%ROWCOUNT||' - COD: '||V_PROV.CODPROVINCIA||' NOMBRE: '||V_PROV.NOM_PROVINCIA);
FETCH C1 INTO V_PROV.CODPROVINCIA, V_PROV.NOM_PROVINCIA;
END LOOP;
CLOSE C1;
END;
/