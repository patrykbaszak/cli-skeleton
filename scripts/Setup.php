<?php

declare(strict_types=1);

use Symfony\Component\Yaml\Yaml;

require_once dirname(__DIR__).'/vendor/autoload.php';

$composer  = json_decode(file_get_contents(__DIR__ . '/../skeleton/composer.json'));
$routes = Yaml::parse(file_get_contents(__DIR__ . '/../skeleton/config/routes.yaml'));

// setup composer
$composer->title ??= 'CLI';
$composer->description ??= 'Awesome CLI';

// setup controller
$routes['controllers']['resource']['path'] = '../src/Presentation/Controller/API/';
$routes['controllers']['resource']['namespace'] = 'App\Presentation\Controller\API';

file_put_contents(__DIR__ . '/../skeleton/config/routes.yaml', Yaml::dump($routes, 10, 4));
file_put_contents(__DIR__ . '/../skeleton/composer.json', json_encode($composer, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES));
