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

Config::Set('router.page.makayam', 'PluginMakayam_ActionMakayam');

return $config;
