#!/bin/ksh

export ORACLE_SID=$1

sqlplus /nolog << EOF
conn / as sysdba
set long 3000 linesize 150
col machine format a30
select
s.machine, s.program, sq.sql_fulltext
from
v\$session s, v\$process p, v\$sql sq
where
p.spid=$2 and
s.paddr=p.addr and
s.SQL_HASH_VALUE=sq.HASH_VALUE;
exit
EOF
