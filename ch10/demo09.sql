-- Index Organized Tables, example 6

set echo on
set long 100000
set pages 100

begin
    dbms_metadata.set_transform_param
    ( DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', false );
end;
/

select dbms_metadata.get_ddl( 'TABLE', 'T2' ) from dual;

select dbms_metadata.get_ddl( 'TABLE', 'T3' ) from dual;
