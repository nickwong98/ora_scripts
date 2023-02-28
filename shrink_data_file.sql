-- General datafile resize statement for Oracle database
select
'ALTER DATABASE DATAFILE ''' || df.FILE_NAME || ''' RESIZE ' || DECODE(CEIL((df.BLOCKS-fs.BLOCKS)*ts.BLOCK_SIZE/1024/1024),1,2,CEIL((df.BLOCKS-fs.BLOCKS)*ts.BLOCK_SIZE/1024/1024)) || 'M;' "RESIZE_STMT"
from
dba_free_space fs, dba_data_files df, dba_tablespaces ts
where
ts.tablespace_name=df.tablespace_name
and fs.file_id=df.file_id
and fs.block_id+fs.blocks=df.blocks
and fs.bytes>1024*1024 -- finding free blocks more than 1M
order by df.FILE_NAME;
