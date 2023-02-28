-- check top table size -- INDEX,LOBINDEX,LOBSEGMENT,TABLE, INCLUDING ROW COUNT
-- edit <schema_name> for actual schema name
with tabsize as (
    select owner,table_name,sum(bytes)/1024/1024/1024 "SIZE"
    from (
    select seg.owner,seg.segment_name "TABLE_NAME", seg.bytes
    from dba_segments seg
    where seg.owner='<schema_name>'
    and segment_type='TABLE'
    union
    select ind.owner,ind.table_name, seg.bytes
    from dba_segments seg
    left outer join dba_indexes ind
    on (seg.segment_name=ind.index_name and seg.owner=ind.owner)
    where seg.owner='<schema_name>'
    and segment_type='INDEX'
    union
    select lob.owner,lob.table_name, seg.bytes
    from dba_segments seg
    left outer join dba_lobs lob
    on (seg.segment_name=lob.segment_name and seg.owner=lob.owner)
    where seg.owner='<schema_name>'
    and segment_type='LOBSEGMENT'
    union
    select ind.owner,ind.table_name, seg.bytes
    from dba_segments seg
    right outer join dba_indexes ind
    on (seg.segment_name=ind.index_name and seg.owner=ind.owner)
    where seg.owner='<schema_name>'
    and segment_type='LOBINDEX'
    ) source
    where table_name not like 'BIN$%'
    group by owner,table_name
    )
select tabsize.owner,tabsize.table_name, tabsize."SIZE" "Size (GB)", tab.num_rows
from tabsize,dba_tables tab
where tabsize.table_name=tab.table_name
and tab.owner=tabsize.owner
order by "SIZE" desc;
