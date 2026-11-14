# A Water Monitoring System — ER diagram

```mermaid
erDiagram
    direction LR
    monitoring_site {
        bigint site_id PK
        text site_name UK
        text watershed_name
    }
    sensor {
        bigint sensor_id PK
        bigint site_id FK
        text serial_number UK
        date installed_on
        boolean active
    }
    reading {
        bigint reading_id PK
        bigint sensor_id FK
        timestamptz observed_at
        numeric ph
        numeric turbidity_ntu
    }
    monitoring_site ||--o{ sensor : "site_id"
    sensor ||--o{ reading : "sensor_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Jaja_Tamunonengiofori_301909526_ERDiagram.png)
