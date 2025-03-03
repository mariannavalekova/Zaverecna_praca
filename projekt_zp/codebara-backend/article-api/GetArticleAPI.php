<?php
require_once '../config.php';
header('Content-Type: application/json');

if (!isset($_GET['chapter_id'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing chapter_id']);
    exit;
}

$chapter_id = intval($_GET['chapter_id']);
$conn = connect_to_database();

try {
    $stmt = $conn->prepare("SELECT * FROM articles WHERE chapter_id = :chapter_id");
    $stmt->execute(['chapter_id' => $chapter_id]);
    $article = $stmt->fetch(PDO::FETCH_ASSOC);
    echo json_encode(['article' => $article ? $article : null]);
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>
