# GraphQL, WebSocket & gRPC Security

This guide outlines security considerations for modern API technologies.

## 1. GraphQL
*   **Query Depth and Complexity limits**: Failing to limit query depth or complexity, leading to Denial of Service (DoS) attacks via nested queries.
*   **Introspection**: Leaving introspection enabled in production, exposing the entire schema to attackers.
*   **Field-Level Resolvers**: Missing authorization checks on individual fields, leading to data leakage (similar to IDOR).
*   **Batching Attacks**: Exploiting GraphQL batching to perform brute-force or enumeration attacks efficiently.

## 2. WebSockets
*   **Connection Authentication**: Failing to authenticate WebSocket connections during the handshake phase.
*   **Cross-Site WebSocket Hijacking (CSWSH)**: Lack of Origin validation, allowing malicious sites to connect on behalf of the user.
*   **Unencrypted Traffic**: Using `ws://` instead of `wss://`, exposing data to man-in-the-middle attacks.
*   **Input Validation**: Failing to validate data received over the WebSocket connection.

## 3. gRPC
*   **Message Size Limits**: Missing limits on message sizes, potentially leading to DoS.
*   **Authentication/Authorization**: Implementing insecure custom authentication interceptors instead of standard mechanisms.
*   **Metadata Validation**: Failing to validate metadata (headers), similar to HTTP header injection vulnerabilities.
