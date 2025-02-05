<?php
require_once '../config.php';

function create_chapter_api() {
    header('Content-Type: application/json');

    // Only allow POST requests
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405); // Method Not Allowed
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    // Get JSON input and decode it
    $data = json_decode(file_get_contents('php://input'), true);

    // Validate required field: title
    if (!isset($data['title']) || empty(trim($data['title']))) {
        http_response_code(400); // Bad Request
        echo json_encode(['error' => 'Chapter title is required.']);
        exit;
    }

    $title = trim($data['title']);
    $conn = connect_to_database();

    try {
        // Insert the new chapter into the chapters table
        $stmt = $conn->prepare("INSERT INTO chapters (title) VALUES (:title)");
        $stmt->execute(['title' => $title]);
        $chapter_id = $conn->lastInsertId();

        http_response_code(201); // Created
        echo json_encode([
            'success' => true,
            'chapter' => [
                'chapter_id' => $chapter_id,
                'title'      => $title
            ]
        ]);
    } catch (PDOException $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
        exit;
    }
}

// Call the function to handle the request
create_chapter_api();
?>
