<?php

declare(strict_types=1);

$composer  = json_decode(file_get_contents(__DIR__ . '/../skeleton/composer.json'));

// setup composer
$composer->title ??= 'CLI';
$composer->description ??= 'Awesome CLI';
$composer->scripts->{'auto-scripts'} = (object) ['cache:clear' => 'symfony-cmd'];

file_put_contents(__DIR__ . '/../skeleton/composer.json', json_encode($composer, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
