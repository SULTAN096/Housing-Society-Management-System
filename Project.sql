create database ab;
--Schema
CREATE TABLE Blocks (
    BlockID CHAR(1) PRIMARY KEY CHECK (BlockID IN ('A', 'B', 'C', 'D'))
);
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Contact NVARCHAR(15),
    Address NVARCHAR(255),
    Salary DECIMAL(10, 2),
    CNIC NVARCHAR(15) UNIQUE,
    Post NVARCHAR(50) CHECK (Post IN ('Assistant Manager', 'Sweeper', 'Dealer', 'Electrician', 'General Staff')),
    BlockID CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);
CREATE TABLE Construction (
    ConstructionID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Age INT,
    Salary DECIMAL(10, 2),
    Contact NVARCHAR(15),
    Role NVARCHAR(50) CHECK (Role IN ('Attender', 'Labourer', 'Helper')),
    BlockID CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);
CREATE TABLE Head (
    HeadID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Contact NVARCHAR(15),
    CNIC NVARCHAR(15) UNIQUE,
    Address NVARCHAR(255),
    Role NVARCHAR(50) CHECK (Role IN ('Owner', 'Manager')),
    BlockID CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);
CREATE TABLE Schools (
    SchoolID INT PRIMARY KEY IDENTITY(1,1),
    SchoolName NVARCHAR(100) NOT NULL,
    PrincipalName NVARCHAR(100),
    ContactNumber NVARCHAR(15),
    Email NVARCHAR(100),
    BlockID CHAR(1) UNIQUE FOREIGN KEY REFERENCES Blocks(BlockID)
);
CREATE TABLE School(
    ClassID INT PRIMARY KEY IDENTITY(1,1),
    ClassName NVARCHAR(50) NOT NULL,
    TeacherID INT,
    Students INT,
    Staff INT,
    TeacherName NVARCHAR(100),
    TeacherAge INT,
    TeacherCNIC NVARCHAR(15) UNIQUE,
    TeacherSalary DECIMAL(10, 2),
    TeacherEmail NVARCHAR(100),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID)
);
CREATE TABLE SecurityStaff (
    SecurityID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Age INT,
    CNIC NVARCHAR(15) UNIQUE,
    Email NVARCHAR(100),
    Salary DECIMAL(10, 2),
    Timing NVARCHAR(50),
    Role NVARCHAR(50) CHECK (Role IN ('Head', 'Guard')),
    BlockID CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);
CREATE TABLE Shops (
    ShopID INT PRIMARY KEY IDENTITY(1,1),
    ShopName NVARCHAR(100) NOT NULL,
    OwnerName NVARCHAR(100) NOT NULL,
    OwnerAge INT,
    OwnerContact NVARCHAR(15),
    OwnerCNIC NVARCHAR(15) UNIQUE,
    OwnerEmail NVARCHAR(100),
    BlockID CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);

CREATE TABLE Mosque (
    MosqueID INT PRIMARY KEY IDENTITY(1,1),
    NameOfImam NVARCHAR(100) NOT NULL,
    ImamID NVARCHAR(15) UNIQUE,
    ImamAge INT,
    Salary DECIMAL(10, 2),
    ContactNumber NVARCHAR(15),
    BlockID CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);
CREATE TABLE Plots (
    PlotID INT PRIMARY KEY IDENTITY(1,1),
    PlotType NVARCHAR(50) CHECK (PlotType IN ('Commercial', 'Residential')),
    BlockID CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);
CREATE TABLE Clinic (
    ClinicID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Contact NVARCHAR(15),
    Email NVARCHAR(100),
    Age INT,
    CNIC NVARCHAR(15) UNIQUE,
    Role NVARCHAR(50) CHECK (Role IN ('Doctor', 'Pharmacist', 'Receptionist')),
    BlockID CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);
CREATE TABLE Roads (
    RoadID INT PRIMARY KEY IDENTITY(1,1),
    RoadName NVARCHAR(50) NOT NULL,
    StartBlock CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID),
    EndBlock CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);
CREATE TABLE Houses (
    HouseID INT PRIMARY KEY IDENTITY(1,1),
    OwnerName NVARCHAR(100) NOT NULL,
    Occupation NVARCHAR(100),
    CNIC NVARCHAR(15) UNIQUE,
    Email NVARCHAR(100),
    ContactNumber NVARCHAR(15),
    BlockID CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);
CREATE TABLE Parks (
    ParkID INT PRIMARY KEY IDENTITY(1,1),
    ParkName NVARCHAR(100) NOT NULL,
    StaffRole NVARCHAR(50),
    NameOfStaff NVARCHAR(100),
    CNIC NVARCHAR(15) UNIQUE,
    Contact NVARCHAR(15),
    Salary DECIMAL(10, 2),
    BlockID CHAR(1) FOREIGN KEY REFERENCES Blocks(BlockID)
);


--Triggers

--CNIC Format Trigger: Validates CNIC format (xxxxx-xxxxxxx-x) before insertion
CREATE TRIGGER trg_validate_staff_cnic
ON Staff
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE CNIC IS NOT NULL
        AND CNIC NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    )
    BEGIN
        RAISERROR('Staff table: Invalid CNIC format. Required format: xxxxx-xxxxxxx-x', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE TRIGGER trg_validate_head_cnic
ON Head
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE CNIC IS NOT NULL
        AND CNIC NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    )
    BEGIN
        RAISERROR('Head table: Invalid CNIC format. Required format: xxxxx-xxxxxxx-x', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE TRIGGER trg_validate_security_cnic
ON SecurityStaff
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE CNIC IS NOT NULL
        AND CNIC NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    )
    BEGIN
        RAISERROR('SecurityStaff table: Invalid CNIC format. Required format: xxxxx-xxxxxxx-x', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

CREATE TRIGGER trg_validate_shop_cnic
ON Shops
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE OwnerCNIC IS NOT NULL
        AND OwnerCNIC NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    )
    BEGIN
        RAISERROR('Shops table: Invalid Owner CNIC format. Required format: xxxxx-xxxxxxx-x', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

CREATE TRIGGER trg_validate_house_cnic
ON Houses
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE CNIC IS NOT NULL
        AND CNIC NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    )
    BEGIN
        RAISERROR('Houses table: Invalid CNIC format. Required format: xxxxx-xxxxxxx-x', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;

CREATE TRIGGER trg_validate_mosque_cnic
ON Mosque
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE ImamID IS NOT NULL
        AND ImamID NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    )
    BEGIN
        RAISERROR('Mosque table: Invalid Imam CNIC format. Required format: xxxxx-xxxxxxx-x', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE TRIGGER trg_validate_school_cnic
ON School
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE TeacherCNIC IS NOT NULL
        AND TeacherCNIC NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    )
    BEGIN
        RAISERROR('School table: Invalid Teacher CNIC format. Required format: xxxxx-xxxxxxx-x', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE TRIGGER trg_validate_park_cnic
ON Parks
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE CNIC IS NOT NULL
        AND CNIC NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    )
    BEGIN
        RAISERROR('Parks table: Invalid CNIC format. Required format: xxxxx-xxxxxxx-x', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

CREATE TRIGGER trg_validate_clinic_cnic
ON Clinic
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE CNIC IS NOT NULL
        AND CNIC NOT LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9]'
    )
    BEGIN
        RAISERROR('Clinic table: Invalid CNIC format. Required format: xxxxx-xxxxxxx-x', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--Role-Salary Validation: Validates salary ranges for different roles
create trigger trg_validate_role_salary
on staff
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where (post = 'assistant manager' and (salary < 50000.00 or salary > 150000.00))
           or (post = 'dealer' and (salary < 30000.00 or salary > 80000.00))
           or (post = 'electrician' and (salary < 25000.00 or salary > 60000.00))
           or (post = 'general staff' and (salary < 20000.00 or salary > 40000.00))
           or (post = 'sweeper' and (salary < 15000.00 or salary > 30000.00))
    )
    begin
        declare @errmsg nvarchar(500)
        select @errmsg = 
            case 
                when post = 'assistant manager' then 'invalid salary for assistant manager (50,000 - 150,000)'
                when post = 'dealer' then 'invalid salary for dealer (30,000 - 80,000)'
                when post = 'electrician' then 'invalid salary for electrician (25,000 - 60,000)'
                when post = 'general staff' then 'invalid salary for general staff (20,000 - 40,000)'
                when post = 'sweeper' then 'invalid salary for sweeper (15,000 - 30,000)'
            end
        from inserted
        
        raiserror(@errmsg, 16, 1)
        rollback transaction
        return
    end
end;

create trigger trg_validate_construction_role_salary
on construction
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where (role = 'attender' and (salary < 15000.00 or salary > 30000.00))
           or (role = 'labourer' and (salary < 20000.00 or salary > 40000.00))
           or (role = 'helper' and (salary < 18000.00 or salary > 35000.00))
    )
    begin
        declare @errmsg nvarchar(500)
        select @errmsg = 
            case 
                when role = 'attender' then 'invalid salary for attender (15,000 - 30,000)'
                when role = 'labourer' then 'invalid salary for labourer (20,000 - 40,000)'
                when role = 'helper' then 'invalid salary for helper (18,000 - 35,000)'
            end
        from inserted
        
        raiserror(@errmsg, 16, 1)
        rollback transaction
        return
    end
end;

create trigger trg_one_school_per_block
on schools
after insert, update
as
begin
    if exists (
        select blockid 
        from schools
        group by blockid
        having count(*) > 1
    )
    begin
        raiserror('only one school is allowed per block', 16, 1)
        rollback transaction
        return
    end
end;

--Single Owner Trigger: Ensures one owner per shop
create trigger trg_single_shop_owner
on shops
after insert, update
as
begin
    if exists (
        select ownercnic
        from shops
        where ownercnic is not null
        group by ownercnic
        having count(*) > 1
    )
    begin
        declare @dupowner nvarchar(100)
        select @dupowner = ownername 
        from shops 
        where ownercnic in (
            select ownercnic
            from shops
            group by ownercnic
            having count(*) > 1
        )
        
        raiserror('owner %s already owns another shop (one owner per shop only)', 16, 1, @dupowner)
        rollback transaction
        return
    end
end;

--Prevents owner changes
create trigger trg_prevent_owner_changes
on shops
after update
as
begin
    if update(ownercnic)
    begin
        if exists (
            select 1
            from inserted i
            join shops s on i.ownercnic = s.ownercnic
            where i.shopid != s.shopid
        )
        begin
            raiserror('cannot assign existing owner to another shop', 16, 1)
            rollback transaction
            return
        end
    end
end;

--CNIC Uniqueness Trigger: Maintains CNIC uniqueness across all tables
create trigger trg_check_cnic_staff
on staff
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where i.cnic is not null
        and (
            exists (select 1 from head where cnic = i.cnic)
            or exists (select 1 from securitystaff where cnic = i.cnic)
            or exists (select 1 from shops where ownercnic = i.cnic)
            or exists (select 1 from houses where cnic = i.cnic)
            or exists (select 1 from mosque where imamid = i.cnic)
            or exists (select 1 from school where teachercnic = i.cnic)
            or exists (select 1 from parks where cnic = i.cnic)
            or exists (select 1 from clinic where cnic = i.cnic)
        )
    )
    begin
        raiserror('cnic already exists in another table (staff)', 16, 1)
        rollback transaction
    end
end;
create trigger trg_check_cnic_head
on head
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where i.cnic is not null
        and (
            exists (select 1 from staff where cnic = i.cnic)
            or exists (select 1 from securitystaff where cnic = i.cnic)
            or exists (select 1 from shops where ownercnic = i.cnic)
            or exists (select 1 from houses where cnic = i.cnic)
            or exists (select 1 from mosque where imamid = i.cnic)
            or exists (select 1 from school where teachercnic = i.cnic)
            or exists (select 1 from parks where cnic = i.cnic)
            or exists (select 1 from clinic where cnic = i.cnic)
        )
    )
    begin
        raiserror('cnic already exists in another table (head)', 16, 1)
        rollback transaction
    end
end;

-- 3. SecurityStaff table trigger
create trigger trg_check_cnic_security
on securitystaff
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where i.cnic is not null
        and (
            exists (select 1 from staff where cnic = i.cnic)
            or exists (select 1 from head where cnic = i.cnic)
            or exists (select 1 from shops where ownercnic = i.cnic)
            or exists (select 1 from houses where cnic = i.cnic)
            or exists (select 1 from mosque where imamid = i.cnic)
            or exists (select 1 from school where teachercnic = i.cnic)
            or exists (select 1 from parks where cnic = i.cnic)
            or exists (select 1 from clinic where cnic = i.cnic)
        )
    )
    begin
        raiserror('cnic already exists in another table (securitystaff)', 16, 1)
        rollback transaction
    end
end;

-- 4. Shops table trigger (using ownercnic)
create trigger trg_check_cnic_shops
on shops
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where i.ownercnic is not null
        and (
            exists (select 1 from staff where cnic = i.ownercnic)
            or exists (select 1 from head where cnic = i.ownercnic)
            or exists (select 1 from securitystaff where cnic = i.ownercnic)
            or exists (select 1 from houses where cnic = i.ownercnic)
            or exists (select 1 from mosque where imamid = i.ownercnic)
            or exists (select 1 from school where teachercnic = i.ownercnic)
            or exists (select 1 from parks where cnic = i.ownercnic)
            or exists (select 1 from clinic where cnic = i.ownercnic)
        )
    )
    begin
        raiserror('cnic already exists in another table (shops)', 16, 1)
        rollback transaction
    end
end;

-- 5. Houses table trigger
create trigger trg_check_cnic_houses
on houses
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where i.cnic is not null
        and (
            exists (select 1 from staff where cnic = i.cnic)
            or exists (select 1 from head where cnic = i.cnic)
            or exists (select 1 from securitystaff where cnic = i.cnic)
            or exists (select 1 from shops where ownercnic = i.cnic)
            or exists (select 1 from mosque where imamid = i.cnic)
            or exists (select 1 from school where teachercnic = i.cnic)
            or exists (select 1 from parks where cnic = i.cnic)
            or exists (select 1 from clinic where cnic = i.cnic)
        )
    )
    begin
        raiserror('cnic already exists in another table (houses)', 16, 1)
        rollback transaction
    end
end;

-- 6. Mosque table trigger (using imamid)
create trigger trg_check_cnic_mosque
on mosque
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where i.imamid is not null
        and (
            exists (select 1 from staff where cnic = i.imamid)
            or exists (select 1 from head where cnic = i.imamid)
            or exists (select 1 from securitystaff where cnic = i.imamid)
            or exists (select 1 from shops where ownercnic = i.imamid)
            or exists (select 1 from houses where cnic = i.imamid)
            or exists (select 1 from school where teachercnic = i.imamid)
            or exists (select 1 from parks where cnic = i.imamid)
            or exists (select 1 from clinic where cnic = i.imamid)
        )
    )
    begin
        raiserror('cnic already exists in another table (mosque)', 16, 1)
        rollback transaction
    end
end;

-- 7. School table trigger (using teachercnic)
create trigger trg_check_cnic_school
on school
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where i.teachercnic is not null
        and (
            exists (select 1 from staff where cnic = i.teachercnic)
            or exists (select 1 from head where cnic = i.teachercnic)
            or exists (select 1 from securitystaff where cnic = i.teachercnic)
            or exists (select 1 from shops where ownercnic = i.teachercnic)
            or exists (select 1 from houses where cnic = i.teachercnic)
            or exists (select 1 from mosque where imamid = i.teachercnic)
            or exists (select 1 from parks where cnic = i.teachercnic)
            or exists (select 1 from clinic where cnic = i.teachercnic)
        )
    )
    begin
        raiserror('cnic already exists in another table (school)', 16, 1)
        rollback transaction
    end
end;

-- 8. Parks table trigger
create trigger trg_check_cnic_parks
on parks
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where i.cnic is not null
        and (
            exists (select 1 from staff where cnic = i.cnic)
            or exists (select 1 from head where cnic = i.cnic)
            or exists (select 1 from securitystaff where cnic = i.cnic)
            or exists (select 1 from shops where ownercnic = i.cnic)
            or exists (select 1 from houses where cnic = i.cnic)
            or exists (select 1 from mosque where imamid = i.cnic)
            or exists (select 1 from school where teachercnic = i.cnic)
            or exists (select 1 from clinic where cnic = i.cnic)
        )
    )
    begin
        raiserror('cnic already exists in another table (parks)', 16, 1)
        rollback transaction
    end
end;

-- 9. Clinic table trigger
create trigger trg_check_cnic_clinic
on clinic
after insert, update
as
begin
    if exists (
        select 1 from inserted i
        where i.cnic is not null
        and (
            exists (select 1 from staff where cnic = i.cnic)
            or exists (select 1 from head where cnic = i.cnic)
            or exists (select 1 from securitystaff where cnic = i.cnic)
            or exists (select 1 from shops where ownercnic = i.cnic)
            or exists (select 1 from houses where cnic = i.cnic)
            or exists (select 1 from mosque where imamid = i.cnic)
            or exists (select 1 from school where teachercnic = i.cnic)
            or exists (select 1 from parks where cnic = i.cnic)
        )
    )
    begin
        raiserror('cnic already exists in another table (clinic)', 16, 1)
        rollback transaction
    end
end;

--Views

--staffbypost: staff categorized by their post
create view staffByPost as
select post, count(*) totalStaff, avg(salary) avgSalary
from Staff
group by post;

--constructionworkersbyrole: laborers, helpers, attenders grouped by role
create  view constructionWorkersByRole as
select role, count(*) totalWorkers,AVG(salary) avgSalary
from Construction
group by Role;

-- blockheads: heads (owners/managers) for each block
create view BlockHeads as
select BlockID,name,role,Email
from head h;

-- headcontactinfo: essential contact details for heads
create view HeadContactInfo as
select *
from head;

-- securityschedule: security staff with their timings
create view SecuritySchedule as
select name, timing, role, blockid
from securitystaff;

-- shopsbyblock: all shops organized by block
create view ShopsByBlock as
select shopname, ownername, blockid
from shops;

-- mosquestaff: imam details for each block
create view MosqueStaff as
select nameofimam, ImamAge, salary, blockid
from mosque;

-- houseowners: basic information about house owners
create view houseowners as
select ownername, occupation, contactnumber, blockid
from houses;

-- blockresidents: residents organized by block
create view blockresidents as
select distinct blockid, (select count(*) from houses h where h.blockid = houses.blockid) as householdcount
from houses;
select * from blockresidents;

-- allemployees: combined view of staff, construction, security, etc.
create view allemployees as
select 'staff' as employeetype, name, post as role, salary, blockid from staff
union
select 'construction' as employeetype, name, role, salary, blockid from construction
union
select 'security' as employeetype, name, role, salary, blockid from securitystaff
union
select 'mosque' as employeetype, nameofimam, 'imam' as role, salary, blockid from mosque
union
select 'park' as employeetype, nameofstaff, staffrole as role, salary, blockid from parks
union
select 'school' as employeetype, teachername, 'teacher' as role, teachersalary as salary, s.blockid 
from school sc join schools s on sc.schoolid = s.schoolid;

-- emergencycontacts: critical contacts for emergencies
create view emergencycontacts as
select 'block head' as contacttype, name, contact, blockid from head
union
select 'security head' as contacttype, name, null as contact, blockid from securitystaff where role = 'head'
union
select 'clinic' as contacttype, name, contact, blockid from clinic where role = 'doctor'
union
select 'school' as contacttype, schoolname as name, contactnumber as contact, blockid from schools;

-- roledistribution: count of people in different roles
create view roledistribution as
select 'staff' as category, post as role, count(*) as count from staff group by post
union
select 'construction' as category, role, count(*) as count from construction group by role
union
select 'security' as category, role, count(*) as count from securitystaff group by role
union
select 'head' as category, role, count(*) as count from head group by role
union
select 'clinic' as category, role, count(*) as count from clinic group by role
union
select 'teachers' as category, 'teacher' as role, count(*) as count from school
union
select 'imams' as category, 'imam' as role, count(*) as count from mosque
union
select 'park staff' as category, staffrole as role, count(*) as count from parks group by staffrole;

--Data insertion
-- 1. First insert blocks (required for foreign keys)
insert into blocks (blockid) values ('a'), ('b'), ('c'), ('d');

-- 2. Insert head/owners (needed for some relationships)
insert into head (name, email, contact, cnic, address, role, blockid)
values 
('ali khan', 'ali@example.com', '03001234567', '12345-6789012-3', '123 main st', 'owner', 'a'),
('sara ahmed', 'sara@example.com', '03011234567', '12345-6789012-4', '456 oak ave', 'manager', 'b');

-- 3. Insert staff
insert into staff (name, contact, address, salary, cnic, post, blockid)
values
('rehman malik', '03021234567', 'staff quarter 1', 50000, '23456-7890123-4', 'assistant manager', 'a'),
('fatima khan', '03031234567', 'staff quarter 2', 40000, '23456-7890123-5', 'general staff', 'b');

-- 4. Insert security staff
insert into securitystaff (name, age, cnic, email, salary, timing, role, blockid)
values
('asad iqbal', 35, '34567-8901234-5', 'asad@example.com', 25000.00, 'day', 'guard', 'a'),
('nadia shah', 28, '34567-8901234-6', 'nadia@example.com', 30000.00, 'night', 'head', 'b');

-- 5. Insert schools (need schools table first for school foreign key)
insert into schools (schoolname, principalname, contactnumber, email, blockid)
values
('sunrise public school', 'dr. amir khan', '03041234567', 'sunrise@example.com', 'a'),
('city grammar school', 'ms. sana ali', '03051234567', 'citygrammar@example.com', 'b');

-- 6. Insert school classes
insert into school (classname, teacherid, students, staff, teachername, teacherage, teachercnic, teachersalary, teacheremail, schoolid)
values
('class 1', 1, 25, 5, 'sadia malik', 32, '45678-9012345-6', 40000.00, 'sadia@example.com', 1),
('class 2', 2, 30, 5, 'imran shah', 35, '45678-9012345-7', 45000.00, 'imran@example.com', 2);

-- 7. Insert shops
insert into shops (shopname, ownername, ownerage, ownercontact, ownercnic, owneremail, blockid)
values
('general store', 'kamran ali', 45, '03061234567', '56789-0123456-7', 'kamran@example.com', 'a'),
('medical store', 'dr. sana khan', 38, '03071234567', '56789-0123456-8', 'sana@example.com', 'b');

-- 8. Insert houses
insert into houses (ownername, occupation, cnic, email, contactnumber, blockid)
values
('ahmed raza', 'doctor', '67890-1234567-8', 'ahmed@example.com', '03081234567', 'a'),
('farhan malik', 'engineer', '67890-1234567-9', 'farhan@example.com', '03091234567', 'b');

-- 9. Insert mosque
insert into mosque (nameofimam, imamid, imamage, salary, contactnumber, blockid)
values
('imam sahib', '78901-2345678-9', 50, 30000.00, '03101234567', 'a'),
('maulana ismail', '78901-2345678-0', 55, 35000.00, '03111234567', 'b');

-- 10. Insert plots
insert into plots (plottype, blockid)
values
('residential', 'a'),
('commercial', 'b');

-- 11. Insert clinic
insert into clinic (name, contact, email, age, cnic, role, blockid)
values
('city clinic', '03121234567', 'clinic@example.com', 40, '89012-3456789-0', 'doctor', 'a'),
('community health', '03131234567', 'health@example.com', 35, '89012-3456789-1', 'pharmacist', 'b');

-- 12. Insert roads
insert into roads (roadname, startblock, endblock)
values
('main boulevard', 'a', 'b'),
('market street', 'b', 'c');

-- 13. Insert parks
insert into parks (parkname, staffrole, nameofstaff, cnic, contact, salary, blockid)
values
('central park', 'gardener', 'naveed khan', '90123-4567890-1', '03141234567', 20000.00, 'a'),
('children park', 'caretaker', 'saima malik', '90123-4567890-2', '03151234567', 18000.00, 'b');

-- 14. Insert construction workers
insert into construction (name, age, salary, contact, role, blockid)
values
('bashir ahmed', 30, 25000.00, '03161234567', 'labourer', 'a'),
('akbar khan', 25, 20000.00, '03171234567', 'helper', 'b');