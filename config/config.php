<?php

$config = array();

// Yandex login
$config['ya_login'] = '';
//Yandex password
$config['ya_password'] = '';

// Для получения app_id и app_password необходимо зайти на  https://oauth.yandex.ru/client/new
// В поле права выбрать Яндекс.Метрика и отметить "Получение статистики, чтение параметров своих и доверенных счётчиков "
//  Присоздании нового приложения вы получите :
// 1. Id приложения = $config['ya_app_id']
// 2. Пароль приложения = $config['ya_app_password']

//Yandex app ID
$config['ya_app_id'] = '';
//Yandex app password
$config['ya_app_password'] = '';

// Номер счетчика. Посмотреть можно тут http://metrika.yandex.ru/grants/
$config['ya_counter_id'] = '';

// Периоды обновления статистики. 
// В промежутках между периодами статистика будет браться из кеш
$config['ya_update_time'] = 60*60;

Config::Set('router.page.makayam', 'PluginMakayam_ActionMakayam');


if (is_file(dirname(__FILE__) . '/config.local.php')) 
{
    include(dirname(__FILE__) . '/config.local.php');
}

return $config;

