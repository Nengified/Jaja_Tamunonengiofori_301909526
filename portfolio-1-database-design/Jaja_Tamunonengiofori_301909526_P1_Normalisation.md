# A Water Monitoring System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| sensor_id | reading records (list) |
| --- | --- |
| 2001 | [3001] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| reading.reading_id | reading.sensor_id | sensor.sensor_id | sensor.site_id | sensor.serial_number | monitoring_site.site_id | monitoring_site.site_name |
| --- | --- | --- | --- | --- | --- | --- |
| 3001 | 2001 | 2001 | 1001 | WQ-2048 | 1001 | Cedar Marsh |

Key: reading_id.

## 2NF: depend on the whole key

reading: sensor_id is a proper part of candidate key (sensor_id, observed_at), and determines sensor details.

## sensor_example

| sensor.sensor_id | sensor.site_id | sensor.serial_number | monitoring_site.site_id | monitoring_site.site_name |
| --- | --- | --- | --- | --- |
| 2001 | 1001 | WQ-2048 | 1001 | Cedar Marsh |

## reading_example

| reading.reading_id | reading.sensor_id |
| --- | --- |
| 3001 | 2001 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## monitoring_site

| site_id | site_name | watershed_name |
| --- | --- | --- |
| 1001 | Cedar Marsh | Pine Creek |

## sensor

| sensor_id | site_id | serial_number | installed_on | active |
| --- | --- | --- | --- | --- |
| 2001 | 1001 | WQ-2048 | 2025-03-12 | true |

## reading

| reading_id | sensor_id | observed_at | ph | turbidity_ntu |
| --- | --- | --- | --- | --- |
| 3001 | 2001 | 2025-03-13T10:15:00+00:00 | 7.2 | 1.4 |

## Dependencies

- monitoring_site: (site_id) → site_name, watershed_name
- sensor: (sensor_id) → site_id, serial_number, installed_on, active
- reading: (reading_id) → sensor_id, observed_at, ph, turbidity_ntu

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
