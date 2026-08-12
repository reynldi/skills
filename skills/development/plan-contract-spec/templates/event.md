<!-- Use the project's discovered event envelope and broker conventions in place of these defaults. Only include metadata and mechanisms the system actually supports. -->

# {Event Name}

**Lifecycle**: ACTIVE
**Owner**: {owner}
**Next consumer**: {stage / person}
**Review trigger**: {contract or implementation change}

## `{event.name.v1}`

- **Contract**: New / Modified / Existing
- **Type**: Command / Domain Event / Integration Event
- **Producer**: {service/application}
- **Consumers**: {services/applications}
- **Broker**: {the project's broker}
- **Topic/Channel**: `{topic-name}`
- **Delivery**: At-most-once / At-least-once / Exactly-once
- **Ordering**: Guaranteed / Not guaranteed / Guaranteed by `{partitionKey}`
- **Version**: {e.g. `v1`}
- **Technical Spec**: {path/section}

### Message Metadata

| Field           | Type     | Required | Description                   |
| --------------- | -------- | :------: | ----------------------------- |
| `eventId`       | string   |   Yes    | Unique event identifier       |
| `eventType`     | string   |   Yes    | Event name and version        |
| `occurredAt`    | datetime |   Yes    | ISO-8601 event timestamp      |
| `producer`      | string   |   Yes    | Producing service             |
| `correlationId` | string   |    No    | Correlates related operations |
| `causationId`   | string   |    No    | Triggering request/event ID   |
| `partitionKey`  | string   |    No    | Ordering/partitioning key     |
| `traceId`       | string   |    No    | Distributed tracing ID        |

### Payload

**Payload**: `{EventPayload}`

| Field    | Type   | Required | Description | Constraints |
| -------- | ------ | :------: | ----------- | ----------- |
| `{name}` | string |   Yes    | {desc}      | {rule}      |

```json
{
  "eventId": "<uuid>",
  "eventType": "<event.name.v1>",
  "occurredAt": "<ISO-8601 timestamp>",
  "producer": "<service-name>",
  "partitionKey": "<resource-id>",
  "payload": {
    "<field>": "<value>"
  }
}
```

Keep the example synchronized with the metadata and payload tables.

### Delivery and Processing

- **Idempotency**: {deduplication strategy, e.g. by `eventId`}
- **Retry Policy**: {count, delay, backoff}
- **Dead-Letter Queue**: `{queue/topic}` or None
- **Retention**: {duration}
- **Schema Compatibility**: Backward / Forward / Full
- **Sensitive Data**: {none, or masking/encryption requirements}

### Consumer Behaviour

| Scenario            | Expected Behaviour                   |
| ------------------- | ------------------------------------ |
| Valid message       | Process and acknowledge              |
| Duplicate message   | Ignore safely and acknowledge        |
| Temporary failure   | Retry according to policy            |
| Invalid payload     | Reject or send to DLQ                |
| Unsupported version | Reject or use compatibility handling |
| Permanent failure   | Send to DLQ and alert                |

Adapt this table to the actual broker and delivery semantics.
