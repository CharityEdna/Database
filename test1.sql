-- Active: 1696419593212@@127.0.0.1@3306
CREATE DATABASE life;
    DEFAULT CHARACTER SET = 'utf8mb4';
    use life;
    create table Campus(BranchID varchar(8), Branchname varchar(12), city varchar(10), country varchar(10));
    create table Student(StudentID varchar(10) primary key, Fname varchar(10), Lname varchar(10), DOB varchar(8), Course varchar(6));
    create table Department(Deptno varchar(9), name varchar(8));
    create table Teacher(TeacherID varchar(7), Course varchar(9), Deptno varchar(7), Fname varchar(10), Lname varchar(10), DOB varchar(9));
    show tables;
    insert into Campus values('B01', 'Mukono', 'Kampala', 'Uganda');
    insert into Campus values('B02', 'Kampala', 'Kampala', 'Uganda');
    insert into Campus values('B03', 'Mbarara', 'Fortportal', 'Uganda');
    select * from Campus;
    insert into Student values('M001', 'Ajok', 'Sarah', '25/6/02', 'DIT');
     insert into Student values('M002', 'Aber', 'Charity', '22/9/01', 'BSIT');
      insert into Student values('M003', 'Kivuna', 'Kevin', '30/5/99', 'BSIT');
       insert into Student values('M004', 'Odi', 'Peter', '25/6/02', 'DIT');
        insert into Student values('M005', 'Laker', 'Joanna', '23/1/01', 'BSIT');
         insert into Student values('M006', 'Okomoli', 'Joseph', '10/2/02', 'BSIT');
          insert into Student values('M007', 'Lakica', 'Leticia', '10/2/03', 'BSCS');
           insert into Student values('M008', 'Kiwang', 'Steven', '26/1/99', 'BSCS');
           select * from student;
           insert into Department values('D01', 'BSIT');
           insert into Department values('D02', 'BSCS');
           insert into Department values('D03', 'DIT');
           select * from Department;
           insert into Teacher values('T01', 'BSCS', 'D02', 'Ajok', 'Hector', '19/2/80');
            insert into Teacher values('T02', 'BSIT', 'D01', 'Ageno', 'Rinah', '2/17/98');
             insert into Teacher values('T03', 'DIT', 'D03', 'Mbale', 'Paul', '1/15/90');
             select * from Teacher;
             Alter  table Department ADD HOD VARCHAR(30); 
             select * from Department;
             
            
             



           
    



