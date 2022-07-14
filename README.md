# SQL
## PL/SQL Basic Block Structure  
<pre>
  DECLARE - Declare variables, cursor, exceptions etc used within blocks
    Declaration
  BEGIN - REQUIRED, Actual query statements being processed
    statement1; ...
    [Nested PL/SQL Block possible]
  EXCEPTION - Exceptions being processed
    exception statement1; ...
  END; - REQUIRED
  /
</pre>

## Types of PL/SQL Blocks
  <table>
    <tr>
      <th>Anonymous</th>
      <td>블록에 이름 지정하지 않은 익명의 프로시저, 재호출 불가</td>
      <td><pre>
      [DECLARE]
      BEGIN 
        --statements
      [EXCEPTION]
      END;
      </pre></td>
    </tr>
    <tr>
      <th>Procedure</th>
      <td>Named procedure, 재호출 가능</td>
      <td><pre>
      PROCEDURE name IS
      BEGIN 
        -- statements
      [EXCEPTION]
      END;
      </pre></td>
    </tr>
    <tr>
      <th>Function</th>
      <td>리턴되는 값이 있음</td>
      <td><pre>
      FUNCTION name RETURN datatype IS
      BEGIN
        --statements
        RETURN value; (RETURN value is required)
      [EXCEPTION]
      END;
      </pre></td>
    </tr>
  </table>

## Variables
<p><b>Declaring variables</b></p>
<code>IDENTIFIER [CONSTANT] DATATYPE [NOT NULL]
[:= | DEFUALT EXPRESSION];</code>
<br>
<p>Examples</p>
<ul>
  <li>v_hiredate DATE;</li>
  <li>v_deptno NUMBER(2) NOT NULL := 10;</li>
  <li>v_location VARCHAR(13) := 'Atlanta';</li>
  <li>v_comm CONSTANT NUMBER := 1400;</li>
</ul>

### Functions of Variables in PL/SQL
<ul>
  <li>데이터 임시 저장</li>
  <li>저장된 값 조작</li>
  <li>재사용</li>
  <li>유지 관리의 용이성</li>
</ul>

### Variable Types
<ol>
  <li>스칼라 데이터 유형(Scalar)</li>
    <ul>
      <li>내부 구성 요소 없이 숫자, 문자, 날짜, 불린 등(NUMBER, BOOLEAN, CHARACTER, DATETIME) 네 가지 범주로 분류하는 <b>단일 값</b> 형태의 데이터</li>
      <li>기본 데이터 유형은 ORACLE SERVER 테이블의 열 유형과 일치</li>
      <li><b>BOOLEAN(불린) 타입 지원</b> => TRUE, FALSE, NULL</li>
      <li><b>%TYPE</b> => 데이터베이스 열 정의 또는 이전에 선언한 다른 변수 사용</li>
  </ul>
  <li>조합 데이터 유형(Composite)</li>
    <ul>
      <li>피드 그룹을 정의하고 조작 가능</li>
      <li><b>RECORD</b></li>
        <ul>
          <li>필드라고 불리는 PL/SQL 테이블, 레코드, 임의의 스칼라 데이터 유형 중 하나 이상의 구성 요소 포함하는 조합 데이터 유형</li>
          <li>레코드 생성하려면 레코드 유형 정의 후 해당 유형의 레코드 선언</li>
          <li><pre>
          DECLARE
            TYPE record_name_type IS RECORD
              (FIELDS);
             record_name record_name_type;
          </pre></li>
          <li><b>%ROWTYPE</b> => 한 행을 단위로 하여 데이터베이스 테이블 또는 뷰의 열 모음에 따라 변수를 선언</li>
      </ul>
      <li><b>TABLE</b></li>
      <ul>
        <li>기본 키와 대응되는 값이 있음, 안에 들어가는 데이터 유형은 동일한 타입으로 구성</li>
        <li>INDEX는 BINARY_INTEGER, PLS_INTEGER 사용</li>
        <li>크기 제한 없이 동적으로 증가</li>
        <li>레코드와 마찬가지로 정의와 변수 선언 파트로 나뉘며 테이블의 데이터 유형 선언 후 선언한 해당 데이터 유형의 변수를 선언</li>
        <li><pre>
        DECLARE
          TYPE table_name_type IS TABLE OF column type
          INDEX BY [BINARY_INTEGER|PLS_INTEGER];
          table_name table_name_type;
        </pre></li>
      </ul>
  </ul>
  <li>참조 데이터 유형</li>
    <ul>
      <li>다른 프로그램 항목을 지정하는 값(포인트) 보유</li>
  </ul>
  <li>LOB(대형 객체) 데이터 유형</li>
  <ul>
    <li>한 행을 초과하여 저장되는 대형 객체의 위치 지정값 보유</li>
  </ul>
</ol>

### SQL Function In PL/SQL Block
<ul>
  <li>DECODE, GROUP 함수를 제외한 SQL 함수들은 사용 가능</li>
  <li>BEGIN 내의 SQL Statement 내에서는 모든 SQL 함수 사용 가능</li>
</ul>

### Block Control
<ul>
  <li>DDL, DCL 사용으로 블록 제어는 불가능</li>
  <li>COMMIT, SAVEPOINT, ROLLBACK 등 TCL을 이용한 트랜잭션 제어는 가능</li>
</ul>

### TABLE METHODS
<table>
  <tr>
    <th>EXISTS(n)</th>
    <td>n번째 요소가 존재하면 TRUE 반환</td>
  </tr>
  <tr>
    <th>COUNT</th>
    <td>요소 수 반환</td>
  </tr>
  <tr>
    <th>FIRST, LAST</th>
    <td>첫번째/마지막 인덱스 번호 반환</td>
  </tr>
  <tr>
    <th>PRIOR(n)</th>
    <td>인덱스 n 앞 인덱스 번호를 번환</td>
  </tr>
  <tr>
    <th>NEXT(n)</th>
    <td>인덱스 n 뒤 인덱스 번호를 반환</td>
  </tr>
  <tr>
    <th>EXTEND(n, i)</th>
    <td>테이블의 크기 증가</td>
  </tr>
  <tr>
    <th>TRIM</th>
    <td>끝에서 요소를 하나 제거</td>
  </tr>
  <tr>
    <th>DELETE</th>
    <td>특정한 인덱스 지정하지 않을 시 모든 요소를 제거</td>
  </tr>
</table>

## LOOP

### LOOP
<pre>
DECLARE
  declare condition parameter
BEGIN
  LOOP
  EXIT WHEN condition;
  END LOOP;
</pre>

### WHILE LOOP
<pre>
DECLARE
  declare condition parameter
BEGIN
  WHILE condition LOOP
  END LOOP;
</pre>

### FOR LOOP
<pre>
BEGIN
  FOR parameter IN start..end LOOP
  END LOOP;
</pre>

## Cursor
<ul>
  <li>SQL 문을 실행할 때마다 명령문의 구문을 분석하고 실행할 메모리 영역</li>
  <li>커서의 두 가지 유형: 1) 암시적 커서 2) 명시적 커서</li>
</ul>

### Types of Cursor
<h5>Implicit Cursor(암시적 커서)</h5>
<ul>
  <li>하나의 행만 반환하는 질의를 포함</li>
  <li>모든 DML, PL/SQL SELECT 문에 대해 PL/SQL에서 암시적으로 선언</li>
</ul>
<h5>Explicit Cursor(명시적 커서)</h5>
<ul>
  <li>둘 이상의 해을 반환하는 질의에 대해 선언</li>
  <li>직접 선언하여 이름 지정 필요(named)</li>
  <li>블록의 실행 가능한 작업에 있는 특정 명령문 통하여 조작</li>
  <li>다중행 SELECT 문에 의해 반환된 각 행을 개별적으로 처리할 때 사용 용이</li>
  <li>Active Set(활성 집합) => 다중 행 질의에 의해 반환되는 행 집합</li>
  <li>명시적 커서의 기능</li>
  <ul>
    <li>현재 처리되고 있는 행 추적</li>
    <li>PL/SQL 블록에서 수동 제어 가능</li>
  </ul>
</ul>

### Explicit Cursor
<pre>
수동 제어
  DECLARE  
    - 커서 선언, SQL 영역 생성
    - INTO 절 필요 없음 
  OPEN  
    - 활성 집합 식별
    - 반환되는 행 없어도 예외 사항 발생하지 않음
  FETCH  
    - 커서에서 데이터 인출
    - 현재 행을 변수에 로드
    - EMPTY? - 기존 행 테스트, 행이 있으면 FETCH로 돌아감
  CLOSE  
    - 활성 집합 해제
</pre>
<pre>
FOR LOOP
- 명시적 커서를 처리하기 위한 단축 방법으로 열기, 인출, 닫기가 암시적으로 발생
- 커서의 자동 조작
- 수동으로 조작이 필요한 경우에는 반드시 명시적으로 해당 과정을 제어하는 수동 제어 방식으로 사용 필요
FOR record_name IN cursor_name LOOP
  statement1;
  statement2;
END LOOP;
</pre>

### Cursor Attributes
<ul>
  <li><b>%ISOPEN</b>: Always has the value of FALSE</li>
  <li><b>%FOUND</b>: SELECT or DML statement returned a row then TRUE, if not returned then FALSE</li>
  <li><b>%NOTFOUND</b>: SELECT or DML statement returned a row then FALSE, if not returned then TRUE</li>
  <li><b>%ROWCOUNT</b>: SELECT or DML statement has run, the number of rows fetched so far</li>
</ul>

### Cursor Parameter & Update
<pre>
DECLARE
  CURSOR cursor_name[parameter_name, datatype, ...]
  IS
  SELECT_STATEMENT
  WHERE (WHERE 절 조건에 들어가는 값을 parameter로 받음)
  FOR UPDATE table_column
    - 명시적 잠금을 사용하여 트랜잭션 기간 동안 액세스 거부 가능
    - 갱신 또는 삭제 전에 행을 잠그기 위한 구문
    - FOR UPDATE 절은 ORDER BY가 있는 경우에도 SELECT 문의 가장 마지막에 위치
BEGIN
  UPDATE...
  WHERE CURRENT OF cursor_name
    - 커서를 사용하여 현재 행 갱신 및 삭제
    - 커서 질의에 FOR UPDATE 절을 포함시켜 먼저 행을 잠근 후 사용
    - WHERE CURRENT OF 절을 사용하여 명시적 커서에서 현재 행을 참조할 수 있음
 </pre>

## Exception

### Exception Processing
<ul>
  <li>Handler로 트랩</li>
  <li>트랩이 없을 경우에는 호출 환경으로 전달하게 됨</li>
</ul>

### Exception Trap
<p>블록의 EXCEPTION 색션에 있는 해당 예외 Handler로 처리가 분기</p>
<p>PL/SQL이 예외사항을 처리하면 블록이 성공적으로 종료되며 해당하는 예외 Handler가 없으면 블록이 실패하여 예외사항 호출 환경으로 전달됨</p>
<pre>
EXCEPTION
  WHEN exception1 [OR exception2 ...] THEN
    statement1;
    statement2;
  WHEN exception3 THEN
    statement1;
    statement2;
  WHEN OTHERS THEN
    statement1;
    statement2;
</pre>

### Pre-defined Exceptions
<table>
  <tr>
    <th>NO_DATA_FOUND</th>
    <td>데이터 리턴하지 않음</td>
  </tr>
  <tr>
    <th>TOO_MANY_ROWS</th>
    <td>SELECT 문이 하나 이상의 ROW 리턴</td>
  </tr>
  <tr>
    <th>INVALID_CURSOR</th>
    <td>잘못된 커서 연산 발생</td>
  </tr>
  <tr>
    <th>ZERO_DIVIDE</th>
    <td>0으로 나눔</td>
  </tr>
  <tr>
    <th>DUP_VAL_ON_INDEX</th>
    <td>중복값 삽입 시도</td>
  </tr>
</table>

### Non-predefined Exceptions
<ul>
  <li>선언 부분에서 예외 사항의 이름 선언</li>
  <ul>
    <li><code>exception_name EXCEPTION;</code></li>
  </ul>
  <li>PRAGMA EXCEPTION_INIT 문을 사용하여 선언한 예외사항과 표준 오라클 서버 오류 번호를 연결</li>
  <ul>
    <li><code>PRAGMA EXCEPTION_INIT(exception_name, Oracle Exception Code)</code></li>
  </ul>
  <li>선언한 예외 사항을 해당하는 예외 처리 루틴에서 참조</li>
  <li><b>SQLERRM</b>: ORACLE 오류 메세지 출력</li>
  <li><b>SQLCODE</b>: ORACLE 오류 코드의 숫자 값 반환</li>
  <li><a href="https://docs.oracle.com/cd/E11882_01/server.112/e17766/">오라클 Database Error Messages List</a></li>
</ul>

### User-defined Exceptions
<ul>
  <li>선언 부분에서 사용자가 정의한 예외사항의 이름 선언</li>
  <li>실행 부분에서 RAISE 문을 사용하여 예외사항 명시적으로 발생</li>
  <li>선언한 예외사항을 해당하는 예외 처리 루틴에서 참조</li>
</ul>

### RAISE_APPLICIATION_ERROR
<p>20000~20999까지의 에러 숫자가 비워져 있으므로 사용자가 정의하여 사용자 정의 오류 메시지를 실행시킬 수 있음</p>
<code>RAISE_APPLICATION_ERROR(error_number, message[, [TRUE|FALSE]]);</code>
<p>사용자가 정의한 오류 메시지를 내장(stored) 하위 프로그램에서 실행하는 프로시저로 내장 하위 프로그램 실행을 통해서만 호출</p>

## Stored Procedure
<pre>
CREATE OR REPLACE PROCEDURE procedure_name
  parameter_name MODE type
  IS
 BEGIN
  statement1;
 END;
 => COMPILE
</pre>

### Stored Procedure Function
<ul>
  <li>Anonymous와는 달리 매개변수를 사용하여 호출할 수 있는 명명된(named) PL/SQL 블록</li>
  <li>재사용 및 유지 관리 기능 향상</li>
  <li>코드 컴파일을 하여 소스 코드가 p code로 컴파일됨</li>
</ul>

### Stored Procedure Parameter
<table>
  <tr>
    <th>IN</th>
    <td>기본값, 값을 서브 프로그램에 전달</td>
  </tr>
  <tr>
    <th>OUT</th>
    <td>값을 호출 환경으로 반환</td>
  </tr>
  <tr>
    <th>IN OUT</th>
    <td>값을 서브 프로그램에 전달하고 호출 환경으로 반환</td>
  </tr>
</table>
<pre>
IN 매개변수
  CREATE OR REPLACE PROCEDURE procedure_name
    parameter_name IN type
OUT 매개변수
  CREATE OR REPLACE PROCEDURE procedure_name
    parameter_name OUT type -- 비어있는 값
IN OUT 매개변수
  CREATE OR REPLACE PROCEDURE procedure_name
    parameter_name IN OUT type
</pre>

## Function
<pre>
CREATE OR REPLACE FUNCTION function_name
  ([parameter IN(mode) type])
  RETURN type
IS
BEGIN
  statement1
  RETURN; (리턴 후 바로 종료되기 때문에 리턴은 반드시 실행 구문 마지막에 위치)
END;
</pre>
<ul>
  <li>Procedure와 같이 매개변수를 사용하여 호출할 수 있는 명명된 PL/SQL 블록</li>
  <li>Procedure와는 RETURN 구문이 존재하는 것을 제외하면 구조적으로 동일</li>
  <li>일반적으로 값을 계산할 때 사용하며 재사용 및 유지 관리 기능 향상 용이</li>
</ul>

### Function Restrictions
<ol>
  <li>사용자가 정의한 함수는 내장 함수이며 단일 행만 반환하는 함수</li>
  <li>IN 매개변수만 사용 가능</li>
  <li>데이터 유형은 SQL 데이터 유형인 CHAR, DATE, NUMBER만 가능</li>
  <li>BOOLEAN, RECORD, TABLE 등 PL/SQL 형식의 데이터 유형은 사용 불가</li>
  <li>DML 사용 불가</li>
</ol>

### Function Usage
<ul>
  <li>SELECT 명령의 SELECT 절</li>
  <li>WHERE 및 HAVING 절 조건</li>
  <li>CONNECT BY, START WITH, ORDER BY, GROUP BY 절</li>
  <li>INSERT 명령의 VALUES 절</li>
  <li>UPDATE 명령의 SET 절</li>
</ul>
<pre>
Procedure처럼 호출
Example) 
  VARIABLE g_variable TYPE;
  EXECUTE :g_variable := function_name(parameter);
  PRINT g_variable;
  => Procedure처럼 호출 가능 
  

내장 함수처럼 호출
Example) SELECT절에서 호출
  SELECT function_name(parameter) FROM dual;
Example) WHERE절 조건에서 호출 
  SELECT * 
  FROM table_name
  WHERE column_name = function_name(parameter);
</pre>

### Difference Between Procedure and Function
<table>
  <thead>
    <tr>
      <th>프로시저(Procedure)</th>
      <th>함수(Function)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>PL/SQL 문으로 실행</td>
      <td>표현식의 일부로 호출</td>
    </tr>
     <tr>
      <td>RETURN 데이터 유형을 포함하지 않음</td>
      <td>RETURN 데이터 유형을 포함</td>
    </tr>
     <tr>
      <td>값을 반환하지 않거나 하나 이상의 값을 반환할 수 있음</td>
      <td>값을 하나만 반환</td>
    </tr>
  </tbody>
</table>
