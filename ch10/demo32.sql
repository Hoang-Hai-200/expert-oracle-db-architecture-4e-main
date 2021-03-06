-- Object Tables, example 3

set echo on

drop table people;

CREATE TABLE "PEOPLE"
  OF "PERSON_TYPE"
  ( constraint people_pk primary key(name) )
    object identifier is PRIMARY KEY
/

select name, type#, segcollength
    from sys.col$
    where obj# = ( select object_id
                   from user_objects
                   where object_name = 'PEOPLE' )
     and name like 'SYS\_NC\_%' escape '\'
/

insert into people (name) values ( 'Hello World!' );
select sys_nc_oid$ from people p;
select utl_raw.cast_to_raw( 'Hello World!' ) data from dual;
select utl_raw.cast_to_varchar2(sys_nc_oid$) data from people;
