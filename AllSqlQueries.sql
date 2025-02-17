--  **** 1. Basic Data Retrival *****

-- (a) :- Retrieve all columns from the Customer Table for customers with a credit score above 700.

select * from Customer
where creditscore > 700


-- (b) :- List all loans from the Loan Table where the loan term exceeds 100 months.

select * from Loan
where loanterm > 100




-- **** 2. Joins and Relationships *****

-- (a) :- Find the branch names and total loan amounts handled by each branch by joining the Branch Table and Loan Table.

select b.BranchName, sum(l.LoanAmount) as Total_Loan_Amount
from Branch as b
left join Loan as l
on b.branchid = l.branchid
group by b.branchname


-- (b) :- Display a list of all employees from the HR Table along with the branch name where they are assigned (use the Branch Table for the branch names).

select e.employeeid, e.name, b.BranchName 
from HR as e
left join Branch as b
on e.branchid = b.branchid


-- (c) :- Retrieve the loan amount, loan date, and customer name by joining the Loan Table and Customer Table.

select concat(c.FirstName,' ', c.LastName) as customersFullName , l.LoanAmount, l.LoanDate 
from loan as l
join customer as c
on l.customerid = c.customerid





-- **** 3. Aggregation and Grouping *****

-- (a) :- Calculate the total amount collected from each loan in the Collection Table.

select LoanID, sum(AmountCollected) as Total_Amount_Collected 
from Collection
group by LoanID
order by LoanID



-- (b) :- Find the average loan amount issued per branch in the Loan Table.

select BranchID, avg(LoanAmount) as avg_Loan_Amount 
from Loan
group by BranchID



-- (c) :- Determine the highest and lowest deposit amounts for each deposit type in the Deposit Table.

select Deposittype, max(DepositAmount) as highest_Deposit_Amount, min(DepositAmount) as lowest_Deposit_Amount
from Deposit
group by DepositType





-- **** 4. Filtering and Conditional Logic *****

-- (a) :- List all active loans in the Loan Table with an interest rate above 10%.

select * from Loan
where InterestRate > 10



-- (b) :- Retrieve all customers who are self-employed from the Customer Table and have an annual income above 300,000.

select * from Customer
where Occupation = 'Self-Employed' and AnnualIncome > 300000





-- **** 5. Subqueries *****


-- (a) :- Find customers who have an account balance in the Account Table above the average account balance of all customers.

select * from customer
where CustomerAccountNumber in (
select Accountnumber from Account
where AccountBalance >( select avg(AccountBalance) from account))



-- (b) :- Retrieve all branches from the Branch Table that handle more than the average number of employees across all branches.

select * from Branch
where totalemployees > (select avg(totalemployees) from branch)





-- **** 6. Advanced Joins *****

-- (a) :- Find all customers who have both a loan and a deposit account, displaying their customer ID, loan ID, and deposit amount.

select c.customerid, l.loanID, d.depositID from Customer as c
join deposit as d
on c.CustomerAccountNumber = d.accountnumber
join loan as l
on c.customerID = l.customerID




-- **** 7. Window Functions *****

-- (a) :- Calculate the rank of each branch based on their total assets in the Branch Table.

select *,
rank() over(order by totalassets desc) as Rnk
from branch




--(b) :- For each customer in the Customer Table, find their percentile rank based on their annual income.

select *,
percent_rank() over(order by annualincome) as percntrnk 
from customer





-- **** 8. String Functions *****

-- (a) :- Retrieve the first names of all customers from the Customer Table whose last names start with “M”.

select firstname from customer
where lastname like 'M%'



-- (b) :- Extract the year from the account opening date in the Account Table and list the total accounts opened per year.

select years, count(years) as total_accounts from
(select extract(year from opendate) as years from account)
group by years
order by years desc




-- **** 9. Date and Time Functions *****

-- (a) :- Find the average age of employees in the HR Table based on their dates of birth.

select round(avg(extract(year from CURRENT_DATE )- extract(year from dob)),2) as avg_age  from Hr





-- **** 10. Data Modification and Transactions *****


-- (a) :- Insert a new record into the Customer Table for a hypothetical customer (practice with INSERT).

insert into customer values (
8659, 'Dan', 'Smith', '2000-04-16', 86881527, 'Business', 800, 892658, 'Salaried'
)



-- (b) :- Update the processing fee in the Product Table for all loans with an interest rate below 8% to a new fee of 1,000.

update products
set processingfee = 1000
where interestrate < 8



-- (c) :- Delete all records from the Collection Table where the outstanding balance is zero.

delete from collection
where outstandingbalance is null or outstandingbalance = 0








-- advance questions ********************************************************************


-- 1.	Complex Joins: Retrieve a list of all loan products and their corresponding departments. If a product isn’t handled by a department, include it with a NULL value for the department.


select p.productid, p.productname, d.departmentname from products as p
left join department as d
on p.productname = any(string_to_array(d.ProductsHandled,','))




-- 	2.	Window Functions: For each branch, rank the top three loans in terms of LoanAmount. Display the branch name, loan ID, amount, and ranking.

with cte as (
select b.branchid, b.branchname, l.loanid, l.loanamount, 
row_number() over(partition by b.branchid order by l.loanamount desc) as rnk
from branch as b
join loan as l
on b.branchid = l.branchid
)
select * from cte
where rnk < 4




-- 	3.	Aggregation with Filtering: Calculate the total deposit amount by branch and deposit type, but include only branches with a minimum of 100 deposits.

select branchid, deposittype, sum(depositamount) as total_deposit_amount from deposit
group by branchid, deposittype
having count(branchid)>=100
order by branchid




--	4.	Correlated Subquery: Identify customers who have more than the average AccountBalance across all accounts in their branch.

select * from customer as c
join account as a
on c.customeraccountnumber = a.accountnumber
where a.accountbalance > (select avg(accountbalance) from account)





--	5.	Date Calculations: Find the average time (in days) between each LoanDate and its latest collection date, for loans that have a collection recorded.

select avg(maxcollectiondate - loandate) as average_days_in_collection from (
select l.loandate as loandate, max(c.collectiondate) as maxcollectiondate from loan as l
join collection as c
on l.loanid = c.loanid
group by l.loandate
order by l.loandate)





--	6.	Conditional Aggregates: For each loan product, calculate the total number of loans and the number of loans with a monthly repayment schedule.

select productid,
count(case when repaymentschedule = 'Monthly' then 1 end) as monthly_schedule,
count(*) as total_loans
from loan
group by productid




--	7.	Using CASE Statements: Write a query that categorizes customers based on CreditScore: “Excellent” (above 750), “Good” (650-750), “Average” (500-650), and “Poor” (below 500).

select customerid, creditscore,
case
	when creditscore > 750 then 'Excellent'
	when creditscore >= 650 and creditscore <= 750 then 'Good'
	when creditscore >= 500 and creditscore < 650 then 'Average'
	else 'Poor'
end	as categories 
from customer





--	8.	Self-Join: Identify any branches that have the same TotalEmployees and TotalAssets as another branch. Display both branch names.

select b.* from branch as b
join branch as b1
on b.totalemployees = b1.totalemployees and b.totalassets = b1.totalassets
and b.branchname <> b1.branchname





--	9.	Nested Subqueries with Aggregates: Find the top 5 customers by AnnualIncome within each customer type. Display customer details, their type, and ranking within their type.

with cte as (
	select customerid, firstname, lastname, dob, customeraccountnumber, customertype, annualincome,
	row_number() over(partition by customertype order by annualincome desc) as rnk
	from customer)

select * from cte
where rnk < 6





--	10.	Analytical Functions: For each ProductType in the Loan Table, calculate the cumulative total of LoanAmount over time, ordered by LoanDate. Display the cumulative sum along with each loan’s details.

select loanid,
productid,
loandate,
loanamount,
sum(loanamount) over(partition by productid order by loandate) as cumulative_loan_amount
from loan




-- ****************** done ************************
