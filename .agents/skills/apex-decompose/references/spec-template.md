# Feature: {Feature Name}

## Overview
One paragraph describing what this feature does from the user's perspective.

## Source Files
- `path/to/file1.ts` — Role in the feature
- `path/to/file2.ts` — Role in the feature

## Behavior Contract

### Inputs
| Name | Type | Source | Required | Description |
|------|------|--------|----------|-------------|
| param1 | string | request.body | yes | Description |

### Outputs
| Name | Type | Destination | Description |
|------|------|-------------|-------------|
| result | object | response.json | Description |

### Side Effects
1. Writes to `table_name` in database when condition X
2. Emits event `event_name` on success
3. Calls `external-service/endpoint` with payload Y

## Edge Cases
1. **When input is empty** — Returns 400 with message "..."
2. **When service is down** — Retries 3 times, then falls back to cached value
3. **When concurrent requests** — Uses optimistic locking on field Z

## Dependencies
| Dependency | Type | Version | Purpose |
|-----------|------|---------|---------|
| package-x | npm | ^2.0.0 | Used for Y |
| service-z | API | v3 | Called during Z |

## Configuration
| Key | Default | Description |
|-----|---------|-------------|
| FEATURE_FLAG_X | false | Enables experimental behavior |
| TIMEOUT_MS | 5000 | Request timeout |

## Migration Notes
- [VERIFY] Confirm whether the retry logic is still needed in the new architecture
- The hardcoded value `42` on line 87 of file.ts is the max batch size from a 2023 incident
- Order of operations in `processQueue()` is critical — step 2 must complete before step 3
