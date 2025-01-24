-- Active: 1696419593212@@127.0.0.1@3306
CREATE DATABASE UCU_Electoral_System;
    DEFAULT CHARACTER SET = 'utf8mb4';
    use UCU_Electoral_System;
    -- drop DATABASE UCU_Electoral_System;

    -- TABLES
CREATE TABLE Faculty(FacultyID VARCHAR(10) PRIMARY KEY, Faculty_Name VARCHAR(90) UNIQUE NOT NULL);
CREATE TABLE Programs (ProgramID VARCHAR(15) PRIMARY KEY, FacultyID VARCHAR(10), Program_Name VARCHAR(255) NOT NULL);
CREATE TABLE Posts(PostID INT PRIMARY KEY, PostName VARCHAR(100) NOT NULL, Description TEXT, Eligibility_criteria TEXT);
CREATE TABLE Users(
    UserID VARCHAR(100) PRIMARY KEY,
    Names VARCHAR(255) NOT NULL,
    Gender CHAR(1) NOT NULL CHECK (Gender IN ('M', 'F')),
    FacultyID VARCHAR(10),
    ProgramID VARCHAR(15),
    Nationality VARCHAR(50) NOT NULL, 
    Residency_Status ENUM('Resident', 'Non-Resident') NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    Role ENUM('voter', 'candidate and voter') DEFAULT 'voter',
    Password VARCHAR(255) NOT NULL, -- Stores the hashed password
    has_voted BOOLEAN DEFAULT FALSE
);
CREATE TABLE Applications(
    ApplicationID VARCHAR(10) PRIMARY KEY, 
    UserID VARCHAR(100)  NOT NULL,
    PostID INT  NOT NULL,
    Submission_time DATETIME NOT NULL,
    DocumentPath VARCHAR(255) NOT NULL,
    Deadline DATETIME NOT NULL DEFAULT '2024-12-04 23:59:59',
    Status ENUM('rejected', 'approved', 'submitted') DEFAULT 'submitted'  
);
CREATE TABLE Candidates(
    CandidateID VARCHAR(10) PRIMARY KEY, 
    ApplicationID VARCHAR(10),
    UserID VARCHAR(100),
    Names VARCHAR(70) NOT NULL, 
    Nationality VARCHAR(50) NOT NULL, 
    FacultyID VARCHAR(10), 
    ProgramID VARCHAR(15),
    Residency_Status VARCHAR(20) NOT NULL, 
    PostID INT, 
    is_nominated BOOLEAN DEFAULT FALSE
);
CREATE TABLE Nominees(
    NominationID INT AUTO_INCREMENT PRIMARY KEY,
    UserID VARCHAR(100),
    CandidateID VARCHAR(10),
    FacultyID VARCHAR(10),
    ProgramID VARCHAR(15),
    PostID INT,
    Nominated_by VARCHAR(100) NULL, 
    Nomination_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Vetting_status ENUM('pending', 'vetted', 'rejected') DEFAULT 'pending'
);   

SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME = 'Selected_Candidates'
  AND COLUMN_NAME = 'NominationID';

ALTER TABLE Selected_Candidates
DROP FOREIGN KEY selected_candidates_ibfk_2;

ALTER TABLE Nominees
MODIFY COLUMN NominationID INT AUTO_INCREMENT PRIMARY KEY;


CREATE TABLE Selected_Candidates(
    Selected_CandidateID VARCHAR(10) PRIMARY KEY,
    CandidateID VARCHAR(10),
    UserID VARCHAR(100),
    NominationID VARCHAR(10),
    Names VARCHAR(70),
    Nationality VARCHAR(50) NOT NULL,
    Residency_Status ENUM('Resident', 'Non-Resident'),
    FacultyID VARCHAR(10),
    ProgramID VARCHAR(15),
    PostID INT NOT NULL,
    DateAdded TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);    

CREATE TABLE Votes (
    VoteID INT AUTO_INCREMENT PRIMARY KEY,     
    UserID VARCHAR(100) NOT NULL,                     
    CandidateID VARCHAR(10) NOT NULL,                  
    PostID INT NOT NULL,                       
    vote_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Results (
    ResultID INT AUTO_INCREMENT PRIMARY KEY,
    PostID INT NOT NULL,
    PostName VARCHAR(100) NOT NULL, 
    CandidateID VARCHAR(10) NOT NULL,
    CandidateName VARCHAR(100) NOT NULL,  
    VoteCount INT DEFAULT 0,
    CandidateRank INT  
);
show tables;



-- FOREIGN KEYS
ALTER TABLE Programs add FOREIGN KEY(FacultyID) REFERENCES Faculty(FacultyID);
ALTER TABLE Applications add FOREIGN KEY(UserID) REFERENCES Users(UserID);
ALTER TABLE Applications add FOREIGN KEY(PostID) REFERENCES Posts(PostID);
ALTER TABLE Candidates add FOREIGN KEY(UserID) REFERENCES Users(UserID);
ALTER TABLE Candidates add FOREIGN KEY(ApplicationID) REFERENCES Applications(ApplicationID);
ALTER TABLE Candidates add FOREIGN KEY(FacultyID) REFERENCES Faculty(FacultyID);
ALTER TABLE Candidates add FOREIGN KEY(PostID) REFERENCES Posts(PostID);
ALTER TABLE Candidates add FOREIGN KEY(ProgramID) REFERENCES Programs(ProgramID);
ALTER TABLE Users add FOREIGN KEY(FacultyID) REFERENCES Faculty(FacultyID);
ALTER TABLE Users add FOREIGN KEY(ProgramID) REFERENCES Programs(ProgramID);
ALTER TABLE Nominees add FOREIGN KEY(CandidateID) REFERENCES Candidates(CandidateID);
ALTER TABLE Nominees add FOREIGN KEY(UserID) REFERENCES Users(UserID);
ALTER TABLE Nominees add FOREIGN KEY(FacultyID) REFERENCES Faculty(FacultyID);
ALTER TABLE Nominees add FOREIGN KEY(PostID) REFERENCES Posts(PostID);
ALTER TABLE Nominees add FOREIGN KEY(ProgramID) REFERENCES Programs(ProgramID);
ALTER TABLE Selected_Candidates add FOREIGN KEY(CandidateID) REFERENCES Candidates(CandidateID);
ALTER TABLE Selected_Candidates add FOREIGN KEY(NominationID) REFERENCES Nominees(NominationID);
ALTER TABLE Selected_Candidates add FOREIGN KEY(UserID) REFERENCES Users(UserID);
ALTER TABLE Selected_Candidates add FOREIGN KEY(FacultyID) REFERENCES Faculty(FacultyID);
ALTER TABLE Selected_Candidates add FOREIGN KEY(PostID) REFERENCES Posts(PostID);
ALTER TABLE Selected_Candidates add FOREIGN KEY(ProgramID) REFERENCES Programs(ProgramID);
ALTER TABLE Votes add FOREIGN KEY(UserID) REFERENCES Users(UserID);
ALTER TABLE Votes add FOREIGN KEY(PostID) REFERENCES Posts(PostID);
ALTER TABLE Votes add FOREIGN KEY(CandidateID) REFERENCES Candidates(CandidateID);
ALTER TABLE Results add FOREIGN KEY(PostID) REFERENCES Posts(PostID);
ALTER TABLE Results add FOREIGN KEY(CandidateID) REFERENCES Candidates(CandidateID);

-- showing the constraints on the table.
SELECT 
    CONSTRAINT_NAME, 
    CONSTRAINT_TYPE, 
    TABLE_NAME 
FROM 
    information_schema.TABLE_CONSTRAINTS 
WHERE 
    TABLE_SCHEMA = 'UCU_Electoral_System';




-- PROCEDURES
    Show PROCEDURE status where db = 'UCU_Electoral_System';


    -- Procedure to add a user
DELIMITER $$
CREATE PROCEDURE AddUser(
    IN p_UserID VARCHAR(100),
    IN p_Names VARCHAR(255),
    IN p_Gender CHAR(1),
    IN p_FacultyID VARCHAR(10),
    IN p_Program VARCHAR(10),
    IN p_Nationality VARCHAR(50),
    IN p_Residency_Status ENUM('Resident', 'Non-Resident'),
    IN p_Email VARCHAR(255),
    IN p_Role ENUM('voter', 'candidate and voter'),
    IN p_has_voted BOOLEAN
)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE UserID = p_UserID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'UserID already exists.';
    END IF;
    IF EXISTS (SELECT 1 FROM Users WHERE Email = p_Email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists.';
    END IF;
    INSERT INTO Users (
        UserID, Names, Gender, FacultyID, Program, Nationality, 
        Residency_Status, Email, Role, has_voted
    )
    VALUES (
        p_UserID, p_Names, p_Gender, p_FacultyID, p_Program, p_Nationality,
        p_Residency_Status, p_Email, p_Role, p_has_voted
    );
END $$
DELIMITER ;




-- procedure to Handle Nominations and insert nominations into the Nominees table:
DELIMITER $$
CREATE PROCEDURE NominateCandidate (
    IN nominatorUserID VARCHAR(100), 
    IN candidateID VARCHAR(10),     
    IN postID INT                   
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Candidates
        WHERE CandidateID = candidateID
          AND PostID = postID
    ) THEN
        INSERT INTO Nominees (
            NominationID,
            UserID,
            CandidateID,
            FacultyID,
            ProgramID,
            PostID,
            Nominated_by,
            Nomination_Date,
            Vetting_status
        )
        SELECT 
            CONCAT('NOM', LPAD(COALESCE(MAX(CAST(SUBSTRING(NominationID, 4) AS UNSIGNED)), 0) + 1, 3, '0')), -- Generate NominationID
            C.UserID,
            C.CandidateID,
            C.FacultyID,
            C.ProgramID,
            C.PostID,
            nominatorUserID, 
            NOW(),           -- Current timestamp
            'pending'        -- Default vetting status
        FROM Candidates C
        WHERE C.CandidateID = candidateID AND C.PostID = postID;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid candidate or PostID specified.';
    END IF;
END$$
DELIMITER ;
CALL NominateCandidate('U001', 'CO002', 1);




-- a procedure created to enforce the rules for nominating candidates
DELIMITER $$
CREATE PROCEDURE NominateCandidate(
    IN CurrentUserID VARCHAR(100),  
    IN CandidateID VARCHAR(10),    
    IN NominatedBy VARCHAR(100)    
)
BEGIN
    DECLARE UserFacultyID VARCHAR(10);
    DECLARE CandidateFacultyID VARCHAR(10);
    DECLARE CandidateResidencyStatus VARCHAR(50);
    DECLARE UserResidencyStatus VARCHAR(50);
    DECLARE CandidatePostID INT;
    DECLARE UserNationality VARCHAR(50);
    SELECT FacultyID, Residency_Status, Nationality
    INTO UserFacultyID, UserResidencyStatus, UserNationality
    FROM Users
    WHERE UserID = CurrentUserID;

    SELECT FacultyID, Residency_Status, PostID
    INTO CandidateFacultyID, CandidateResidencyStatus, CandidatePostID
    FROM Candidates
    WHERE CandidateID = CandidateID;

    -- Rule 1: Check eligibility for MP Faculty posts (PostIDs: 5, 6, 7, 8, 9, 10)
    IF CandidatePostID IN (5, 6, 7, 8, 9, 10) THEN
        IF CandidateFacultyID != UserFacultyID THEN
            SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'You can only nominate candidates from your faculty for MP Faculty posts.';
        END IF;
    END IF;
    -- Rule 2: Check eligibility for MP Residents and MP Non-Residents
    IF CandidatePostID = 2 OR CandidatePostID = 3 THEN
        IF CandidateResidencyStatus != UserResidencyStatus THEN
            SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'Residency status mismatch: You can only nominate candidates with the same residency status.';
        END IF;
    END IF;

    -- Rule 3: Exclude Ugandan users from nominating MP International
    IF CandidatePostID = 4 THEN
        IF UserNationality = 'Ugandan' THEN
            SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'You cannot nominate MP International candidates if you are Ugandan.';
        END IF;
    END IF;
    -- Rule 4: Check if the candidate has already been nominated by this user
    IF EXISTS (
        SELECT 1 FROM Nominees 
        WHERE CandidateID = CandidateID 
          AND UserID = CurrentUserID
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You have already nominated this candidate.';
    END IF;
    -- If all conditions pass, insert the nomination into the Nominees table
    INSERT INTO Nominees (
        NominationID, 
        UserID, 
        CandidateID, 
        FacultyID, 
        ProgramID, 
        PostID, 
        Nominated_by, 
        Nomination_Date, 
        Vetting_status
    )
    SELECT 
        CONCAT('NOM', LPAD(FLOOR(RAND() * 10000), 4, '0')), 
        CurrentUserID, 
        CandidateID, 
        UserFacultyID, 
        NULL,            
        CandidatePostID, 
        NominatedBy, 
        NOW(), 
        'pending'
    FROM Candidates
    WHERE CandidateID = CandidateID;
END$$
DELIMITER ;




-- checks which candidates have voted and updates the has_voted column in the Users table to true
DELIMITER $$
CREATE PROCEDURE UpdateVoteStatus()
BEGIN
    UPDATE Users u
    JOIN Votes v ON u.UserID = v.UserID
    SET u.has_voted = TRUE
    WHERE v.UserID IS NOT NULL; 
END$$
DELIMITER ;
CALL UpdateVoteStatus();
select * from Users;



-- procedure Ensures all vetted candidates are moved to the Selected_Candidates table.
DELIMITER $$
CREATE PROCEDURE AddVettedToSelectedCandidates()
BEGIN
    INSERT INTO Selected_Candidates (
        Selected_CandidateID, 
        CandidateID, 
        UserID, 
        NominationID, 
        Names, 
        Nationality, 
        Residency_Status, 
        FacultyID, 
        ProgramID,
        PostID, 
        VettingStatus, 
        DateAdded
    )
    SELECT 
        CONCAT('SEL-', n.CandidateID) AS Selected_CandidateID,
        n.CandidateID,
        n.UserID,
        n.NominationID,
        u.Names,
        u.Nationality,
        u.Residency_Status,
        n.FacultyID,
        n.ProgramID,
        n.PostID,
        n.Vetting_status AS VettingStatus,
        CURRENT_TIMESTAMP AS DateAdded
    FROM Nominees n
    JOIN Users u ON n.UserID = u.UserID
    WHERE n.Vetting_status = 'vetted'
      AND n.CandidateID NOT IN (SELECT CandidateID FROM Selected_Candidates);
END $$
DELIMITER ;
CALL AddVettedToSelectedCandidates();




-- - Procedure that allows you to update the vetting_status column
CREATE TABLE VettingAuditLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY, 
    NominationID VARCHAR(10) NOT NULL, 
    Action VARCHAR(50) NOT NULL, 
    New_Status ENUM('pending', 'vetted', 'rejected') NOT NULL, 
    ChangeTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);
DELIMITER //
CREATE PROCEDURE UpdateVettingStatus(
    IN p_nomination_id VARCHAR(10),
    IN p_new_status ENUM('pending', 'vetted', 'rejected')
)
BEGIN
    IF p_new_status IN ('pending', 'vetted', 'rejected') THEN
        UPDATE Nominees
        SET Vetting_status = p_new_status
        WHERE NominationID = p_nomination_id;
        INSERT INTO VettingAuditLog (NominationID, Action, New_Status, ChangeTimestamp)
        VALUES (p_nomination_id, 'Status Updated', p_new_status, CURRENT_TIMESTAMP);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid vetting status. Allowed values: pending, vetted, rejected';
    END IF;
END//
DELIMITER;
SELECT * FROM VettingAuditLog;



-- procedure to cast votes
DELIMITER $$
CREATE PROCEDURE CastVote(
    IN p_user_id VARCHAR(100),
    IN p_candidate_id VARCHAR(10),
    IN p_post_id INT
)
BEGIN
    DECLARE candidate_name VARCHAR(100);
    DECLARE post_name VARCHAR(100);
    DECLARE vote_count INT;
    INSERT INTO Votes (UserID, CandidateID, PostID)
    VALUES (p_user_id, p_candidate_id, p_post_id);
    SELECT u.Names INTO candidate_name
    FROM Users u
    JOIN Candidates c ON u.UserID = c.UserID
    WHERE c.CandidateID = p_candidate_id;
    SELECT PostName INTO post_name
    FROM Posts
    WHERE PostID = p_post_id;
    SELECT COUNT(*) INTO vote_count
    FROM Votes
    WHERE CandidateID = p_candidate_id AND PostID = p_post_id;
    IF NOT EXISTS (
        SELECT 1
        FROM Results
        WHERE CandidateID = p_candidate_id AND PostID = p_post_id
    ) THEN
        INSERT INTO Results (PostID, PostName, CandidateID, CandidateName, VoteCount)
        VALUES (p_post_id, post_name, p_candidate_id, candidate_name, vote_count);
    ELSE
        UPDATE Results
        SET VoteCount = vote_count
        WHERE CandidateID = p_candidate_id AND PostID = p_post_id;
    END IF;
    -- Step 7: Rank the candidates based on votes for each post
    SET @rank = 0;
    -- Re-ranking candidates
    UPDATE Results r
    JOIN (
        SELECT CandidateID, VoteCount
        FROM Results
        WHERE PostID = p_post_id
        ORDER BY VoteCount DESC
    ) ranked_results
    ON r.CandidateID = ranked_results.CandidateID
    AND r.PostID = p_post_id
    SET r.CandidateRank = (@rank := @rank + 1);
END$$
DELIMITER ;
call castVote('U001', 'CO001', 1);






    -- TRIGGERS
    Show triggers in UCU_Electoral_System;

    -- trigger to prevent invalid programs from being inserted into the Programs table for a specific faculty,
   DELIMITER $$
CREATE TRIGGER validate_program_before_insert
BEFORE INSERT ON Programs
FOR EACH ROW
BEGIN
    IF NEW.FacultyID = 'F01' AND NEW.Program_Name NOT IN ('BSIT', 'BSCS', 'BSDS') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid program for this faculty.';
    END IF;
    IF NEW.FacultyID = 'F02' AND NEW.Program_Name NOT IN ('BBA', 'BSAF', 'BHRM') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid program for this faculty.';
    END IF;
     IF NEW.FacultyID = 'F03' AND NEW.Program_Name NOT IN ('LLB') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid program for this faculty.';
    END IF;
     IF NEW.FacultyID = 'F04' AND NEW.Program_Name NOT IN ('BPH', 'BSPH') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid program for this faculty.';
    END IF;
     IF NEW.FacultyID = 'F05' AND NEW.Program_Name NOT IN ('BAMC') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid program for this faculty.';
    END IF;
     IF NEW.FacultyID = 'F06' AND NEW.Program_Name NOT IN ('BSW', 'BPAM', 'BHRP') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid program for this faculty.';
    END IF;
END$$
DELIMITER ;


--  trigger that will ensure the document filename ends with .zip.
DELIMITER $$
CREATE TRIGGER check_zip_extension
BEFORE INSERT ON Applications
FOR EACH ROW
BEGIN
    IF NEW.DocumentPath NOT LIKE '%.zip' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The document must be a Zipped file.';
    END IF;
END$$
DELIMITER ;


-- Trigger to Prevent Late Submissions
DELIMITER $$
CREATE TRIGGER prevent_submission_after_deadline
BEFORE INSERT ON Applications
FOR EACH ROW
BEGIN
    -- Checks if the current time is past the deadline
    IF NOW() > '2024-12-04 23:59:59' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Submission not allowed. The deadline has passed.';
    END IF;
    SET NEW.Submission_time = NOW();
END$$
DELIMITER ;



-- Trigger for Approving an Application and also updates the Role in the Users Table to candidate and voter 
DELIMITER $$
CREATE TRIGGER approve_application
AFTER UPDATE ON Applications
FOR EACH ROW
BEGIN
    
    DECLARE newCandidateID VARCHAR(10);

    IF NEW.Status = 'approved' AND OLD.Status != 'approved' THEN
        UPDATE Users
        SET Role = 'candidate and voter'
        WHERE UserID = NEW.UserID;

        SELECT CONCAT('CO', LPAD(IFNULL(MAX(CAST(SUBSTRING(CandidateID, 3) AS UNSIGNED)), 0) + 1, 3, '0'))
        INTO newCandidateID
        FROM Candidates;

        INSERT INTO Candidates (CandidateID, ApplicationID, UserID, Names, Nationality, FacultyID, ProgramID, Residency_Status, PostID, is_nominated)
        SELECT newCandidateID, NEW.ApplicationID, NEW.UserID, U.Names, U.Nationality, U.FacultyID, U.ProgramID, U.Residency_Status, NEW.PostID, FALSE
        FROM Users U
        WHERE U.UserID = NEW.UserID;
    END IF;
END$$
DELIMITER ;




-- trigger to automatically hash the password if it’s inserted in plain text into the Users table:
DELIMITER $$
CREATE TRIGGER before_users_insert
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    IF NEW.Password IS NOT NULL THEN
        SET NEW.Password = SHA2(NEW.Password, 256);
    END IF;
END$$
DELIMITER ;

SELECT * FROM Users WHERE UserID = 'U001';
SELECT UserID, Nationality, Residency_Status FROM Users WHERE UserID = 'U001';





-- update the candidates when a nomination is deleted from the Nominees table,
DELIMITER //
CREATE TRIGGER after_nomination_delete
AFTER DELETE ON Nominees
FOR EACH ROW
BEGIN
    UPDATE Candidates
    SET is_nominated = FALSE
    WHERE CandidateID = OLD.CandidateID;
END //
DELIMITER ;
select * from Nominees;




-- Trigger to Ensure Two Nominations Per User Per Post
DELIMITER //
CREATE TRIGGER EnsureTwoNominations
BEFORE INSERT ON Nominees
FOR EACH ROW
BEGIN
    DECLARE nomination_count INT;
    SELECT COUNT(*)
    INTO nomination_count
    FROM Nominees
    WHERE Nominated_by = NEW.Nominated_by
      AND PostID = NEW.PostID;

    IF nomination_count >= 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A user can only nominate two candidates for a post.';
    END IF;
END;
//
DELIMITER ;




DELIMITER $$
CREATE TRIGGER validate_nomination_rules
BEFORE INSERT ON Nominees
FOR EACH ROW
BEGIN
    DECLARE user_nationality VARCHAR(50);
    DECLARE user_residency_status VARCHAR(20);
    DECLARE candidate_residency_status VARCHAR(20);
    -- Fetch details of the user making the nomination
    SELECT Nationality, Residency_Status INTO user_nationality, user_residency_status
    FROM Users
    WHERE UserID = NEW.Nominated_by;
    -- Fetch details of the candidate being nominated
    SELECT Residency_Status INTO candidate_residency_status
    FROM Users
    WHERE UserID = NEW.CandidateID;
    -- Rule 1: Ugandan users cannot nominate for MP International (PostID = 4)
    IF user_nationality = 'Ugandan' AND NEW.PostID = 4 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ugandan users cannot nominate for MP International Students.';
    END IF;
    -- Rule 2: Residents cannot nominate Non-Residents
    IF user_residency_status = 'Resident' AND candidate_residency_status = 'Non-Resident' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Residents cannot nominate Non-Residents.';
    END IF;
    -- Rule 3: Non-Residents cannot nominate Residents
    IF user_residency_status = 'Non-Resident' AND candidate_residency_status = 'Resident' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Non-Residents cannot nominate Residents.';
    END IF;
END$$
DELIMITER ;



-- Trigger to Insert Vetted Candidates into Selected_Candidates Table
DELIMITER $$
CREATE TRIGGER after_vetting_update
AFTER UPDATE ON Nominees
FOR EACH ROW
BEGIN
    IF NEW.Vetting_status = 'vetted' THEN
        INSERT INTO Selected_Candidates (
            Selected_CandidateID,
            CandidateID,
            UserID,
            NominationID,
            Names,
            Nationality,
            Residency_Status,
            FacultyID,
            ProgramID,
            PostID
        )
        VALUES (
            CONCAT('SC-', NEW.NominationID), -- Generate Selected_CandidateID
            NEW.CandidateID,
            NEW.UserID,
            NEW.NominationID,
            (SELECT Names FROM Candidates WHERE CandidateID = NEW.CandidateID), 
            (SELECT Nationality FROM Users WHERE UserID = NEW.UserID), 
            (SELECT Residency_Status FROM Users WHERE UserID = NEW.UserID), 
            (SELECT FacultyID FROM Users WHERE UserID = NEW.UserID), 
            (SELECT ProgramID FROM Users WHERE UserID = NEW.UserID),
            NEW.PostID
        );
    END IF;
END $$
DELIMITER ;




-- trigger will prevent a user from voting multiple times
DELIMITER $$
CREATE TRIGGER BeforeCastVote
BEFORE INSERT ON Votes
FOR EACH ROW
BEGIN
    DECLARE vote_exists INT;
    SELECT COUNT(*)
    INTO vote_exists
    FROM Votes
    WHERE UserID = NEW.UserID
    AND CandidateID = NEW.CandidateID
    AND PostID = NEW.PostID;
    IF vote_exists > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You have already voted for this candidate in this post.';
    END IF;
END$$
DELIMITER ;




DELIMITER $$
CREATE TRIGGER PreventUgandansFromVotingForMPInternational
BEFORE INSERT ON Votes
FOR EACH ROW
BEGIN
    DECLARE user_nationality VARCHAR(50);

    SELECT Nationality INTO user_nationality
    FROM Users
    WHERE UserID = NEW.UserID;
    -- Check if the user is Ugandan and attempting to vote for MP-International (PostID = 4)
    IF user_nationality = 'Ugandan' AND NEW.PostID = 4 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Ugandan users cannot vote for the MP-International post.';
    END IF;
END$$
DELIMITER ;


-- to Restrict Votes for MP Engineering Post
DELIMITER $$
CREATE TRIGGER restrict_vote_mp_engineering
BEFORE INSERT ON Votes
FOR EACH ROW
BEGIN
    DECLARE engineering_faculty_id VARCHAR(10);
    
    SELECT FacultyID INTO engineering_faculty_id
    FROM Faculty
    WHERE Faculty_Name = 'Faculty of Engineering, Design and technology';
    -- Check if the user belongs to the Faculty of Engineering
    IF (SELECT FacultyID FROM Users WHERE UserID = NEW.UserID) != engineering_faculty_id
       AND NEW.PostID = (SELECT PostID FROM Posts WHERE PostName = 'MP Faculty of Engineering, Design and technology') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cannot vote for MP Faculty of Engineering, Design and Technology if you do not belong to that faculty.';
    END IF;
END$$
DELIMITER ;



-- Restrict Voting for MP Residents Post
DELIMITER $$
CREATE TRIGGER restrict_vote_mp_residents
BEFORE INSERT ON Votes
FOR EACH ROW
BEGIN
    DECLARE mp_residents_post_id INT;
    DECLARE user_residency_status ENUM('Resident', 'Non-Resident');
   
    SELECT PostID 
    INTO mp_residents_post_id
    FROM Posts
    WHERE PostName = 'MP-Residents'
    LIMIT 1;
    
    SELECT Residency_Status
    INTO user_residency_status
    FROM Users
    WHERE UserID = NEW.UserID
    LIMIT 1;
    
    IF user_residency_status != 'Resident' AND NEW.PostID = mp_residents_post_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Only users with Residency_Status as Resident can vote for the MP Residents post.';
    END IF;
END$$
DELIMITER ;
drop trigger if exists restrict_vote_mp_residents;






SELECT * FROM Selected_Candidates;
-- --  This query ensures that existing vetted candidates are added to the Selected_Candidates table without duplication.
INSERT INTO Selected_Candidates (
    Selected_CandidateID, 
    CandidateID, 
    UserID, 
    NominationID, 
    Names, 
    Nationality, 
    Residency_Status, 
    FacultyID, 
    PostID,  
    DateAdded
)
SELECT 
    CONCAT('SEL-', n.CandidateID) AS Selected_CandidateID,
    n.CandidateID,
    n.UserID,
    n.NominationID,
    u.Names,
    u.Nationality,
    u.Residency_Status,
    n.FacultyID,
    n.PostID,
    CURRENT_TIMESTAMP AS DateAdded
FROM Nominees n
JOIN Users u ON n.UserID = u.UserID
WHERE n.Vetting_status = 'vetted'
  AND n.CandidateID NOT IN (SELECT CandidateID FROM Selected_Candidates);
  select * from Selected_Candidates;








-- INSERT DATA
INSERT INTO Faculty VALUES('F01', 'Faculty of Engineering, Design and technology');
INSERT INTO Faculty VALUES('F02', 'Faculty School of Business');
INSERT INTO Faculty VALUES('F03', 'Faculty of Law');
INSERT INTO Faculty VALUES('F04', 'Faculty School of Public Health, Nursing & Midwifery');
INSERT INTO Faculty VALUES('F05', 'Faculty Journalism, Media and Communication');
INSERT INTO Faculty VALUES('F06', 'Faculty of Social Sciences');
SELECT * FROM Faculty;


INSERT INTO Programs VALUES('PR1', 'F01', 'BSIT');
INSERT INTO Programs VALUES('PR2', 'F01', 'BSCS');
INSERT INTO Programs VALUES('PR3', 'F01', 'BSDS');
INSERT INTO Programs VALUES('PR4', 'F02', 'BBA');
INSERT INTO Programs VALUES('PR5', 'F02', 'BHRM');
INSERT INTO Programs VALUES('PR6', 'F03', 'LLB');
INSERT INTO Programs VALUES('PR7', 'F04', 'BPH');
INSERT INTO Programs VALUES('PR8', 'F04', 'BSPH');
INSERT INTO Programs VALUES('PR9', 'F06', 'BSW');
INSERT INTO Programs VALUES('PR10', 'F06', 'BPAM');
INSERT INTO Programs VALUES('PR11', 'F06', 'BHRP');
INSERT INTO Programs VALUES('PR12', 'F03', 'LLB');
INSERT INTO Programs VALUES('PR13', 'F05', 'BAMC');
SELECT * FROM Programs;

INSERT INTO Posts VALUES (1, 'Guild President', 'Head of the student guild and manages guild funds', 'Should not have any retakes, can come from any faculty');
INSERT INTO Posts VALUES(2, 'MP-Residents', 'Responsible for students residing under the school hostels', 'Must be a Resident of the University, Have one or no retakes');
INSERT INTO Posts VALUES(3, 'MP Non-Residents', 'Head of the students who reside outside hall', 'Must be a Non-resident, Have one or no retakes' );
INSERT INTO Posts VALUES(4, 'MP International Students', 'Representative responsible for overseeing the welfare of Non-Ugandan students', 'Must not be Ugandan, Have one or no retakes');
INSERT INTO Posts VALUES (5, 'MP Faculty of Engineering, Design and technology', 'Focuses on representing the interests of Engineering students, voicing their concerns to the faculty administration', 'Should not have any retakes and Must belong to the Engineering, Design and technology Faculty');
INSERT INTO Posts VALUES (6, 'MP Business School', 'Focuses on representing the interests of Business students', 'Should not have any retakes and must belong to the Business Faculty');
INSERT INTO Posts VALUES (7, 'MP Law Society', 'Representing the interests of law students', 'Should not have any retakes and Must belong to the Law faculty');
INSERT INTO Posts VALUES (8, 'MP School of Journalism, media and Communication', 'Representing the interests of journalism students to the administration', 'Should not have any retakes and Must belong to the journalsim school');
INSERT INTO Posts VALUES (9, 'MP School of Nursing', 'Representing the interests of nursing students', 'Should not have any retakes and Must belong to nursing school');
INSERT INTO Posts VALUES (10, 'MP School of Social Sciences', 'Representing the SWASWA students and voicing their concerns to the faculty administration', 'Should not have any retakes and Must belong to the social works Department');
SELECT * FROM Posts;


SELECT * FROM Users;
alter table Users add constraint email_chk check (email like'%@%');
INSERT INTO Users VALUES('U001', 'Aber Charity', 'F', 'F01', 'PR2', 'Ugandan', 'Non-Resident', 'abercharity11@gmail.com', 'voter', 'Changeme@001', false);
INSERT INTO Users VALUES('U002', 'Abaasa Lynn', 'F', 'F04',  'PR7', 'Ugandan', 'Resident', 'abaasa2@gmail.com', 'voter', 'Changeme@002', false);
INSERT INTO Users VALUES('U003', 'Abura Peter', 'M', 'F06', 'PR9', 'Ugandan', 'Non-Resident', 'aburapeter12@gmail.com', 'voter', 'Changeme@003', false);
INSERT INTO Users VALUES('U004', 'Ebong Meshack', 'M', 'F03', 'PR12', 'Ugandan', 'Non-Resident', 'Ebong.M@gmail.com', 'voter', 'Changeme@004', false);
INSERT INTO Users VALUES('U005', 'Gwokyalya Loureen', 'F', 'F05', 'PR13', 'Ugandan', 'Resident', 'gwo.L12@gmail.com', 'voter', 'Changeme@005', false);
INSERT INTO Users VALUES('U006', 'Kizito Henry', 'M',  'F02', 'PR4', 'Ugandan', 'Non-Resident', 'K.H@gmail.com', 'voter', 'Changeme@006', false);
INSERT INTO Users VALUES('U007', 'Lugoba Patrik', 'M',  'F01', 'PR1', 'Ugandan', 'Resident', 'lugoba@gmail.com', 'voter', 'Changeme@007', false);
INSERT INTO Users VALUES('U008', 'Opira Nathan', 'M', 'F02', 'PR5', 'Ugandan', 'Non-Resident', 'opira.N@gmail.com', 'voter', 'Changeme@008', false);
INSERT INTO Users VALUES('U009', 'Achen Judith', 'F', 'F01', 'PR3', 'Kenyan', 'Resident', 'judithchen7@gmail.com', 'voter', 'Changeme@009', false);
INSERT INTO Users VALUES('U0010', 'Amito Betty', 'F', 'F05', 'PR13', 'Ugandan', 'Resident', 'amitobetty3@gmail.com', 'voter', 'Changeme@0010', false);
INSERT INTO Users VALUES('U0011', 'Ademba George', 'M', 'F04', 'PR8', 'Kenyan', 'Non-Resident', 'ademba@gmail.com', 'voter', 'Changeme@0011', false);
INSERT INTO Users VALUES('U0012', 'Kingston Allen', 'M', 'F05', 'PR13', 'American', 'Resident', 'kingallen@gmail.com', 'voter', 'Changeme@0012', false);
INSERT INTO Users VALUES('U0013', 'Musiimenta Daphine', 'F', 'F02', 'PR4', 'Ugandan', 'Non-Resident', 'daphineliz@gmail.com', 'voter', 'Changeme@0013', false);
INSERT INTO Users VALUES('U0014', 'Muhairwe Dominic', 'M', 'F06', 'PR10', 'Ugandan', 'Non-Resident', 'MD@gmail.com', 'voter', 'Changeme@0014', false);
INSERT INTO Users VALUES('U0015', ' Ntege Triga', 'M', 'F04', 'PR7', 'Ugandan', 'Resident', 'trigantege112@gmail.com', 'voter', 'Changeme@0015', false);
INSERT INTO Users VALUES('U0016', 'Rukundo Olive', 'F', 'F02', 'PR5', 'Ugandan', 'Resident', 'rukunda132@gmail.com', 'voter', 'Changeme@0016', false);
INSERT INTO Users VALUES('U0017', 'Nampima Rose', 'F', 'F06', 'PR11', 'Ugandan', 'Resident', 'rose.N@gmail.com', 'voter', 'Changeme@0017', false);
INSERT INTO Users VALUES('U0018', 'Mwesigye Samantha', 'F', 'F03', 'PR12', 'Ugandan', 'Non-Resident', 'samantha@gmail.com', 'voter', 'Changeme@0018', false);
INSERT INTO Users VALUES('U0019', 'Emma Wilson', 'M', 'F01', 'PR1', 'Kenyan', 'Non-Resident', 'E.Wilson@gmail.com', 'voter', 'Changeme@0019', false);
INSERT INTO Users VALUES('U0020', 'Sekisonge Timothy', 'M', 'F03', 'PR12', 'Ugandan', 'Non-Resident', 'ST-mothy@gmail.com', 'voter', 'Changeme@0020', false);
INSERT INTO Users VALUES('U0021', 'Harry Styles', 'M', 'F01', 'PR2', 'Ugandan', 'Non-Resident', 'harry@gmail.com', 'voter', 'Changeme@0021', false);
INSERT INTO Users VALUES('U0022', 'Chinedu Onyemma', 'M', 'F06', 'PR9', 'Nigerian', 'Resident', 'chineduonyemma@gmail.com', 'voter', 'Changeme@0022', false);
INSERT INTO Users VALUES('U0023', 'Baijuki Jemima', 'F', 'F03', 'PR12', 'Ugandan', 'Non-Resident', 'jemma10@gmail.com', 'voter', 'Changeme@0023', false);
INSERT INTO Users VALUES('U0024', 'Ojok Marvin', 'M', 'F03', 'PR12', 'Ugandan', 'Non-Resident', 'marvin.O@gmail.com', 'voter', 'Changeme@0024', false);
INSERT INTO Users VALUES('U0025', 'Atim sarah', 'F', 'F03', 'PR6', 'Ugandan', 'Non-Resident', 'atimsarah@gmail.com', 'voter', 'Changeme@0025', false);
INSERT INTO Users VALUES('U0026', 'Atom Akwankwasa', 'M', 'F01', 'PR3', 'Ugandan', 'Resident', 'atomix@gmail.com', 'voter', 'Changeme@0026', false);
INSERT INTO Users VALUES('U0027', 'Tendo Beatrice', 'F', 'F01', 'PR1', 'Ugandan', 'Non-Resident', 't.breecee@gmail.com', 'voter', 'Changeme@0027', false);
INSERT INTO Users VALUES('U0028', 'Auma Angella', 'F', 'F01', 'PR2', 'Ugandan', 'Non-Resident', 'angellaauma@gmail.com', 'voter', 'Changeme@0028', false);
INSERT INTO Users VALUES('U0029', 'Kaleygira Emma', 'M', 'F01', 'PR1', 'Ugandan', 'Non-Resident', 'k.emma@gmail.com', 'voter', 'Changeme@0029', false);
INSERT INTO Users VALUES('U0030', 'Madeng Samuel Deng', 'M', 'F01', 'PR3', 'South-Sudanese', 'Non-Resident', 'smdeng@gmail.com', 'voter',  'Changeme@0030', false);
INSERT INTO Users VALUES('U0031', 'Xhosa Cynthia', 'F', 'F01', 'PR2', 'South-African', 'Non-Resident', 'C.xhosa16@gmail.com', 'voter', 'Changeme@0031', false);
INSERT INTO Users VALUES('U0032', 'Ivy Namusoke', 'F', 'F02', 'PR4', 'Ugandan', 'Non-Resident', 'ivynamusoke0@gmail.com', 'voter', 'Changeme@0032', false);
INSERT INTO Users VALUES('U0033', 'Blessed Roland', 'M', 'F02', 'PR5', 'Ugandan', 'Non-Resident', 'roland@gmail.com', 'voter', 'Changeme@0033', false);
INSERT INTO Users VALUES('U0034', 'Kaitesi Ritah', 'F', 'F02', 'PR5', 'Ugandan', 'Resident', 'kaitesi@gmail.com', 'voter', 'Changeme@0034', false);
INSERT INTO Users VALUES('U0035', 'Nkunda Praise', 'F', 'F05', 'PR13', 'Ugandan', 'Non-Resident', 'praise.N@gmail.com', 'voter', 'Changeme@0035', false);


INSERT INTO Applications (ApplicationID, UserID, PostID, Submission_time, DocumentPath, Deadline, Status)
VALUES ('AP01', 'U002', 1, NOW(), '/documents/U002.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP02', 'U003', 1, NOW(), '/documents/U003.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP03', 'U0018', 1, NOW(), '/documents/U0018.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP04', 'U0028', 5, NOW(), '/documents/U0028.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP05', 'U0029', 5, NOW(), '/documents/U0029.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP06', 'U0026', 5, NOW(), '/documents/U0026.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP07', 'U0027', 5, NOW(), '/documents/U0027.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP08', 'U007', 2, NOW(), '/documents/U007.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP09', 'U0016', 2, NOW(), '/documents/U0016.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP010', 'U0017', 2, NOW(), '/documents/U0017.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP011', 'U0011', 4, NOW(), '/documents/U0011.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP012', 'U0030', 4, NOW(), '/documents/U0030.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP013', 'U0031', 4, NOW(), '/documents/U0031.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP014', 'U0023', 5, NOW(), '/documents/U0023.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP015', 'U0024', 5, NOW(), '/documents/U0024.zip', '2024-12-02 23:59:59', 'submitted'),
       ('AP016', 'U0025', 5, NOW(), '/documents/U0025.zip', '2024-12-02 23:59:59', 'submitted');

-- sample insertion
insert into Applications values('AP017', 'U0021', 5, NOW(), '/documents/U0025.zip', '2024-12-02 23:59:59', 'submitted');

select * from Applications;
select * from Users;
SELECT * FROM Candidates;
SELECT * FROM Nominees;
SELECT * FROM Selected_Candidates;
select * from Votes;
select * from Results;



-- query to retrieve the nomination count by each candidate:
SELECT 
    CandidateID,
    COUNT(*) AS NominationCount
FROM 
    Nominees
GROUP BY 
    CandidateID;

 



-- VIEWS
-- view to ShowCandidates that are eligible to be nominated
CREATE VIEW ShowCandidates AS
SELECT 
    c.Names AS CandidateName,
    c.CandidateID,
    p.PostName,
    p.PostID,
    p.Description AS PostDescription
FROM 
    Candidates c
JOIN 
    Posts p ON c.PostID = p.PostID;


-- view for rejected applications
CREATE VIEW RejectedApplications AS
SELECT *
FROM Applications
WHERE Status = 'rejected';
SELECT * FROM RejectedApplications;

-- those not nominated
CREATE VIEW NotNominatedCandidates AS
SELECT *
FROM Candidates
WHERE is_nominated = FALSE;
SELECT * FROM NotNominatedCandidates;



CREATE VIEW ResultsView AS
SELECT 
    PostName,
    CandidateName,
    VoteCount,
    CandidateRank
FROM Results;
SELECT * FROM ResultsView;



 






-- CREATING USER ACCOUNTS.
CREATE USER 'Admin'@'localhost' IDENTIFIED BY 'admin@123';
GRANT ALL PRIVILEGES ON UCU_Electoral_System.* TO 'Admin'@'localhost';
SELECT User, Host FROM mysql.user;



-- Create user accounts, assigning passwords and Grant EXECUTE privilege on the NominateCandidate procedure
CREATE USER 'U001'@'localhost' IDENTIFIED BY 'Changeme@001';
GRANT SELECT ON UCU_Electoral_System.Posts TO 'U001'@'localhost';
GRANT INSERT, SELECT ON UCU_Electoral_System.Applications TO 'U001'@'localhost';
GRANT EXECUTE ON PROCEDURE UCU_Electoral_System.NominateCandidate TO 'U001'@'localhost';
GRANT SELECT ON ShowCandidates TO 'U001'@'localhost';
GRANT EXECUTE ON PROCEDURE UCU_Electoral_System.CastVote TO 'U001'@'localhost';
GRANT SELECT ON ResultsView TO 'U001'@'localhost';

SHOW GRANTS FOR 'U0031'@'localhost';


CREATE USER 'U002'@'localhost' IDENTIFIED BY 'Changeme@002';
GRANT SELECT ON UCU_Electoral_System.Posts TO 'U002'@'localhost';
GRANT INSERT, SELECT ON UCU_Electoral_System.Applications TO 'U002'@'localhost';
GRANT EXECUTE ON PROCEDURE UCU_Electoral_System.NominateCandidate TO 'U002'@'localhost';
GRANT SELECT ON ShowCandidates TO 'U002'@'localhost';
GRANT EXECUTE ON PROCEDURE UCU_Electoral_System.CastVote TO 'U002'@'localhost';
GRANT SELECT ON ResultsView TO 'U002'@'localhost';



CREATE USER 'U0031'@'localhost' IDENTIFIED BY 'Changeme@0031';
GRANT SELECT ON UCU_Electoral_System.Posts TO 'U0031'@'localhost';
GRANT INSERT, SELECT ON UCU_Electoral_System.Applications TO 'U0031'@'localhost';

GRANT EXECUTE ON PROCEDURE UCU_Electoral_System.NominateCandidate TO 'U0031'@'localhost';
GRANT SELECT ON ShowCandidates TO 'U0031'@'localhost';
GRANT EXECUTE ON PROCEDURE UCU_Electoral_System.CastVote TO 'U0031'@'localhost';
GRANT SELECT ON ResultsView TO 'U0031'@'localhost';
















DROP USER 'Admin';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'Admin';
REVOKE ALL PRIVILEGES ON UCU_Electoral_Commission.* FROM 'Admin'@'localhost';

SELECT User, Host FROM mysql.user WHERE User = 'Admin';
