# ADR-0003: Why WebSockets over Polling

## Status
Accepted

## Context
CineSync requires real-time communication in order to determine when all users 
in a session have matched on a film. This can be handled in one of two ways.

The first approach is polling, where the frontend sends regular HTTP requests 
to the server at set intervals to check if any data has changed. The downside 
is that this is wasteful — if no changes occur over a 10 second period, the 
frontend has still sent 10 HTTP requests to the server unnecessarily. At a 
small scale this is manageable, but as the user base grows the server will 
struggle to keep up. Latency is also an issue — if the poll interval is set 
to 1000ms and a user swipes at 50ms, there will be a noticeable delay before 
the update appears.

The alternative is WebSockets, which establish a single persistent two-way 
connection between the client and server when the session starts. If a change 
occurs on the server, the client is instantly notified without any unnecessary 
requests. However, WebSockets are more complex to implement than standard HTTP 
requests — specifically, when multiple server instances are running, Instance A 
has no knowledge of events on Instance B. As discussed in ADR-0002, this is 
mitigated by Redis pub/sub.

## Decision
Use WebSockets for real-time communication due to their efficiency and 
scalability, despite being more complex to implement than polling.

## Consequences
The positive consequence is that server bandwidth is not wasted on unnecessary 
HTTP requests — instead a persistent connection is maintained between client 
and server, and updates are pushed instantly. The negative consequences are 
that WebSockets are more complex to implement, particularly around multi-instance 
scaling, though this is mitigated by Redis pub/sub as noted in ADR-0002. 
Additionally, if a WebSocket connection drops mid-session the client will cease 
to receive live updates — this is handled by implementing automatic reconnection 
logic on the client side so the user experience is not disrupted.