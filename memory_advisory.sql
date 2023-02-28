-- to show SGA and shared pool usage

### max SGA (MB)
select bytes/1024/1024 from v$sgainfo where name='Maximum SGA Size';

### free SGA (MB)
select bytes/1024/1024 from v$sgainfo where name='Free SGA Memory Available';

### free shared pool (MB)
select sum(decode(name,'free memory',bytes))/1024/1024 from v$sgastat where pool = 'shared pool';

### total shared pool (MB)
select sum(bytes)/1024/1024 from v$sgastat where pool = 'shared pool';
select bytes/1024/1024 from v$sgainfo where name='Shared Pool Size';


--- info about sga_max_size and sga_target
SGA_MAX_SIZE And SGA_TARGET Allocation On Oracle Linux Server (Doc ID 2136920.1)

https://docs.oracle.com/cd/E11882_01/server.112/e25494.pdf
On some UNIX platforms that do not support dynamic shared memory, the physical memory in use by the SGA is equal to the value of the SGA_MAX_SIZE parameter. On such platforms, there is no real benefit in setting SGA_TARGET to a value smaller than SGA_MAX_SIZE. Therefore, setting SGA_MAX_SIZE on those platforms is not recommended.
On other platforms, such as Solaris and Windows, the physical memory consumed by the SGA is equal to the value of SGA_TARGET.

-- to show current memory settings and advisory
SET LINES 200 PAGES 200 TRIMS ON
col name for a40
col value for a20
SELECT INSTANCE_NAME FROM V$INSTANCE;
SELECT NAME,VALUE/1024/1024 "VALUE (MB)" FROM V$PARAMETER WHERE NAME in ('memory_max_target','memory_target','sga_max_size','sga_target','pga_aggregate_limit','pga_aggregate_target','shared_pool_size') ORDER BY NAME;
SELECT PGA_TARGET_FOR_ESTIMATE/1024/1024 "PGA_TARGET_FOR_ESTIMATE(MB)", PGA_TARGET_FACTOR, BYTES_PROCESSED, ESTD_TIME, ESTD_EXTRA_BYTES_RW, ESTD_PGA_CACHE_HIT_PERCENTAGE, ESTD_OVERALLOC_COUNT
FROM V$PGA_TARGET_ADVICE;
SELECT * FROM V$MEMORY_TARGET_ADVICE;
SELECT * FROM V$SGA_TARGET_ADVICE;
select SHARED_POOL_SIZE_FOR_ESTIMATE,ESTD_LC_SIZE,ESTD_LC_TIME_SAVED,ESTD_LC_LOAD_TIME,ESTD_LC_MEMORY_OBJECT_HITS from V$SHARED_POOL_ADVICE;
SELECT NAME,VALUE/1024/1024 "VALUE (MB)" FROM V$PGASTAT WHERE NAME='maximum PGA allocated';
