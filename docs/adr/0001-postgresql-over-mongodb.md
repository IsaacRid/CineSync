# ADR-0001: Why PostgreSQL over MongoDB

## Status
Accepted

## Context
CineSync requires a database that can handle clearly structured, relational 
data — for example, a user belongs to many groups, and a group has many 
matches. While I considered MongoDB due to the flexible, schema-less nature 
of user preferences data (favourite genres, directors etc.) which could grow 
over time, the relational nature of the core data made PostgreSQL the stronger 
choice. PostgreSQL provides referential integrity, ensuring a group can never 
reference a non-existent user at the database level rather than relying on 
application code. It also provides ACID transactions, meaning that multi-table 
writes such as creating a match across the group, film, and match record tables 
are atomic — either all writes succeed or none are committed, maintaining data 
integrity. Finally, complex queries such as "all films matched by groups this 
user is in" are natural SQL joins in PostgreSQL, whereas MongoDB would require 
multiple queries or unwieldy aggregation pipelines.

## Decision
Use PostgreSQL due to its referential integrity, complex queries, and atomic 
writes.

## Consequences
The negative consequence of not choosing a flexible NoSQL database such as 
MongoDB is that once the schemas have been enforced, it will be trickier to 
expand upon in the future. This is mitigated through Flyway database migrations 
— if a table, relationship, or column needs to be introduced, a versioned 
migration file is written and Flyway applies the changes in order. The positive 
consequences are a structured, consistent, and production-grade database that 
can be queried in a complex manner.