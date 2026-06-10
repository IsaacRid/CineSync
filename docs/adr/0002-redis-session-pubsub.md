# ADR-0002: Why Redis for Session Management and Pub/Sub

## Status
Accepted

## Context
One type of data that CineSync needs to store is session state — specifically 
who is in the group session, what films have been swiped, and current matches. 
Storing this in PostgreSQL, while possible, would be slow and wasteful due to 
how frequently session data changes, resulting in a high volume of reads and 
writes against a disk-based database. Redis solves this by storing data in 
memory rather than on disk, making reads and writes extremely fast. Redis also 
provides a publish/subscribe system — when a user swipes on a film, the backend 
can publish a swipe event and any other user connected to the session will 
receive it instantly. This is what enables the real-time matching system.

## Decision
Use Redis to store session state for its fast in-memory read and write speeds, 
and to power real-time updates via its pub/sub system.

## Consequences
The positive consequence of using Redis is that session data can be accessed 
far more quickly than if it were stored in PostgreSQL, due to data being held 
in memory rather than on disk. The negative consequence is that memory is 
volatile — if the server restarts, all active session data will be lost. This 
is an accepted trade-off for this project given the ephemeral nature of 
sessions; it is not a significant inconvenience for users to simply start a 
new session.