<?php
require_once '../config.php';

function delete_chapter_api() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405); // Method Not Allowed
        echo json_encode(['error' => 'Only POST requests are allowed.']);
        exit;
    }

    $data = json_decode(file_get_contents('php://input'), true);
    if (!isset($data['chapter_id'])) {
        http_response_code(400); // Bad Request
        echo json_encode(['error' => 'Missing chapter_id field.']);
        exit;
    }

    $chapter_id = intval($data['chapter_id']);
    $conn = connect_to_database();

    try {
        $stmt = $conn->prepare("DELETE FROM chapters WHERE chapter_id = :chapter_id");
        $stmt->execute(['chapter_id' => $chapter_id]);
        echo json_encode(['success' => true, 'message' => 'Chapter deleted successfully.']);
    } catch (PDOException $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

delete_chapter_api();
?>
