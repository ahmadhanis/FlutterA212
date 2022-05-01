<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$name = addslashes($_POST['name']);
$desc = addslashes($_POST['desc']);
$price = $_POST['price'];
$qty = $_POST['qty'];
$barcode = $_POST['barcode'];
$type = $_POST['type'];
$base64image = $_POST['image'];

$sqlinsert = "INSERT INTO `tbl_products`(`product_name`, `product_desc`, `product_category`, `product_qty`, `product_price`, `product_barcode`) VALUES ('$name','$desc','$type',$qty,$price,'$barcode')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($base64image);
    $path = '../assets/products/' . $filename . '.jpg';
    $is_written = file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>