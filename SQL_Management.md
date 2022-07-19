# Database Management

## Command Lines
<p>Database Start/Stop</p>
<pre>
- DB start nomount|mount
  SYS > STARTUP OPTION
- DB shutdown normal|transactional|immediate|abort
  SYS > SHUTDOWN OPTION
- Listener management
  LSNRCTL (listener control)
    - START
    - STOP
    - STATUS
    - SERVICES
- Oracle Enterprise Manager
  EMCTL START DBCONSOLE
</pre>
<p>Parameters</p>
<pre>
- Search parameters
  SHOW PARAMETER OPTION;
 - Update parameters
  ALTER SYSTEM SET parameter_name=value;
</pre>
<p>Tablespace</p>
<pre>
- Tablespace 생성
  CREATE TABLESPACE tablespace_name DATAFILE 'route/filename' SIZE size;
- 공간 추가
  ALTER DATABASE DATAFILE 'route/filename' RESIZE size;
- 상태 변경
  ALTER TABLESPACE tablespace_name STATUS
- 삭제
  DROP TABLESPACE tablespace_name INCLUDING CONTENTS AND DATAFILES;
</pre>

## Undo Data Management

### Automatic Undo Management
<p>Automatic Undo Management 조건</p>
<ul>
  <li>DB에 UNDO TABLESPACE가 최소 1개 (여러 개 생성 가능하지만 동시 사용은 하지 못함)</li>
  <li>UNDO Parameters</li>
  <ul>
    <li>undo_management = AUTO (automatic undo management)</li>
    <li>undo_retention = COMMIT 했을 때 UNDO 테이블에 머무는 시간</li>
    <li>undo_tablespace = UNDO 테이블 설정</li>
  </ul>
</ul>

<p>DBA의 영역</p>
<ul>
  <li>Storage Management(용량 관리): Long Tx, 동시 Tx 용량이 충분해야 함</li>
  <li>종료된 Tx의 UNDO data 보유 시간(커밋한 데이터가 UNDO에 머무르는 시간)</li>
  <ul>
    <li>undo_retention 기본값은 900초(15분)</li>
    <li>UNDO SEGMENT 상태를 ONLINE으로 처리 => COMMIT 후 종료해도 15분 후 꺼짐</li>
    <li>Query, Flashback Table 기술지원</li>
  </ul>
</ul>

## Database Concurrency
<p>Lock: 하나의 테이블에 동시 접속 후 UPDATE할 때 B가 먼저 수정 후 A가 수정 시, B가 COMMIT, ROLLBACK 할 때까지 A는 Lock이 걸려있음</p>

### BLOCKING_SESSION
<ul>
	<li>SQL*Net message from client => 차단한 유저</li>
	<li>enq: TX - row lock contention => 차단 당한 유저</li>
</ul>
<pre>
* 세션 KILL => 세션은 SID와 SERIAL 번호로 구분
ALTER SYSTEM KILL SESSION 'SID, SERIAL번호';
</pre>
<p>V$SESSION에서는 문제가 있는 SESSION 보여줌</p>
<p>em에서 BLOCKING_SESSION 확인</p>
<ul>
	<li>em에서 ACTIVE SESSIONS에 WAIT 그래프 생성</li>
	<li>BLOCKING SESSIONS 확인 후 KILL 가능</li>
</ul>

### DEAD LOCK
<p>먼저 명령문 wait하던 곳에서 Deadlock 감지 에러가 뜨면서 wait이 끝나고 실행 중이던 명령문을 USER가 COMMIT, ROLLBACK하면 다른 유저의 Lock이 풀림</p>
<p>tmon이 문장 중 하나의 명령문을 취소 시켜 에러 감지 명령문 띄움</p>
<pre>
* 테이블 모든 행에 lock 걸어두는 명령어
LOCK TABLE table_name IN EXCLUSIVE MODE;
</pre>

## Database Security
<ul>
  <li>Restricting access to data and services => Authority</li>
  <li>Authenticating users => User ID/Password</li>
  <li>Monitoring actions => Auditing</li>
</ul>

### User Security Settings
<ol>
  <li>ID/PW</li>
  <li>Tablespace Settings</li>
    <ul>
      <li>Default Tablespace</li>
      <li>Quota(용량)</li>
    </ul>
  <li>Authority & Role</li>
  <li>Profile</li>
</ol>

### Profile
<p>Parameter</p>
<ul>
	<li>resource_limit => 파라미터가 true일 경우 자원 제한</li>
	<li>resource_parameters</li>
	<li>password_parameters</li>
</ul>
<p>resource_parameters</p>
<ul>
	<li>SESSIONS_PER_USER - 동시 접속 가능한 세션 수 제한</li>
	<li>CPU_PER_SESSION - 세션에 대한 CPU 시간 제한</li>
	<li>CPU_PER_CALL - 호출에 대한 CPU 시간 제한(parse, execute, fetch)</li>
	<li>CONNECT_TIME - specify the total elapsed time limit for a session, expressed in minutes</li>
	<li>IDLE_TIME - permitted periods of continuous inactive time during a session</li>
</ul>
<p>password_parameters</p>
<ul>
	<li>FAILED_LOGIN_ATTEMPTS</li>
	<li>PASSWORD_LIFE_TIME</li>
	<li>PASSWORD_REUSE_TIME</li>
	<li>PASSWORD_LOCK_TIME</li>
	<li>PASSWORD_GRACE_TIME</li>
	<li>PASSWORD_VERIFY_FUNCTION</li>
</ul>
<pre>
* create profile
CREATE PROFILE new_profile_name
	LIMIT PASSWORD_REUSE_MAX 10
	PASSORD_REUSE_TIME 30;
* Lock 걸린 계정 해제
SYS > ALTER USER user_name ACCOUNT UNLOCK;
* 비밀번호 변경
ALTER USER user_name IDENTIFIED BY password;
* 프로파일 삭제
DROP PROFILE profile_name CASCADE; (적용중인 계정이 있을 경우)
</pre>

### Authority
<ul>
  <li>System: DB를 변경할 수 있는 권한</li>
  <li>Object: 객체를 access 할 수 있는 권한</li>
  <li>Role: 여러 개의 권한을 모아서 한꺼번에 부여</li>
</ul>

### Audit
<p>사용자가 부여받은 권한 등을 올바르게 사용하고 있는지 여부를 감시하는, DB 활동을 감시하는 기능</p>

#### Monitoring for Compliance(감사 종류)
<ul>
  <li>Mandatory auditing (DBA 감사)</li>
  <li>SYSDBA (and SYSOPER) auditing (DBA 감사)</li>
  <ul>
    <li>DBA 감사 parameter: AUDIT_SYS_OPERATIONS</li>
    <li>FALSE일 경우에는 기본 감사만 진행</li>
  </ul>
  <li>Standard database auditing(표준 데이터베이스 감사) (일반 계정 활동 감사) => DML 감사에는 부적합</li>
  <li>Fine-grained auditing(FGA) (일반 계정 활동 감사) => DML 감사에는 부적합</li>
  <li>Value-based auditing => DML 감사에 적합 (값이 남는 감사, 값의 변경 여부 감사하는데 적합)</li>
    <ul>
      <li>Trigger 사용 가능</li>
    </ul>
</ul>

#### Standard Database Auditing
<p>Standard Database Auditing Setting</p>
<ul>
  <li>Data Dictionary: DBA_AUDIT_TRAIL</li>
  <li>Data Dictionary: DBA_COMMON_AUDIT_TRAIL (FGA, STANDARD 둘다 조회)</li>
</ul>
<ol>
  <li>Enable databse auditing</li>
    <ul>
      <li>Parameter => audit_trail(감사 기록) = 감사 기록을 남기는 장소 지정</li>
      <li>audit_trail은 대표적인 정적 파라미터(설정 시 DB ON/OFF 필요)</li>
      <li>장소 옵션: none, DB, OS, xml</li>
      <ul>
        <li>OS 적용 시 txt 파일 형식으로 저장</li>
        <li>xml 적용 시 xml 파일 형식으로 저장</li>
        <li>DB 적용 시 SYS의 AUD$에 감사기록 저장 (감사 기록 미관리 시 SYSTEM TABLESPACE의 용량 부족 문제 발생)</li>
        <li><code>TRUNCATE TABLE AUD$;</code></li>
      </ul>
    </ul>
  <li>Specify audit options: 감사 대상  지정</li>
    <ul>
      <li>System 권한 감사(Audited Privileges)</li>
      <li>Object 권한 감사(Audited Objects) => 자세하지 않고 불필요한 감사 기록이 많이 남음</li>
      <li>명령문 감사(Audited Statements)</li>
    </ul>
  <li>Review audit information: 감사 결과 확인</li>
  <li>Maintain audit trail: 기록 백업 </li>
</ol>

#### Fine-grained auditing(FGA)
<ul>
  <li>Standard database auditing의 객체 감사의 부족한 점을 개선하기 위해 추가된 감사 기능</li>
  <li>옵션을 자세하게 설정할 수 있어 감사 기록 양을 줄일 수 있음</li>
  <li>Data Dictionary</li>
  <ul>
    <li>DBA_FGA_AUDIT_TRAIL</li>
    <li>DBA_COMMON_AUDIT_TRAIL (FGA, STANDARD 둘다 조회)</li>
  </ul>
  <li>Object Audit(객체 감사)만 가능, DBMS_FGA 패키지를 기반으로 하여 FGA 실행 가능</li>
  <ul>
    <li>SELECT</li>
    <li>INSERT</li>
    <li>UPDATE</li>
    <li>DELETE</li>
    <li>MERGE</li>
  </ul>
</ul>
<ul>
  <li>FGA Policy</li>
  <li>Define Audit criteria, Audit action</li>
  <li>Handler: 해당 policy에 대한 감사 기록 별도 관리 옵션 지정 가능</li>
  <li><code>DBMS_FGA.ADD_POLICY(OPTIONS)</code></li>
  <li>OPTIONS</li>
  <ul>
    <li>object_name: TABLE</li>
    <li>policy_name: Policy name</li>
    <li>audit_column: 감사할 column</li>
    <li>statement_types: 감사 실행할 명령문</li>
    <li>audit_column_opts: DBMS_FGA.ALL_COLUMNS => SELECT 명령문 시 지정한 컬럼이 모두 조회되어야만 감사 기록 남는 설정</li>
  </ul>
</ul>

#### Value-Based auditing
<ul>
  <li>값이 변화하였을 때 감사(Standard, FGA는 COMMIT, ROLLBACk 여부 등이 기록에 남지 않음)</li>
  <li>Trigger 사용 필요</li>
  <li>COMMIT하여 값이 변동된 이후 전에 값과 변경된 값 확인 가능</li>
</ul>
<pre>
* Value-Based auditing TRIGGER 예시 *

conn system/oracle
CREATE TABLE system.audit_employees
(os_user VARCHAR2(10),
dml_date DATE,
description VARCHAR2(1000))
/

CREATE OR REPLACE TRIGGER
	system.hrsalary_audit
	AFTER UPDATE OF salary
	ON hr.employees
	REFERENCING NEW AS NEW OLD AS OLD
	FOR EACH ROW
BEGIN
	IF :old.salary != :new.salary THEN
	INSERT INTO system.audit_employees
	VALUES(sys_context('userenv', 'os_user'), sysdate, 
	:new.employee_id || ' salary changed from '||:old.salary|| ' to '||:new.salary);
	END IF;
END;
/
</pre>

## Monitoring
<p>Tuning을 위한 목적으로 모니터링 진행</p>

### System (Instance)
<ul>
  <li>Memory</li>
  <li>I/O</li>
  <li>Contention(경합)</li>
	<ul>
		<li>데이터 => Lock</li>
		<li>CPU => Latch</li>
	</ul>
</ul>
<p>시스템 진단 도구: V$VIEWS</p>
<ul>
  <li>휘발성 데이터</li>
  <li>DB 재시작 시 초기화</li>
  <li>시스템 통계 데이터는 휘발성이기 때문에 정기적 수집, 보관을 통한 분석을 위해 모두 자동화되어 있음</li>
  <ul>
    <li>수집: mmon(background process) => 정기적인 수집 담당, 1시간에 1번씩 여러가지 성능 지표 수집 => snapshot</li>
    <li>분석: ADDM(분석 엔진) - 2번째 스냅샷이 만들어질 때부터 1시간에 1번씩 스냅샷을 비교하면서 분석 => 결과 => 조언(advisor), 경고 생성</li>
    <li>통합 저장: AWR(Automatic Workload Repository) => 스냅샷, 결과, 조언, 경고 등 모든 모니터링 정보를 8일간 저장 후 자동 삭제 처리, Baseline은 삭제에서 제외</li>
    <ul>
      <li>통계는 상대적이기 때문에 Baseline을 저장해야 이상 현상 등 비교하여 탐지할 수 있음</li>
      <li>Baseline도 AWR에 저장됨</li>
    </ul>
    <li>기본적으로 자동이지만 관리자가 수동으로 수집, 분석 등 활동 가능</li>
  </ul>
  <li>Parameter: statistics_level = BASIC(활동 안 함)|TYPICAL(위와 같은 주기로 활동)|ALL(분석 내용 추가)</li>
</ul>

### Application (Optimizing)
<ul>
  <li>Schema Object</li>
	<ul>
		<li>진단 데이터(통계): Table, Index(스키마에 대한 객체 통계)</li>
		<ul>
			<li>명령문: Analyze Table ~ (개별적인 객체 단위)</li>
			<li><code>
			ANALYZE TABLE EMPLOYEES COMPUTE STATISTICS;
			</li></code>
			<li>dbms_stats(패키지): DB 전체 또는 특정 스키마 단위, 객체 단위 등 선택적으로 단위 지정하여 일괄적으로 분석</li>
			<li><code>
			EXEC DBMS_STATS.GATHER_SCHEMA_STATS('schema_name');
			</code></li>
		</ul>
		<li></li>
	</ul>
  <li>SQL</li>
</ul>
<p>Optimizing</p>
<ul>
	<li>Parse</li>
	<ol>
		<li>Syntax, Semantic</li>
		<li>Compile</li>
		<li>Parse Tree</li>
		<li>Execution Plan(Optimizing) => 실행 계획 세우기 위해 실제 테이블 상태가 아닌 최적화 통계를 확인한 후 계획 세우기 때문에 통계 자료가 부정확할 시 잘못된 실행 계획이 세워질 수 있으므로 dba의 정기적인 통계 데이터 업데이트가 필요</li>
	</ol>
</ul>
