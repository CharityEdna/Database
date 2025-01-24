-- Active: 1696419593212@@127.0.0.1@3306
CREATE DATABASE HQ_Library;
    DEFAULT CHARACTER SET = 'utf8mb4';
    use HQ_Library;
show tables;

create table Books(BookID VARCHAR(10) PRIMARY KEY, Title VARCHAR(25), Publisher VARCHAR(25), NumberOfCopies INT NOT NULL, AvailabiltyStatus VARCHAR(20));
create Table Borrower(BorrowerID VARCHAR(10) PRIMARY KEY, BorrowerName VARCHAR(35) NOT NULL, Gender CHAR(1), PhoneNumber INT, Email VARCHAR(25), Programme VARCHAR(15), BookID VARCHAR(10));
create table Librarian(LibrarianID VARCHAR(10) PRIMARY KEY , Fname VARCHAR(15), Lname VARCHAR(20), WorkingHours VARCHAR(15) NOT NULL);
create table LoanTracker(LoanID VARCHAR(10) PRIMARY KEY, BorrowerID VARCHAR(10), BookID VARCHAR(10), AvailableNumberOfCopies INT, LoanDate VARCHAR(10) NOT NULL, TimeBorrowed VARCHAR(10) NOT NULL, ReturnDate VARCHAR(10) NOT NULL, LibrarianID VARCHAR(10) NOT NULL);
create table Renewal(RenewalID VARCHAR(10) PRIMARY KEY, LoanID VARCHAR(10), RenewalDate VARCHAR(10), RenewalTime VARCHAR(10), NewReturnDate VARCHAR(15), LibrarianID VARCHAR(10));
create table Penalty(PenaltyCode VARCHAR(10) PRIMARY KEY, Reason VARCHAR(40), BorrowerID VARCHAR(10), BookID VARCHAR(10), Amount INT NULL);
create table ReturnedBooks(ReturnID VARCHAR(10) PRIMARY KEY, LoanID VARCHAR(10) NOT NULL, ReturnDate VARCHAR(12), ReturnTime VARCHAR(10), BookCondition VARCHAR(30), LibrarianID VARCHAR(10) NOT NULL);
create table Resources(ResourceID VARCHAR(10) PRIMARY KEY, Title VARCHAR(50), Author VARCHAR(30), Format VARCHAR(20), AvailabilityStatus VARCHAR(25));
create table User(UserID VARCHAR(10) PRIMARY KEY, Names VARCHAR(30), Email VARCHAR(25) NOT NULL, SecretPassword VARCHAR(30), Subscription VARCHAR(15) NOT NULL);
create table Payment(paymentID VARCHAR(20) PRIMARY KEY, DateOfPayment VARCHAR(20) NULL, MethodOfPayment VARCHAR(20) NULL, Subscription VARCHAR(20) NOT NULL, UserID VARCHAR(10) NOT NULL);
show tables;

ALTER TABLE LoanTracker add FOREIGN KEY(BorrowerID) REFERENCES Borrower(BorrowerID);
ALTER TABLE LoanTracker add FOREIGN KEY(BookID) REFERENCES Books(BookID);
ALTER TABLE LoanTracker add FOREIGN KEY(LibrarianID) REFERENCES Librarian(LibrarianID);
ALTER TABLE Renewal add FOREIGN KEY(LoanID) REFERENCES LoanTracker(LoanID);
ALTER TABLE Renewal add FOREIGN KEY(LibrarianID) REFERENCES Librarian(LibrarianID);
ALTER TABLE Penalty add FOREIGN KEY(BorrowerID) REFERENCES Borrower(BorrowerID);
ALTER TABLE Penalty add FOREIGN KEY(BookID) REFERENCES Books(BookID);
ALTER TABLE ReturnedBooks add FOREIGN KEY(LoanID) REFERENCES LoanTracker(LoanID);
ALTER TABLE ReturnedBooks add FOREIGN KEY(LibrarianID) REFERENCES Librarian(LibrarianID);
ALTER TABLE Payment add FOREIGN KEY(UserID) REFERENCES User(UserID);
ALTER TABLE Borrower add FOREIGN KEY(BookID) REFERENCES Books(BookID);





ALTER TABLE Books MODIFY AvailabiltyStatus VARCHAR(20) DEFAULT 'Available';
ALTER TABLE Books ADD CONSTRAINT chk_AvailabilityStatus CHECK (AvailabiltyStatus IN ('Available', 'Unavailable'));
INSERT INTO Books VALUES('B001', 'The Great Gatsby', 'Scribner', 5, 'Available');
INSERT INTO Books VALUES('B002', '1984', 'Secker & Warburg', 3, 'Available');
INSERT INTO Books VALUES('B003', 'To Kill a Mockingbird', 'J.B. Lippincott', 2, 'Available');
INSERT INTO Books VALUES('B004', 'Pride and Prejudice', 'T. Egerton', 9, 'Available');
INSERT INTO Books VALUES('B005', 'The Catcher in the Rye', 'Little, Brown', 15, 'Available');
INSERT INTO Books VALUES('B006', 'Moby Dick', 'Harper & Brothers', 3, 'Available');
INSERT INTO Books VALUES('B007', 'War and Peace', 'The Russian Messenger', 2, 'Available');
INSERT INTO Books VALUES('B008', 'The Odyssey', 'Penguin Classics', 6, 'Available');
INSERT INTO Books VALUES('B009', 'Brave New World', 'Chatto & Windus', 5, 'Available');
INSERT INTO Books VALUES('B010', 'The Hobbit', 'George Allen & Unwin', 1, 'Available');
INSERT INTO Books VALUES('B011', 'Queen Charlotte', 'kevin Hart', 1, 'Unavailable');
SELECT * FROM Books;



desc Books;
desc Borrower;
desc LoanTracker;

alter table Borrower add constraint email check (email like'%@%');
ALTER TABLE Borrower add constraint borrower_gen check (gender= 'M' or gender= 'F');
ALTER Table Borrower add constraint borrow_gender check (Gender = upper(Gender));
ALTER TABLE Borrower MODIFY PhoneNumber VARCHAR(10);
ALTER TABLE Borrower ADD CONSTRAINT chk_PhoneNumber CHECK (PhoneNumber LIKE("__________"));



INSERT INTO Borrower VALUES('BR01', 'Aber Charity', 'F','0787612230', 'abercharity11@gmail.com', 'BSIT', 'B005');
INSERT INTO Borrower VALUES('BR02', 'Wasswa Elijah', 'M', '0757612230', 'W.Elijah@gmail.com', 'BCSC', 'B007');
INSERT INTO Borrower VALUES('BR03', 'Nakku Brian', 'M', '0700368392', 'Nakku90@gmail.com', 'DIT', 'B004');
INSERT INTO Borrower VALUES('BR04', 'John Pol', 'M', '0787694621', 'JPol40@gmail.com', 'BSIT', 'B001');
INSERT INTO Borrower VALUES('BR05', 'Moses Kibuuka', 'M', '0787614993', 'mosesk@gmail.com', 'LAW', 'B002');
INSERT INTO Borrower VALUES('BR06', 'Kato Brian', 'M', '0787797550', 'katobrian12@gmail.com', 'BBA', 'B003');
INSERT INTO Borrower VALUES('BR07', 'Kato Brian', 'M', '0787797550', 'katobrian12@gmail.com', 'BBA', 'B009');
SELECT * FROM Borrower;




INSERT INTO Librarian VALUES('L001', 'Ageno', 'Sarah', '7am-1pm');
INSERT INTO Librarian VALUES('L002', 'Ngabo', 'Oscar', '2pm-9pm');
SELECT * FROM Librarian;
SELECT* from Books;



INSERT INTO LoanTracker VALUES('LN01', 'BR01', 'B005', 14, '2024-09-06', '10:30 AM', DATE_ADD('2024-09-06', INTERVAL 1 WEEK), 'L001');
INSERT INTO LoanTracker VALUES('LN02', 'BR06', 'B003', 1, '2024-06-30', '02:15 PM',  DATE_ADD('2024-06-30', INTERVAL 1 WEEK), 'L002');
INSERT INTO LoanTracker VALUES('LN03', 'BR06', 'B009', 2, '2024-06-30', '02:15 PM', DATE_ADD('2024-06-30', INTERVAL 1 WEEK), 'L002');
INSERT INTO LoanTracker VALUES('LN04', 'BR03', 'B004', 8, '2024-07-10', '01:00 PM', DATE_ADD('2024-07-10', INTERVAL 1 WEEK), 'L001');
INSERT INTO LoanTracker VALUES('LN05', 'BR04', 'B001', 4, '2024-07-20', '3:00 PM', DATE_ADD('2024-07-20', INTERVAL 1 WEEK), 'L002');
SELECT * FROM loanTracker;


INSERT INTO Renewal VALUES('BR06', 'LN03', '2024-07-04', '3:30PM', DATE_ADD('2024-07-04', INTERVAL 1 WEEK), 'L002');
SELECT * FROM Renewal;




INSERT INTO ReturnedBooks VALUES('R01', 'LN01', '15-06-2024', '8:00AM', 'Good', 'L001');
INSERT INTO ReturnedBooks VALUES('R02', 'LN02', '06-07-2024', '2:00PM', 'Damaged', 'L002');
SELECT * FROM ReturnedBooks;
SELECT * from Penalty;


ALTER TABLE Penalty ADD PaymentStatus VARCHAR(10) DEFAULT 'Pending';
INSERT INTO Penalty VALUES('Code1', 'Damaged', 'BR06', 'B003',50000, 'Pending');
INSERT INTO Penalty VALUES('Code2', 'Lost', 'BR03', 'B004',100000, 'Pending');
SELECT * FROM Borrower WHERE BorrowerID = 'BR06';
SELECT * FROM Penalty;

UPDATE Penalty SET PaymentStatus = 'cleared' WHERE PenaltyCode = 'Code1'; -- Example for a specific penalty




INSERT INTO Resources VALUES('Re01', 'Love is Blind', 'Aber Valentine', 'e-book', 'offline access'),
('Re23', 'Jungle', 'Thompson Roland', 'Audio-book', 'online access'),
('Re05', 'Destiny', 'Kato Kimera', 'Video', 'online access'),
('Re69', 'How to win for Dummies', 'Blessed Roland', 'Article', 'offline access');
SELECT * FROM Resources;

desc user;
alter table User add constraint email_chk check (email like'%@%');
ALTER TABLE User add constraint user_id UNIQUE(Email);
INSERT INTO User VALUES ('u001', 'Erima Ashley', 'ashma@outlook.com', '******', 'Annual');
INSERT INTO User VALUES ('u002', 'Jordna Wakabi', 'jorwabi@gmail.com', '*********', 'Premium');
INSERT INTO User VALUES ('u003', 'Gai Edna', 'gail123@gmail.com', '*******', 'Trial');
INSERT INTO User VALUES ('u004', 'Alicia Nama', 'nama@gmail.com', '*******', 'Free');
INSERT INTO User VALUES ('u005', 'John Mark', 'MJ12@outlook.com', '*******', 'Trial');
SELECT * FROM User;




ALTER TABLE Payment ADD CONSTRAINT chk_PaymentMethod CHECK (MethodOfPayment IN ('Apple_Pay', 'PayPal', 'Credit_Card', 'MobileMoney'));
ALTER TABLE Payment DROP CONSTRAINT chk_PaymentMethod;

desc Payment;
INSERT INTO Payment VALUES('P01', '12-01-2024', 'Apple_Pay', 'Annual', 'u001');
INSERT INTO Payment VALUES('P02', '', '', 'Free', 'u004');
INSERT INTO Payment VALUES('P03', '', '', 'Trial', 'u003');
INSERT INTO Payment VALUES('P04', '15-01-2024', 'PayPal','Premium', 'u002');
UPDATE Payment SET DateOfPayment = '01-10-2024', Subscription = 'Premium', MethodOfPayment ='Credit Card' WHERE paymentID = 'P02';

SELECT * FROM Payment;


-- showing the constraints on the table.
SELECT 
    CONSTRAINT_NAME, 
    CONSTRAINT_TYPE, 
    TABLE_NAME 
FROM 
    information_schema.TABLE_CONSTRAINTS 
WHERE 
    TABLE_SCHEMA = 'HQ_Library';

select * from Borrower;

select * from borrower where BorrowerName like "A%";
select * from borrower where BorrowerName LIKE "Aber Charity";
SELECT Title FROM Books WHERE AvailabiltyStatus = 'Unavailable';
SELECT * FROM Books WHERE AvailabiltyStatus = 'Unavailable';

SELECT SUM(NumberOfCopies) AS TotalBooks FROM Books WHERE AvailabiltyStatus = 'Available';
desc books;
SELECT * FROM books;




-- PROCEDURES
Show PROCEDURE status where db = 'HQ_Library';

DELIMITER //
CREATE PROCEDURE AddNewBook(
    IN p_BookID VARCHAR(10),
    IN p_Title VARCHAR(25),
    IN p_Publisher VARCHAR(25),
    IN p_NumberOfCopies INT,
    IN p_AvailabilityStatus VARCHAR(20)
)
BEGIN
    INSERT INTO Books (BookID, Title, Publisher, NumberOfCopies, AvailabiltyStatus)
    VALUES (p_BookID, p_Title, p_Publisher, p_NumberOfCopies, p_AvailabilityStatus);
END //

DELIMITER;
CALL AddNewBook('B016', 'The YOO', 'HarperOne', 17, 'Available');
select * from Books;


DELIMITER //
CREATE PROCEDURE GetBookDetailsByID(
    IN p_BookID VARCHAR(10)
)
BEGIN
    SELECT * 
    FROM Books
    WHERE BookID = p_BookID;
END //

DELIMITER ;
CALL GetBookDetailsByID('B006');



DELIMITER //
-- We don’t use any input parameters because it’s designed to show all books in the table.
CREATE PROCEDURE ShowAllBooks()
BEGIN
    SELECT 
        Title,
        NumberOfCopies,
        AvailabiltyStatus
    FROM 
        Books;
END //

DELIMITER ;
CALL ShowAllBooks();
SELECT * FROM LoanTracker;


DELIMITER //
CREATE PROCEDURE UpdateBookOnReturn(
    IN p_BookID VARCHAR(10)
)
BEGIN
    -- Increment the number of copies for the returned book
    UPDATE Books
    SET NumberOfCopies = NumberOfCopies + 1
    WHERE BookID = p_BookID;
    
    -- Update availability status based on the updated number of copies
    UPDATE Books
    SET AvailabiltyStatus = 'Available'
    WHERE BookID = p_BookID AND NumberOfCopies > 0;
END //

DELIMITER ;

CALL UpdateBookOnReturn('B001');
SELECT * FROM Books;

SELECT * FROM Borrower;


DELIMITER //
CREATE PROCEDURE AddNewBorrower(
    IN p_BorrowerID VARCHAR(10),
    IN p_BorrowerName VARCHAR(35),
    IN p_Gender CHAR(1),
    IN p_PhoneNumber VARCHAR(10),
    IN p_Email VARCHAR(25),
    IN p_Programme VARCHAR(15),
    IN p_BookID VARCHAR(10)
)
BEGIN
    -- Insert the new borrower data into the Borrower table
    INSERT INTO Borrower (BorrowerID, BorrowerName, Gender, PhoneNumber, Email, Programme, BookID)
    VALUES (p_BorrowerID, p_BorrowerName, p_Gender, p_PhoneNumber, p_Email, p_Programme, p_BookID);
END //

DELIMITER ;
CALL AddNewBorrower('BR08', 'Zake Hudson', 'M', '0758356123', 'zakehudson@8.com', 'BCOM', 'B005');

DELIMITER //

CREATE PROCEDURE ViewBorrowers()
BEGIN
    -- Select all records from the Borrower table
    SELECT * FROM Borrower;
END //
DELIMITER ;
CALL ViewBorrowers();

SELECT * from  Librarian;
show databases;




-- TRIGGERS
Show triggers in HQ_Library;

-- AFTER INSERT 
-- This trigger activates after data is inserted into the Book table. It logs new entries in the BookAudit table.

CREATE TABLE BookAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    BookID VARCHAR(10),
    Action VARCHAR(20),
    ActionTime DATETIME
);

DELIMITER //
CREATE TRIGGER after_insert_books
AFTER INSERT ON Books
FOR EACH ROW
BEGIN
    INSERT INTO BookAudit (BookID, Action, ActionTime)
    VALUES (NEW.BookID, 'Inserted', NOW());
END //
DELIMITER ;
INSERT INTO Books (BookID, Title, Publisher, NumberOfCopies, AvailabiltyStatus)
VALUES ('B017', 'Super', 'Kolo Muani', 5, 'Available');
SELECT * FROM BookAudit;
desc books;
SELECT* from Books;




-- AFTER UPDATE
-- This trigger activates after data is updated in the Borrower table. It logs new entries in the Borrower table into the BorrowersAudit.
CREATE TABLE BorrowerAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    BorrowerID VARCHAR(10),
    Action VARCHAR(20),
    ActionTime DATETIME,
    OldData VARCHAR(50) NULL,
    NewData VARCHAR(50) NULL
);

DELIMITER //
CREATE TRIGGER after_update_borrower
AFTER UPDATE ON Borrower
FOR EACH ROW
BEGIN
    INSERT INTO BorrowerAudit (BorrowerID, Action, ActionTime, OldData, NewData)
    VALUES (OLD.BorrowerID, 'Updated', NOW(), OLD.Email, NEW.Email);
END //
DELIMITER ;

UPDATE Borrower SET Email = 'mk2024@gmail.com' WHERE BorrowerID = 'BR05';
SELECT * FROM BorrowerAudit;
desc Borrower;
select * from borrower;


-- AFTER DELETE
-- This trigger activates after data is deleted from the Penalty table. It logs new entries in the penaltyAudit.
SELECT * FROM Penalty;
 insert INTO Penalty VALUES("Code3","Lost","BR08","B005",100000,"Cleared");

CREATE TABLE PenaltyAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    PenaltyCode VARCHAR(10),
    Action VARCHAR(20),
    ActionTime DATETIME
);

 DELIMITER //
CREATE TRIGGER after_delete_penalty
AFTER DELETE ON Penalty
FOR EACH ROW
BEGIN
    INSERT INTO PenaltyAudit (PenaltyCode, Action, ActionTime)
    VALUES (OLD.PenaltyCode, 'Deleted', NOW());
END //
DELIMITER ;
DELETE FROM Penalty WHERE PenaltyCode = 'Code3';
SELECT * FROM PenaltyAudit;



-- BEFORE INSERT
-- Trigger validates foreign (BorrowerID,BookID) keys before inserting a new record into LoanTracker
CREATE TABLE LoanTrackerAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    AttemptedBookID INT,
    AttemptedBorrowerID INT,
    Action VARCHAR(20),          
    ActionTime DATETIME,          
    ErrorMessage VARCHAR(100)     
);

DELIMITER //
CREATE TRIGGER before_insert_loantracker
BEFORE INSERT ON LoanTracker
FOR EACH ROW
BEGIN
    -- Check if the BookID exists in the Books table
    IF NOT EXISTS (SELECT 1 FROM Books WHERE BookID = NEW.BookID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid BookID';
    END IF;

    -- Check if the BorrowerID exists in the Borrower table
    IF NOT EXISTS (SELECT 1 FROM Borrower WHERE BorrowerID = NEW.BorrowerID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid BorrowerID';
    END IF;
END //
DELIMITER ;

SELECT * FROM LoanTracker;
SELECT * FROM Borrower;
SELECT * FROM Books;
INSERT INTO LoanTracker VALUES ("LN06","BR010","B002",2,"2024-07-1","4:00PM", DATE_ADD('2024-07-1',INTERVAL 1 WEEK), "L002");





-- BEFORE DELETE
 -- Trigger to prevent deleting a book record if there are available copies 
select * from Books;
DELIMITER //
CREATE TRIGGER before_delete_books
BEFORE DELETE ON Books
FOR EACH ROW
BEGIN
    IF OLD.NumberOfCopies > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete a book with available copies';
    END IF;
END //
select * from Books;

DELIMITER ;

UPDATE Books set NumberOfCopies=0 where BookID ="B010";
SELECT * FROM Books;
-- deleted example with no available copies/ zero copies
DELETE From  Books where BookID = 'B001';
-- example with available copies
DELETE From  Books where BookID = 'B001';



-- Before Update
-- Trigger to log changes in the NumberOfCopies for books in the Books table
CREATE TABLE Booklogs (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    BookID VARCHAR(10),
    Action VARCHAR(20),
    ActionTime DATETIME,
    OldNumberOfCopies INT,
    NewNumberOfCopies INT
);

DELIMITER //
CREATE TRIGGER before_update_books
BEFORE UPDATE ON Books
FOR EACH ROW
BEGIN
    -- Check if the NumberOfCopies has changed
    IF OLD.NumberOfCopies != NEW.NumberOfCopies THEN
        -- Insert an entry into the BooksAudit table with the old and new values
        INSERT INTO Booklogs (BookID, Action, ActionTime, OldNumberOfCopies, NewNumberOfCopies)
        VALUES (OLD.BookID, 'Updated', NOW(), OLD.NumberOfCopies, NEW.NumberOfCopies);
    END IF;
END //

DELIMITER ;
select * FROM Books;

UPDATE Books set NumberOfCopies=10 where BookID = "B003";

SELECT * FROM Booklogs;






-- CREATING USERS
SHOW GRANTS FOR CURRENT_USER();


-- creating an admin user(L003(Amos))
CREATE USER 'Chief_librarian'@'localhost' IDENTIFIED BY 'admin@123';
GRANT ALL PRIVILEGES ON *.* TO 'Chief_librarian'@'localhost' WITH GRANT OPTION;


-- creating a other librarian accounts(L001, L002)
CREATE USER 'lib1'@'localhost' IDENTIFIED BY 'shift@7am';
GRANT SELECT, UPDATE, INSERT ON HQ_Library.* TO 'lib1'@'localhost'; 




-- creating an online user
CREATE USER 'user1'@'localhost' IDENTIFIED BY 'user@123';
GRANT SELECT ON HQ_Library.* TO 'user1'@'localhost';
REVOKE SELECT ON HQ_Library.* FROM 'user1'@'localhost';
GRANT SELECT ON HQ_Library.Resources TO 'user1'@'localhost';




SELECT * FROM LoanTracker;

-- creating a physical users(borrower)
-- allowing them access to what they need to know or belongs to them.
CREATE USER 'library_user'@'localhost' IDENTIFIED BY 'library_password';
GRANT SELECT (BookID, Title, Publisher, AvailabiltyStatus) ON HQ_Library.Books TO 'library_user'@'localhost';
GRANT SELECT (Reason, Amount, BookID) ON HQ_Library.Penalty TO 'library_user'@'localhost';
GRANT SELECT (BorrowerID, BorrowerName, Gender, PhoneNumber, Email, Programme, BookID) ON HQ_Library.Borrower TO 'library_user'@'localhost';
GRANT SELECT (BorrowerID, BookID, LoanDate, ReturnDate, LibrarianID) ON HQ_Library.LoanTracker TO 'library_user'@'localhost';


-- creating another user account
CREATE USER 'library_user2'@'localhost' IDENTIFIED BY 'library_password';
GRANT SELECT (BookID, Title, Publisher, AvailabiltyStatus) ON HQ_Library.Books TO 'library_user2'@'localhost';
GRANT SELECT (Reason, Amount, BookID) ON HQ_Library.Penalty TO 'library_user2'@'localhost';
GRANT SELECT (BorrowerID, BorrowerName, Gender, PhoneNumber, Email, Programme, BookID) ON HQ_Library.Borrower TO 'library_user2'@'localhost';
GRANT SELECT (BorrowerID, BookID, LoanDate, ReturnDate, LibrarianID) ON HQ_Library.LoanTracker TO 'library_user2'@'localhost';


-- create a view and restrict to specific columns
-- creating a proedure on the view created



SELECT * from Books;


CREATE USER 'BSIT1'@'localhost' IDENTIFIED BY 'password';


-- Sample table 
create table donor(DonorID VARCHAR(10), name VARCHAR(15));






