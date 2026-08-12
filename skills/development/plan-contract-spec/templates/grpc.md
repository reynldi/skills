<!-- Use the project's discovered proto conventions (packages, naming, metadata) in place of these defaults. Remove any subsection that does not apply. -->

# {RPC Name}

**Lifecycle**: ACTIVE
**Owner**: {owner}
**Next consumer**: {stage / person}
**Review trigger**: {contract or implementation change}

## `{ServiceName}.{MethodName}`

- **Contract**: New / Modified / Existing
- **RPC Type**: Unary / Server Streaming / Client Streaming / Bidirectional Streaming
- **Auth**: {required/optional + who}
- **Idempotency**: {Yes/No — request ID/key strategy}
- **Version**: {e.g. `v1`}
- **Technical Spec**: {path/section}

### Request

**Metadata**

| Key               | Required | Description                    |
| ----------------- | :------: | ------------------------------ |
| `authorization`   |   Yes    | `Bearer <token>`               |
| `idempotency-key` |    No    | Client-generated UUID          |
| `request-id`      |    No    | Request correlation identifier |

**Message**: `{RequestMessage}`

| Field    | Type   | Required | Description | Constraints |
| -------- | ------ | :------: | ----------- | ----------- |
| `{name}` | string |   Yes    | {desc}      | {rule}      |

```proto
message {RequestMessage} {
  string name = 1;
}
```

### Response

**Message**: `{ResponseMessage}`

| Field        | Type                      | Description           |
| ------------ | ------------------------- | --------------------- |
| `id`         | string                    | Unique identifier     |
| `status`     | string                    | Domain status         |
| `created_at` | google.protobuf.Timestamp | Creation timestamp    |
| `updated_at` | google.protobuf.Timestamp | Last update timestamp |

```proto
message {ResponseMessage} {
  string id = 1;
  string status = 2;
  google.protobuf.Timestamp created_at = 3;
  google.protobuf.Timestamp updated_at = 4;
}
```

### Errors

| gRPC Code           | Description                       |
| ------------------- | --------------------------------- |
| `INVALID_ARGUMENT`  | Validation error                  |
| `UNAUTHENTICATED`   | Missing or invalid authentication |
| `PERMISSION_DENIED` | Insufficient permission           |
| `NOT_FOUND`         | Resource not found                |
| `ALREADY_EXISTS`    | Resource already exists           |
| `ABORTED`           | Conflict or concurrent operation  |
| `INTERNAL`          | Internal server error             |
| `UNAVAILABLE`       | Service temporarily unavailable   |

Only include errors relevant to the RPC. Never reuse removed field numbers.

```proto
service {ServiceName} {
  rpc {MethodName}({RequestMessage}) returns ({ResponseMessage});
}
```
