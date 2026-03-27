USE MYSQL;
CREATE DATABASE IF NOT EXISTS BANKSHI;
CREATE TABLE Branch(Branch_name varchar(30), Branch_city varchar(25), assets int, PRIMARY KEY(Branch_name));
CREATE TABLE bankAccount(Accno int, branch_name varchar (30), balance int, PRIMARY KEY(Accno), foreign key (Branch_name) references Branch(Branch_name));
CREATE TABLE bankCustomer(Customer_name varchar(20), Customer_street varchar(30), CustomerCity varchar(35), PRIMARY KEY(Customer_name));
CREATE TABLE DEPOSITER(Customer_name varchar(20), Accno int, FOREIGN KEY(Customer_name) references bankCustomer(Customer_name), FOREIGN KEY(Accno) references bankAccount(Accno));
CREATE TABLE LOAN(Loan_number int, Branch_name varchar(30),Amount int,PRIMARY KEY(Loan_number),foreign key(Branch_name) references Branch(Branch_name));

INSERT INTO Branch VALUES("SBI_Chamrajpet","Bangalore",50000);
INSERT INTO Branch VALUES("SBI_ResidencyRoad","Bangalore",10000);
INSERT INTO Branch VALUES("SBI_ShivajiRoad","Bombay",20000);
INSERT INTO Branch VALUES("SBI_ParliamentRoad","Delhi",10000);
INSERT INTO Branch VALUES("SBI_Jantarmantar","Delhi",20000);

INSERT INTO bankAccount VALUES(1,"SBI_Chamrajpet",2000);
INSERT INTO bankAccount VALUES(2,"SBI_ResidencyRoad",5000);
INSERT INTO bankAccount VALUES(3,"SBI_ShivajiRoad",6000);
INSERT INTO bankAccount VALUES(4,"SBI_ParliamentRoad",9000);
INSERT INTO bankAccount VALUES(5,"SBI_Jantarmantar",8000);
INSERT INTO bankAccount VALUES(6,"SBI_ShivajiRoad",4000);
INSERT INTO bankAccount VALUES(8,"SBI_ResidencyRoad",4000);
INSERT INTO bankAccount VALUES(9,"SBI_ParliamentRoad",3000);
INSERT INTO bankAccount VALUES(10,"SBI_ResidencyRoad",5000);
INSERT INTO bankAccount VALUES(11,"SBI_Jantarmantar",2000);

INSERT INTO bankCustomer VALUES("Avinash","Bull_Temple_Road","Bangalore");
INSERT INTO bankCustomer VALUES("Dinesh","Bannergatta_Road","Bangalore");
INSERT INTO bankCustomer VALUES("Mohan","NationalCollege_Road","Bangalore");
INSERT INTO bankCustomer VALUES("Nikil","Akbar_Road","Delhi");
INSERT INTO bankCustomer VALUES("Ravi","Prithviraj_Road","Delhi");

INSERT INTO DEPOSITER VALUES("Avinash",1);
INSERT INTO DEPOSITER VALUES("Dinesh",2);
INSERT INTO DEPOSITER VALUES("Nikil",4);
INSERT INTO DEPOSITER VALUES("Ravi",5);
INSERT INTO DEPOSITER VALUES("Avinash",8);
INSERT INTO DEPOSITER VALUES("Nikil",9);
INSERT INTO DEPOSITER VALUES("Dinesh",10);
INSERT INTO DEPOSITER VALUES("Nikil",11);

INSERT INTO LOAN VALUES(1,"SBI_Chamrajpet",1000);
INSERT INTO LOAN VALUES(2,"SBI_ResidencyRoad",2000);
INSERT INTO LOAN VALUES(3,"SBI_ShivajiRoad",3000);
INSERT INTO LOAN VALUES(4,"SBI_ParliamentRoad",4000);
INSERT INTO LOAN VALUES(5,"SBI_Jantarmantar",5000);

SELECT* FROM Branch;
SELECT* FROM bankAccount;
SELECT* FROM bankCustomer;
SELECT* FROM DEPOSITER;
SELECT* FROM LOAN;

SELECT Branch_name, CONCAT(assets / 100000, ' lakhs') AS `assets in lakhs`
FROM branch;
SELECT d.Customer_name from Depositer d, BankAccount b 
where b.Branch_name="SBI_ResidencyRoad" and d.Accno= b.Accno
group by d.Customer_name having count(d.Accno)>=2;
CREATE VIEW sum_of_loan AS
SELECT Branch_name, SUM(Balance) AS total_loan_amount
FROM BankAccount
GROUP BY Branch_name;
select * from sum_of_loan;
SELECT bc.Customer_name,CONCAT(balance+1000,'rupees') 
updated_balance from BankAccount b, BankCustomer bc, DEPOSITER d where bc.Customer_name=d.Customer_name and b.Accno=d.Accno and bc.CustomerCity="Bangalore";
select distinct S.customer_name
from depositor as S;
USE BANKSHI;

SELECT DISTINCT S.Customer_name
FROM DEPOSITER AS S
WHERE NOT EXISTS (
    SELECT *
    FROM Branch AS B
    WHERE B.Branch_city = 'Delhi'
    AND NOT EXISTS (
        SELECT *
        FROM DEPOSITER AS T
        JOIN bankAccount AS R 
            ON T.Accno = R.Accno
        WHERE R.Branch_name = B.Branch_name
          AND T.Customer_name = S.Customer_name
    )
);
CREATE TABLE BORROWER(
    Customer_name varchar(20), 
    Loan_number int, 
    PRIMARY KEY(Customer_name, Loan_number),
    FOREIGN KEY(Customer_name) references bankCustomer(Customer_name), 
    FOREIGN KEY(Loan_number) references LOAN(Loan_number)
);

INSERT INTO BORROWER VALUES("Avinash",1);
INSERT INTO BORROWER VALUES("Dinesh",2);
INSERT INTO BORROWER VALUES("Nikil",4);
INSERT INTO BORROWER VALUES("Ravi",5);
INSERT INTO BORROWER VALUES("Mohan",3);

select distinct customer_name
from borrower where customer_name not in
(select customer_name from DEPOSITER );

SELECT DISTINCT B.Customer_name
FROM BORROWER AS B
JOIN LOAN AS L 
    ON B.Loan_number = L.Loan_number
JOIN Branch AS BrL 
    ON L.Branch_name = BrL.Branch_name 
WHERE BrL.Branch_city = 'Bangalore' 

AND B.Customer_name IN (
    SELECT D.Customer_name
    FROM DEPOSITER AS D
    JOIN bankAccount AS A 
        ON D.Accno = A.Accno
    JOIN Branch AS BrA 
        ON A.Branch_name = BrA.Branch_name 
    WHERE BrA.Branch_city = 'Bangalore' 
);

SET SQL_SAFE_UPDATES = 0;
UPDATE Branch
SET assets = assets * 1.05;
SET SQL_SAFE_UPDATES = 1;
SELECT Branch_name, assets 
FROM Branch;

SELECT branch_name 
FROM branch 
WHERE assets > (
    SELECT MAX(assets) 
    FROM branch
    WHERE branch_city = 'Bangalore'
);
DELETE FROM bankAccount
WHERE branch_name IN (
    SELECT Branch_name
    FROM Branch
    WHERE Branch_city = 'Bombay'
);
