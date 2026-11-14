# A Water Monitoring System — database design

My case study records monitoring_site, sensor, reading.

## Users

- Water-quality analysts reviewing measurements
- Field technicians registering sensors

## Main operations

- Register sites and sensors
- Record timestamped water readings
- Review filtered readings and site-level summaries

## Entities

| Entity | Information stored |
| --- | --- |
| monitoring_site | A geographic site where water monitoring takes place. |
| sensor | A registered water sensor installed at one monitoring site. |
| reading | A timestamped set of water measurements reported by a sensor. |

## monitoring_site

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| site_id | BIGINT | PK | Yes |
| site_name | TEXT | Unique | Yes |
| watershed_name | TEXT |  | Yes |
- Unique key: (site_name).

## sensor

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| sensor_id | BIGINT | PK | Yes |
| site_id | BIGINT | FK | Yes |
| serial_number | TEXT | Unique | Yes |
| installed_on | DATE |  | Yes |
| active | BOOLEAN |  | Yes |
- site_id → monitoring_site.site_id
- Unique key: (serial_number).

## reading

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| reading_id | BIGINT | PK | Yes |
| sensor_id | BIGINT | FK | Yes |
| observed_at | TIMESTAMPTZ |  | Yes |
| ph | NUMERIC(18,2) |  | Yes |
| turbidity_ntu | NUMERIC(18,2) |  | Yes |
- sensor_id → sensor.sensor_id
- Unique key: (sensor_id, observed_at).

## Relationships and business rules

- Every monitoring site must have a name.
- Every sensor must reference an existing monitoring site.
- A sensor serial number identifies at most one registered sensor.
- Every reading must reference an existing sensor.
- A reading pH value must be between 0 and 14 inclusive.
- A reading turbidity value must be zero or greater.
- A sensor may report at most one reading for a given observation timestamp.

## Assumptions

- Identifiers are generated synthetic values and are globally unique across the model.
- Each sensor belongs to exactly one monitoring site; each reading belongs to exactly one sensor.
- A sensor may have at most one reading at a given timestamp.
- pH values are measured on the conventional 0 to 14 scale, and turbidity is nonnegative.
- For a separate benchmark plan, generate 25000 synthetic readings and compare the same observed_at range query with and without a B-tree index; verify equivalent results.
- The MongoDB collection stores event documents with site and sensor context embedded where useful, rather than replacing the relational schema.

