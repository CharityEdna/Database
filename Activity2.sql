-- Active: 1696419593212@@127.0.0.1@3306
CREATE DATABASE Charity_Edna;
    DEFAULT CHARACTER SET = 'utf8mb4';
    use Charity_Edna;
    create table Teacher(DID INT primary key, Fname varchar(15) not null, Lname varchar(15) not null, Salary INT, Speciality_Code varchar(10), Deptno varchar(10), foreign key (Speciality_Code ) REFERENCES Speciality(Speciality_Code), foreign key (Deptno) REFERENCES Department(Deptno));
    create table Speciality(Speciality_Code varchar(10) primary key, Name varchar(40) not null unique);
    create table Department(Deptno varchar(10) primary key, Name varchar(30)unique);
    show tables;
    insert into Teacher values('01', 'Okello','Peter', '2000000', 'C01', 'Dpt01'); 
    insert into Teacher values('02', 'Nakato', 'Sarah', '1800000', 'C02', 'Dpt03');
    insert into Teacher values('03', 'Otto', 'Richard', '1500000','C03', 'Dpt02');
    insert into Teacher values('04','Muhirwa', 'Joan', '1000000', 'C04', 'Dpt04');
    select * from Teacher;
    insert into Speciality values('C02', 'BSCS');
      insert into Speciality values('C01', 'BL');
       insert into Speciality values('C03', 'BSWASWA');
       insert into Speciality values('C04', 'BCE');
       select * from Speciality;
       insert into Department values('Dpt02', 'Business Faculty');
        insert into Department values('Dpt04', 'Engineering Faculty');
         insert into Department values('Dpt03', 'Technology Faculty');
          insert into Department values('Dpt01', 'law Faculty');
          select * from Department;
          ALTER TABLE Department ADD Section Varchar(20);
          select * from Department;
          update Department set Section='A' where Deptno='Dpt01';
          update Department set Section='B' where Deptno='Dpt02';
          update Department set Section='C' where Deptno='Dpt03';
          update Department set Section='D' where Deptno='Dpt04';
          select * from Department;
          Alter table Teacher rename column Fname to Surname;
          select * from Teacher;
          UPDATE Teacher set salary=2000000 where Surname= 'Aber';
          SELECT * from Teacher;
          Alter table Teacher Add Salaries int;
          select * from Teacher;
          Update Teacher Set Salaries=salary*15/100 Where Surname='Okello';
          Update Teacher Set Salaries=salary*15/100 Where Surname='Nakato';
          Update Teacher Set Salaries=salary*15/100 Where Surname='Otto';
          Update Teacher Set Salaries=salary*15/100 Where Surname='Muhirwa';
          select * from Teacher where Salaries > 4000000 and Salaries < 8000000;



          
        
   
