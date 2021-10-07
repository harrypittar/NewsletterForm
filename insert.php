<?php
$server = "localhost";
$username = "root";
$password = "password";
$dbname = "newsletterform";

$conn = mysqli_connect($server, $username, $password, $dbname );
if(isset($_POST['submit'])){

    if(!empty($_POST['name']) && !empty($_POST['mail']) && !empty($_POST['mob_digits'])){
        
        $name = $_POST['name'];
        $mail = $_POST['mail'];
        $mob_digits = $_POST['mob_digits'];
        
        $query = "insert into details(name,email,phone) values('$name','$mail', '$mob_digits')";
        $run = mysqli_query($conn, $query) or die(mysqli_error($conn));

        if($run){
            echo " Form submitted successfully" ;
            $query = mysqli_query($conn, "SELECT * FROM details");
            $fopen = fopen("/var/www/admin/storage.csv", "w");
            fwrite($fopen, "\n".'name'. ",".'email'. ",".'phone');
            while($row = mysqli_fetch_assoc($query)){
                fwrite($fopen,"\n".$row['name'].",".$row['email'].",".$row['phone']);

            }
            echo shell_exec("aws s3 mv storage.csv s3://newsletterbucket");
            fclose($fopen);


        }
        else{
            echo "Form not submitted" ;
        }
    }
    else{
    echo " all fields required";
    }
}

?>