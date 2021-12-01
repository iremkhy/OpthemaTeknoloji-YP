--Marital Status
create table dbo.MaritalStatus
(
MaritalStatusID int primary key identity(1,1),
MaritalStatus varchar(20) unique not null,
)

--Customer
create table dbo.Customer
(
CustomerID int primary key identity(1,1),
FirstName nvarchar(255) not null,
MiddleName nvarchar(255),
LastName nvarchar(255) not null,
Birthday date not null,
Sex tinyint not null,
ModifiedDate datetime2 default getdate(),
constraint CHK_TextNoSpaceOnly check(len(FirstName)>0 and len(LastName)>0),
constraint CHK_SexISO check(Sex in (0,1,2,9)),
constraint CHK_Age check(year(birthday)<year(getdate()) and year(birthday)>1900)
)
alter table dbo.Customer
add MaritalStatusID int constraint FK_MaritalStatusCustomer foreign key references dbo.MaritalStatus(MaritalStatusID)


--Phone Number Type
create table dbo.PhoneNumberType  -- LOOKUP Table
(
PhoneNumberTypeID tinyint primary key identity(1,1),
Name varchar(20) unique not null,
ModifiedDate datetime2 default getdate()
)

--Customer Phone
create table dbo.CustomerPhone
(
CustomerID int constraint FK_CustomervPhone foreign key references dbo.Customer(CustomerID),
PhoneNumber varchar(10) not null,
PhoneNumberTypeID tinyint references dbo.PhoneNumberType(PhoneNumberTypeID),
ModifiedDate datetime2 default getdate(),
constraint CHK_PhoneNumberValidity check(PhoneNumber like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
unique(CustomerID,PhoneNumber)
)

--Customer Email Address
create table dbo.CustomerEmailAddress
(
CustomerID int constraint FK_CustomervEmailAddress foreign key references dbo.Customer(CustomerID),
EmailAddressID int primary key identity(1,1),
EmailAddress nvarchar(320) unique not null,
ModifiedDate datetime2 default getdate(),
constraint CHK_EmailValidity check(EmailAddress like '%_@__%.__%'),
)
alter table dbo.CustomerAddress
add ResidentialStatusID int constraint FK_ResidentialStatusCustomerAddress foreign key references dbo.ResidentialStatus(ResidentialStatusID)

--Province
create table dbo.Province
(
ProvinceID tinyint primary key identity(1,1),
ProvinceName nvarchar(100) unique not null,
Population int not null,
ModifiedDate datetime2 default getdate(),
constraint CHK_ProvinceNameNoSpaceOnly check(len(ProvinceName)>0),
)

--City
create table dbo.City
(
CityID tinyint primary key identity(1,1),
CityName nvarchar(100) unique not null,
ProvinceID tinyint constraint FK_CityvProvince foreign key references dbo.Province(ProvinceID) not null,
ModifiedDate datetime2 default getdate(),
constraint CHK_CityNameNoSpaceOnly check(len(CityName)>0)
)

--Address
create table dbo.Address
(
AddressID int primary key identity(1,1),
AddressName nvarchar(100) not null,
CityID tinyint constraint AddressvCity foreign key references dbo.City(CityID),
ProvinceID tinyint constraint AddressvProvince foreign key references dbo.Province(ProvinceID),
PostalCode int not null,
ModifiedDate datetime2 default getdate(),
constraint CHK_AddressNameNoSpaceOnly check(len(AddressName)>0),
constraint CHK_PostalCode check(PostalCode>=10000 and PostalCode<=99999)
)

--Residantal Status
create table dbo.ResidentialStatus
(
ResidentialStatusID smallint primary key identity(1,1),
ResidentialStatus varchar(20) unique not null,
)

--Customer Address
create table dbo.CustomerAddress
(
CustomerID int constraint FK_CustomerAddress foreign key references dbo.Customer(CustomerID),
AddressID int constraint FK_AddressCustomer foreign key references dbo.Address(AddressID),
unique(CustomerID,AddressID)
)

--Banks
create table dbo.Bank
(
BankID tinyint primary key identity(1,1),
Name varchar(30) unique not null,
constraint CHK_BankNameNoSpaceOnly check(len(Name)>0)
)

--Branches
create table dbo.Branches
(
BranchID int primary key identity(1,1),
BranchName nvarchar(50) not null,
CityID tinyint constraint FK_BranchCity foreign key references dbo.City(CityID) not null,
BankID tinyint constraint FK_BranchBank foreign key references dbo.Bank(BankID) not null
)

--Account Type
create table dbo.AccountType
(
AccountTypeID smallint primary key identity(1,1),
AccountTypeName nvarchar(50) unique not null,
)

--Account Status Type
create table dbo.AccountStatusType
(
AccountStatusTypeID bit primary key,
AccountStatusTypeName nvarchar(20) unique not null,
)

--Account
create table dbo.Account
(
AccountID int primary key identity(1,1),
OpeningDate datetime2 default getdate(),
AccountTypeID smallint constraint FK_AccountAccountType foreign key references dbo.AccountType(AccountTypeID),
AccountStatusTypeID bit default 1 constraint FK_AccountAccountStatusType foreign key references dbo.AccountStatusType(AccountStatusTypeID),
AccountNumber varchar(16) unique not null,
Balance decimal default 0 not null,
constraint CHK_AccountNumberLength check(len(AccountNumber)=16)
)
alter table dbo.Account
add OverDraftEligibility tinyint
constraint FK_OverdraftValue check(overdrafteligibility=0 or overdrafteligibility=1)
 
alter table dbo.Account
add constraint CHK_BalanceValidity check((overdrafteligibility=1 and balance>=-100) or (overdrafteligibility=0 and balance>=0))
alter table dbo.Account
add SavingsInterestRateID tinyint constraint FK_AccountvSavingsInterest foreign key references SavingsInterestRates(SavingsInterestRateID)
 
alter table dbo.Account
add constraint CHK_SavingsInterestValidity check((AccounttypeId=2 and SavingsInterestrateId is not null)or(AccounttypeId!=2 and SavingsInterestrateId is null))
 
alter table dbo.Account
add BranchID int constraint FK_BranchvAccount foreign key references dbo.Branches(BranchID)

--Customer Account
create table dbo.CustomerAccount
(
CustomerID int constraint FK_CustomerAccount foreign key references dbo.Customer(CustomerID),
AccountID int constraint FK_AccountCustomer foreign key references dbo.Account(AccountID),
unique(CustomerID,AccountID)
)

--Transaction Type
create table dbo.TransactionType
(
TransactionTypeID smallint primary key identity(1,1),
TransactionType varchar(20),
)

--Transaction Sub Type
create table dbo.TransactionSubType
(
TransactionSubTypeID int primary key identity(1,1),
TransactionTypeID smallint foreign key references dbo.TransactionType(TransactionTypeID),
TransactionName varchar(50),
)

--Transaction
create table dbo.TransactionLog
(
TransactionLogID bigint primary key identity(1,1),
TransactionSubTypeID int foreign key references dbo.TransactionSubType(TransactionSubTypeID),
TransactionDate datetime2 default getdate(),
SenderCustomerID int foreign key references dbo.Customer(CustomerID),
AccountNumber varchar(16) foreign key references dbo.Account(AccountNumber),
Debit decimal(9,2),
Credit decimal(9,2),
ReceiverAccountNumber varchar(16) foreign key references dbo.Account(AccountNumber),
constraint CHK_CreditValidity check((Credit>0 and debit=0) or (credit=0 and debit>0))
)

--Savings Interest Rates
create table dbo.SavingsInterestRates
(
SavingsInterestRateID tinyint primary key identity(1,1),
SavingsInterestRateValue decimal(5,3) unique not null
)

--Position
create table dbo.Position
(
PositionID int primary key identity(1,1),
PositionName varchar(50) unique not null,
MinSalary int not null,
MaxSalary int not null
)

--Department
create table dbo.Department
(
DepartmentID smallint primary key identity(1,1),
DepartmentName varchar(50) unique not null,
)

--BranchDepartment
create table dbo.BranchDepartment
(
BranchID int constraint FK_BranchDepartment foreign key references dbo.Branches(BranchID),
DepartmentID smallint constraint FK_DepartmentBranch foreign key references dbo.Department(DepartmentID),
unique(BranchID,DepartmentID)
)

--Employee
create table dbo.Employee
(
EmployeeID int primary key identity(1,1),
FirstName varchar(50) not null,
MiddleName varchar(50),
Lastname varchar(50) not null,
PositionID int FOREIGN KEY REFERENCES dbo.Position(PositionID) not null,
DepartmentID smallint FOREIGN KEY REFERENCES dbo.Department(DepartmentID) not null,
PhoneNumber varchar(10) not null,
PhoneNumberTypeID tinyint REFERENCES dbo.PhoneNumberType(PhoneNumberTypeID),
EmailAddress nvarchar(320) unique not null,
StartDate date,
Salary decimal
)
alter table dbo.Employee
add BranchID int constraint FK_EmployeevBranch foreign key references dbo.Branches(BranchID)

--Occupation
create table dbo.Occupation
(
OccupationID int primary key identity(1,1),
OccupationType varchar(30) unique not null,)

--Customer - Employment
create table dbo.CustomerEmployment
(
CustomerID int constraint FK_CustomerEmployment foreign key references dbo.Customer(CustomerID) unique not null,
OccupationID int constraint FK_OccupationEmployment foreign key references dbo.Occupation(OccupationID) not null,
CurrentJobStartingDate date not null,
GrossAnnualIncome int not null,
)

--User Login Details
create table dbo.UserLoginDetails
(
UserID int primary key identity(1,1),
UserName varchar(15) not null,
Password varchar(10) not null,
ModifiedDate datetime2 default getdate(),
constraint CHK_UsernamePasswordValidity check(len(username)>=6 and len(password)>=8),
)

--User Login
create table dbo.AccountUserLogin
(
AccountID int constraint FK_AccountUserLogin foreign key references dbo.Account(AccountID) not null,
UserID int constraint FK_UserLoginAccount foreign key references dbo.UserLoginDetails(UserID) not null,
)

--User Security Questions
create table dbo.UserSecurityQuestions
(
UserSecurityQuestionID int primary key identity(1,1),
UserSecurityQuestion nvarchar(50) unique not null
)

-- User Security Answers
create table dbo.UserSecurityAnswers
(
UserID int constraint FK_SecurityAnswer foreign key references dbo.UserLoginDetails(UserID) unique,
UserSecurityAnswer nvarchar(50) not null,
UserSecurityQuestionID int constraint FK_SecurityAnswervQuestion foreign key references dbo.UserSecurityQuestions(UserSecurityQuestionID) not null
)

--Loan Type
create table dbo.LoanType
(
LoanTypeID smallint primary key identity(1,1),
Name varchar(30) not null
)
 
--Loan
create table dbo.Loans
(
LoanID int primary key identity(1,1),
AccountID int constraint FK_AccountvLoan References dbo.Account(AccountID) not null,
LoanTypeID smallint constraint FK_LoanTypevLoan References dbo.LoanType(LoanTypeID) not null,
BranchID int constraint FK_BranchLoan References dbo.Branches(BranchID) not null,
Amount decimal not null,
InterestRate decimal not null,
StartDate date not null,
DueDate date not null
)

--Loan Payment History
create table dbo.LoanPaymentHistory
(
LoanPaymentID int primary key identity(1,1),
LoanID int constraint FK_PaymentvCredit References dbo.Loans(LoanID) not null,
PaymentDate date,
Amount decimal
)

--Card Type
create table dbo.CardType
(
TypeID smallint primary key identity(1,1),
Name varchar(30) not null
)

--Card Info
create table dbo.CardInfo
(
CardID int primary key identity(1,1),
CustomerID int constraint FK_CustomervCard REFERENCES dbo.Customer(CustomerID) not null,
AccountID int constraint FK_AccountvCard REFERENCES dbo.Account(AccountID) not null,
CardTypeID smallint constraint FK_CardTypevCard REFERENCES dbo.CardType(TypeID) not null,
CardNo varchar(16) unique not null,
CardSecurityCode smallint not null,
IssueDate date not null,
ExpDate date not null,
unique(CustomerID,AccountID),
constraint CHK_CSCValidity check(CardSecurityCode like '[0-9][0-9][0-9]' or CardSecurityCode like '[0-9][0-9][0-9][0-9]'),
constraint CHK_CardNoValidity check(len(CardNo)=16)
)

