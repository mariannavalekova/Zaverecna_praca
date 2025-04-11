-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Hostiteľ: 172.17.0.1:3306
-- Čas generovania: Pi 11.Apr 2025, 19:00
-- Verzia serveru: 10.5.26-MariaDB-ubu2004-log
-- Verzia PHP: 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Databáza: `codebara`
--

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `articles`
--

CREATE TABLE `articles` (
  `article_id` int(11) NOT NULL,
  `chapter_id` int(11) NOT NULL,
  `content` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `articles`
--

INSERT INTO `articles` (`article_id`, `chapter_id`, `content`, `created_at`, `updated_at`) VALUES
(1, 4, '<h4><strong>What is a Variable in Python?</strong></h4><p>A variable in Python is a symbolic name that refers to a value stored in memory. Unlike some other programming languages, Python does not require explicit declaration of variable types. The type of a variable is inferred based on the assigned value.<br>&nbsp;</p><h4><strong>Declaring and Assigning Variables</strong></h4><p>In Python, a variable is created as soon as a value is assigned to it using the = operator.</p><pre><code class=\"language-python\">x = 10       # Integer variable\ny = 3.14     # Floating-point variable\nname = \"John\" # String variable\nis_active = True  # Boolean variable</code></pre><p>&nbsp;</p><h4><strong>Variable Naming Rules</strong></h4><ol><li>Variable names must start with a letter (A-Z or a-z) or an underscore _.</li><li>The rest of the name can contain letters, numbers (0-9), and underscores.</li><li>Variable names are case-sensitive (age and Age are different variables).</li><li>Reserved words (keywords) cannot be used as variable names.</li></ol><pre><code class=\"language-python\">my_variable = 5\n_userName = \"Alice\"\ncount123 = 42</code></pre><p>&nbsp;</p>', '2025-02-24 13:53:06', '2025-02-27 06:26:02'),
(2, 5, '<h2>Loops in Python</h2><p>Loops allow you to repeat tasks or instructions multiple times without writing the same code again and again. Python provides two main types of loops: the <strong>for loop</strong> and the <strong>while loop</strong>.</p><h2>The for Loop</h2><p>A for loop repeats a set of instructions a specific number of times. It\'s commonly used when you know exactly how many times you want the loop to run.</p><h3>Syntax of a for loop:</h3><pre><code class=\"language-python\">for variable in range(start, end, step):\n    # Code to repeat\n</code></pre><ul><li>start is the number where the loop begins (optional; default is 0).</li><li>end is the number where the loop stops (this number is not included).</li><li>step is how much the number increases or decreases each loop iteration (optional; default is 1).</li></ul><h3>Example: Using range() in a for loop</h3><p>Let\'s print numbers from 1 to 5:</p><pre><code class=\"language-python\">for number in range(1, 6):\n    print(number)\n</code></pre><p><strong>Output:</strong></p><pre><code class=\"language-python\">1\n2\n3\n4\n5\n</code></pre><p>In this example, range(1, 6) generates numbers starting from 1 and ending at 5.</p><h3>Example: Using range() with step</h3><p>You can also specify a step to skip numbers:</p><pre><code class=\"language-python\">for number in range(0, 11, 2):\n    print(number)\n</code></pre><p><strong>Output:</strong></p><pre><code class=\"language-python\">0\n2\n4\n6\n8\n10\n</code></pre><p>Here, the loop prints even numbers from 0 to 10 by increasing by 2 each time.</p><h2>The while Loop</h2><p>A while loop repeats a block of code as long as a certain condition remains true. It\'s commonly used when you don\'t know beforehand how many times you will need the loop to run.</p><h3>Syntax of a while loop:</h3><pre><code class=\"language-python\">while condition:\n    # Code to repeat\n</code></pre><h3>Example: Printing numbers from 1 to 5 using a while loop</h3><pre><code class=\"language-python\">count = 1\n\nwhile count &lt;= 5:\n    print(count)\n    count += 1  # Adds 1 to count each time\n</code></pre><p><strong>Output:</strong></p><pre><code class=\"language-python\">1\n2\n3\n4\n5\n</code></pre><p>The loop continues as long as the condition (count &lt;= 5) remains true.</p><h2>Differences Between for and while Loops</h2><ul><li>Use a <strong>for loop</strong> when you know exactly how many times to repeat the action.</li><li>Use a <strong>while loop</strong> when repetition depends on a condition and the exact number of repetitions isn\'t known in advance.</li></ul><p>Loops help you write efficient and clear code by automating repetitive tasks easily!</p><p>&nbsp;</p>', '2025-02-25 11:17:26', '2025-03-11 13:26:11'),
(4, 3, '', '2025-03-11 13:17:37', '2025-03-24 15:55:20'),
(7, 2, '<h2>Introduction to Python</h2><p>Python is a simple, beginner-friendly programming language widely used around the world. It’s popular because it’s easy to read and understand, which makes it great for students who are just starting to learn about programming. Python can help you create almost anything—from fun games and animations to websites and even scientific programs!</p><p>One of the best things about Python is how clearly written its commands are. Instead of complicated symbols, Python uses words and simple commands that look a lot like regular English. This means you can quickly understand and write your own programs without much trouble.</p><p>For example, if you want Python to say \"Hello\" to you, you can simply write:</p><pre><code class=\"language-python\">print(\"Hello!\")</code></pre><p>Python can also solve math problems, answer questions, draw graphics, and more. Many schools choose Python as a first programming language because it helps students develop logical thinking, problem-solving skills, and creativity. With Python, you can easily turn your ideas into real working programs, making it a fun and rewarding first step into the world of coding.</p>', '2025-03-24 17:46:05', '2025-03-24 17:46:05'),
(8, 1, '<h2>Capy functions</h2><p>This chapter is documentation to the custom methods that are used in the levels.<br>All methods are written in the style capy.method(argument) for exaple:</p><pre><code class=\"language-python\">capy.say(\"Hello\") # method say with string atribute \"Hello\"</code></pre><h3>moveRight()</h3><p>This method moves hero to the right, default value is 1, maximal value is 10.</p><pre><code class=\"language-python\">capy.moveRight() # moves hero by 1 grid square to the right\ncapy.moveRight(3) # moves hero by 3 grid squares to the right</code></pre><h3>moveLeft()</h3><p>This method moves hero to the left, default value is 1, maximal value is 10.</p><pre><code class=\"language-python\">capy.moveLeft() # moves hero by 1 grid square to the left\ncapy.moveLeft(3) # moves hero by 3 grid squares to the left</code></pre><h3>moveUp()</h3><p>This method moves hero up, default value is 1, maximal value is 10.</p><pre><code class=\"language-python\">capy.moveUp() # moves hero by 1 grid square up\ncapy.moveUp(3) # moves hero by 3 grid squares up</code></pre><h3>moveDown()</h3><p>This method moves hero down, default value is 1, maximal value is 10.</p><pre><code class=\"language-python\">capy.moveDown() # moves hero by 1 grid square down\ncapy.moveDown(3) # moves hero by 3 grid squares down</code></pre><h3>say()</h3><p>This method displays its argument in the capy console under the code editor. It does not have default argument, so there must be variable, string or number assigned as argument. For more structured sentences, use combination of strings and variables converted to the string using str() method.</p><pre><code class=\"language-python\">capy.say(\"Hello!\") # shows message Hello! in the capy console\ncapy.say(\"Hello, \"+ str(name)+ \"!\") # shows Hello, Jane!, when \"Jane\" was value of the variable name </code></pre><h3>collect()</h3><p>This methods interact with tangerine objects in the level. It does not have argument. When it is called, tangerine object disappears from the level and tangerine count is increased. Capy needs to be on the square with tangerine or on the square next to the on with tangerine, to be able to collect it.</p><pre><code class=\"language-python\">capy.collect()</code></pre>', '2025-03-24 17:47:30', '2025-03-24 17:47:30'),
(9, 13, '<h2>Data Types in Python</h2><p>In Python, every value has a <strong>data type</strong>, which describes the kind of information it represents and how it can be used. Understanding data types helps you to use Python effectively and avoid common mistakes.</p><p>Here are some basic Python data types:</p><h3>Integer (int)</h3><p>Integers represent whole numbers without decimal points. They can be positive, negative, or zero</p><pre><code class=\"language-python\">\nx = 7\ny = -3 </code></pre><h3>Floating-point (float)</h3><p>Floats represent numbers with a decimal point, useful for precision in calculations.</p><pre><code class=\"language-python\">pi = 3.14\ntemperature = -2.5 </code></pre><h3>String (str)</h3><p>Strings are sequences of characters (letters, numbers, symbols). They are always enclosed in quotes (\"\" or \'\').</p><pre><code class=\"language-python\">name = \"Emma\"\nmessage = \'Hello, world!\' </code></pre><h3>Boolean (bool)</h3><p>Boolean types represent either True or False. They are useful for conditions and decisions in your programs.</p><pre><code class=\"language-python\">is_raining = True\nfinished_homework = False</code></pre><h3>Why Data Types Matter</h3><p>Knowing the data type of your variables is important because each type supports different operations. For example, you can perform mathematical operations with integers and floats, but you cannot directly perform arithmetic with strings without converting them first.</p><p>Python automatically detects the type of a variable based on the value you assign to it. If you\'re ever unsure about a variable\'s type, you can use Python’s built-in function type() to find out:</p><pre><code class=\"language-python\">\nx = 10 print(type(x))  # Output: &lt;class \'int\'&gt;</code></pre>', '2025-03-24 17:49:36', '2025-03-24 17:49:36'),
(10, 6, '<p>Imagine you\'re playing a game, and your character reaches a fork in the road. How does your character decide where to go? By making a <strong>decision</strong>! In Python, we help our programs make decisions using something called an <strong>if condition</strong>.</p><h3>What Is an if Condition?</h3><p>An if condition helps your Python program decide what to do next. It asks a simple question that has two answers: <strong>Yes (True)</strong> or <strong>No (False)</strong>.</p><p>Here\'s how you write a simple if condition in Python:</p><pre><code class=\"language-python\">age = 10\r\n\r\nif age &gt;= 8:\r\n    print(\"You can ride the rollercoaster!\")\r</code></pre><p>\n</p><p>This means that <strong>If</strong> your age is 8 or older (age &gt;= 8), the program prints \"You can ride the rollercoaster!\".</p><h3>Else - What If the Answer Is No?</h3><p>Sometimes, you want your program to do something else if the answer is \"No.\" You can add an <strong>else</strong> condition:</p><pre><code class=\"language-python\">age = 6\r\n\r\nif age &gt;= 8:\r\n    print(\"You can ride the rollercoaster!\")\r\nelse:\r\n    print(\"Sorry, you\'re too young. Try again next year!\")\r\n</code></pre><p>\n</p><p>Now, the program will say \"Sorry, you\'re too young.\" if the age is less than 8.</p><h3>What About More Than Two Choices? (elif)</h3><p>Sometimes there are more than just two options. For example, deciding what to wear based on the weather:</p><pre><code class=\"language-python\">weather = \"sunny\"\r\n\r\nif weather == \"rainy\":\r\n    print(\"Take an umbrella! 🌧️\")\r\nelif weather == \"sunny\":\r\n    print(\"Wear sunglasses! 😎\")\r\nelif weather == \"snowy\":\r\n    print(\"Wear a warm coat! ❄️\")\r\nelse:\r\n    print(\"Just dress comfortably!\")\r\n</code></pre>', '2025-04-11 16:56:54', '2025-04-11 16:56:54');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `chapters`
--

CREATE TABLE `chapters` (
  `chapter_id` int(11) NOT NULL,
  `title` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `chapters`
--

INSERT INTO `chapters` (`chapter_id`, `title`) VALUES
(1, 'How to use capy'),
(2, 'Introduction to Python'),
(3, 'Number operations'),
(4, 'Variables'),
(5, 'Loops'),
(6, 'If conditions'),
(13, 'Data types');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `class`
--

CREATE TABLE `class` (
  `class_id` int(11) NOT NULL,
  `class_code` varchar(45) NOT NULL,
  `teacher_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `class`
--

INSERT INTO `class` (`class_id`, `class_code`, `teacher_id`) VALUES
(1, 'upqLf8bKX1', 5),
(2, 'vVKJtIALJs', 5),
(3, 'mwrN1oHqXf', 5),
(4, 'wCfaC61N2p', 11);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `class_has_students`
--

CREATE TABLE `class_has_students` (
  `class_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `class_has_students`
--

INSERT INTO `class_has_students` (`class_id`, `student_id`) VALUES
(1, 6),
(4, 10);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `completed_levels`
--

CREATE TABLE `completed_levels` (
  `user_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `completed_levels`
--

INSERT INTO `completed_levels` (`user_id`, `level_id`, `date`) VALUES
(5, 38, '2025-03-24 15:39:43'),
(7, 25, '2025-03-24 16:51:58'),
(7, 26, '2025-03-24 16:52:31'),
(7, 29, '2025-03-24 16:58:00'),
(7, 30, '2025-03-24 17:00:00'),
(7, 31, '2025-03-24 17:02:01'),
(7, 36, '2025-03-18 12:19:22'),
(7, 37, '2025-03-24 15:31:14'),
(7, 38, '2025-03-24 15:44:54'),
(7, 39, '2025-03-24 16:26:48'),
(7, 40, '2025-03-24 16:45:27'),
(10, 31, '2025-03-24 17:29:33'),
(10, 37, '2025-03-24 17:20:05'),
(10, 38, '2025-03-24 17:21:01'),
(10, 39, '2025-03-24 17:22:30'),
(11, 37, '2025-03-24 18:15:06'),
(12, 25, '2025-03-24 20:13:59'),
(12, 26, '2025-03-24 20:16:57'),
(12, 27, '2025-03-24 20:18:35'),
(12, 29, '2025-03-24 20:21:54'),
(12, 37, '2025-03-24 19:57:19'),
(12, 38, '2025-03-24 19:59:53'),
(12, 39, '2025-03-24 20:08:34'),
(12, 40, '2025-03-24 20:11:57');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `levels`
--

CREATE TABLE `levels` (
  `level_id` int(11) NOT NULL,
  `title` varchar(45) NOT NULL,
  `chapter_id` int(11) NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `tangerine_count` int(11) DEFAULT NULL,
  `level_hint` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `levels`
--

INSERT INTO `levels` (`level_id`, `title`, `chapter_id`, `description`, `tangerine_count`, `level_hint`) VALUES
(25, 'Sum', 3, 'Use capy.say() to display sum of two random Integers.', 0, ''),
(26, 'Substract', 3, 'Use capy.say() to substract 5 from 36.', 0, ''),
(27, 'Multiply', 3, 'Use capy.say() to display multiplication of 5 by 3.', 0, '* is sign for multiplication in python'),
(28, 'Divide', 3, 'Use capy.say() to display division of 10 by 2.', 0, '/ is sign for division in python'),
(29, 'Printing variable', 4, 'Create a variable named name and assign your own name to it. Then, use two capy.say() methods:\nIn the first one, say \"hello\".\nIn the second one, say the value of your name variable.', 0, ''),
(30, 'Summing variables', 4, 'Create a variable named tangerines and assign it the value 0.\nUse the capy.collect() method to collect a tangerine and increment the tangerines variable by one each time you collect one.\nAfter collecting all the tangerines, use capy.say() to display the number of tangerines you\'ve collected.', 2, ''),
(31, 'For loop introduction', 5, 'Use for loop to collect 2 tangerines', 2, ''),
(36, 'Tangerine collection', 5, 'Using for loop help capy collect all tagerines:\nInitialize tangerines = 0.\nUse a for loop to move down three times.\nAfter each move, call capy.collect() and increment tangerines by 1.\nAt the end, use capy.say() to announce how many tangerines were collected.', 3, ''),
(37, 'Move right', 2, 'Using method moveRight() move capy to the finisht flag.', 0, ''),
(38, 'Move Down', 2, 'Using moveRight() and moveDown() method, move capy to the finish flag', 0, ''),
(39, 'Move left', 2, 'Move capy to the finish flag.', 0, 'moveRight(), moveLeft(), moveDown()'),
(40, 'Move up', 2, 'Using all capy move methods try to get to the finish flag.', 0, ''),
(41, 'Playground', 1, 'This is level where you can try any of capy functions from documentation to see how they work. Have fun :)', 0, '');

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `obstacles`
--

CREATE TABLE `obstacles` (
  `obstacle_id` int(11) NOT NULL,
  `level_id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `type` varchar(45) NOT NULL,
  `position_x` int(11) NOT NULL,
  `position_y` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `obstacles`
--

INSERT INTO `obstacles` (`obstacle_id`, `level_id`, `image_path`, `type`, `position_x`, `position_y`) VALUES
(107, 25, '/img/finish.png', 'finish', 352, 99),
(108, 26, '/img/finish.png', 'finish', 351, 99),
(111, 28, '/img/finish.png', 'finish', 252, 201),
(112, 27, '/img/finish.png', 'finish', 200, 149),
(113, 29, '/img/finish.png', 'finish', 302, 99),
(120, 30, '/img/tangerine.png', 'tangerine', 254, 96),
(121, 30, '/img/tangerine.png', 'tangerine', 253, 298),
(122, 30, '/img/finish.png', 'finish', 401, 300),
(123, 31, '/img/tangerine.png', 'tangerine', 204, 98),
(124, 31, '/img/tangerine.png', 'tangerine', 353, 95),
(125, 31, '/img/finish.png', 'finish', 399, 99),
(144, 37, '/img/finish.png', 'finish', 401, 99),
(145, 37, '/img/rock.png', 'rock', 50, 159),
(146, 37, '/img/rock.png', 'rock', 100, 159),
(147, 37, '/img/rock.png', 'rock', 148, 159),
(148, 37, '/img/rock.png', 'rock', 350, 157),
(149, 37, '/img/rock.png', 'rock', 300, 158),
(150, 37, '/img/rock.png', 'rock', 252, 160),
(151, 37, '/img/rock.png', 'rock', 200, 158),
(152, 37, '/img/rock.png', 'rock', 0, 157),
(183, 39, '/img/rock.png', 'rock', 349, 255),
(184, 39, '/img/rock.png', 'rock', 352, 206),
(185, 39, '/img/rock.png', 'rock', 351, 157),
(186, 39, '/img/rock.png', 'rock', 301, 158),
(187, 39, '/img/rock.png', 'rock', 250, 157),
(188, 39, '/img/rock.png', 'rock', 201, 157),
(189, 39, '/img/rock.png', 'rock', 150, 157),
(190, 39, '/img/rock.png', 'rock', 101, 156),
(191, 39, '/img/rock.png', 'rock', 49, 156),
(192, 39, '/img/rock.png', 'rock', -3, 155),
(193, 39, '/img/rock.png', 'rock', 198, 350),
(194, 39, '/img/rock.png', 'rock', 246, 352),
(195, 39, '/img/rock.png', 'rock', 297, 354),
(196, 39, '/img/rock.png', 'rock', 344, 353),
(197, 39, '/img/rock.png', 'rock', 348, 308),
(198, 39, '/img/rock.png', 'rock', 150, 352),
(199, 39, '/img/finish.png', 'finish', 102, 399),
(280, 38, '/img/rock.png', 'rock', 0, 157),
(281, 38, '/img/rock.png', 'rock', 51, 157),
(282, 38, '/img/rock.png', 'rock', 251, 265),
(283, 38, '/img/rock.png', 'rock', 251, 216),
(284, 38, '/img/rock.png', 'rock', 201, 158),
(285, 38, '/img/rock.png', 'rock', 150, 158),
(286, 38, '/img/rock.png', 'rock', 98, 159),
(287, 38, '/img/rock.png', 'rock', 251, 365),
(288, 38, '/img/rock.png', 'rock', 251, 314),
(289, 38, '/img/finish.png', 'finish', 351, 299),
(335, 40, '/img/rock.png', 'rock', 0, 149),
(336, 40, '/img/rock.png', 'rock', 52, 151),
(337, 40, '/img/rock.png', 'rock', 101, 151),
(338, 40, '/img/rock.png', 'rock', 150, 151),
(339, 40, '/img/rock.png', 'rock', 350, 298),
(340, 40, '/img/rock.png', 'rock', 351, 252),
(341, 40, '/img/rock.png', 'rock', 351, 201),
(342, 40, '/img/rock.png', 'rock', 349, 149),
(343, 40, '/img/rock.png', 'rock', 300, 148),
(344, 40, '/img/rock.png', 'rock', 249, 148),
(345, 40, '/img/rock.png', 'rock', 199, 149),
(346, 40, '/img/finish.png', 'finish', 200, 249),
(347, 40, '/img/rock.png', 'rock', 306, 298),
(348, 40, '/img/rock.png', 'rock', 263, 297),
(349, 40, '/img/rock.png', 'rock', 216, 294),
(350, 36, '/img/tangerine.png', 'tangerine', 194, 94),
(351, 36, '/img/tangerine.png', 'tangerine', 292, 195),
(352, 36, '/img/tangerine.png', 'tangerine', 388, 297),
(353, 36, '/img/finish.png', 'finish', 351, 402);

-- --------------------------------------------------------

--
-- Štruktúra tabuľky pre tabuľku `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `role` varchar(45) NOT NULL DEFAULT 'user',
  `school_name` varchar(500) DEFAULT NULL,
  `teacher_name` varchar(45) DEFAULT NULL,
  `teacher_surname` varchar(45) DEFAULT NULL,
  `is_teacher` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Sťahujem dáta pre tabuľku `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `email`, `role`, `school_name`, `teacher_name`, `teacher_surname`, `is_teacher`) VALUES
(5, 'username', '$2y$10$zegFmxC4rkPD/kGKFC7yAevTCJH12JsboX./q.vUxKl1QRj1HOhEC', 'email@gmail.com', 'user', 'UKF Nitra', 'Johny', 'Depp', 1),
(6, 'Ursula', '$2y$10$88hDtrJc2iNhlXU6OTBqe.2wHSd9ia5DSrcHD9zmmqwgHA2ZS/jvm', 'student@gmail.com', 'user', NULL, NULL, NULL, 0),
(7, 'admin', '$2y$10$Ij/MozfUxJNcUGVe2de0YumgDIhH.kiGpSzwhQIcKPYGPNRiQiS6a', 'admin@gmail.com', 'admin', NULL, NULL, NULL, 0),
(8, 'Ferko', '$2y$10$rq0jEQhtYekGYPRbpBkFV.PzAjsuXXPI0ljYIdWp3GOou/KXk9Hc2', 'student2@gmail.com', 'user', NULL, NULL, NULL, 0),
(9, 'Marianna', '$2y$10$vZhk3Unk17Eu6UnCo80gh.EIHNn0riBKdtjJ663Voi10nLnP0bUma', 'student5@gmail.com', 'user', NULL, NULL, NULL, 0),
(10, 'Mirai_007', '$2y$12$HhOGIruEEjPc8mJ0tM.4q.cnXjcp/WCHaPtD8VDsQ01B/sDU0oO6S', 'miriama.valekova@gmail.com', 'user', NULL, NULL, NULL, 0),
(11, 'Ucitel', '$2y$12$YknitpcisopGeVL1e1gyYeeddjcOc3XHNbHHPcMqnl2.46JkVpgDS', 'ucitel@gmail.com', 'user', 'UKF', 'Martin', 'Informatik', 1),
(12, 'Miroslava', '$2y$12$w86pgxaB5KFC/MuSaAqW4ern382fEb65f3cC28pott5hg.ant1VZq', 'valekova.miroslava@gmail.com', 'user', NULL, NULL, NULL, 0);

--
-- Kľúče pre exportované tabuľky
--

--
-- Indexy pre tabuľku `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`article_id`),
  ADD UNIQUE KEY `uq_chapter_id` (`chapter_id`);

--
-- Indexy pre tabuľku `chapters`
--
ALTER TABLE `chapters`
  ADD PRIMARY KEY (`chapter_id`);

--
-- Indexy pre tabuľku `class`
--
ALTER TABLE `class`
  ADD PRIMARY KEY (`class_id`),
  ADD KEY `fk_class_users1_idx` (`teacher_id`);

--
-- Indexy pre tabuľku `class_has_students`
--
ALTER TABLE `class_has_students`
  ADD PRIMARY KEY (`class_id`,`student_id`),
  ADD KEY `fk_class_has_users_users1_idx` (`student_id`),
  ADD KEY `fk_class_has_users_class1_idx` (`class_id`);

--
-- Indexy pre tabuľku `completed_levels`
--
ALTER TABLE `completed_levels`
  ADD PRIMARY KEY (`user_id`,`level_id`),
  ADD KEY `fk_users_has_levels_users1_idx` (`user_id`),
  ADD KEY `fk_users_has_levels_levels1` (`level_id`);

--
-- Indexy pre tabuľku `levels`
--
ALTER TABLE `levels`
  ADD PRIMARY KEY (`level_id`),
  ADD KEY `fk_levels_chapters1_idx` (`chapter_id`);

--
-- Indexy pre tabuľku `obstacles`
--
ALTER TABLE `obstacles`
  ADD PRIMARY KEY (`obstacle_id`),
  ADD KEY `fk_obstacles_levels` (`level_id`);

--
-- Indexy pre tabuľku `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT pre exportované tabuľky
--

--
-- AUTO_INCREMENT pre tabuľku `articles`
--
ALTER TABLE `articles`
  MODIFY `article_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pre tabuľku `chapters`
--
ALTER TABLE `chapters`
  MODIFY `chapter_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT pre tabuľku `class`
--
ALTER TABLE `class`
  MODIFY `class_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pre tabuľku `levels`
--
ALTER TABLE `levels`
  MODIFY `level_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT pre tabuľku `obstacles`
--
ALTER TABLE `obstacles`
  MODIFY `obstacle_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=354;

--
-- AUTO_INCREMENT pre tabuľku `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Obmedzenie pre exportované tabuľky
--

--
-- Obmedzenie pre tabuľku `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`chapter_id`) REFERENCES `chapters` (`chapter_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Obmedzenie pre tabuľku `class`
--
ALTER TABLE `class`
  ADD CONSTRAINT `fk_class_users1` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `class_has_students`
--
ALTER TABLE `class_has_students`
  ADD CONSTRAINT `fk_class_has_users_class1` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_class_has_users_users1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `completed_levels`
--
ALTER TABLE `completed_levels`
  ADD CONSTRAINT `fk_users_has_levels_levels1` FOREIGN KEY (`level_id`) REFERENCES `levels` (`level_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_users_has_levels_users1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `levels`
--
ALTER TABLE `levels`
  ADD CONSTRAINT `fk_levels_chapters1` FOREIGN KEY (`chapter_id`) REFERENCES `chapters` (`chapter_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Obmedzenie pre tabuľku `obstacles`
--
ALTER TABLE `obstacles`
  ADD CONSTRAINT `fk_obstacles_levels` FOREIGN KEY (`level_id`) REFERENCES `levels` (`level_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
