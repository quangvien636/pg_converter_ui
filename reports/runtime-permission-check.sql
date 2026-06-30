drop table if exists rt_perm_check;
create table rt_perm_check(id integer);
create index rt_perm_check_idx on rt_perm_check(id);
create or replace function rt_perm_check_fn() returns integer language sql as 'select 1';
drop function rt_perm_check_fn();
drop table rt_perm_check;
