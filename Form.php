<?php include "../inc/dbinfo.inc";

  /* Connect to MySQL and select the database. */
  $connection = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD);

  if (mysqli_connect_errno()) echo "Failed to connect to MySQL: " . mysqli_connect_error();

  $database = mysqli_select_db($connection, DB_DATABASE);

  /* Ensure that the DETAILS table exists. */
  VerifyDetailsTable($connection, DB_DATABASE);

  /* If input fields are populated, add a row to the DETAILS table. */
  $details_name = htmlentities($_POST['NAME']);
  $details_email = htmlentities($_POST['ADDRESS']);

  if (strlen($details_name) || strlen($details_email)) {
    AddEmployee($connection, $details_name, $details_email);
  }
?>


<html>
<body>
<h1>Newsletter Form</h1>
<iframe name="dummyframe" id="dummyframe" style="display: none;"></iframe>
<!-- Input form -->
<form action="" id="myForm" target="dummmyframe" method="POST">
  <table border="0">
    <tr>
      <td>NAME</td>
      <td>ADDRESS</td>
    </tr>
    <tr>
      <td>
        <input type="text" name="NAME" maxlength="45" size="30" />
      </td>
      <td>
        <input type="text" name="ADDRESS" maxlength="90" size="60" />
      </td>
      <td>
        <input type="submit" value="SUBMIT" />
      </td>
    </tr>
  </table>
</form>
</body>
</html>




<?php
$info = mysqli_query($connection, "SELECT * FROM DETAILS");
$fopen = fopen("/var/www/html/storage.csv", "w");
            fwrite($fopen, "\n".'NAME'. ",".'ADDRESS');
            while($row = mysqli_fetch_assoc($info)){
                fwrite($fopen,"\n".$row['NAME'].",".$row['ADDRESS']);

            }
            echo shell_exec("aws s3 mv storage.csv s3://mynewsletterbucket");
            fclose($fopen);
/* Add an employee to the table. */
function AddEmployee($connection, $name, $address) {
   $n = mysqli_real_escape_string($connection, $name);
   $a = mysqli_real_escape_string($connection, $address);

   $query = "INSERT INTO DETAILS (NAME, ADDRESS) VALUES ('$n', '$a');";

   if(!mysqli_query($connection, $query)) echo("<p>Error adding employee data.</p>");
}

/* Check whether the table exists and, if not, create it. */
function VerifyDetailsTable($connection, $dbName) {
  if(!TableExists("DETAILS", $connection, $dbName))
  {
     $query = "CREATE TABLE DETAILS (
         ID int(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
         NAME VARCHAR(45),
         ADDRESS VARCHAR(90)
       )";

     if(!mysqli_query($connection, $query)) echo("<p>Error creating table.</p>");
  }
}

/* Check for the existence of a table. */
function TableExists($tableName, $connection, $dbName) {
  $t = mysqli_real_escape_string($connection, $tableName);
  $d = mysqli_real_escape_string($connection, $dbName);

  $checktable = mysqli_query($connection,
      "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_NAME = '$t' AND TABLE_SCHEMA = '$d'");

  if(mysqli_num_rows($checktable) > 0) return true;

  return false;
}
?>    

