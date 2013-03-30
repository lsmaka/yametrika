<?php

$config = array();

// Yandex login
$config['ya_login'] = '';
//Yandex password
$config['ya_password'] = '';

// ��� ��������� app_id � app_password ���������� ����� ��  https://oauth.yandex.ru/client/new
// � ���� ����� ������� ������.������� � �������� "��������� ����������, ������ ���������� ����� � ���������� ��������� "
//  ����������� ������ ���������� �� �������� :
// 1. Id ���������� = $config['ya_app_id']
// 2. ������ ���������� = $config['ya_app_password']

//Yandex app ID
$config['ya_app_id'] = '';
//Yandex app password
$config['ya_app_password'] = '';

// ����� ��������. ���������� ����� ��� http://metrika.yandex.ru/grants/
$config['ya_counter_id'] = '';

// ������� ���������� ����������. 
// � ����������� ����� ��������� ���������� ����� ������� �� ���
$config['ya_update_time'] = 60*60;

Config::Set('router.page.makayam', 'PluginMakayam_ActionMakayam');


if (is_file(dirname(__FILE__) . '/config.local.php')) 
{
    include(dirname(__FILE__) . '/config.local.php');
}

return $config;

