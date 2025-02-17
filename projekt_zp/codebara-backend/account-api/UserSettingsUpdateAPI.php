<?php
require_once '../config.php';

function updateUserSettings() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['user_id'], $data['username'], $data['email'], $data['is_teacher'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing required fields.']);
        exit;
    }

    $conn = connect_to_database();
    $stmt = $conn->prepare("
        UPDATE users SET 
            username = :username, 
            email = :email, 
            school_name = :school_name, 
            teacher_name = :teacher_name, 
            teacher_surname = :teacher_surname, 
            is_teacher = :is_teacher 
        WHERE user_id = :user_id
    ");

    try {
        $stmt->execute([
            'username'        => trim($data['username']),
            'email'           => trim($data['email']),
            'school_name'     => $data['is_teacher'] ? trim($data['school_name']) : null,
            'teacher_name'    => $data['is_teacher'] ? trim($data['teacher_name']) : null,
            'teacher_surname' => $data['is_teacher'] ? trim($data['teacher_surname']) : null,
            'is_teacher'      => intval($data['is_teacher']),
            'user_id'         => intval($data['user_id'])
        ]);
        echo json_encode(['success' => 'User settings updated successfully.']);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

updateUserSettings();
?>
