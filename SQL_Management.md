# Database Management

## Command Lines
<pre>
- DB start
SYS > startup nomount|mount
- DB shutdown normal|transactional|immediate|abort
SYS > shutdown option
- Listener management
lsnrctl (listener control)
  - start
  - stop
  - status
  - services
- Oracle Enterprise Manager
emctl start dbconsole
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
  <li>Standard database auditing(표준 데이터베이스 감사) (일반 계정 활동 감사) => DML 감사에는 부적합</li>
  <li>Fine-grained auditing(FGA) (일반 계정 활동 감사) => DML 감사에는 부적합</li>
  <li>Value-based auditing => DML 감사에 적합 (값이 남는 감사, 값의 변경 여부 감사하는데 적합)</li>
    <ul>
      <li>Trigger 사용 가능</li>
    </ul>
</ul>

#### Standard Database Auditing
<p>Standard Database Auditing Setting</p>
<ol>
  <li>Enable databse auditing</li>
    <ul>
      <li>Parameter => audit_trail(감사 기록) = 감사 기록을 남기는 장소 지정</li>
      <li>audit_trail은 대표적인 정적 파라미터(설정 시 DB ON/OFF 필요)</li>
      <li>장소 옵션: none, DB, OS, xml</li>
    </ul>
  <li>Specify audit options: 감사 대상  지정</li>
    <ul>
      <li>System 권한 감사(Audited Privileges)</li>
      <li>Object 권한 감사(Audited Objects)</li>
      <li>명령문 감사(Audited Statements)</li>
    </ul>
  <li>Review audit information: 감사 결과 확인</li>
  <li>Maintain audit trail: 기록 백업 </li>
</ol>


