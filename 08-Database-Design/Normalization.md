# Normalization

> Part of **Complete SQL Notes** (`08-Database-Design`). [Back to roadmap](../README.md).

Normalization (Overview)
## Definition
Organize tables to remove redundancy and anomalies, keeping lossless joins. More normal = less duplication, more joins.
## Why
One flat register repeats dept/HOD per student; update HOD in 1 place after split.
3. Syntax (idea, not command)
1NF atomic -> 2NF no partial -> 3NF no transitive -> BCNF determinant=superkey.
## Explained
Anomalies: insert (can't add dept without student), update (HOD in 3 rows), delete (lose dept). Lossless: join back exactly. Dependency: A->B if A decides B.
5. Examples (flat vs split)
Bad flat: (Abhishek,CS,Dr.Ramesh,DBMS,88) repeats CS/HOD per enrollment (8 rows, HOD x3 for DBMS).
Good: departments(3)+students(5)+courses(5)+enrollments(8)+marks(8). HOD once.
Counts prove: flat 8 HOD copies vs 3 rows.
## Changes
Split tables, same facts, fewer copies.
## Steps
Spot repeats, find FDs, split, set PK/FK, rejoin test.
## Mistakes
1 Every attr own table (over-split, slow). 2 Lossy split (no common key). 3 Normalizing reports needlessly. 4 Ignoring FDs. 5 Denormalize nothing ever (sometimes ok for read speed).
## Exam
Define each NF; anomaly types; lossless condition; FD notation.
10. Practice 5Q
Q1 Anomaly if HOD changes? A update 2 rows CS. Q2 Insert dept no student? A blocked flat, allowed split. Q3 Delete last CS student? A loses dept flat. Q4 Lossless key? A dept_id join. Q5 Over-normalize? A bad (too many joins).
## Revision
Split repeats, keep keys, join back exactly.
