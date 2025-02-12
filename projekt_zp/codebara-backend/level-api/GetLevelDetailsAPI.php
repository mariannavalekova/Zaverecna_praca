<?php
require_once '../config.php';

function get_level_details_api() {
    header('Content-Type: application/json');

    if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
        http_response_code(405);
        echo json_encode(['error' => 'Only GET requests are allowed.']);
        exit;
    }

    if (!isset($_GET['level_id'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing level_id parameter.']);
        exit;
    }

    $level_id = intval($_GET['level_id']);
    $conn = connect_to_database();

    try {
        // Fetch level data
        $stmt = $conn->prepare("SELECT level_id, title, description FROM levels WHERE level_id = :level_id");
        $stmt->execute(['level_id' => $level_id]);
        $level = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$level) {
            http_response_code(404);
            echo json_encode(['error' => 'Level not found.']);
            exit;
        }

        // Fetch obstacles for this level
        $stmt2 = $conn->prepare("
            SELECT obstacle_id, image_path, type, position_x, position_y 
            FROM obstacles 
            WHERE level_id = :level_id
        ");
        $stmt2->execute(['level_id' => $level_id]);
        $obstacles = $stmt2->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode([
            'level' => [
                'level_id'   => $level['level_id'],
                'title'      => $level['title'],
                'description'=> $level['description'],
            ],
            'obstacles' => $obstacles
        ]);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['error' => 'Database error: ' . $e->getMessage()]);
    }
}

get_level_details_api();
?>
