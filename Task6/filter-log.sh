#!/bin/bash

INPUT_LOG="audit.log"
OUTPUT_FILE="audit-extract.json"

> "$OUTPUT_FILE"

jq 'select(.objectRef.resource=="secrets" and .verb=="get")' "$INPUT_LOG" >> "$OUTPUT_FILE"
jq 'select(.verb=="create" and .objectRef.subresource=="exec")' "$INPUT_LOG" >> "$OUTPUT_FILE"
jq 'select(.objectRef.resource=="pods" and .requestObject.spec.containers[].securityContext.privileged==true)' "$INPUT_LOG" >> "$OUTPUT_FILE"

grep -i 'audit-policy' "$INPUT_LOG" >> "$OUTPUT_FILE"