-- Active: 1696419593212@@127.0.0.1@3306
CREATE DATABASE Charity;
    DEFAULT CHARACTER SET = 'utf8mb4';
    use Charity;
    create table student(StudentID varchar(15) Primary key, Fname varchar(8), Lname varchar(9), Course varchar(20), DOB varchar(12), Deptno Varchar(20));
    create table DEPARTMENT(Deptno varchar(9) primary key, name varchar(20));
    show tables;
    insert into student values('MB/001', 'LAKICA', 'LETICIA', 'DIT', '22-25-2001', 'DP/003');
    insert into student values('MB/002', 'OJOK', 'JOSEPH', 'BSIT', '22-25-2002', 'DP/002');
    insert into student values('MB/003', 'OKOLIMO', 'JOSEPH', 'BSCS', '01-09-2000', 'DP/001');
    insert into student values('MB/004', 'ABER', 'CHARITY', 'BSIT', '25-06-2002', 'DP/002');
    select * from student;
    insert into Department values('DP/001', 'BSCS');
    insert into Department values('DP/002', 'BSIT');
    insert into Department values('DP/003', 'DIT');
    select * from Department;
    select * from student limit 3;
    select * from student where Deptno = 'DP/001'; 
    show databases;
    use charity;
    show tables;
    select * from student;
    
    
    