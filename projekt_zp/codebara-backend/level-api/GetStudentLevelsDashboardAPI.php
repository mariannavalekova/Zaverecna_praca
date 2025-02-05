<?php
require_once '../config.php';

function getStudentLevelsDashboard() {
    header('Content-Type: application/json');

    // Allow only GET requests
    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        http_response_code(405);
        echo json_encode(['error' => 'Only GET requests are allowed.']);
        exit;
    }

    // Ensure the user_id parameter is provided
    if (!isset($_GET['user_id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing user_id parameter.']);
        exit;
    }

    $user_id = intval($_GET['user_id']);
    $conn = connect_to_database();

    try {
        // Query each chapter with subqueries to count total levels and completed levels for the given user
        $sql = "
            SELECT 
                c.chapter_id, 
                c.title,
                (SELECT COUNT(*) FROM levels l WHERE l.chapter_id = c.chapter_id) AS total_levels,
                (SELECT COUNT(*) 
                   FROM completed_levels cl 
                   JOIN levels l ON cl.level_id = l.level_id 
                   WHERE cl.user_id = :user_id AND l.chapter_id = c.chapter_id
                ) AS completed_levels
            FROM chapters c
        ";

        $stmt = $conn->prepare($sql);
        $stmt->execute(['user_id' => $user_id]);
        $chapters = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode(['chapters' => $chapters]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

getStudentLevelsDashboard();
?>
