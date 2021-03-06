-- Seeing a Restart, first example

set serverout on
drop table t purge;

set echo on

create table t ( x int, y int );

insert into t values ( 1, 1 );

commit;

create or replace trigger t_bufer
  before update on t for each row
  begin
      dbms_output.put_line
      ( 'old.x = ' || :old.x ||
        ', old.y = ' || :old.y );
      dbms_output.put_line
      ( 'new.x = ' || :new.x ||
        ', new.y = ' || :new.y );
  end;
/

set serveroutput on
update t set x = x+1;

set echo off
prompt in another session:
prompt set serveroutput on
prompt update t set x = x+1 where x > 0;;
pause
set echo on
commit;
