<?php
require_once '../config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Only POST requests are allowed.']);
    exit;
}

$input = file_get_contents("php://input");
$data = json_decode($input, true);

if (!isset($data['user_id']) || !isset($data['level_id'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing required parameters: user_id and level_id.']);
    exit;
}

$user_id = intval($data['user_id']);
$level_id = intval($data['level_id']);

$conn = connect_to_database();

try {
    $stmt = $conn->prepare("
        INSERT INTO completed_levels (user_id, level_id, date)
        VALUES (:user_id, :level_id, NOW())
    ");
    $stmt->execute([
        'user_id' => $user_id,
        'level_id' => $level_id
    ]);
    echo json_encode([
        'success' => true,
        'message' => 'Level marked as completed.'
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
