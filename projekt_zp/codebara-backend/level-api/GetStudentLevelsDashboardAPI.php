<?php
require_once '../config.php';

function getStudentLevelsDashboard() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        http_response_code(405);
        echo json_encode(['error' => 'Only GET requests are allowed.']);
        exit;
    }

    if (!isset($_GET['user_id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing user_id parameter.']);
        exit;
    }

    $user_id = intval($_GET['user_id']);
    $conn = connect_to_database();

    try {
        $sql = "
            SELECT 
                c.chapter_id, 
                c.title,
                (SELECT COUNT(*) 
                   FROM levels l 
                   WHERE l.chapter_id = c.chapter_id
                ) AS total_levels,
                (SELECT COUNT(*) 
                   FROM completed_levels cl 
                   JOIN levels l ON cl.level_id = l.level_id 
                   WHERE cl.user_id = :user_id 
                     AND l.chapter_id = c.chapter_id
                ) AS completed_levels
            FROM chapters c
        ";

        $stmt = $conn->prepare($sql);
        $stmt->execute(['user_id' => $user_id]);
        $chapters = $stmt->fetchAll(PDO::FETCH_ASSOC);

        foreach ($chapters as &$chapter) {
            $chapterId = $chapter['chapter_id'];

            $stmt2 = $conn->prepare("
                SELECT 
                    l.level_id, 
                    l.title, 
                    CASE WHEN cl.user_id IS NOT NULL THEN 1 ELSE 0 END AS completed
                FROM levels l
                LEFT JOIN completed_levels cl 
                    ON l.level_id = cl.level_id AND cl.user_id = :user_id
                WHERE l.chapter_id = :chapter_id
                ORDER BY l.level_id ASC
            ");
            $stmt2->execute(['chapter_id' => $chapterId, 'user_id' => $user_id]);
            $levels = $stmt2->fetchAll(PDO::FETCH_ASSOC);

            $chapter['levels'] = $levels;
        }
        unset($chapter);

        echo json_encode(['chapters' => $chapters]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

getStudentLevelsDashboard();
?>
