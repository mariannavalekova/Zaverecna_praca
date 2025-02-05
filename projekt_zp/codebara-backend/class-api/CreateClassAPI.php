<?php
require_once '../config.php';

function generateRandomString($length = 10) {
    $characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[random_int(0, $charactersLength - 1)];
    }
    return $randomString;
}

function createClass() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['teacher_id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing teacher_id.']);
        exit;
    }

    $teacher_id = intval($data['teacher_id']);
    $class_code = generateRandomString(10);

    $conn = connect_to_database();

    try {
        $stmt = $conn->prepare("INSERT INTO class (class_code, teacher_id) VALUES (:class_code, :teacher_id)");
        $stmt->execute([
            'class_code' => $class_code,
            'teacher_id' => $teacher_id,
        ]);
        $class_id = $conn->lastInsertId();
        echo json_encode([
            'success' => true,
            'class'   => [
                'class_id'   => $class_id,
                'class_code' => $class_code,
                'teacher_id' => $teacher_id,
            ],
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

createClass();
?>
