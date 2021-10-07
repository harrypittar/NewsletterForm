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