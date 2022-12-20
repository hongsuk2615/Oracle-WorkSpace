/*
    SUBQUERY (서브쿼리)
    하나의 주된 SQL (SELECT, CREATE, INSERT) 안에 포함된 또하나의 SELECT 문
    
    메인 SQL문을 위해서 보조 역할을 하는 SELECT 문
    -> 주로 조건절 안에서 쓰임.
*/
-- 간단 서브쿼리 예시 1
-- 노옹철 사원과 같은 부서인 사원들
-- 1) 노옹철 사원의 부서코드를 조회.
SELECT DEPT_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME = '노옹철';

-- 2) 부서코드가 D9인 사원들 조회
SELECT EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9';

-- 위의 두단계를 합치기.(서브쿼리 활용)
SELECT EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '노옹철');

-- 두번째 예시
-- 전체사원의 평균 급여보다 더 많은 급여를 받고 있는 사원들의 사번, 이름, 직급코드를 조회.

SELECT EMP_ID
     , EMP_NAME
     , DEPT_CODE
  FROM EMPLOYEE
 WHERE SALARY > (SELECT ROUND(AVG(SALARY))
                   FROM EMPLOYEE);
                   
/*
    서브쿼리 구분
    서브쿼리를 수행한 결과값이 몇행 몇열이냐에 따라서 분류가 됨.
    - 단일행 (단일열) 서브쿼리 : 서브쿼리를 수행한 결과값이 오직 1개일때(한칸의 칼럼값으로 나올때)
    - 다중행 (단일열) 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 행 일때
    - (단일행) 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러 열 일때
    - 다중행 다중열 서브쿼리   : 서브쿼리를 수행한 결과값이 여러행 여러열일때
    
    => 서브쿼리를 수행한 결과가 몇행 몇열이냐에 따라 사용가능한 연산자가 달라진다.
*/

/*
    1. 단일행 (단일열) 서브쿼리 (SINGLE ROW SUBQUERY)
    서브쿼리의 조회결과값이 오직 1개일때
    
    일반 연산자 사용가능( =, !=, >, <, >=, <=, ...)
*/
-- 전직원의 평균 급여보다 더 적게받는 사원들의 사원명, 직급코드, 급여 조회
SELECT EMP_NAME
     , DEPT_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY < (SELECT ROUND(AVG(SALARY))
                   FROM EMPLOYEE); -- 결과값이 1행 1열일때, 오로지 1개의 값
                   
-- 최저급여를 받는 사원의 사번, 사원명, 직급코드 ,급여, 입사일 조회
SELECT EMP_ID
     , EMP_NAME
     , JOB_CODE
     , SALARY
     , HIRE_DATE
  FROM EMPLOYEE
 WHERE SALARY = (SELECT MIN(SALARY)
                   FROM EMPLOYEE);
-- 노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEE
                  WHERE EMP_NAME = '노옹철');
                  
-- 사번, 이름, 부서명, 급여
SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , SALARY
  FROM EMPLOYEE
  LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEE
                  WHERE EMP_NAME = '노옹철');
                  
-- 부서별 급여합이 가장 큰 부서 하나만을 조회, 부서코드, 부서명, 급여합
SELECT DEPT_CODE
     , DEPT_TITLE
     , SUM(SALARY)
  FROM EMPLOYEE
  LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY) =(SELECT MAX(SUM(SALARY))
                       FROM EMPLOYEE
                      GROUP BY DEPT_CODE);
                       
/*
    2. 다중행 서브쿼리(MULTI ROW SUBQUERY)
    
    서브쿼리의 조회 결과값이 여러 행일 경우
    
    - IN (10, 20, 30 , ...) 서브쿼리 : 여러개의 결과값중에서 하나라도 일치하는 것이 있다면 / <-> NOT IN
    - > ANY  (10, 20, 30, ...) : 여러개의 결과값중에서 "하나라도" 클 경우, 여러개의 결과값중에서 가장 작은 값보다 클경우    OR
    - < ANY  (10, 20, 30, ...) : 여러개의 결과값중에서 "하나라도" 작을 경우, 여러개의 결과값중에서 가장 큰 값보다 작을경우  OR
    
    - > ALL : 여러개의 결과값이 모든 값보다 클경우         AND
              즉, 여러개의 결과값중에서 가장 큰값보다 클경우
    - < ALL : 여러개의 결과값이 모든 값보다 작을경우        AND
              즉, 여러개의 결과값중에서 가장 작은값보다 작을 경우       

*/

-- 각 부서별 최고급여를 받는 사원의 이름, 직급코드, 급여조회
-- 부서별 최고급여
SELECT MAX(SALARY)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;

SELECT EMP_NAME
     , JOB_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE SALARY IN (SELECT MAX(SALARY)
                    FROM EMPLOYEE
                   GROUP BY DEPT_CODE);

-- 선동일 또는 유재식과 같은 부서인 사원들을 조회하시요.(사원명, 부서코드, 급여)
SELECT EMP_NAME
     , DEPT_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE IN (SELECT DEPT_CODE
                       FROM EMPLOYEE
                      WHERE EMP_NAME IN ('선동일', '유재식'));

-- 이오리 또는 하동운 사원과 같은 직급인 사원들을 조회하시요(사원명, 직급코드, 부서코드, 급여)
SELECT EMP_NAME
     , JOB_CODE
     , DEPT_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE JOB_CODE IN ( SELECT JOB_CODE
                       FROM EMPLOYEE
                      WHERE EMP_NAME IN ('이오리', '하동운'));
                      
-- 사원 < 대리 < 과장 < 차장 < 부장
-- 대리 직급인데도 불구하고 과장 직급의 급여보다 많이 받는 사원들 조회
SELECT SALARY
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND JOB_NAME = '과장';
 
SELECT SALARY
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND JOB_NAME = '대리';

SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , SALARY
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE 
   AND JOB_NAME = '대리'
   AND SALARY >= ANY(SELECT SALARY
                       FROM EMPLOYEE E
                          , JOB J
                      WHERE E.JOB_CODE = J.JOB_CODE
                        AND JOB_NAME = '과장');
            
-- 과장직급임에도 불구하고 '모든' 차장직급의 급여보다도 더 많이 받는 직원 조회
-- 차장직급의 급여
SELECT SALARY
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND JOB_NAME = '차장';

SELECT EMP_ID
     , EMP_NAME
     , E.JOB_CODE
     , SALARY
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND JOB_NAME = '과장'
   AND SALARY > ALL ( SELECT SALARY
                        FROM EMPLOYEE E
                           , JOB J
                       WHERE E.JOB_CODE = J.JOB_CODE
                         AND JOB_NAME = '차장');
/*
    3. (단일행) 다중열 서브쿼리
    
    서브쿼리 조회 결과가 값은 한행이지만, 나열된 컬럼의 갯수가 여러개인 경우..
*/
-- 하이유사원과 같은 부서코드, 같은 직급코드에 해당되는 사원들 조회(사원명, 부서코드, 직급코드, 고용일)
-- 1) 하이유 사원의 부서코드와 직급코드 먼저 조회 => 단일행 다중열(DEPT_CODE, JOB_CODE)
SELECT DEPT_CODE
     , JOB_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME = '하이유';
-- 2) 부서코드가 D5이면서 직급코드가 J5인 사원들 조회.
SELECT EMP_NAME
     , DEPT_CODE
     , JOB_CODE
     , HIRE_DATE
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5' OR JOB_CODE = 'J5';
-- 3) 위의 내용물들을 하나의 쿼리문으로 합치기.
-- 다중열 서브쿼리(비교할 값의 순서를 맞추는게 중요하다)
-- (비교대상칼럼1, 비교대상 칼럼2) = (비교할 값 1, 비교할 값 2 ) -> 서브쿼리로 제시(리터럴은 안됨)
SELECT EMP_NAME
     , DEPT_CODE
     , JOB_CODE
     , HIRE_DATE
  FROM EMPLOYEE
 WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE
                                     , JOB_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '하이유');
                                 
-------------------------------------------------------------------------------
-- 박나라 사원과 같은 직급코드, 같은 사수사번을 가진 사원들의 사번, 이름, 직급코드, 사수사번 조회
-- 다중열 서브쿼리로 작성하기
SELECT EMP_ID
     , EMP_NAME
     , JOB_CODE
     , MANAGER_ID
  FROM EMPLOYEE    
 WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE
                                      , MANAGER_ID
                                   FROM EMPLOYEE
                                  WHERE EMP_NAME = '박나라');
                                  
                                  
/*
    4. 다중행 다중열 서브쿼리
    
    서브쿼리 조회 결과가 여러행 여러 컬럼일 경우
*/
-- 각 직급별 최소 급여를 받는 사원들 조회(사번, 이름, 직급코드 ,급여)
-- 1) 각 직급별 최소급여를 조회
SELECT JOB_CODE
     , MIN(SALARY)
  FROM EMPLOYEE
 GROUP BY JOB_CODE
 ORDER BY JOB_CODE;


-- 2)최소급여와 일치하는 사원들 조회
SELECT EMP_ID
     , EMP_NAME
     , JOB_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE (JOB_CODE = 'J1' AND SALARY = '8000000')
    OR (JOB_CODE = 'J2' AND SALARY = '3700000')
    OR (JOB_CODE = 'J3' AND SALARY = '3400000')
    OR (JOB_CODE = 'J4' AND SALARY = '1550000')
    OR (JOB_CODE = 'J5' AND SALARY = '2200000')
    OR (JOB_CODE = 'J6' AND SALARY = '2000000')
    OR (JOB_CODE = 'J7' AND SALARY = '1380000');

--3)위 내용을 가지고 하나의 쿼리문으로 만들기 

SELECT EMP_ID
     , EMP_NAME
     , JOB_CODE
     , SALARY
  FROM EMPLOYEE
 WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE
                                   , MIN(SALARY)
                                FROM EMPLOYEE
                               GROUP BY JOB_CODE);
  
/* WHERE (JOB_CODE = 'J1' AND SALARY = '8000000')
    OR (JOB_CODE = 'J2' AND SALARY = '3700000')
    OR (JOB_CODE = 'J3' AND SALARY = '3400000')
    OR (JOB_CODE = 'J4' AND SALARY = '1550000')
    OR (JOB_CODE = 'J5' AND SALARY = '2200000')
    OR (JOB_CODE = 'J6' AND SALARY = '2000000')
    OR (JOB_CODE = 'J7' AND SALARY = '1380000');*/

-- 각 부서별 최고 급여를 받는 사원들 조회(사번,이름, 부서코드, 급여)
-- 부서가 없는 사원의 경우 없음이라는 부서로 출력 되도록
SELECT EMP_ID AS 사번
     , EMP_NAME AS 이름
     , NVL(DEPT_CODE, '없음') AS 부서코드
     , SALARY AS 급여
  FROM EMPLOYEE
 WHERE (NVL(DEPT_CODE, '없음'), SALARY) IN (SELECT NVL(DEPT_CODE, '없음')
                                                , MAX(SALARY)
                                             FROM EMPLOYEE
                                            GROUP BY DEPT_CODE)
 ORDER BY 부서코드;
 
----------------------------------------------------------------------------------------
/*
    5. 인라인뷰(INLINE VIEW)
    FROM 절에 서브쿼리를 제시하는것
    
    서브쿼리를 수행한 결과를 테이블대신 사용하는 개념
*/
-- 보너스 포함 연봉이 3000만원 이상인 사원들의 사번, 이름, 보너스포함 연봉, 부서코드를 조회.
SELECT EMP_ID AS 사원
     , EMP_NAME AS 이름
     , (SALARY + SALARY*NVL(BONUS, 0))*12 AS 보너스포함연봉
     , DEPT_CODE AS 부서코드
  FROM EMPLOYEE
 WHERE (SALARY + SALARY*NVL(BONUS, 0))*12 >= 30000000;
 
-- 인라인뷰 사용 : (보너스포함연봉이 3000만원 이상인 사원들의) 사원명만 골라내기
SELECT 이름
  FROM (SELECT EMP_ID AS 사원
             , EMP_NAME AS 이름
             , (SALARY + SALARY*NVL(BONUS, 0))*12 AS 보너스포함연봉
             , DEPT_CODE AS 부서코드
          FROM EMPLOYEE
         WHERE (SALARY + SALARY*NVL(BONUS, 0))*12 >= 30000000
       )
 WHERE 부서코드 IS NULL;

-- 인라인뷰를 주로 사용하는예
-- TOP - N 분석 : 데이터베이스상에 있는 자료 중 최상위 N개의 자료를 보기 위해 사용하는 기능.

-- 전 직원중 급여가 가장 높은 상위 5명 (순위, 사원명, 급여)
-- *ROWNUM : 오라클에서 제공해주는 칼럼. '조회된 순서'대로 1부터 순번을 부여해주는 컬럼
SELECT ROWNUM
     , EMP_NAME
     , SALARY
  FROM EMPLOYEE
 WHERE ROWNUM <= 5
 ORDER BY SALARY DESC; 
 -- 원하는 값이 안나오는 이유 : ORDER BY로 정렬하기 전에 이미 ROWNUM의 순번이 매겨져 있기때문
 -- 해결방법 : ORDER BY로 이미 정렬할 테이블을 가지고 ROWNUM 순번을 매기면 됨

SELECT ROWNUM
     , EMP_NAME
     , SALARY
  FROM (SELECT * 
          FROM EMPLOYEE
         ORDER BY SALARY  DESC
       )
 WHERE ROWNUM <= 5;
 
-- 각 부서별 평균급여가 높은 3개의 부서코드, 평균 급여 조회
SELECT ROWNUM
     , DEPT_CODE
     , SALARY /* "ROUND(AVG(SALARY)" , S.* */
  FROM (SELECT ROUND(AVG(SALARY)) AS SALARY
             , DEPT_CODE
          FROM EMPLOYEE
         GROUP BY DEPT_CODE
         ORDER BY 1 DESC) S
 WHERE ROWNUM <= 3;
 
-- ROWNUM을 이용하면 순위를 매길수 있음
-- 다만 정렬이 되지 않은 상태에서는 순위를 매기면 의미가 없으므로
-- 선 정렬 후 순위 매기기를 해야한다. => 우선적으로 인라인 뷰로 ORDER BY절을 만들고 메인쿼리에서 순번을 붙임


-- 가장 최근에 입사한 사원 5명 사원명, 급여, 입사일
SELECT ROWNUM
     , S.*
  FROM (SELECT EMP_NAME
             , SALARY
             , HIRE_DATE
          FROM EMPLOYEE
         ORDER BY HIRE_DATE DESC) S
 WHERE ROWNUM <= 5;
 
/*
  6. 순위 매기는 함수(WINDOW FUNCTION)
  RANK() OVER(정렬기준)
  DENSE_RANK() OVER (정렬기준)
  
  - RANK() OVER(정렬기준) : 공동 1위가 3명이라고 한다면 그 다음 순위는 4위로
  - DENSE_RANK() OVER(정렬기준) : 공동 1위가 3명이면 그다음 순위는 2위로
  
  정렬기준 : ORDER BY 절(정렬기준 컬럼이름, 오름차순/내림차순, NULLS FIRST 나 NULLS LAST는 기술 불가.)
  오직 SELECT 절에서만 기술 가능
*/

-- 사원들의 급여가 높은 순서대로 매기기. 사원명, 급여, 순위 조회 : RANK OVER
SELECT EMP_NAME
     , SALARY
     , RANK() OVER(ORDER BY SALARY DESC) AS 순위
  FROM EMPLOYEE;
  
SELECT EMP_NAME
     , SALARY
     , DENSE_RANK() OVER(ORDER BY SALARY DESC) AS 순위
  FROM EMPLOYEE;
  
-- 5위까지만 조회하겠다
SELECT EMP_NAME
     , SALARY
     , RANK() OVER(ORDER BY SALARY DESC) AS 순위
  FROM EMPLOYEE
 WHERE RANK() OVER(ORDER BY SALARY DESC) <=5; 
-- WINDOW함수를 WHERE 절에서 기술불가능
-- 인라인 뷰로 변경
SELECT S.*
  FROM (SELECT EMP_NAME
             , SALARY
             , RANK() OVER(ORDER BY SALARY DESC) AS 순위
          FROM EMPLOYEE) S
 WHERE S.순위 <= 5;
  

