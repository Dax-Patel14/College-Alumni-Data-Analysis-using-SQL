## 1. Create new schema as alumni
CREATE SCHEMA alumni;
USE alumni;
-- screenshot(P2_Q1) attached

## 2. Import all .csv files into MySQL
-- (right click on alumni schema -> Table Data import Wizard -> Give path of the file -> Next -> choose options : Create a new table , select drop if exist -> next -> next)
-- screenshot(P2_Q2) attached


## 3. Run SQL command to see the structure of six tables
DESC college_a_hs;
DESC college_a_se;
DESC college_a_sj;
DESC college_b_hs;
DESC college_b_se;
DESC college_b_sj;

## 4. Display first 1000 rows of tables (College_A_HS, College_A_SE, College_A_SJ, College_B_HS, College_B_SE, College_B_SJ) with Python.
-- Jupyter Notebook File(SQL_Project2) attached

## 5. Import first 1500 rows of tables (College_A_HS, College_A_SE, College_A_SJ, College_B_HS, College_B_SE, College_B_SJ) into MS Excel
-- Excel File(SQL_Project2_Q5) attached

## 6. Perform data cleaning on table College_A_HS and store cleaned data in view College_A_HS_V, Remove null values. 

CREATE OR REPLACE VIEW college_a_hs_v as
SELECT * FROM college_a_hs
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL
AND Name IS NOT NULL AND FatherName IS NOT NULL
AND MotherName IS NOT NULL AND Batch IS NOT NULL
AND Degree IS NOT NULL AND PresentStatus IS NOT NULL
AND EntranceExam IS NOT NULL AND HSDegree IS NOT NULL
AND Institute IS NOT NULL AND Location IS NOT NULL;

SELECT * FROM college_a_hs_v;


## 7. Perform data cleaning on table College_A_SE and store cleaned data in view College_A_SE_V, Remove null values.

CREATE OR REPLACE VIEW college_a_se_v as
SELECT * FROM college_a_se
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL
AND Name IS NOT NULL AND FatherName IS NOT NULL
AND MotherName IS NOT NULL AND Batch IS NOT NULL
AND Degree IS NOT NULL AND PresentStatus IS NOT NULL
AND Organization IS NOT NULL AND Location IS NOT NULL;

SELECT * FROM college_a_se_v;

## 8. Perform data cleaning on table College_A_SJ and store cleaned data in view College_A_SJ_V, Remove null values.
CREATE OR REPLACE VIEW college_a_sj_v as
SELECT * FROM college_a_sj
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL
AND FatherName IS NOT NULL AND MotherName IS NOT NULL
AND Batch IS NOT NULL AND Degree IS NOT NULL
AND PresentStatus IS NOT NULL AND Organization IS NOT NULL
AND Designation IS NOT NULL AND Location IS NOT NULL;

SELECT * FROM college_a_sj_v;

## 9. Perform data cleaning on table College_B_HS and store cleaned data in view College_B_HS_V, Remove null values.
CREATE OR REPLACE VIEW college_b_hs_v as
SELECT * FROM college_b_hs
WHERE RollNo IS NOT NULL
AND LastUpdate IS NOT NULL AND Name IS NOT NULL
AND FatherName IS NOT NULL AND MotherName IS NOT NULL
AND Branch IS NOT NULL AND Batch IS NOT NULL
AND Degree IS NOT NULL AND PresentStatus IS NOT NULL
AND HSDegree IS NOT NULL AND EntranceExam IS NOT NULL
AND Institute IS NOT NULL AND Location IS NOT NULL;

SELECT * FROM college_b_hs_v;

## 10. Perform data cleaning on table College_B_SE and store cleaned data in view College_B_SE_V, Remove null values.
CREATE OR REPLACE VIEW college_b_se_v as
SELECT * FROM college_b_se
WHERE RollNo IS NOT NULL
AND LastUpdate IS NOT NULL AND Name IS NOT NULL
AND FatherName IS NOT NULL AND MotherName IS NOT NULL
AND Branch IS NOT NULL AND Batch IS NOT NULL
AND Degree IS NOT NULL AND PresentStatus IS NOT NULL
AND Organization IS NOT NULL AND Location IS NOT NULL;

SELECT * FROM college_b_se_v;

## 11. Perform data cleaning on table College_B_SJ and store cleaned data in view College_B_SJ_V, Remove null values.
CREATE OR REPLACE VIEW college_b_sj_v as
SELECT * FROM college_b_sj
WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL
AND Name IS NOT NULL AND FatherName IS NOT NULL
AND MotherName IS NOT NULL AND Branch IS NOT NULL
AND Batch IS NOT NULL AND Degree IS NOT NULL
AND PresentStatus IS NOT NULL AND Organization IS NOT NULL
AND Designation IS NOT NULL AND Location IS NOT NULL;

SELECT * FROM college_b_sj_v;

## 12. Make procedure to use string function/s for converting record of Name, FatherName, MotherName into lower case for views (College_A_HS_V, College_A_SE_V, College_A_SJ_V, College_B_HS_V, College_B_SE_V, College_B_SJ_V)

DELIMITER ||
CREATE PROCEDURE college_lower()
BEGIN
SELECT RollNo,LastUpdate, lower(Name) Name,lower(FatherName) FatheName,lower(MotherName) MotherName,Batch,Degree,PresentStatus,HSDegree,EntranceExam,Institute,Location from college_a_hs_v;
SELECT RollNo,LastUpdate,lower(Name) Name,lower(FatherName) FatheName,lower(MotherName) MotherName,Batch,Degree,PresentStatus,Organization,Location from college_a_se_v;
SELECT RollNo,LastUpdate,lower(Name) Name,lower(FatherName) FatheName,lower(MotherName) MotherName,Batch,Degree,PresentStatus,Organization,Designation,Location from college_a_sj_v;
SELECT RollNo,LastUpdate,lower(Name) Name,lower(FatherName) FatheName,lower(MotherName) MotherName,Batch,Degree,PresentStatus,HSDegree,EntranceExam,Institute,Location from college_b_hs_v;
SELECT RollNo,LastUpdate,lower(Name) Name,lower(FatherName) FatheName,lower(MotherName) MotherName,Batch,Degree,PresentStatus,Organization,Location from college_b_se_v;
SELECT RollNo,LastUpdate,lower(Name) Name,lower(FatherName) FatheName,lower(MotherName) MotherName,Batch,Degree,PresentStatus,Organization,Designation,Location from college_b_sj_v;

END ||
DELIMITER ;

CALL college_lower();
-- screenshot(P2_Q12) attached


## 13. Import the created views (College_A_HS_V, College_A_SE_V, College_A_SJ_V, College_B_HS_V, College_B_SE_V, College_B_SJ_V) into MS Excel and make pivot chart for location of Alumni.
-- Excel File(SQL_Project2_Q13) attached

## 14. Write a query to create procedure get_name_collegeA using the cursor to fetch names of all students from college A.
DROP PROCEDURE IF EXISTS get_name_collegeA;

DELIMITER $$
CREATE PROCEDURE get_name_collegeA(INOUT name1 TEXT(40000))
BEGIN
	# Declare variable
	DECLARE finished INT DEFAULT 0;
	DECLARE namelist VARCHAR(16000) DEFAULT "";
    
    # Declare Cursor
    DECLARE namedetail CURSOR FOR SELECT name from college_a_hs UNION  
    SELECT name from college_a_se UNION
    SELECT name from college_a_sj;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=1;
    
    # open cursor 
    OPEN namedetail;
    
	-- starting label defination
    getnames: 
    -- Loop statement
		LOOP
    
		FETCH namedetail INTO namelist;
        IF finished = 1 THEN LEAVE getnames;
        END IF;
        
        SET name1 = CONCAT(namelist,';',name1);
        
        END LOOP getnames;
        
        # close cursor
        CLOSE namedetail;
    
END $$
DELIMITER ;

SET @name_a= '';
CALL get_name_collegeA(@name_a);
SELECT @name_a;
-- screenshot(P2_Q14) attached


## 15. Write a query to create procedure get_name_collegeB using the cursor to fetch names of all students from college B.
DROP PROCEDURE IF EXISTS get_name_collegeB;
DELIMITER \\
CREATE PROCEDURE get_name_collegeB(INOUT name2 TEXT(40000))
BEGIN
	# Declare variable
	DECLARE finished INT DEFAULT 0;
	DECLARE namelist VARCHAR(16000) DEFAULT "";
    
    # Declare Cursor
    DECLARE namedetail CURSOR FOR 
    SELECT name from college_b_hs UNION  
    SELECT name from college_b_se UNION
    SELECT name from college_b_sj;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished=1;
    
    # open cursor 
    OPEN namedetail;
    
	-- starting label defination
    getnames: 
    -- Loop statement
		LOOP
    
		FETCH namedetail INTO namelist;
        IF finished = 1 THEN LEAVE getnames;
        END IF;
        
        SET name2 = CONCAT(namelist,';',name2);
        
        END LOOP getnames;
        
        # close cursor
        CLOSE namedetail;
    
END \\
DELIMITER ;

SET @name_b= '';
CALL get_name_collegeB(@name_b);
SELECT @name_b;
-- screenshot(P2_Q15) attached

## 16. Calculate the percentage of career choice of College A and College B Alumni
-- (w.r.t Higher Studies, Self Employed and Service/Job)

SELECT "HigherStudies" PresentStatus,(SELECT COUNT(*) FROM college_a_hs)/
((SELECT COUNT(*) FROM college_a_hs) + (SELECT COUNT(*) FROM college_a_se) + (SELECT COUNT(*) FROM college_a_sj))*100
College_A_Percentage,
(SELECT COUNT(*) FROM college_b_hs)/
((SELECT COUNT(*) FROM college_b_hs) + (SELECT COUNT(*) FROM college_b_se) + (SELECT COUNT(*) FROM college_b_sj))*100
College_B_Percentage
UNION
SELECT "Self Employed" PresentStatus,(SELECT COUNT(*) FROM college_a_se)/
((SELECT COUNT(*) FROM college_a_hs) + (SELECT COUNT(*) FROM college_a_se) + (SELECT COUNT(*) FROM college_a_sj))*100
College_A_Percentage,
(SELECT COUNT(*) FROM college_b_se)/
((SELECT COUNT(*) FROM college_b_hs) + (SELECT COUNT(*) FROM college_b_se) + (SELECT COUNT(*) FROM college_b_sj))*100
College_B_Percentage
UNION
SELECT "Service Job" PresentStatus,(SELECT COUNT(*) FROM college_a_sj)/
((SELECT COUNT(*) FROM college_a_hs) + (SELECT COUNT(*) FROM college_a_se) + (SELECT COUNT(*) FROM college_a_sj))*100
College_A_Percentage,
(SELECT COUNT(*) FROM college_b_sj)/
((SELECT COUNT(*) FROM college_b_hs) + (SELECT COUNT(*) FROM college_b_se) + (SELECT COUNT(*) FROM college_b_sj))*100
College_B_Percentage;

-- screenshot(P2_Q16)