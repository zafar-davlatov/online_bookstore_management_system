# Online Bookstore Management System

A fully normalised (3NF) physical database for an online bookstore, built with **PostgreSQL 14+**. The project demonstrates schema design, constraint application, many-to-many relationships, generated columns, and idempotent scripting practices.

---

## Repository Structure

| File | Purpose |
|---|---|
| `01_create_schema.sql` | Creates the `bookstore` schema and sets the search path |
| `02_create_tables.sql` | DDL — defines all 10 tables with primary keys, foreign keys, and constraints |
| `03_insert_data.sql` | DML — populates all tables using natural-key JOINs (no hardcoded surrogate IDs) |
| `04_alter_tables.sql` | Adds `record_ts DATE NOT NULL DEFAULT CURRENT_DATE` to every table post-creation |
| `05_verification.sql` | Confirms `record_ts` is populated in every row across all 10 tables |

All scripts are **idempotent** — safe to run multiple times without creating duplicates or errors.

---

## Database Overview

**Schema:** `bookstore`  
**Dialect:** PostgreSQL 14+  
**Normal Form:** 3NF

### Tables

| Table | Rows | Description |
|---|---|---|
| `publishers` | 6 | Book publishing companies |
| `authors` | 8 | Author biographical details |
| `genres` | 7 | Genre classification labels |
| `books` | 8 | Central book catalogue (price, format, stock) |
| `book_authors` | 8 | M2M junction — books ↔ authors |
| `book_genres` | 14 | M2M junction — books ↔ genres |
| `customers` | 6 | Registered users |
| `orders` | 6 | Purchase transactions |
| `order_items` | 8 | Line items with auto-computed subtotal |
| `reviews` | 6 | Star ratings and comments |

### Many-to-Many Relationships

- **books ↔ authors** via `book_authors`
- **books ↔ genres** via `book_genres` (books can belong to multiple genres)

### Notable Features

- `order_items.subtotal` is a **GENERATED ALWAYS AS** column (`quantity * unit_price`) — computed and maintained automatically by PostgreSQL
- All `INSERT` statements resolve foreign keys via **JOIN on natural keys** (e.g. ISBN, email, publisher name) instead of hardcoded IDs
- Conflict handling uses `ON CONFLICT … DO NOTHING` and `WHERE NOT EXISTS` throughout

---

## Constraint Types

Five constraint categories are applied across all tables, annotated in the SQL comments as `C1`–`C5`:

| Code | Rule | Example |
|---|---|---|
| C1 | Date must be > 2000-01-01 | `publication_date`, `order_date`, `review_date` |
| C2 | Numeric value cannot be negative | `price`, `stock_quantity`, `quantity`, `unit_price` |
| C3 | Value must belong to a fixed set | `books.format`, `orders.status`, `authors.gender` |
| C4 | UNIQUE on natural keys | `isbn`, `email`, `publisher name`, `(customer_id, book_id)` |
| C5 | NOT NULL on all mandatory attributes | Applied to every required column in all 10 tables |

---

## Requirements

- PostgreSQL 14 or higher
- A database user with `CREATE SCHEMA` and `CREATE TABLE` privileges
