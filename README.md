# Comprehensive Banking Data Analysis with Advance SQL

## Project Overview

**Level**: Intermediate

**Database**: `bankingSqlProj1`

This project involves analyzing a multifaceted banking dataset, including tables on loans, customers, deposits, branches, and HR data. The goal was to extract insights through SQL queries that simulate real-world banking analytics. Key aspects include calculating loan totals, identifying customer profiles, analyzing branch performance, and generating insights on deposits and collections.

![bankingimg](https://github.com/tannu872/sql_banking_project/blob/c02c34f149f106faf4bd27cc02da9a4f2b729f53/image1.jpg)

## Objectives

1. **Data Retrieval**: Querying customer and loan information to assess customer creditworthiness and loan distribution.
2. **Data Aggregation**: Summing deposits, averaging loan amounts, and analyzing collection data.
3. **Data Joining**: Linking tables to derive insights acrosss departments (e.g., associating branches with employees and customers).
4. **Data Manipulation**: Practiced INSERT, UPDATE, and DELETE statements, simulating the management of banking records.
5. **Advanced SQL**: Using subqueries, window functions, and complex joins to uncover detailed insights like average balances and branch rankings.

## Project Structure

### Database Setup
![erdimg](https://github.com/tannu872/sql_banking_project/blob/24325454c757029464f450527df4dbc0d406ded4/erdupdated.png)
1. **Tables**: Product Table, Department Table, Loan Table, HR Table, Branch Table, Customer Table, Collection Table, Deposit Table, Account Table and Business Persons Table. Each table includes relevant columns and relationships.
2. **Data Modeling**:
```sql
----Loan Table----

Alter table Loan
Add Constraint fk_Product
Foreign Key (ProductID)
References Products(ProductID);

Alter table Loan
Add Constraint fk_Employee
Foreign Key (EmployeeID)
References HR(EmployeeID);

Alter table Loan
Add Constraint fk_Branch
Foreign Key (BranchID)
References Branch(BranchID);

Alter table Loan
Add Constraint fk_Customer
Foreign Key (CustomerID)
References Customer(CustomerID);


----HR Table----

Alter table HR
Add Constraint fk_Branch
Foreign Key (BranchID)
References Branch(BranchID);


----Collection table----

Alter table Collection
Add Constraint fk_Loan
Foreign Key (LoanID)
References Loan(LoanID);


----Deposit table----

Alter table Deposit
Add Constraint fk_Branch
Foreign Key (BranchID)
References Branch(BranchID);


----Account table----

Alter table Account
Add Constraint fk_Branch
Foreign Key (BranchID)
References Branch(BranchID);
```
