/*
    DML(DATA MANIPULATION LANGUAGE)
    데이터 조작언어
    
    테이블에 새로운 데이터를 삽입(INSERT)하거나
    기존의 데이터를 수정(UPDATE)하거나
    삭제(DELETE) 하는 구문
    
*/


/*
    1. INSERT : 테이블에 새로운 행을 추가하는 구문
    
    [표현법]
    INSERT INTO ~~
    
    1) INSERT INTO 테이블명 VALUES(값1 , 값2, 값3 ...)
    => 해당 테이블에 "모든" 칼럼에 대해 추가하고자 하는 값을 내가 
       직접 제시해서 "한 행"씩 INSERT 할때 쓰는 방법.
       주의사항 : 컬럼의 순서, 자료형, 갯수를 맞춰서 VALUES 괄호 안에 값을 나열해야함.
       - 부족하게 제시했을 경우 : 에러 발생(칼럼의 갯수가 부족)
       - 값을 더 많이 제시한 경우 : 에버 발생 (TOO MANY VALUES)
*/

-- EMPLOYEE 테이블에 사원 정보 추가
INSERT INTO EMPLOYEE 
VALUES(900, '홍길동', '001213-3155674', 'hong@kh.or.kr' , '01099999999', 'D1','J7','S6',2200000,NULL,NULL,SYSDATE,NULL,'N');
INSERT INTO EMPLOYEE 
VALUES(901, '홍길동', '001213-3155674', 'hong@kh.or.kr' , '01099999999', 'D1','J7','S6',2200000,NULL,NULL,SYSDATE,NULL,DEFAULT);--DEFAULT 설정값 추가

SELECT * FROM EMPLOYEE;

/*
INSERT INTO 테이블명(컬럼명1, 컬럼명2, 컬럼명3)
VALUES(값1, 값2, 값3);
해당테이블에 특정 칼럼만 선택해서 그 칼럼에 추가할 값만 제시하고자 할 때 사용

- 그래도 한행 단위로 추가되기 때문에 선택이 안된 칼럼은 기본적으로 NULL OR DEFAULT 값이 들어감.
주의사항 : NOT NULL, PRIMARY KEY 제약 조건이 걸려있는 칼럼은 반드시 직접 값을 넣어줘야한다.
          NOT NULL + DEFAULT는 제외
*/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SAL_LEVEL)
VALUES (902,'민경민','990505-1111111','J7','S6');


/*
    3) INSERT INTO 테이블명(서브쿼리);
    => VALUES() 로 값을 직접 기술하는게 아니라, 서브쿼리로 조회한 결과값을 통째로 INSERT 하는 구문
    즉, 여러행을 한번에 INSERT 할 수 있음.

*/

-- 새로운 테이블
CREATE TABLE BOARD_IMAGE(
    BOARD_IMAGE_NO NUMBER PRIMARY KEY,
    ORIGIN_NAME VARCHAR2(100) NOT NULL,
    CHANGE_NAME VARCHAR2(100) NOT NULL
);
INSERT INTO BOARD_IMAGE
(
    SELECT 2 AS BOARD_IMAGE_NO  
         , 'abcD.jpg' AS ORIGIN_NAME
         , '2022122012345D.jpg' AS CHANGE_NAME
      FROM DUAL
     UNION
    SELECT 3 AS BOARD_IMAGE_NO  
         , 'abcE.jpg' AS ORIGIN_NAME
         , '2022122012345E.jpg' AS CHANGE_NAME
      FROM DUAL
      UNION
    SELECT 4 AS BOARD_IMAGE_NO  
         , 'abcF.jpg' AS ORIGIN_NAME
         , '2022122012345F.jpg' AS CHANGE_NAME
      FROM DUAL
      UNION
    SELECT 5 AS BOARD_IMAGE_NO  
         , 'abcG.jpg' AS ORIGIN_NAME
         , '2022122012345G.jpg' AS CHANGE_NAME
      FROM DUAL
      UNION
    SELECT 6 AS BOARD_IMAGE_NO  
         , 'abcH.jpg' AS ORIGIN_NAME
         , '2022122012345H.jpg' AS CHANGE_NAME
      FROM DUAL
      
);
SELECT * FROM BOARD_IMAGE;

/*
    INSERT ALL 계열
    2개 이상의 테이블에 각각 INSERT 할때 사용
    조건 : 그 때 사용되는 서브쿼리가 동일해야 한다.
    
    1) INSERT ALL
       INTO 테이블1 VALUES (값들 나열)
       INTO 테이블2 VALUES (값들 나열)

*/
-- 새로운 테이블 만들기
-- 첫번째 테이블 : 급여가 300만원 이상인 사원들의 사번, 사원명, 직급명을 보관할 테이블
-- 테이블명 : EMP_JOB / EMP_ID, EMP_NAME, JOB_NAME
CREATE TABLE EMP_JOB(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    JOB_NAME VARCHAR2(20)
);
-- 두번째 테이블 : 급여가 300만원 이상인 사원들의 사번, 사원명, 부서명을 보관할 테이블
-- 테이블 명 : EMP_DEPT / EMP_ID, EMP_NAME, DEPT_TITLE
CREATE TABLE EMP_DEPT(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(20)
);

-- 급여가 300만원 이상인 사원들의 사번, 사원명, 직급명 조회
SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 WHERE SALARY >= 3000000;

INSERT ALL
INTO EMP_JOB VALUES(EMP_ID,EMP_NAME , JOB_NAME)
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_TITLE)
SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DEPT_TITLE
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 WHERE SALARY >= 3000000;
 SELECT * FROM EMP_JOB;
 SELECT * FROM EMP_DEPT;
 
/*
    2) INSERT ALL
       WHEN 조건1 THEN
            INTO 테이블명1 VALUES(컬럼명)
       WHEN 조건2 THEN
            INTO 테이블명1 VALUES(컬럼명)     
       서브쿼리
       - 조건에 맞는 값만 넣고 싶을 때
*/ 
--- 테스트용 새로운 테이블 생성
-- 2010년도 기준으로 이전에 입사한 사원들의 사번, 사원명, 입사일, 급여를 담는 테이블(EMP_OLD)
CREATE TABLE EMP_OLD
AS SELECT EMP_ID
        , EMP_NAME
        , HIRE_DATE
        , SALARY
     FROM EMPLOYEE
    WHERE 1=0;
    
-- 2010년도 기준으로 이전에 입사한 사원들의 사번, 사원명, 입사일, 급여를 담는 테이블(EMP_NEW)
CREATE TABLE EMP_NEW
AS SELECT EMP_ID
        , EMP_NAME
        , HIRE_DATE
        , SALARY
     FROM EMPLOYEE
    WHERE 1=0;
    
--서브쿼리
SELECT EMP_ID
     , EMP_NAME
     , HIRE_DATE
     , SALARY
  FROM EMPLOYEE
 WHERE HIRE_DATE >='2010/01/01';     --2010년도 이후 입사자

SELECT EMP_ID
     , EMP_NAME
     , HIRE_DATE
     , SALARY
  FROM EMPLOYEE
 WHERE NOT HIRE_DATE >='2010/01/01'; --2010년도 이전 입사자
 
INSERT ALL
  WHEN HIRE_DATE < '2010/01/01' THEN
       INTO EMP_OLD(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
  WHEN HIRE_DATE >='2010/01/01' THEN
       INTO EMP_NEW(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID
     , EMP_NAME
     , HIRE_DATE
     , SALARY
  FROM EMPLOYEE;

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

DELETE FROM EMP_NEW;
DELETE FROM EMP_OLD;

/*
    UPDATE

*/