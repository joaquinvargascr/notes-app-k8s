<!DOCTYPE html>
<html>
<head>
    <title>{{ config('app.name') }}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.3/dist/slate/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container">
    @yield('content')
</div>

</body>
</html>
