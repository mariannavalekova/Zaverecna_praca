<?php
require_once '../config.php';

function delete_level_api() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405); 
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['level_id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing level_id field.']);
        exit;
    }

    $level_id = intval($data['level_id']);
    $conn = db_connect();

    try {
        $stmt = $conn->prepare("DELETE FROM levels WHERE level_id = :level_id");
        $stmt->execute(['level_id' => $level_id]);
        echo json_encode(['success' => true, 'message' => 'Level deleted successfully.']);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

delete_level_api();
?>
