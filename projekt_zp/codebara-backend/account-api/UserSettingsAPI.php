<?php
require_once '../config.php';

function user_settings_api() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        if (!isset($_GET['user_id'])) {
            http_response_code(400);
            echo json_encode(['error' => 'User ID is required.']);
            exit;
        }

        $userId = intval($_GET['user_id']);
        $conn = connect_to_database();

        try {
            $stmt = $conn->prepare("SELECT username, email, role, school_name, teacher_name, teacher_surname, is_teacher FROM users WHERE user_id = :user_id");
            $stmt->execute(['user_id' => $userId]);
            $userData = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($userData) {
                echo json_encode($userData);
            } else {
                http_response_code(404);
                echo json_encode(['error' => 'User not found.']);
            }
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
        }
        exit;
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $data = json_decode(file_get_contents('php://input'), true);

        if (!isset($data['username'], $data['email'], $data['is_teacher'])) {
            http_response_code(400);
            echo json_encode(['error' => 'Missing required fields.']);
            exit;
        }

        $conn = connect_to_database();
        $stmt = $conn->prepare("
            UPDATE users SET email = :email, school_name = :school_name, teacher_name = :teacher_name, 
            teacher_surname = :teacher_surname, is_teacher = :is_teacher WHERE username = :username
        ");

        try {
            $stmt->execute([
                'email'          => trim($data['email']),
                'school_name'    => $data['is_teacher'] ? trim($data['school_name']) : null,
                'teacher_name'   => $data['is_teacher'] ? trim($data['teacher_name']) : null,
                'teacher_surname'=> $data['is_teacher'] ? trim($data['teacher_surname']) : null,
                'is_teacher'     => intval($data['is_teacher']),
                'username'       => trim($data['username']),
            ]);
            echo json_encode(['success' => 'User settings updated successfully.']);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
        }
        exit;
    }

    http_response_code(405);
    echo json_encode(['error' => 'Only GET and POST requests are allowed.']);
}

user_settings_api();
?>
