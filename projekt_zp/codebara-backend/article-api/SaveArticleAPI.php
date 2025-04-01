<?php
require_once '../config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Only POST requests are allowed.']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
if (!isset($data['chapter_id']) || !isset($data['content'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing chapter_id or content']);
    exit;
}

$chapter_id = intval($data['chapter_id']);
$content = $data['content'];
$conn = db_connect();

try {
    $stmt = $conn->prepare("SELECT article_id FROM articles WHERE chapter_id = :chapter_id");
    $stmt->execute(['chapter_id' => $chapter_id]);
    $article = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($article) {
        $stmt = $conn->prepare("UPDATE articles SET content = :content, updated_at = CURRENT_TIMESTAMP WHERE chapter_id = :chapter_id");
        $stmt->execute(['content' => $content, 'chapter_id' => $chapter_id]);
    } else {
        $stmt = $conn->prepare("INSERT INTO articles (chapter_id, content) VALUES (:chapter_id, :content)");
        $stmt->execute(['chapter_id' => $chapter_id, 'content' => $content]);
    }
    echo json_encode(['success' => true]);
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
}
?>
