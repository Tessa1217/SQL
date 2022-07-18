# Database Management

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
  <li>Value-based auditing => DML 감사에 적합 (값이 남는 감사)</li>
</ul>


