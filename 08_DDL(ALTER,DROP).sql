--
/*
    DDL(ALTER, DROP)
    객체를 새롭게 생성(CREATE), 수정(ALTER), 삭제(DROP)하는 구문
    
    
    1. ALTER 
    객체 구조를 수정하는 구문.
    
    <테이블 수정>
    [표현법]
    ALTER TABLE 테이블명 수정할 내용;
    - 수정할 내용
    1) 칼럼 추가 / 수정 / 삭제
    2) 제약조건 추가 / 삭제 -> 수정은 불가(삭제후 추가는 가능)
    3) 테이블명 / 칼럼명 / 제약조건명 수정
*/

--1) 칼럼추가/수정/삭제
--1-1) 칼럼추가(ADD) : ADD 추가할 칼럼명 자료형 DEFAULT 기본값 단, DEFAULT 기본값은 생략가능.
SELECT * FROM DEPT_COPY;
--CNAME 칼럼추가.
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);
-- 새로운 칼럼이 만들어지고 기본값으로 NULL값이 추가됨.

-- LNAME 칼럼추가 DEFAULT지정해서
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국'; 
-- 새로운 칼럼이 만들어지고 NULL값이 아닌 DEFAULT값으로 채워짐.

-- 1_2) 컬럼수정(MODIFY)
--      컬럼의 자료형 수정 : MODIFY 수정할 컬럼명 바꾸고자하는 자료형
--      DEFAULT 값 수정  : MODIFY 수정할 컬럼명 DEFAULT 바꾸고자하는 기본값
-- DEPT_COPY테이블로 DEPT_ID칼럼의 자료형을  CHAR(3)로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
-- 현재 변경하고자 하는 칼럼에 이미 CHAR형 문자열로 담겨있는 값을 완전 다른 타입으로 변경이 불가능함.
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;

-- 현재 변경하고자하는 칼럼에 담겨있는 값보다 작게는 변경 불가
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(1);

-- 한번에 여러개의 컬럼 변경 가능
-- DEPT_TITLE 칼럼의 데이터타입을 VARCHAR2(40)으로
-- LOCATION_ID 칼럼의 데이터타입을 VARCHAR2(2)
-- LNAME 컬럼의 기본값을 '미국'으로
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE VARCHAR2(40)
MODIFY LOCATION_ID VARCHAR2(2)
MODIFY LNAME DEFAULT '미국';

--1_3) 칼럼 삭제 (DROP COLUMN) : DROP COLUMN 삭제하고자 하는 칼럼명
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

SELECT * FROM DEPT_COPY2;

-- DEPT_ID 칼럼 지우기
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;
ROLLBACK; -- DML문만 ROLLBACK가능 // DDL문은 불가능(자동 COMMIT)

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
-- 테이블에 최소 1개의 컬럼은 존재해야함.

-- 2) 제약조건 추가 / 삭제
/*
    2_2) 제약조건 추가
    -PRIMARY KEY : ADD PRIMARY KEY (컬럼명);
    -FOREIGN KEY : ADD FOREIGN KEY (컬럼명) REFERENCES 참조할테이블(참조할칼럼)
    -UNIQUE : ADD UNIQUE(컬럼);
    -CHECK : ADD CHECK (컬럼에 대한 조건);
    -NOT NULL : MODIFY 컬럼명 NOT NULL;
    나만의 제약조건명 부여하고자 할때 : CONSTRAINT 제약조건명을 제약조건 앞에다가 추가.
    -> CONSTRAINT 제약조건명은 생략가능하다.(임의의 이름이 붙음)
    -> 주의사항 :현재 계정 내에 고유한 이름으로 부여해야함.
*/
-- DEPT_COPY테이블로 부터 
-- DEPT_ID칼럼에 PRIMARY KEY 제약조건 추가
-- DEPT_TITLE칼럼에 UNIQUE 제약조건 추가
-- LNAME 칼럼에 NOT NULL 제약조건 추가
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DCOPY_PK PRIMARY KEY (DEPT_ID)
ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL;

/*
    2_2) 제약조건 삭제
    PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK : DROP CONSTRAINT 제약조건명
    NOT NULL : MODIFY 컬럼명 NULL;
*/

-- DEPT_COPY 테이블에 DCOPY_PK 지우기
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;


