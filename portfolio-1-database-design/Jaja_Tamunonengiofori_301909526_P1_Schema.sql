-- A Water Monitoring System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."monitoring_site" (
  "site_id" bigint NOT NULL,
  "site_name" text NOT NULL,
  "watershed_name" text NOT NULL,
  CONSTRAINT "pk_monitoring_site" PRIMARY KEY ("site_id"),
  CONSTRAINT "uq_monitoring_site_0" UNIQUE ("site_name")
);
CREATE TABLE portfolio."sensor" (
  "sensor_id" bigint NOT NULL,
  "site_id" bigint NOT NULL,
  "serial_number" text NOT NULL,
  "installed_on" date NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_sensor" PRIMARY KEY ("sensor_id"),
  CONSTRAINT "uq_sensor_0" UNIQUE ("serial_number")
);
CREATE TABLE portfolio."reading" (
  "reading_id" bigint NOT NULL,
  "sensor_id" bigint NOT NULL,
  "observed_at" timestamptz NOT NULL,
  "ph" numeric(18,2) NOT NULL,
  "turbidity_ntu" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_reading" PRIMARY KEY ("reading_id"),
  CONSTRAINT "uq_reading_0" UNIQUE ("sensor_id", "observed_at")
);
ALTER TABLE portfolio."sensor" ADD CONSTRAINT "fk_sensor_0" FOREIGN KEY ("site_id") REFERENCES portfolio."monitoring_site" ("site_id");
ALTER TABLE portfolio."reading" ADD CONSTRAINT "fk_reading_0" FOREIGN KEY ("sensor_id") REFERENCES portfolio."sensor" ("sensor_id");
ALTER TABLE portfolio."reading" ADD CONSTRAINT "reading_ph_range" CHECK (("ph" >= 0) AND ("ph" <= 14));
ALTER TABLE portfolio."reading" ADD CONSTRAINT "reading_turbidity_nonnegative" CHECK ("turbidity_ntu" >= 0);
COMMIT;
