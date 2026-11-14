-- Fictional sample records for A Water Monitoring System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."monitoring_site" ("site_id", "site_name", "watershed_name") VALUES (1001, 'Cedar Marsh', 'Pine Creek');
INSERT INTO portfolio."sensor" ("sensor_id", "site_id", "serial_number", "installed_on", "active") VALUES (2001, 1001, 'WQ-2048', '2025-03-12', TRUE);
INSERT INTO portfolio."reading" ("reading_id", "sensor_id", "observed_at", "ph", "turbidity_ntu") VALUES (3001, 2001, '2025-03-13T10:15:00Z', 7.2, 1.4);
COMMIT;
