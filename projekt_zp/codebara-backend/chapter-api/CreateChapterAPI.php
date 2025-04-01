<?php
require_once '../config.php';

function create_chapter_api() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405); 
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    $data = json_decode(file_get_contents('php://input'), true);

    if (!isset($data['title']) || empty(trim($data['title']))) {
        http_response_code(400);
        echo json_encode(['error' => 'Chapter title is required.']);
        exit;
    }

    $title = trim($data['title']);
    $conn = db_connect();

    try {
        $stmt = $conn->prepare("INSERT INTO chapters (title) VALUES (:title)");
        $stmt->execute(['title' => $title]);
        $chapter_id = $conn->lastInsertId();

        http_response_code(201); 
        echo json_encode([
            'success' => true,
            'chapter' => [
                'chapter_id' => $chapter_id,
                'title'      => $title
            ]
        ]);
    } catch (PDOException $e) {
        http_response_code(500); 
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
        exit;
    }
}

create_chapter_api();
?>
