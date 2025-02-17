-- *******************  DATA MODELING  ******************


--  Loan Table:-

Alter table Loan
Add Constraint fk_Product
Foreign Key (ProductID)
References Products(ProductID)


Alter table Loan
Add Constraint fk_Employee
Foreign Key (EmployeeID)
References HR(EmployeeID)


Alter table Loan
Add Constraint fk_Branch
Foreign Key (BranchID)
References Branch(BranchID)


Alter table Loan
Add Constraint fk_Customer
Foreign Key (CustomerID)
References Customer(CustomerID)



--  HR Table:-

Alter table HR
Add Constraint fk_Branch
Foreign Key (BranchID)
References Branch(BranchID)




-- Collection table:-

Alter table Collection
Add Constraint fk_Loan
Foreign Key (LoanID)
References Loan(LoanID)



-- Deposit table:-

Alter table Deposit
Add Constraint fk_Branch
Foreign Key (BranchID)
References Branch(BranchID)



-- Account table

Alter table Account
Add Constraint fk_Branch
Foreign Key (BranchID)
References Branch(BranchID)




-- Business Persons table

Alter table BusinessPerson
Add Constraint fk_Branch
Foreign Key (BranchHandled)
References Branch(BranchID)

