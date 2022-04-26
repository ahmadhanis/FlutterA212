<?php
session_start();
if (!isset($_SESSION['sessionid'])) {
    echo "<script>alert('Session not available. Please login');</script>";
    echo "<script> window.location.replace('login.php')</script>";
    
} 
$email = $_SESSION['email'];


?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="../js/menu.js" defer></script>

    <title>Welcome to SlumShop</title>
</head>

<body>
    <!-- Sidebar -->
    <div class="w3-sidebar w3-bar-block" style="display:none" id="mySidebar">
        <button onclick="w3_close()" class="w3-bar-item w3-button w3-large">Close &times;</button>
        <div class="w3-card w3-padding w3-container w3-center" style="height:250px;width:250px"></div>
        <hr>
        <a href="#" class="w3-bar-item w3-button">My Products</a>
        <a href="#" class="w3-bar-item w3-button">Customer</a>
        <a href="#" class="w3-bar-item w3-button">Orders</a>
        <a href="#" class="w3-bar-item w3-button">Reports</a>
        <a href="#" class="w3-bar-item w3-button">Logout</a>
    </div>

    <div class="w3-yellow">
        <button class="w3-button w3-yellow w3-xlarge" onclick="w3_open()">☰</button>
        <div class="w3-container">
            <h3>My Products</h3>
            <p>
                <?php 
                echo "Welcome $email";
                ?>
            </p>
        </div>
    </div>
    <div class="w3-bar w3-yellow">
        <a href="newproduct.php" class="w3-bar-item w3-button w3-right">New Product</a>
    </div>


    <footer class="w3-footer w3-center w3-bottom w3-yellow">Slumshop</footer>

</body>

</html>