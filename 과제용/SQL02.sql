--1
SELECT STUDENT_NO AS 학번,
       STUDENT_NAME AS 이름,
       ENTRANCE_DATE AS 입학년도 --포맷바꾸기
  FROM TB_STUDENT
 WHERE DEPARTMENT_NO = '002'
 ORDER BY ENTRANCE_DATE;
 
--2
SELECT PROFESSOR_NAME,
       PROFESSOR_SSN
  FROM TB_PROFESSOR
 WHERE PROFESSOR_NAME NOT LIKE '___';
 
--3
SELECT PROFESSOR_NAME AS 교수이름
       SUB(PROFESSER_SSN,0,2) AS 나이
       
--4
SELECT PROFESSOR_NAME AS 이름