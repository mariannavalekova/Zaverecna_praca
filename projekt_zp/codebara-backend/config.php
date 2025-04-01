<?php
class Database {
    private $host;
    private $port;
    private $user;
    private $password;
    private $database;
    private $conn;

    public function __construct($host, $port, $user, $password, $database) {
        $this->host = $host;
        $this->port = $port;
        $this->user = $user;
        $this->password = $password;
        $this->database = $database;
    }

    public function connect() {
        try {
            $dsn = "mysql:host=$this->host;port=$this->port;dbname=$this->database;charset=utf8mb4";
            $this->conn = new PDO($dsn, $this->user, $this->password);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            die("Connection failed: " . $e->getMessage());
        }

        return $this->conn;
    }

    public function close() {
        $this->conn = null; // Closing the connection
    }
}

function db_connect() {
    $database = new Database('mariadb105.r6.websupport.sk', 3315,'codebara_user', '#uW5kajMhAzEK>=gl36u', 'codebara');
    //$connection = new PDO("mysql:host=mariadb105.r6.websupport.sk;port=3315;dbname=codebara", "codebara_user", "tu_vlozte_heslo");
    $connection = $database->connect();
    
    return $connection;
}

function db_close($connection) {
    $connection = null;
}
?>


