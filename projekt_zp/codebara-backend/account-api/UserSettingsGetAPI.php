<?php
require_once '../config.php';

function getUserSettings() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        http_response_code(405);
        echo json_encode(['error' => 'Only GET requests are allowed.']);
        exit;
    }

    if (!isset($_GET['user_id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'User ID is required.']);
        exit;
    }

    $userId = intval($_GET['user_id']);
    $conn = connect_to_database();

    try {
        $stmt = $conn->prepare("SELECT username, email, school_name, teacher_name, teacher_surname, is_teacher FROM users WHERE user_id = :user_id");
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
}

getUserSettings();
?>
