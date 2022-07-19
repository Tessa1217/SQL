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
<p>복수의 Tread가 자신이 상대가 필요로 하는 리소스를 소유하면서 서로 상대가 소유한 리소스를 기다리고 있는 상황</p>
<p>SQL Server는 deadlock 발생 시 해당 Thread 중 가장 트랜잭션이 짧게 진행된 쓰레드를 자동적으로 KILL하여 데드락 상황 해소</p>
<p><a href="http://www.sqlprogram.com/TIPS/tip-deadlock.aspx">데드락 기본</a></p>
<p>tmon이 문장 중 하나의 명령문을 취소 시켜 에러 감지 명령문 띄움</p>
<pre>
* 테이블 모든 행에 lock 걸어두는 명령어
LOCK TABLE table_name IN EXCLUSIVE MODE;
</pre>
<p>먼저 명령문 wait하던 곳에서 DeadLock감지 에러(ORA-00060)가 뜨면서 wait이 끝나고
실행 중이던 명령문을 user가 commit, rollback해주면 다른 유저의 lock이 풀림</p>
<pre>
* Deadlock 예시
HR(1) > UPDATE employees
SET salary = salary * 1.1 
WHERE employee_id = 100;
HR(2) > UPDATE employees
SET salary = salary * 1.1
WHERE employee_id = 101;
HR(1) > UPDATE employees
SET salary = salary * 1.1
WHERE employee_id = 101;
HR(2) > UPDATE employees
SET salary = salary * 1.1
WHERE employee_id = 100;

HR(1) => ORA-00060: Deadlock detected...;
HR(2) => Waiting

=> Deadlock 발생한 트랜잭션에 COMMIT, ROLLBACK 등으로 처리하면 Lock 상태로 변경
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
    <li>분석: ADDM(분석 엔진) - 2번째 스냅샷이 만들어질 때부터 1시간에 1번씩 스냅샷을 비교하면서 분석 => 결과 => 조언(advisor), 경고(em의 Metric and Policy Settings에서 임계치 확인 가능/ Warning, Critical 등 두 가지 thresholds level로 나눠짐) 생성</li>
    <li>통합 저장: AWR(Automatic Workload Repository) => 스냅샷, 결과, 조언, 경고 등 모든 모니터링 정보를 8일간 저장 후 자동 삭제 처리, Baseline은 삭제에서 제외</li>
    <ul>
      <li>통계는 상대적이기 때문에 Baseline을 저장해야 이상 현상 등 비교하여 탐지할 수 있음</li>
	<li>Baseline도 AWR에 저장됨</li>
    </ul>
    <li>기본적으로 자동이지만 관리자가 수동으로 수집, 분석 등 활동 가능</li>
  </ul>
  <li>Parameter: statistics_level = BASIC(활동 안 함)|TYPICAL(위와 같은 주기로 활동)|ALL(분석 내용 추가, 수집하는 정보가 늘어나 OVERHEAD 발생할 수 있음)</li>
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
			<li>수집: <code>
			EXEC DBMS_STATS.GATHER_SCHEMA_STATS('schema_name');
			</code></li>
		<li>삭제: <code>EXEC DBMS_STATS.DELETE_SCHEMA_STATS('schema_name');</code></li>
		<li>옛날 값으로 업데이트: <code>EXEC DBMS_STATS.RESTORE_SCHEMA_STATS('schema_name');</code></li>
		<li>값 Lock 시키기: <code>EXEC DBMS_STATS.LOCK_SCHEMA_STATS('schema_name');</code></li>
		<li>값 Unlock 시키기: <code>EXEC DBMS_STATS.UNLOCK_SCHEMA_STATS('schema_name');</code></li>
			<li>dbms 패키지를 스케줄(Schedule)에 등록 시 자동화된 분석 실행 가능, 변경사항 많은 테이블부터 우선순위 부여하여 분석 실행</li>
			<li>em => Oracle Scheduler => Automated Maintenance Tasks</li>
			<ul>
				<li>Optimizer Statistics Gathering</li>
				<li>Segment Advisor = 테이블에 문제가 있을 경우 해당 advisor에게 전송</li>
				<li>Automatic SQL Tuning = SQL 수정 필요할 시 수정 조언</li>
			</ul>
			<li>dbms_stats에 대한 통계 데이터는 새롭게 갱신된 경우 기존 데이터를 AWR에 30일동안 저장되어 버전 관리 가능</li>
		</ul>
	</ul>
  <li>SQL</li>
  <ul>
	<li>Parameter: SQL_TRACE = True => (File)</li>
	<li>SQLPlus의 AUTO TRACE</li>
	<li>PlusTrace Role 생성</li>
	<li>AUTO TRACE ON/OFF: <code>SET AUTOTRACE TRACEONLY|ON|OFF</code></li>
  </ul>	
</ul>
<p>Optimizing(최적화)</p>
<ul>
	<li>Parse</li>
	<ol>
		<li>Syntax, Semantic</li>
		<li>Compile</li>
		<li>Parse Tree</li>
		<li>Execution Plan(Optimizing) => 실행 계획 세우기 위해 실제 테이블 상태가 아닌 최적화 통계를 확인한 후 계획 세우기 때문에 통계 자료가 부정확할 시 잘못된 실행 계획이 세워질 수 있으므로 dba의 정기적인 통계 데이터 업데이트가 필요</li>
	</ol>
</ul>

### Index
<p>Index 생성과 성능 차이</p>
<ul>
	<li>검색 속도가 빨라짐(다만 경우에 따라 느려지는 경우도 존재, 데이터 변경 작업이 자주 일어나는 테이블의 경우에는 오히려 성능 저하 발생할 수 있음)</li>
	<li>시스템에 걸리는 부하를 줄여서 시스템 전체 성능 향상(I/O 감소 등)</li>
</ul>
<table>
	<caption><b>인덱스 사용해야 하는 경우 판단 기본 기준</b></caption>
	<thead>
		<tr>
			<th>인덱스 사용해야 할 경우</th>
			<th>인덱스를 사용하지 말아야 하는 경우</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>테이블 행 수 많을 경우</td>
			<td>테이블 행 수 적을 경우</td>
		</tr>
		<tr>
			<td>WHERE 문에 해당 컬럼 많이 사용될 경우</td>
			<td>WHERE 문에 해당 컬럼 많이 사용되지 않을 경우</td>
		</tr>
		<tr>
			<td>검색 결과가 전체 데이터의 2~4% 정도일 경우</td>
			<td>검색 결과가 전체 데이터의 10~15% 이상 일 때</td>
		</tr>
		<tr>
			<td>JOIN에 자주 사용되는 컬럼 또는 NULL을 포함하는 컬럼이 많은 경우</td>
			<td>테이블에 DML 작업이 많은 경우</td>
		</tr>
	</tbody>
</table>
<pre>
인덱스 사용 시 Execution Plan 예시
* 인덱스 사용 전
Operation: 
	0 SELECT STATEMENT
	1 TABLE ACCESS FULL
* 인덱스 사용 후
Operation:
	0 SELECT STATEMENT
	1 TABLE ACCESS BY INDEX ROWID
	2 INDEX RANGE SCANE
=> 대용량 데이터가 저장된 테이블의 경우 인덱스 생성 시 consistent gets, physical reads 등 I/O 지표와 time이 줄어든 것을 볼 수 있음
</pre>

<pre>
* 인덱스 생성
CREATE INDEX index_name ON table_name(column_name);
* 인덱스 상태 확인
SELECT index_name, status FROM user_indexes [WHERE table_name = 'table_name'];
* Unusable일 경우 (ex - 테이블을 MOVE할 경우 index 행이 변경되어 Unusable한 상태로 변경될 경우 있음)
ALTER INDEX index_name REBUILD;
* 인덱스 삭제
DROP INDEX index_name;
</pre>

### Advisor
<ul>
	<li>ADDM</li>
	<li>SQL Tuning Advisor => Bad SQL</li>
	<li>SQL Access Advisor => Index</li>
	<li>Memory Advisor (버전 별 메모리 관리 방법 다름, Memory Advisor만 있는 경우는 11G 이상)</li>
	<ul>
		<li>PGA Advisor(10G)</li>
		<li>SGA Advisor(10G)</li>
		<ul>
			<li>Buffer Cache Advisor(9~)</li>
			<li>Shared Pool Advisor(9~)</li>
			<li>Java Pool Advisor(9~)</li>
			<li>Streams Pool Advisor(9~)</li>
		</ul>
	</ul>
	<li>Space</li>
	<ul>
		<li>Segment Advisor => Table</li>
		<li>Undo Advisotr => Undo</li>
	</ul>
	<li>Backup</li>
	<ul>
		<li>MTTR Advisor</li>
	</ul>
</ul>

### Automated Maintenance Tasks
<p>Default Autotask maintenance jobs (일정 취소/조정 가능)</p>
<ul>
	<li>Gathering optimizer statistics</li>
	<li>Automatic Segment Advisor</li>
	<li>Automatic SQL Advisor</li>
</ul>

### Alert

#### Alert Types and Clearing Alerts
<p>Threshold(stateful) alert: Threshold가 수치화(metric based)되어 있는 경우(ex- 97% Critical, 85% Warning)</p>
<p>Nonthreshold(stateless) alert: Threshold가 수치화되지 못하는(event based) 경우 (ex) Snapshot Too Old, Resumable Session Suspended, Recovery Area Low On Free Space)</p>
<ul>
	<li>Resumable Session: 하나의 트랜잭션이 공간 할당 문제로 더 이상 작업이 불가능할 경우 해당 문제가 해결될 때까지 해당 트랜잭션의 작업이 중단되지 않고 잠시 연기시키는 기능</li>
	<li>Snapshot too old: 문장 레벨 읽기 일관성 => 문장 실행 후에는 중간에 값이 변경(Commit)되더라도 변경되기 전값(Undo 데이터)을 사용. Long Query 중 UNDO 공간 부족으로 변경 전값이 삭제되어 전값을 읽을 수 없으면 해당 오류 발생.(사후 경고)</li>
</ul>

## Performance Management

### Performance Monitoring
<ul>
	<li>Memory allocation issues</li>
	<li>Resource contention</li>
	<li>Network bottlenecks</li>
	<li>I/O device contention</li>
	<li>Aplication code problems</li>
</ul>

### Managing Memory 
<ul>
	<li>Automatic Memory Management(AMM)</li>
	<li>Automatic Shared Memory Management(ASMM)</li>
	<li>Manually setting shared memory management(수동 제어)</li>
</ul>

### PGA & SGA
<p>PGA: memory region that contains data and control information for a server process</p>
<p>9~ 이전 버전(AUTO X)</p>
<ul>
	<li>Session memory</li>
	<li>Private SQL: 세션에서 최근에 사용한 SQL</li>
	<li>Sort area: 정렬 메모리, ORDER BY절 Sorting</li>
	<ul>
		<li>Parameter: SORT_AREA_SIZE = 64K</li>
		<li>테이블이 클 경우에는 Sort 메모리(64K)가 작아서 Sorting 불가능할 경우 TEMP 테이블 스페이스 사용하여 테이블 작게 소분해서 SORT MERGE 하여 정렬</li>
	</ul>
</ul>
<p>SGA</p>
<p>9~ 이전 버전</p>
<ul>
	<li>Parameter: SGA_TARGET(SGA 총량)</li>
	<li>총량에서 각각의 메모리 풀을 subarea로 잡아서 할당</li>
	<li>SGA 변경 시 DB shutdown/startup이 필요 => 운영 중에는 메모리 변경을 할 수 없음</li>
</ul>
<table>
	<thead>
		<tr>
			<th></th>
			<th>9~</th>
			<th>10G</th>
			<th>11G</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>SGA</td>
			<td>Dynamic: DB shutdown/startup 없이 메모리 사이즈 변경 가능, 다만 메모리 사이즈 줄일 경우 바로 해당 메모리 사용할 수 있는 것이 아니라 LRU 알고리즘에 맞게 데이터를 비워줘야하기 때문에 dynamic하게 바로바로 적용되지는 않는 단점 존재</td>
			<td><b>ASMM</b>(sga) => Auto: Shared Pool, Buffer Cache, Large Pool, Java Pool들이 공통으로 전체 메모리에서 고정 메모리를 제한 나머지 메모리를 사용하고 고정 memory를 지정하여 나머지 풀들이 해당 메모리를 사용함. 메모리를 훨씬 탄력적으로 사용 가능. mman(memory manager)이 메모리를 관리</td>
			<td rowspan="2"><b>AMM</b>(sga + pga) => SGA와 PGA의 전체 총량을 지정하여 SGA와 PGA 사이의 경계가 없어짐<br>
			Parameter = MEMORY_TARGET (sga, pga target은 0으로 설정), MEMORY_TARGET 0으로 지정할 경우에는 SGA, PGA 각각의 메모리 총량으로 관리하는 ASMM 방식(10G) 방식으로 관리 가능</td>
		</tr>
		<tr>
			<td>PGA</td>
			<td>Auto: SORT_AREA_SIZE와 같이 각 Server Process의 PGA마다 할당했던 공간 대신 통합 사이즈(전체 총량)로 할당하고 접속한 Server Process의 PGA의 Private한 공간을 제외한 나머지 남는 공간을 SQL Work Area로 사용. SQL Work Area는 Sort, Hash, Bitmap 작업 등 처리하는 메모리 공간.</td>
			<td>Auto: 9~ 버전 메모리 관리 방식 유지</td>
		</tr>
	</tbody>
</table>


