<?php
require_once '../config.php';

function get_levels_api() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        http_response_code(405); // Method Not Allowed
        echo json_encode(['error' => 'Only GET requests are allowed.']);
        exit;
    }

    if (!isset($_GET['chapter_id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing chapter_id parameter.']);
        exit;
    }

    $chapter_id = intval($_GET['chapter_id']);
    $conn = connect_to_database();

    try {
        $stmt = $conn->prepare("SELECT level_id, title, chapter_id, description, aswer_string FROM levels WHERE chapter_id = :chapter_id ORDER BY level_id ASC");
        $stmt->execute(['chapter_id' => $chapter_id]);
        $levels = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode(['levels' => $levels]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

get_levels_api();
?>
