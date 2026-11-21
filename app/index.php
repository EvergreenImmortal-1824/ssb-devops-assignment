<?php
$configFile = __DIR__ . '/config.php';
if (!file_exists($configFile)) {
    die("Configuration file missing. Copy config.example.php to config.php.");
}
$config = require $configFile;

try {
    $dsn = "mysql:host={$config['db_host']};dbname={$config['db_name']};charset=utf8mb4";
    $pdo = new PDO($dsn, $config['db_user'], $config['db_pass'], [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    error_log("Database connection failed: " . $e->getMessage());
    http_response_code(500);
    die("Database connection error. Check server logs for details.");
}

// Handle Create (INSERT) and Update (UPDATE) actions
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['action']) && $_POST['action'] === 'create') {
        $title = trim($_POST['title'] ?? '');
        $owner = trim($_POST['owner'] ?? '');
        if ($title !== '' && $owner !== '') {
            $stmt = $pdo->prepare("INSERT INTO tasks (title, owner, status) VALUES (?, ?, 'Pending')");
            $stmt->execute([$title, $owner]);
        }
    } elseif (isset($_POST['action']) && $_POST['action'] === 'toggle' && isset($_POST['id'])) {
        $stmt = $pdo->prepare("UPDATE tasks SET status = IF(status = 'Pending', 'Completed', 'Pending') WHERE id = ?");
        $stmt->execute([(int)$_POST['id']]);
    }
    header("Location: " . $_SERVER['PHP_SELF']);
    exit;
}

// Fetch all records (SELECT)
$tasks = $pdo->query("SELECT id, title, owner, status, created_at FROM tasks ORDER BY id DESC")->fetchAll();
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SSB Digital - Ops Task Tracker</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 800px; margin: 40px auto; padding: 0 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
        form.inline { display: inline; }
        input[type="text"] { padding: 8px; margin-right: 8px; }
        button { padding: 8px 12px; cursor: pointer; }
    </style>
</head>
<body>
    <h2>SSB Digital | Internal Ops Tasks</h2>

    <!-- Create Form -->
    <form method="POST">
        <input type="hidden" name="action" value="create">
        <input type="text" name="title" placeholder="Task description (e.g., Check SSL)" required>
        <input type="text" name="owner" placeholder="Assigned to (e.g., Rahul)" required>
        <button type="submit">Add Task</button>
    </form>

    <!-- Records List -->
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Task</th>
                <th>Owner</th>
                <th>Status</th>
                <th>Created At</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($tasks as $task): ?>
            <tr>
                <td><?= htmlspecialchars($task['id']) ?></td>
                <td><?= htmlspecialchars($task['title']) ?></td>
                <td><?= htmlspecialchars($task['owner']) ?></td>
                <td><strong><?= htmlspecialchars($task['status']) ?></strong></td>
                <td><?= htmlspecialchars($task['created_at']) ?></td>
                <td>
                    <form method="POST" class="inline">
                        <input type="hidden" name="action" value="toggle">
                        <input type="hidden" name="id" value="<?= (int)$task['id'] ?>">
                        <button type="submit">Toggle Status</button>
                    </form>
                </td>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</body>
</html>
