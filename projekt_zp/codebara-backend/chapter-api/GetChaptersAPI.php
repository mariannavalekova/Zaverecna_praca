<?php
require_once '../config.php';

function get_chapters_api() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        http_response_code(405); // Method Not Allowed
        echo json_encode(['error' => 'Only GET requests are allowed.']);
        exit;
    }

    $conn = connect_to_database();

    try {
        $stmt = $conn->prepare("SELECT chapter_id, title FROM chapters ORDER BY chapter_id ASC");
        $stmt->execute();
        $chapters = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['chapters' => $chapters]);
    } catch (PDOException $e) {
        http_response_code(500); // Internal Server Error
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

get_chapters_api();
?>
