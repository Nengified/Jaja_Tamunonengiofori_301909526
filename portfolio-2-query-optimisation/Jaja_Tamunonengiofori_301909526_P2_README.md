# A Water Monitoring System — SQL queries

## 1. Show related reading, sensor, monitoring_site records (up to 20).

```sql
SELECT t0."reading_id" AS "reading_reading_id",
       t0."observed_at" AS "reading_observed_at",
       t1."sensor_id" AS "sensor_sensor_id",
       t1."serial_number" AS "sensor_serial_number",
       t2."site_id" AS "monitoring_site_site_id",
       t2."site_name" AS "monitoring_site_site_name"
FROM portfolio."reading" t0
JOIN portfolio."sensor" t1 ON t0."sensor_id" = t1."sensor_id"
JOIN portfolio."monitoring_site" t2 ON t1."site_id" = t2."site_id"
ORDER BY t0."reading_id", t1."sensor_id", t2."site_id"
LIMIT 20;
```

| reading_reading_id | reading_observed_at | sensor_sensor_id | sensor_serial_number | monitoring_site_site_id | monitoring_site_site_name |
| --- | --- | --- | --- | --- | --- |
| 3001 | 2025-03-13T10:15:00+00:00 | 2001 | WQ-2048 | 1001 | Cedar Marsh |

## 2. Find reading records where observed_at matches "2025-03-13T10:15:00Z" (up to 20).

```sql
SELECT * FROM portfolio."reading"
WHERE "observed_at" IS NOT DISTINCT FROM '2025-03-13T10:15:00Z'
ORDER BY "reading_id"
LIMIT 20;
```

| reading_id | sensor_id | observed_at | ph | turbidity_ntu |
| --- | --- | --- | --- | --- |
| 3001 | 2001 | 2025-03-13T10:15:00+00:00 | 7.2 | 1.4 |

## 3. Count reading records for each sensor_id (up to 20 groups).

```sql
SELECT "sensor_id", count(*) AS record_count
FROM portfolio."reading"
GROUP BY "sensor_id"
ORDER BY record_count DESC, "sensor_id" NULLS LAST
LIMIT 20;
```

| sensor_id | record_count |
| --- | --- |
| 2001 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.212 | 1.212, 1.23, 1.204 | Sort → Seq Scan | 139 |
| After index | 0.196 | 0.196, 0.195, 0.22 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 30 |

The median execution time changed from 1.212 ms to 0.196 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.183..1.184 rows=25 loops=1)
  Seq Scan on reading (actual time=0.015..1.15 rows=25 loops=1)
Planning Time: 0.361 ms
Execution Time: 1.212 ms
```

### Before index, run 2

```text
Sort (actual time=1.2..1.201 rows=25 loops=1)
  Seq Scan on reading (actual time=0.015..1.165 rows=25 loops=1)
Planning Time: 0.352 ms
Execution Time: 1.23 ms
```

### Before index, run 3

```text
Sort (actual time=1.175..1.176 rows=25 loops=1)
  Seq Scan on reading (actual time=0.014..1.142 rows=25 loops=1)
Planning Time: 0.346 ms
Execution Time: 1.204 ms
```

### After index, run 1

```text
Sort (actual time=0.138..0.14 rows=25 loops=1)
  Bitmap Heap Scan on reading (actual time=0.024..0.102 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.014 rows=25 loops=1)
Planning Time: 0.534 ms
Execution Time: 0.196 ms
```

### After index, run 2

```text
Sort (actual time=0.14..0.142 rows=25 loops=1)
  Bitmap Heap Scan on reading (actual time=0.023..0.104 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=25 loops=1)
Planning Time: 0.539 ms
Execution Time: 0.195 ms
```

### After index, run 3

```text
Sort (actual time=0.164..0.166 rows=25 loops=1)
  Bitmap Heap Scan on reading (actual time=0.023..0.108 rows=25 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.014..0.015 rows=25 loops=1)
Planning Time: 0.51 ms
Execution Time: 0.22 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Jaja_Tamunonengiofori_301909526_P2_Queries.sql, then Jaja_Tamunonengiofori_301909526_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Jaja_Tamunonengiofori_301909526_P2_QueryResults.png) · [Index comparison](screenshots/Jaja_Tamunonengiofori_301909526_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

