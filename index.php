<?php
    include_once 'insert.php';
?>
<!DOCTYPE html>
<html>
<head>
    <title></title>
</head>
<body>

<?php
    $sql = "SELECT * FROM details;";
    $results = mysqli_query($conn, $sql);
    $resultsCheck = mysqli_num_rows($results);

    if($resultsCheck > 0) {
        while ($row = mysqli_fetch_assoc($results)){
            echo $row['name'] . "<br>";
            echo $row['email'] . "<br>";
            echo $row['phone'] . "<br>";
            echo "" . "<br>";

        }
    }

?>

</body>
</html>