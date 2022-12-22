--DDL
--1
CREATE TABLE TB_CATEGORY(
    NAME VARCHAR2(10),
    USE_YN CHAR(1) DEFAULT 'Y'
);

--2
CREATE TABLE TB_CLASS_TYPE(
    NO VARCHAR2(5) PRIMARY KEY,
    NAME VARCHAR2(10)
);

--3
ALTER TABLE TB_CATEGORY ADD PRIMARY KEY(NAME);

--4
ALTER TABLE TB_CLASS_TYPE MODIFY NAME NOT NULL;

--5
ALTER TABLE TB_CATEGORY MODIFY NAME VARCHAR2(20);
ALTER TABLE TB_CLASS_TYPE MODIFY NO VARCHAR2(10);

--6
ALTER TABLE TB_CATEGORY RENAME COLUMN NAME TO CATEGORY_NAME;
ALTER TABLE TB_CLASS_TYPE RENAME COLUMN NO TO CLASS_TYPE_NO;

--7
ALTER TABLE TB_CATEGORY RENAME CONSTRAINT SYS_C0011519 TO PK_CATEGORY_NAME;
ALTER TABLE TB_CLASS_TYPE RENAME CONSTRAINT SYS_C0011518 TO PK_CLASS_TYPE_NO;

--8
INSERT INTO TB_CATEGORY VALUES ('공학','Y');
INSERT INTO TB_CATEGORY VALUES ('자연과학','Y');
INSERT INTO TB_CATEGORY VALUES ('의학','Y');
INSERT INTO TB_CATEGORY VALUES ('예체능','Y');
INSERT INTO TB_CATEGORY VALUES ('인문사회','Y');
COMMIT;

--9
ALTER TABLE TB_DEPARTMENT ADD CONSTRAINT FK_DEPARTMENT_CATEGORY FOREIGN KEY(CATEGORY) REFERENCES TB_CATEGORY(CATEGORY_NAME);

--10
GRANT CREATE VIEW TO WORKBOOK; -- VIEW 생성 권한 부여 (SYSTEM관리자계정)

CREATE VIEW VW_학생일반정보
AS SELECT STUDENT_NO AS "학번"
        , STUDENT_NAME AS "학생이름"
        , STUDENT_ADDRESS AS "주소"
     FROM TB_STUDENT;
     
--11
CREATE VIEW VW_지도면담
AS SELECT STUDENT_NAME AS "학생이름"
        , DEPARTMENT_NAME AS "학과이름"
        , PROFESSOR_NAME AS "지도교수이름"
     FROM TB_STUDENT S
        , TB_PROFESSOR P
        , TB_DEPARTMENT D
    WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO
      AND S.COACH_PROFESSOR_NO = P.PROFESSOR_NO;

SELECT * FROM VW_지도면담;


--12
CREATE VIEW VW_학과별학생수
AS SELECT DEPARTMENT_NAME
        , COUNT(DEPARTMENT_NAME) AS "STUDENT_COUNT"
     FROM TB_DEPARTMENT D
        , TB_STUDENT S
    WHERE D.DEPARTMENT_NO = S.DEPARTMENT_NO
    GROUP BY DEPARTMENT_NAME;
    
SELECT * FROM VW_학과별학생수;

--13
UPDATE VW_학생일반정보 
   SET 학생이름 = '김홍석' 
 WHERE 학번 = 'A213046';
 
SELECT * FROM VW_학생일반정보; 

--14
/* READ ONLY 또는 CHECK OPTION 부여 */

--15
SELECT S.*
  FROM (SELECT G.CLASS_NO AS "과목번호"
             , C.CLASS_NAME AS "과목이름"
             , COUNT(G.CLASS_NO) AS "누적수강생수(명)"
          FROM TB_CLASS C
             , TB_GRADE G
         WHERE C.CLASS_NO = G.CLASS_NO
           AND SUBSTR(TERM_NO,1,4) >= 2005
         GROUP BY G.CLASS_NO, C.CLASS_NAME
         ORDER BY "누적수강생수(명)" DESC) S
 WHERE ROWNUM <= 3;
    