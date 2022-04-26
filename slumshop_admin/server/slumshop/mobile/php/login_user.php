<?php
if (!isset($_POST)) {
    echo "failed";
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM tbl_admins WHERE admin_email = '$email' AND admin_pass = '$password'";
$result = $conn->query($sqllogin);
$numrow = $result->num_rows;

if ($numrow > 0) {
    while ($row = $result->fetch_assoc()) {
        $admin['id'] = $row['admin_id'];
        $admin['name'] = $row['admin_name'];
        $admin['email'] = $row['admin_email'];
        $admin['role'] = $row['admin_role'];
        $admin['datereg'] = $row['admin_datereg'];
    }
    $response = array('status' => 'success', 'data' => $admin);
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