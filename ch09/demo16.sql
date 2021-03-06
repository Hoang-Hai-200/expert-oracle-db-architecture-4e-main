-- Delayed Block Cleanout

set echo on
  
create undo tablespace undo_small
  datafile '/tmp/undo.dbf' size 4m
  autoextend off;

drop table big purge;

create table big
  as
  select a.*, rpad('*',1000,'*') data
from all_objects a;

alter table big add constraint big_pk
primary key(object_id);

exec dbms_stats.gather_table_stats( user, 'BIG' );

create table small ( x int, y char(500) );

insert into small select rownum, 'x' from all_users;

commit;

exec dbms_stats.gather_table_stats( user, 'SMALL' );

alter system set undo_tablespace = undo_small;

update big
     set temporary = temporary
     where rowid in
  (
  select r
    from (
  select rowid r, row_number() over
         (partition by dbms_rowid.rowid_block_number(rowid) order by rowid) rn
    from big
         )
  where rn = 1
  );

commit;

variable x refcursor
exec open :x for select * from big where object_id < 100;

!./run.sh

pause "wait for run.sh to finish"

print x

-- After finished, drop the small undo tablespace.
disconnect
connect eoda/foo@PDB1
alter system set undo_tablespace = UNDOTBS1;
disconnect
connect eoda/foo@PDB1
drop tablespace undo_small including contents and datafiles;
