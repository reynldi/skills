<!--HTTP Rest API Template-->
<!--Use it only for RestFull API-->
# {Endpoint Name} 

## {Method} {Path}

- **Auth**: {required/optional + who}
- **Idempotency**: {Yes/No — `Idempotency-Key: <uuid>`}
- **Version**: {e.g. `v1`}
- **Technical Documentation**: {refer to relevant technical docs}

---

### Request

**Headers**

| Header              | Required | Description               |
|---------------------|:--------:|---------------------------|
| `Authorization`     | Yes      | `Bearer <token>`          |
| `Idempotency-Key`   | No       | Client-generated UUID     |

**Query Parameters**

| Name     | Type   | Required | Description |
|----------|--------|:--------:|-------------|
| `{name}` | string | No       | {desc}      |

**Body**: `{Request Model}`

| Field    | Type   | Required | Description | Constraints |
|----------|--------|:--------:|-------------|-------------|
| `{name}` | string | Yes      | {desc}      | {rule}      |

---

### Responses

| Status | Description         |
|--------|---------------------|
| `2xx`  | {success scenario}  |
| `400`  | Validation error    |
| `401`  | Missing/invalid auth|
| `404`  | Resource not found  |
| `409`  | Conflict            |
| `500`  | Internal error      |

**Success `result`**

| Field       | Type     | Description                        |
|-------------|----------|------------------------------------|
| `id`        | string   | Unique identifier.                 |
| `status`    | string   | e.g. `PENDING`, `DONE`            |
| `createdAt` | datetime | ISO‑8601 timestamp.                |
| `updatedAt` | datetime | ISO‑8601 timestamp.                |

```json
{put standard envelope}
```

<!--gRPC API Template-->
<!--Use it only for RPC API only-->
# {RPC Name}

## `{ServiceName}.{MethodName}`

* **RPC Type**: Unary / Server Streaming / Client Streaming / Bidirectional Streaming
* **Auth**: {required/optional + who}
* **Idempotency**: {Yes/No — explain idempotency key or request ID}
* **Version**: {e.g. `v1`}
* **Technical Documentation**: {refer to relevant technical docs}

---

### Request

**Metadata**

| Key               | Required | Description                    |
| ----------------- | :------: | ------------------------------ |
| `authorization`   |    Yes   | `Bearer <token>`               |
| `idempotency-key` |    No    | Client-generated UUID          |
| `request-id`      |    No    | Request correlation identifier |

**Message**: `{RequestMessage}`

| Field    | Type   | Required | Description | Constraints |
| -------- | ------ | :------: | ----------- | ----------- |
| `{name}` | string |    Yes   | {desc}      | {rule}      |

```proto
message {RequestMessage} {
  string name = 1;
}
```

---

### Response

**Message**: `{ResponseMessage}`

| Field        | Type                      | Description            |
| ------------ | ------------------------- | ---------------------- |
| `id`         | string                    | Unique identifier      |
| `status`     | string                    | e.g. `PENDING`, `DONE` |
| `created_at` | google.protobuf.Timestamp | Creation timestamp     |
| `updated_at` | google.protobuf.Timestamp | Last update timestamp  |

```proto
message {ResponseMessage} {
  string id = 1;
  string status = 2;
  google.protobuf.Timestamp created_at = 3;
  google.protobuf.Timestamp updated_at = 4;
}
```

---

### Errors

| gRPC Code           | Description                        |
| ------------------- | ---------------------------------- |
| `INVALID_ARGUMENT`  | Validation error                   |
| `UNAUTHENTICATED`   | Missing or invalid authentication  |
| `PERMISSION_DENIED` | Caller has insufficient permission |
| `NOT_FOUND`         | Resource not found                 |
| `ALREADY_EXISTS`    | Resource already exists            |
| `ABORTED`           | Conflict or concurrent operation   |
| `INTERNAL`          | Internal server error              |
| `UNAVAILABLE`       | Service temporarily unavailable    |

```proto
service {ServiceName} {
  rpc {MethodName}({RequestMessage}) returns ({ResponseMessage});
}
```

<!--Event-based contract template-->
<!--Use it only for event-based API only-->
# {Event Name}

## `{event.name.v1}`

* **Type**: Command / Domain Event / Integration Event
* **Producer**: {service/application}
* **Consumers**: {services/applications}
* **Broker**: Kafka / RabbitMQ / SNS-SQS / Pub/Sub / Other
* **Topic/Channel**: `{topic-name}`
* **Delivery**: At-most-once / At-least-once / Exactly-once
* **Ordering**: Guaranteed / Not guaranteed / Guaranteed by `{partitionKey}`
* **Version**: {e.g. `v1`}
* **Technical Documentation**: {refer to relevant technical docs}

---

### Message Metadata

| Field           | Type     | Required | Description                                   |
| --------------- | -------- | :------: | --------------------------------------------- |
| `eventId`       | string   |    Yes   | Unique event identifier                       |
| `eventType`     | string   |    Yes   | Event name and version                        |
| `occurredAt`    | datetime |    Yes   | ISO-8601 event timestamp                      |
| `producer`      | string   |    Yes   | Producing service                             |
| `correlationId` | string   |    No    | Correlates related operations                 |
| `causationId`   | string   |    No    | Identifier of the triggering request or event |
| `partitionKey`  | string   |    No    | Key used for ordering and partitioning        |
| `traceId`       | string   |    No    | Distributed tracing identifier                |

---

### Payload

**Payload**: `{EventPayload}`

| Field    | Type   | Required | Description | Constraints |
| -------- | ------ | :------: | ----------- | ----------- |
| `{name}` | string |    Yes   | {desc}      | {rule}      |

```json
{
  "eventId": "<uuid>",
  "eventType": "{event.name.v1}",
  "occurredAt": "2026-07-18T12:00:00Z",
  "producer": "{service-name}",
  "correlationId": "<uuid>",
  "causationId": "<uuid>",
  "partitionKey": "{resource-id}",
  "traceId": "<trace-id>",
  "payload": {
    "{name}": "{value}"
  }
}
```

---

### Delivery and Processing

* **Idempotency**: Consumers must deduplicate using `eventId`.
* **Retry Policy**: {retry count, delay, and backoff strategy}
* **Dead-Letter Queue**: `{dead-letter-topic-or-queue}`
* **Retention**: {retention duration}
* **Schema Compatibility**: Backward / Forward / Full
* **Sensitive Data**: {none or describe masking/encryption requirements}

---

### Consumer Behaviour

| Scenario            | Expected Behaviour                       |
| ------------------- | ---------------------------------------- |
| Valid message       | Process and acknowledge                  |
| Duplicate message   | Ignore safely and acknowledge            |
| Temporary failure   | Retry according to retry policy          |
| Invalid payload     | Reject or send to dead-letter queue      |
| Unsupported version | Reject or route to compatibility handler |
| Permanent failure   | Send to dead-letter queue and alert      |
