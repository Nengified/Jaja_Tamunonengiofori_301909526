-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. reject site primary. Expected: pk_monitoring_site, SQLSTATE 23505.
INSERT INTO portfolio."monitoring_site" ("site_id", "site_name", "watershed_name")
VALUES (1001, 'Willow Bend', 'Elm River');

-- 2. reject site unique. Expected: uq_monitoring_site_0, SQLSTATE 23505.
INSERT INTO portfolio."monitoring_site" ("site_id", "site_name", "watershed_name")
VALUES (4101, 'Cedar Marsh', 'Willow Creek');

-- 3. reject site id null. Expected: site_id, SQLSTATE 23502.
INSERT INTO portfolio."monitoring_site" ("site_id", "site_name", "watershed_name")
VALUES (NULL, 'Stone Ford', 'Ash River');

-- 4. reject site name null. Expected: site_name, SQLSTATE 23502.
INSERT INTO portfolio."monitoring_site" ("site_id", "site_name", "watershed_name")
VALUES (4102, NULL, 'Birch River');

-- 5. reject site watershed null. Expected: watershed_name, SQLSTATE 23502.
INSERT INTO portfolio."monitoring_site" ("site_id", "site_name", "watershed_name")
VALUES (4103, 'Fox Hollow', NULL);

-- 6. reject sensor primary. Expected: pk_sensor, SQLSTATE 23505.
INSERT INTO portfolio."sensor" ("sensor_id", "site_id", "serial_number", "installed_on", "active")
VALUES (2001, 1001, 'WQ-4104', '2025-04-01', TRUE);

-- 7. reject sensor unique. Expected: uq_sensor_0, SQLSTATE 23505.
INSERT INTO portfolio."sensor" ("sensor_id", "site_id", "serial_number", "installed_on", "active")
VALUES (4105, 1001, 'WQ-2048', '2025-04-02', TRUE);

-- 8. reject sensor foreign. Expected: fk_sensor_0, SQLSTATE 23503.
INSERT INTO portfolio."sensor" ("sensor_id", "site_id", "serial_number", "installed_on", "active")
VALUES (4106, 9106, 'WQ-4106', '2025-04-03', TRUE);

-- 9. reject sensor id null. Expected: sensor_id, SQLSTATE 23502.
INSERT INTO portfolio."sensor" ("sensor_id", "site_id", "serial_number", "installed_on", "active")
VALUES (NULL, 1001, 'WQ-4107', '2025-04-04', TRUE);

-- 10. reject sensor site null. Expected: site_id, SQLSTATE 23502.
INSERT INTO portfolio."sensor" ("sensor_id", "site_id", "serial_number", "installed_on", "active")
VALUES (4108, NULL, 'WQ-4108', '2025-04-05', TRUE);

-- 11. reject sensor serial null. Expected: serial_number, SQLSTATE 23502.
INSERT INTO portfolio."sensor" ("sensor_id", "site_id", "serial_number", "installed_on", "active")
VALUES (4109, 1001, NULL, '2025-04-06', TRUE);

-- 12. reject sensor date null. Expected: installed_on, SQLSTATE 23502.
INSERT INTO portfolio."sensor" ("sensor_id", "site_id", "serial_number", "installed_on", "active")
VALUES (4110, 1001, 'WQ-4110', NULL, TRUE);

-- 13. reject sensor active null. Expected: active, SQLSTATE 23502.
INSERT INTO portfolio."sensor" ("sensor_id", "site_id", "serial_number", "installed_on", "active")
VALUES (4111, 1001, 'WQ-4111', '2025-04-07', NULL);

-- 14. reject reading primary. Expected: pk_reading, SQLSTATE 23505.
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu")
VALUES (3001, 2001, '2025-03-14T10:15:00Z', 7.1, 1.2);

-- 15. reject reading unique. Expected: uq_reading_0, SQLSTATE 23505.
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu")
VALUES (4112, 2001, '2025-03-13T10:15:00Z', 7.1, 1.2);

-- 16. reject reading foreign. Expected: fk_reading_0, SQLSTATE 23503.
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu")
VALUES (4113, 9113, '2025-03-14T10:15:00Z', 7.1, 1.2);

-- 17. reject reading id null. Expected: reading_id, SQLSTATE 23502.
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu")
VALUES (NULL, 2001, '2025-03-15T10:15:00Z', 7.1, 1.2);

-- 18. reject reading sensor null. Expected: sensor_id, SQLSTATE 23502.
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu")
VALUES (4114, NULL, '2025-03-16T10:15:00Z', 7.1, 1.2);

-- 19. reject reading time null. Expected: observed_at, SQLSTATE 23502.
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu")
VALUES (4115, 2001, NULL, 7.1, 1.2);

-- 20. reject reading ph null. Expected: ph, SQLSTATE 23502.
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu")
VALUES (4116, 2001, '2025-03-17T10:15:00Z', NULL, 1.2);

-- 21. reject reading turbidity null. Expected: turbidity_ntu, SQLSTATE 23502.
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu")
VALUES (4117, 2001, '2025-03-18T10:15:00Z', 7.1, NULL);

-- 22. reject reading ph range. Expected: reading_ph_range, SQLSTATE 23514.
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu")
VALUES (4118, 2001, '2025-03-19T10:15:00Z', 15, 1.2);

-- 23. reject reading turbidity. Expected: reading_turbidity_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu")
VALUES (4119, 2001, '2025-03-20T10:15:00Z', 7.1, -0.1);
