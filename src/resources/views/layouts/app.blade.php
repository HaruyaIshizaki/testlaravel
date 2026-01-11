<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>@yield('title', 'My Website')</title>
    <style>
        header { background: #667eea; color: white; padding: 20px; }
        nav { background: #333; padding: 10px; }
        nav a { color: white; margin: 0 15px; text-decoration: none; }
        main { max-width: 1200px; margin: 20px auto; padding: 20px; }
        footer { background: #333; color: white; text-align: center; padding: 20px; margin-top: 40px; }
    </style>
</head>
<body>
    <header>
        <h1>My Laravel Website</h1>
    </header>

    <nav>
        <a href="/layout/home">ホーム</a>
        <a href="/layout/about">会社概要</a>
        <a href="/layout/contact">お問い合わせ</a>
    </nav>

    <main>
        @yield('content')
    </main>

    <footer>
        <p>© 2025 My Website</p>
    </footer>
</body>
</html>
