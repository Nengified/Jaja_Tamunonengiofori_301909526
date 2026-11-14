-- Show related reading, sensor, monitoring_site records (up to 20).
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

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
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

-- Find reading records where observed_at matches "2025-03-13T10:15:00Z" (up to 20).
SELECT * FROM portfolio."reading"
WHERE "observed_at" IS NOT DISTINCT FROM '2025-03-13T10:15:00Z'
ORDER BY "reading_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."reading"
WHERE "observed_at" IS NOT DISTINCT FROM '2025-03-13T10:15:00Z'
ORDER BY "reading_id"
LIMIT 20;

-- Count reading records for each sensor_id (up to 20 groups).
SELECT "sensor_id", count(*) AS record_count
FROM portfolio."reading"
GROUP BY "sensor_id"
ORDER BY record_count DESC, "sensor_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "sensor_id", count(*) AS record_count
FROM portfolio."reading"
GROUP BY "sensor_id"
ORDER BY record_count DESC, "sensor_id" NULLS LAST
LIMIT 20;
