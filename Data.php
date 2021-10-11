<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<?php include "../inc/dbinfo.inc";?>
<html>
<head><title>Newsletter Subscribers</title>
<style>
th { text-align: left; }

table, th, td {
  border: 2px solid grey;
  border-collapse: collapse;
}

th, td {
  padding: 0.2em;
}
</style>
</head>

<body>
<h1>Newsletter</h1>

<p>Subscribers:</p>

<table border="1">
<tr><th>ID</th><th>Name</th><th>Address</th></tr>

<?php

$connection = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD);
$database = mysqli_select_db($connection, DB_DATABASE);
$result = mysqli_query($connection, "SELECT * FROM DETAILS");
while($query_data = mysqli_fetch_row($result)) {
  echo "<tr>
            <td>$query_data[0]</td>
            <td>$query_data[1]</td>
            <td>$query_data[2]</td>
        </tr>\n";
}

?>
</table>
</body>
</html>	
