# ADR-0005: Why REST over GraphQL

## Status
Accepted

## Context
When deciding on the API design two options were considered: REST and GraphQL. 
REST is where a set of URLs (endpoints) represent resources, accessed through 
standard HTTP methods. Each endpoint returns a fixed shape of data and is 
simple to implement and debug.

GraphQL takes a different approach — a single endpoint accepts queries where 
the client specifies exactly what data it wants. This solves two common 
problems: overfetching (receiving more data than needed) and underfetching 
(having to make multiple requests to get everything needed). However, GraphQL 
adds significant complexity in implementation and is most valuable when data 
requirements are highly variable or nested.

CineSync's data requirements are well defined and straightforward — the 
endpoints will return simple, predictable data sets, making it unlikely to 
encounter meaningful overfetching or underfetching. GraphQL would be overkill 
for a project of this scale.

## Decision
Use REST due to its simplicity, wide adoption in industry, and because 
GraphQL's flexibility would be unnecessary given CineSync's straightforward 
data requirements.

## Consequences
The positive consequences are that REST is simple to set up, easy to debug, 
and widely understood in industry. The negative consequence is that there is 
a theoretical risk of overfetching or underfetching data — however given 
CineSync's simple and well defined data requirements, this is unlikely to 
be a practical issue.