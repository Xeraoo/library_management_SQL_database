## Overview

This project demonstrates the structure and functionalities of a PostgreSQL-based library management system. The database manages books, users, and orders with built-in triggers and constraints to enforce data integrity and business logic. The system handles book availability, user borrowing limits, and updates through the use of SQL functions and triggers.

## Features

- **Tables**: 
  - `books`: Stores information about books, their availability, and loan duration.
  - `users`: Contains user details, including borrowing limits.
  - `orders`: Manages borrowing transactions with details such as reservation status, prolongation, and return dates.

- **Triggers**: 
  - Automated updates of user borrow limits and book availability.
  - Prevents users from borrowing more than 10 books or prolonging loans multiple times.
  - Ensures data consistency when orders are inserted, updated, or deleted.

- **Functions**:
  - `check_before_order_insert()`: Validates book availability and user borrow limits before inserting a new order.
  - `check_before_order_update()`: Ensures a book cannot be prolonged more than once.
  - `update_after_order_insert()`: Updates book availability and user borrow count after an order is inserted.
  - `update_after_order_delete()`: Updates availability and user counts when an order is deleted.

## Key SQL Components

- **Constraints**:
  - Primary keys on `books`, `users`, and `orders`.
  - Unique constraints to ensure a user cannot borrow the same book twice.
  - Foreign key relationships between `orders` and `books`, `users`.

- **Triggers**: 
  - Trigger functions enforce business rules, such as limiting user borrow quantities and maintaining accurate book availability.
 
## Example Data

The database includes pre-loaded data:

- **Books**: Classic titles such as *Pan Tadeusz*, *Sherlock Holmes*, and more.
- **Users**: Pre-defined users with unique IDs and borrowing limits.
- **Orders**: Sample orders to illustrate book borrowing and return processes.
