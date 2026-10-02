create table Branch(
branchNo varchar(10) primary key,
street varchar(150),
city varchar(50),
postcode varchar(10)
);


INSERT INTO public.branch (branchno,street,city,postcode)
	VALUES ('B005','22 Deer Rd','London','SW1 4EH');


INSERT INTO public.branch (branchno,street,city,postcode)
	VALUES ('B007','16 Argyll st','Aberdeen', 'AB2 3SU'),
('B003', '163 Main St', 'Glasgow', 'G11 9QX'),
('B004', '32 Manse Rd', 'Bristol', 'BS99 1NZ'),
('B002', '56 Clover Dr', 'London', 'NW10 6EU');


CREATE TABLE Staff (
    staffNo VARCHAR(10) PRIMARY KEY,
    fName VARCHAR(50),
    lName VARCHAR(50),
    position VARCHAR(50),
    sex CHAR(1),
    DOB DATE,
    salary INT,
    branchNo VARCHAR(10) REFERENCES Branch(branchNo)
);

INSERT INTO Staff (staffNo, fName, lName, position, sex, DOB, salary, branchNo) 
values ('SL21', 'John', 'White', 'Manager', 'M', '1945-10-01', 30000, 'B005'),
('SG37', 'Ann', 'Beech', 'Assistant', 'F', '1960-11-10', 12000, 'B003'),
('SG14', 'David', 'Ford', 'Supervisor', 'M', '1958-03-24', 18000, 'B003'),
('SA9',  'Mary', 'Howe', 'Assistant', 'F', '1970-02-19', 9000,  'B007'),
('SG5',  'Susan', 'Brand', 'Manager', 'F', '1940-06-03', 24000, 'B003'),
('SL41', 'Julie', 'Lee', 'Assistant', 'F', '1965-06-13', 9000,  'B005');

CREATE TABLE PrivateOwner (
    ownerNo VARCHAR(10) PRIMARY KEY,
    fName VARCHAR(50),
    lName VARCHAR(50),
    address VARCHAR(200),
    telNo VARCHAR(20)
);

INSERT INTO PrivateOwner (ownerNo, fName, lName, address, telNo) VALUES
('CO46', 'Joe', 'Keogh', '2 Fergus Dr, Aberdeen AB2 7SX', '01224-861212'),
('CO87', 'Carol', 'Farrel', '6 Achray St, Glasgow G32 9DX', '0141-357-7419'),
('CO40', 'Tina', 'Murphy', '63 Well St, Glasgow G42', '0141-943-1728'),
('CO93', 'Tony', 'Shaw', '12 Park Pl, Glasgow G4 0QR', '0141-225-7025');

CREATE TABLE PropertyForRent (
    propertyNo VARCHAR(10) PRIMARY KEY,
    street VARCHAR(150),
    city VARCHAR(50),
    postcode VARCHAR(15),
    type VARCHAR(20),
    rooms INT,
    rent INT,
    ownerNo VARCHAR(10) REFERENCES PrivateOwner(ownerNo),
    staffNo VARCHAR(10) REFERENCES Staff(staffNo),
    branchNo VARCHAR(10) REFERENCES Branch(branchNo)
);

INSERT INTO PropertyForRent (propertyNo, street, city, postcode, type, rooms, rent, ownerNo, staffNo, branchNo) VALUES
('PA14', '16 Holhead', 'Aberdeen', 'AB7 5SU', 'House', 6, 650, 'CO46', 'SA9', 'B007'),
('PL94', '6 Argyll St', 'London', 'NW2', 'Flat', 4, 400, 'CO87', 'SL41', 'B005'),
('PG4',  '6 Lawrence St', 'Glasgow', 'G11 9QX', 'Flat', 3, 350, 'CO40', NULL, 'B003'),
('PG36', '2 Manor Rd', 'Glasgow', 'G32 4QX', 'Flat', 3, 375, 'CO93', 'SG37', 'B003'),
('PG21', '18 Dale Rd', 'Glasgow', 'G12', 'House', 5, 600, 'CO87', 'SG37', 'B005'),
('PG16', '5 Novar Dr', 'Glasgow', 'G12 9AX', 'Flat', 4, 450, 'CO93', 'SG14', 'B003');

CREATE TABLE Client (
    clientNo VARCHAR(10) PRIMARY KEY,
    fName VARCHAR(50),
    lName VARCHAR(50),
    telNo VARCHAR(20),
    prefType VARCHAR(20),
    maxRent INT
);

INSERT INTO Client (clientNo, fName, lName, telNo, prefType, maxRent) VALUES
('CR76', 'John', 'Kay', '0207-774-5632', 'Flat', 425),
('CR56', 'Aline', 'Stewart', '0141-848-1825', 'Flat', 350),
('CR74', 'Mike', 'Ritchie', '01475-392178', 'House', 750),
('CR62', 'Mary', 'Tregear', '01224-196720', 'Flat', 600);

CREATE TABLE Viewing (
    clientNo VARCHAR(10) REFERENCES Client(clientNo),
    propertyNo VARCHAR(10) REFERENCES PropertyForRent(propertyNo),
    viewDate DATE,
    comment VARCHAR(255),
    PRIMARY KEY (clientNo, propertyNo, viewDate)
);

INSERT INTO Viewing (clientNo, propertyNo, viewDate, comment) VALUES
('CR56', 'PA14', '2004-05-24', 'too small'),
('CR76', 'PG4',  '2004-04-20', 'too remote'),
('CR56', 'PG4',  '2004-05-26', NULL),
('CR62', 'PA14', '2004-05-14', 'no dining room'),
('CR56', 'PG36', '2004-04-28', NULL);

CREATE TABLE Registration (
    clientNo VARCHAR(10) REFERENCES Client(clientNo),
    branchNo VARCHAR(10) REFERENCES Branch(branchNo),
    staffNo VARCHAR(10) REFERENCES Staff(staffNo),
    dateJoined DATE,
    PRIMARY KEY (clientNo, branchNo)
);

INSERT INTO Registration (clientNo, branchNo, staffNo, dateJoined) VALUES
('CR76', 'B005', 'SL41', '2004-01-02'),
('CR56', 'B003', 'SG37', '2003-04-11'),
('CR74', 'B003', 'SG37', '2002-11-16'),
('CR62', 'B007', 'SA9',  '2003-03-07');


SELECT CONCAT(fName, ' ', lName) AS "Nama Lengkap",
salary AS "Gaji"
FROM Staff
WHERE salary < 10000;

select COUNT(*) as "BUKAN YG DI LONDON"
from propertyforrent p 
where not

SELECT CONCAT(fName, ' ', lName) AS "Nama Lengkap",
(salary * 0.10) AS "Bonus",
(salary + (salary * 0.10)) AS "Gaji Akhir"
FROM Staff
WHERE salary < 10000;

SELECT * FROM PropertyForRent p
WHERE p.city != 'London';

SELECT 
    p.propertyNo AS "ID Properti",
    p.city AS "Kota",
    p.type AS "Jenis Properti",
    CONCAT(o.fName, ' ', o.lName) AS "Nama Pemilik",
    COALESCE(CONCAT(c.fName, ' ', c.lName), '-') AS "Nama Klien / Pengguna"
FROM PropertyForRent p
JOIN PrivateOwner o ON p.ownerNo = o.ownerNo
LEFT JOIN Viewing v ON p.propertyNo = v.propertyNo
LEFT JOIN Client c ON v.clientNo = c.clientNo
WHERE LOWER(p.city) != 'london'
ORDER BY p.propertyNo;

SELECT p.propertyNo,CONCAT(o.fName, ' ', o.lName) AS nama_pemilik
FROM PropertyForRent p
JOIN PrivateOwner o ON p.ownerNo = o.ownerNo
WHERE p.propertyNo NOT IN (SELECT propertyNo FROM Viewing WHERE comment IS NOT NULL AND comment != ''
); 

select CONCAT(fname,'', lname ) as nama_pemilik,
address as lokasi_tempat_tinggal
from privateowner p 
where fname like 'T%';

select p.rent as harga_rent, p.propertyno , p."type" as jenis_property,
CONCAT(o.fName, ' ', o.lName) AS nama_pemilik,
CONCAT(p.street, ', ', p.city, ' ', p.postcode) AS alamat_property
from propertyforrent p 
join PrivateOwner o on p.ownerno = o.ownerno
where p.rent < 500;
