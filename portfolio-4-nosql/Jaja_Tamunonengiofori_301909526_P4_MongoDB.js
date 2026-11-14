// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("water_monitoring_events")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("water_monitoring_events", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "reading_recorded",
                    "sensor_status_changed"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "reading"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "reading_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("water_monitoring_events").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "sensor_status_changed",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "examples": {
                "measurement_payload": "illustrative measurement_payload",
                "status_payload": "illustrative status_payload",
                "recorded_by": "illustrative recorded_by"
            }
        }
    }
]));
  await db.getCollection("water_monitoring_events").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("water_monitoring_events").find({"eventType":"reading_recorded"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("water_monitoring_events").find({"source.key.reading_id":3001}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("water_monitoring_events").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("water_monitoring_events").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("water_monitoring_events").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("water_monitoring_events").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("water_monitoring_events").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
