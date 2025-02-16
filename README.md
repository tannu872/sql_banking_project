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

## 1. Basic Data Retrival
1. **Retrieve all columns from the Customer Table for customers with a credit score above 700.**
```sql
select * from Customer
where creditscore > 700;
```
2. **List all loans from the Loan Table where the loan term exceeds 100 months.**
```sql
select * from Loan
where loanterm > 100;
```

## 2. Joins and Relationships
1. **Find the branch names and total loan amounts handled by each branch by joining the Branch Table and Loan Table.**
```sql
select b.BranchName, sum(l.LoanAmount) as Total_Loan_Amount
from Branch as b
left join Loan as l
on b.branchid = l.branchid
group by b.branchname;
```
2. **Display a list of all employees from the HR Table along with the branch name where they are assigned (use the Branch Table for the branch names).**
```sql
select e.employeeid, e.name, b.BranchName 
from HR as e
left join Branch as b
on e.branchid = b.branchid;
```
3. **Retrieve the loan amount, loan date, and customer name by joining the Loan Table and Customer Table.**
```sql
select concat(c.FirstName,' ', c.LastName) as customersFullName , l.LoanAmount, l.LoanDate 
from loan as l
join customer as c
on l.customerid = c.customerid;
```

## 3. Aggregation and Grouping
1. **Calculate the total amount collected from each loan in the Collection Table.**
```sql
select LoanID, sum(AmountCollected) as Total_Amount_Collected 
from Collection
group by LoanID
order by LoanID;
```
2. **Find the average loan amount issued per branch in the Loan Table.**
```sql
select BranchID, avg(LoanAmount) as avg_Loan_Amount 
from Loan
group by BranchID;
```
3. **Determine the highest and lowest deposit amounts for each deposit type in the Deposit Table.**
```sql
select Deposittype, max(DepositAmount) as highest_Deposit_Amount, min(DepositAmount) as lowest_Deposit_Amount
from Deposit
group by DepositType;
```

## 4. Filtering and Conditional Logic
1. **List all active loans in the Loan Table with an interest rate above 10%.**
```sql
select * from Loan
where InterestRate > 10;
```
2. **Retrieve all customers who are self-employed from the Customer Table and have an annual income above 300,000.**
```sql
select * from Customer
where Occupation = 'Self-Employed' and AnnualIncome > 300000;
```

## 5. Subqueries
1. **Find customers who have an account balance in the Account Table above the average account balance of all customers.**
```sql
select * from customer
where CustomerAccountNumber in (
select Accountnumber from Account
where AccountBalance >( select avg(AccountBalance) from account));
```
2. **Retrieve all branches from the Branch Table that handle more than the average number of employees across all branches.**
```sql
select * from Branch
where totalemployees > (select avg(totalemployees) from branch);
```

## 6. Advanced Joins
1. **Find all customers who have both a loan and a deposit account, displaying their customer ID, loan ID, and deposit amount.**
```sql
select c.customerid, l.loanID, d.depositID from Customer as c
join deposit as d
on c.CustomerAccountNumber = d.accountnumber
join loan as l
on c.customerID = l.customerID;
```

## 7. Window Functions
1. **Calculate the rank of each branch based on their total assets in the Branch Table.**
```sql
select *,
rank() over(order by totalassets desc) as Rnk
from branch;
```
2. **For each customer in the Customer Table, find their percentile rank based on their annual income.**
```sql
select *,
percent_rank() over(order by annualincome) as percntrnk 
from customer;
```

## 8. String Functions
1. **Retrieve the first names of all customers from the Customer Table whose last names start with “M”.**
```sql
select firstname from customer
where lastname like 'M%';
```
2. **Extract the year from the account opening date in the Account Table and list the total accounts opened per year.**
```sql
select years, count(years) as total_accounts from
(select extract(year from opendate) as years from account)
group by years
order by years desc;
```

## 9. Date and Time Functions
1. **Find the average age of employees in the HR Table based on their dates of birth.**
```sql
select round(avg(extract(year from CURRENT_DATE )- extract(year from dob)),2) as avg_age  from Hr;
```

## 10. Data Modification and Transactions
1. **Insert a new record into the Customer Table for a hypothetical customer (practice with INSERT).**
```sql
insert into customer values (
8659, 'Dan', 'Smith', '2000-04-16', 86881527, 'Business', 800, 892658, 'Salaried');
```
2. **Update the processing fee in the Product Table for all loans with an interest rate below 8% to a new fee of 1,000.**
```sql
update products
set processingfee = 1000
where interestrate < 8;
```
3. **Delete all records from the Collection Table where the outstanding balance is zero.**
```sql
delete from collection
where outstandingbalance is null or outstandingbalance = 0;
```

## Advanced SQL Operations
1. **Complex Joins: Retrieve a list of all loan products and their corresponding departments. If a product isn’t handled by a department, include it with a NULL value for the department.**
```sql
select p.productid, p.productname, d.departmentname from products as p
left join department as d
on p.productname = any(string_to_array(d.ProductsHandled,','));
```

2. **Window Functions: For each branch, rank the top three loans in terms of LoanAmount. Display the branch name, loan ID, amount, and ranking.**
```sql
with cte as (
select b.branchid, b.branchname, l.loanid, l.loanamount, 
row_number() over(partition by b.branchid order by l.loanamount desc) as rnk
from branch as b
join loan as l
on b.branchid = l.branchid
)
select * from cte
where rnk < 4;
```

3. **Aggregation with Filtering: Calculate the total deposit amount by branch and deposit type, but include only branches with a minimum of 100 deposits.**
```sql
select branchid, deposittype, sum(depositamount) as total_deposit_amount from deposit
group by branchid, deposittype
having count(branchid)>=100
order by branchid;
```

4. **Correlated Subquery: Identify customers who have more than the average AccountBalance across all accounts in their branch.**
```sql
select * from customer as c
join account as a
on c.customeraccountnumber = a.accountnumber
where a.accountbalance > (select avg(accountbalance) from account);
```

5. **Date Calculations: Find the average time (in days) between each LoanDate and its latest collection date, for loans that have a collection recorded.**
```sql
select avg(maxcollectiondate - loandate) as average_days_in_collection from (
select l.loandate as loandate, max(c.collectiondate) as maxcollectiondate from loan as l
join collection as c
on l.loanid = c.loanid
group by l.loandate
order by l.loandate);
```

6. **Conditional Aggregates: For each loan product, calculate the total number of loans and the number of loans with a monthly repayment schedule.**
```sql
select productid,
count(case when repaymentschedule = 'Monthly' then 1 end) as monthly_schedule,
count(*) as total_loans
from loan
group by productid;
```

7. **Using CASE Statements: Write a query that categorizes customers based on CreditScore: “Excellent” (above 750), “Good” (650-750), “Average” (500-650), and “Poor” (below 500).**
```sql
select customerid, creditscore,
case
	when creditscore > 750 then 'Excellent'
	when creditscore >= 650 and creditscore <= 750 then 'Good'
	when creditscore >= 500 and creditscore < 650 then 'Average'
	else 'Poor'
end	as categories 
from customer;
```

8. **Self-Join: Identify any branches that have the same TotalEmployees and TotalAssets as another branch. Display both branch names.**
```sql
select b.* from branch as b
join branch as b1
on b.totalemployees = b1.totalemployees and b.totalassets = b1.totalassets
and b.branchname <> b1.branchname;
```

9. **Cte with Aggregates: Find the top 5 customers by AnnualIncome within each customer type. Display customer details, their type, and ranking within their type.**
```sql
with cte as (
	select customerid, firstname, lastname, dob, customeraccountnumber, customertype, annualincome,
	row_number() over(partition by customertype order by annualincome desc) as rnk
	from customer)

select * from cte
where rnk < 6;
```

10. **Analytical Functions: For each ProductType in the Loan Table, calculate the cumulative total of LoanAmount over time, ordered by LoanDate. Display the cumulative sum along with each loan’s details.**
```sql
select loanid,
productid,
loandate,
loanamount,
sum(loanamount) over(partition by productid order by loandate) as cumulative_loan_amount
from loan;
```
