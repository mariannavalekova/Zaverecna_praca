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
        // 1. Retrieve the chapters along with total levels & completed levels
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

        // 2. For each chapter, fetch its levels (id + title or more)
        foreach ($chapters as &$chapter) {
            $chapterId = $chapter['chapter_id'];

            $stmt2 = $conn->prepare("
                SELECT level_id, title 
                FROM levels 
                WHERE chapter_id = :chapter_id
                ORDER BY level_id ASC
            ");
            $stmt2->execute(['chapter_id' => $chapterId]);
            $levels = $stmt2->fetchAll(PDO::FETCH_ASSOC);

            // attach the levels array to the chapter
            $chapter['levels'] = $levels;
        }
        unset($chapter); // good practice when referencing by &

        // 3. Return the combined result
        echo json_encode(['chapters' => $chapters]);

    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

getStudentLevelsDashboard();
