<?php
require_once '../config.php';

function create_level_api() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405); 
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['chapter_id'], $data['title'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing required fields.']);
        exit;
    }

    $chapter_id = intval($data['chapter_id']);
    $title = trim($data['title']);
    $conn = db_connect();

    try {
        $stmt = $conn->prepare("INSERT INTO levels (title, chapter_id) VALUES (:title, :chapter_id)");
        $stmt->execute(['title' => $title, 'chapter_id' => $chapter_id]);
        $level_id = $conn->lastInsertId();
        http_response_code(201); 
        echo json_encode([
            'success' => true,
            'level'   => [
                'level_id'   => $level_id,
                'title'      => $title,
                'chapter_id' => $chapter_id
            ]
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

create_level_api();
?>
