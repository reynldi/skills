<!-- Use the project's discovered envelope, error model, auth, and naming conventions in place of these defaults. Remove any subsection that does not apply. -->

# {Endpoint Name}

**Lifecycle**: ACTIVE
**Owner**: {owner}
**Next consumer**: {stage / person}
**Review trigger**: {contract or implementation change}

## {Method} {Path}

- **Contract**: New / Modified / Existing
- **Auth**: {required/optional + who}
- **Idempotency**: {Yes/No — `Idempotency-Key: <uuid>` when applicable}
- **Version**: {e.g. `v1`}
- **Technical Spec**: {path/section}

### Request

**Headers**

| Header            | Required | Description           |
| ----------------- | :------: | --------------------- |
| `Authorization`   |   Yes    | `Bearer <token>`      |
| `Idempotency-Key` |    No    | Client-generated UUID |

**Query Parameters**

| Name     | Type   | Required | Description |
| -------- | ------ | :------: | ----------- |
| `{name}` | string |    No    | {desc}      |

**Body**: `{Request Model}`

| Field    | Type   | Required | Description | Constraints |
| -------- | ------ | :------: | ----------- | ----------- |
| `{name}` | string |   Yes    | {desc}      | {rule}      |

### Responses

| Status | Description             |
| ------ | ----------------------- |
| `2xx`  | {success scenario}      |
| `400`  | Validation error        |
| `401`  | Missing/invalid auth    |
| `403`  | Insufficient permission |
| `404`  | Resource not found      |
| `409`  | Conflict                |
| `500`  | Internal error          |

Only include statuses the endpoint can actually return.

**Success `data`**

| Field       | Type     | Description        |
| ----------- | -------- | ------------------ |
| `id`        | string   | Unique identifier  |
| `status`    | string   | Domain status      |
| `createdAt` | datetime | ISO-8601 timestamp |
| `updatedAt` | datetime | ISO-8601 timestamp |

```json
{
  "data": {
    "id": "<id>",
    "status": "<domain-status>",
    "createdAt": "<ISO-8601 timestamp>",
    "updatedAt": "<ISO-8601 timestamp>"
  }
}
```

Keep the example synchronized with the field table. Use the project's standard envelope instead of `data` when one exists.
