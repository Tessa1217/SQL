# SQL
## PL/SQL Basic Block Structure  
<p>DECLARE<p>
  <ul>
    <li>Declare variables, cursor, exceptions etc used within blocks</li>
  </ul>
<p>BEGIN <sub>(Required)</sub><p>
  <ul>
    <li>Actual query statements being processed</li>
  </ul>
<p>EXCEPTION<p>
  <ul>
    <li>Exceptions being processed</li>
  </ul>
<p>END; <sub>(Required)</sub><p>
<p>/</p>

## Types of PL/SQL Blocks
<table>
  <thead>
    <tr>
      <th>Anonymous</th>
      <th>Procedure</th>
      <th>Function</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>블록에 이름 지정하지 않은 익명의 프로시저, 재호출 불가</td>
      <td>Named procedure, 재호출 가능</td>
      <td>리턴되는 값이 있음</td>
    </tr>
  </tbody>
</table>


