# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection water_monitoring_events for reading_recorded and sensor_status_changed events. These are fictional event examples based on monitoring_site, sensor, reading.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related monitoring_site, sensor details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "reading_recorded",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "reading",
        "key": {
            "reading_id": 3001
        },
        "snapshot": {
            "reading_id": 3001,
            "sensor_id": 2001,
            "observed_at": "2025-03-13T10:15:00Z",
            "ph": 7.2,
            "turbidity_ntu": 1.4
        }
    },
    "embedded": {
        "monitoring_site": [
            {
                "key": {
                    "site_id": 1001
                },
                "snapshot": {
                    "site_id": 1001,
                    "site_name": "Cedar Marsh",
                    "watershed_name": "Pine Creek"
                },
                "via": [
                    "reading.sensor_id → sensor.site_id → monitoring_site"
                ]
            }
        ],
        "sensor": [
            {
                "key": {
                    "sensor_id": 2001
                },
                "snapshot": {
                    "sensor_id": 2001,
                    "site_id": 1001,
                    "serial_number": "WQ-2048",
                    "installed_on": "2025-03-12",
                    "active": true
                },
                "via": [
                    "reading.sensor_id → sensor"
                ]
            }
        ]
    },
    "references": {},
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 1 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 2 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("water_monitoring_events").find({"eventType":"reading_recorded"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "reading_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "reading_id": 3001
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("water_monitoring_events").find({"source.key.reading_id":3001}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "reading_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "reading_id": 3001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "sensor_status_changed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "reading_id": 3001
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("water_monitoring_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "reading_recorded",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "reading_id": 3001
    }
  },
  {
    "_id": "event_000002",
    "eventType": "sensor_status_changed",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "reading_id": 3001
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("water_monitoring_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| reading_recorded | 1 |
| sensor_status_changed | 1 |

## Validation and suitability

MongoDB inserted 2 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 2 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Jaja_Tamunonengiofori_301909526_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Jaja_Tamunonengiofori_301909526_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

