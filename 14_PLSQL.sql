/*
    <PL/SQL>
    PROCEDURE LANGUAGE EXTENSION TO SQL
    
    오라클 자체에 내장되어있는 절차적 언어.
    SQL 문장내에서 변수의 정의, 조건처리(IF), 반복문처리(LOOP, FOR, WHILE), 예외처리등을 지원하여 SQL문 단점을 보완.
    다수의 SQL문을 한번에 실행가능
    
    PL/SQL문의 구조
    - [선언부(DECLARE SECTION)] : DECLARE로 시작, 변수나 상수를 선언 및 초기화 하는 부분
    - 실행부(EXECUTABLE SECTION) : BEGIN으로 시작, SQL문 또는 제어문 등의 로직을 기술하는 부분
    - [예외처리부(EXCEPTION SECTION)] : EXCEPTION로 시작, 예외발생시 해결하기 위한 구문을 미리 기술하는 부분
    
*/

-- * 화면에 HELLO ORACLE 출력해보기
-- 1) 서버 아웃풋 옵션을 켜줌

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/
/*
-- 주석을 PL문 뒤에쓰면 오류남 / 마침표는 /로 구분함
    1. DECLARE 선언부
    변수 나 상수를 선언 하는 공간(선언과동시에 초기화도 가능함.)
    일반타입 변수, 레퍼런스 변수, ROW타입 변수
    
    1_1) 일반타입변수 선언 및 초기화
    [표현식] 변수명 [CONSTANT] 자료형 [:=값];  //:= 오라클 대입연산자
*/

DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    -- EID := 800;
    EID := &번호;
    -- ENAME := '민경민';
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);

END;
/
--이게 있어야 블록의 종결로 간주됨
-- 1_2) 레퍼런스 타입 변수 선언 및 초기화(어떤테이블의 어떤칼럼의 데이터타입을 참조해서 그 타입으로 지정)
-- [표현식] 변수명 테이블명.컬럼명%TYPE;
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := 300;
    ENAME := '경민';
    SALARY := 3000000;
    -- 사원의 사번이 200번인 각 사원의 사번, 사원명, 연봉을 대입.
    SELECT EMP_ID
         , EMP_NAME
         , SALARY
      INTO EID
         , ENAME
         , SALARY
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || SALARY);
END;
/

---------------------------실습문제------------------------------------
/*
    레퍼런스타입 변수로 EID ,ENAME, JCODE, SAL, DTITLE을 선언하고
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY)
    DEPARTMENT(DEPT_TITLE)을 참조하도록
    
    사용자가 입력한 사번인 사원의 사번, 사원명, 직급코드, 급여, 부서명 조회후
    변수에 담아서 출력
*/
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
    SELECT EMP_ID
         , EMP_NAME
         , JOB_CODE
         , SALARY
         , DEPT_TITLE
      INTO EID
         , ENAME
         , JCODE
         , SAL
         , DTITLE
      FROM EMPLOYEE E
         , DEPARTMENT D
     WHERE E.DEPT_CODE = D.DEPT_ID
       AND EMP_ID = &사번;
       
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' || DTITLE);
       
END;
/
-----------------------------------------------------------------------------
-- 1_3) ROW타입 변수선언
--      테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
--      [표현식] 변수명 테이블명 %ROWTYPE

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
      INTO E
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,0)); -- 보너스가 NULL일 경우 빈값으로 표시됨. NVL함수를 이용해서 0으로 표시해주기
    
END;
/

------------------------------------------------------------------
-- 2. BEGIN 실행부

/*
    <조건문>
    1) IF 조건식 THEN 실행내용
    
    사번 입력받은후 해당사원의 사번, 이름, 급여, 보너스율(%)를 출력
    단, 보너스를 받지 않는 사원은 보너스율 출력전'보너스를 지급받지 않는 사원입니다' 를 출력
*/

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID
         , EMP_NAME
         , SALARY
         , NVL(BONUS,0)
      INTO EID
         , ENAME
         , SALARY
         , BONUS
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS*100 || '(%)');
END;
/

-- 2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF;
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SALARY EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID
         , EMP_NAME
         , SALARY
         , NVL(BONUS,0)
      INTO EID
         , ENAME
         , SALARY
         , BONUS
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);
    IF BONUS = 0
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    ELSE DBMS_OUTPUT.PUT_LINE('보너스율 : ' || BONUS*100 || '(%)');
    END IF;

END;
/


----------------------------------실습문제-------------------------------------

-- 레퍼런스타입 변수 EID, ENAME, DTITLE, NCODE , 일반타입변수 TEAM VARCHAR2(10)
-- 참조할 칼럼(EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE)

-- 사용자가 입력한 사원의 사번, 이름, 부서명, 근무국가코드 조회후, 각 변수에 대입
-- NCODE의 값이 KO일경우 TEAM에 한국팀대입, 그게아닐경우 해외팀 대입
-- 사번, 이름, 부서, 소속(TEAM) 출력

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;  -- NATIONAL이라는 예약어가 있어서 NATIONAL 테이블을 참조하려면 계정명까지 붙여야함 KH.NATIONAL.~~
    TEAM VARCHAR2(10);
BEGIN
    SELECT EMP_ID
         , EMP_NAME
         , DEPT_TITLE
         , NATIONAL_CODE
      INTO EID
         , ENAME
         , DTITLE
         , NCODE
      FROM EMPLOYEE E
         , DEPARTMENT D
         , LOCATION L
     WHERE E.DEPT_CODE = D.DEPT_ID
       AND D.LOCATION_ID = L.LOCAL_CODE
       AND EMP_NAME = '&사원명';
    
    IF NCODE = 'KO' THEN
        TEAM := '한국팀';
    ELSE
        TEAM := '해외팀';
    END IF;       
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서 : ' || DTITLE);  
    DBMS_OUTPUT.PUT_LINE('소속 : '|| TEAM);
    
END;
/

---3) IF 조건식1 THEN 실행내용 ELSEIF 조건식 THEN 실행내용2[ELSE 실행내용] END IF;
-- 급여가 500만원 이상이면 고급
-- 급여가 300만원 이상이면 중급
-- 그외 초급
-- 출력문 : 해당 사원의 급여등급은 XX입니다

DECLARE 
    SALARY EMPLOYEE.SALARY%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY
         , EMP_NAME
      INTO SALARY
         , ENAME
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
     
     IF SALARY >= 5000000 THEN
        GRADE := '고급';
     ELSIF SALARY >= 3000000 THEN
        GRADE := '중급';
     ELSE
        GRADE := '초급';
     END IF;
     
     DBMS_OUTPUT.PUT_LINE(ENAME || '사원의 급여등급은 ' || GRADE || '입니다.');
END;
/

--4) CASE 비교대상자 WHEN 동등비교값1 THEN 결과값1 WHEN 비교값 2 ELSE 결과값3 END;

DECLARE 
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(10);
BEGIN
    SELECT *
      INTO EMP
      FROM EMPLOYEE
     WHERE EMP_ID = &사번;
     
     DNAME := CASE EMP.DEPT_CODE
                   WHEN 'D1' THEN '인사팀'
                   WHEN 'D2' THEN '회계팀'
                   WHEN 'D3' THEN '마케팅팀'
                   WHEN 'D4' THEN '국내영업팀'
                   WHEN 'D9' THEN '총무팀'
                   ELSE '해외영업팀'
              END;
    
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '은' || DNAME || '입니다.');




END;
/



--반복문
/*
    1) BASIC LOOP문
    [표현식]
    LOOP
        반복적으로 실행할 구문;
        *반복문을 빠져나갈수 있는 구문
    END LOOP;    
        
        
    
    
    
    *반복문을 빠져나갈수 있는 구문
    1) IF 조건식 THEN EXIT; END IF;
    2) EXIT WHEN 조건식;
*/

-- 1~5 까지 순차적으로 1씩 증가하는 값을 출력하는 반복문
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        
       /* 1번방법 
        IF I = 6 THEN
            EXIT;
        END IF;
        */  
        -- 2번 방법
        EXIT WHEN I = 6;
        
    END LOOP;
END;
/

/*
    2) FOR LOOP문
    FOR 변수 IN [REVERSE] 초기값 .. 최종값
    LOOP
        반복적으로 수행할 구문;
    END LOOP;
*/

BEGIN
    FOR I IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I); 
        -- I := I + 1; 증감식으로 활용 불가능 (DECLARE로 선언한 변수가아님)
    END LOOP;    
END;
/

DROP TABLE TEST;
CREATE TABLE TEST(
    TNO NUMBER PRIMARY KEY,
    TDATE DATE DEFAULT SYSDATE
);

CREATE SEQUENCE SEQ_TNO
START WITH 1
INCREMENT BY 2
MAXVALUE 1000
NOCYCLE
NOCACHE;

BEGIN
    FOR I IN 1..100
    LOOP
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL, DEFAULT); -- JAVA에서 객체를 LIST 단위로 데이터를 넣을때 활용
    END LOOP;    
END;
/

SELECT * FROM TEST;
SELECT * FROM DBA_DATA_FILES;
SELECT TABLESPACE_NAME, BYTES, BLOCKS FROM DBA_FREE_SPACE;
/*
    --3) WHILE LOOP문
    [표현식]
    WHILE 반복문이 수행될 조건
    LOOP
        반복적으로 실행시킬 구문
    END LOOP;
*/

DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I < 6
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
    END LOOP;
END;
/
----------------------------------------------------------------------
--4) 예외처리부
/*
    예외(EXCEPTION) : 실행중 발생하는 오류
    [표현식]
    EXCEPTION
        WHEN 예외1 THEN 예외처리구문1;
        WHEN 예외2 THEN 예외처리구문2;
        ..
        WHEN OTHERS THEN 예외처리구문;
        
    * 시스템 예외 (오라클에서 미리 정의해둔 예외)
    - NO_DATA_FOUND : SELECT한 결과가 한 행도 없는 경우
    - TOO_MANY_ROWS : SELECT한 결과가 여러행인 경우
    - ZERO_DIVIDE : 0으로 나눌때
    - DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배되었을때
*/

-- 사용자가 입력한 숫자로 나눗셈 연산을 한 결과를 출력하는 프로그램

DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10 / &숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : ' || RESULT);
EXCEPTION 
    --WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌수 없습니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('나누기 연산시 0으로 나눌수 없습니다.');
END;
/

-- UNIQUE 제약조건위배
BEGIN
    UPDATE EMPLOYEE
       SET EMP_ID = &사번
     WHERE EMP_NAME = '선동일';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미존재하는 사번입니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('알수없는에러발생');
END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID
         , EMP_NAME
      INTO EID
         , ENAME
      FROM EMPLOYEE
     WHERE MANAGER_ID = &사수사번;

    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회됨.');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('데이터가 없습니다.');
END;
/










        
