makayam
=======

Статистика на сайте из Yandex Метрика

Для получения app_id и app_password необходимо зайти на  https://oauth.yandex.ru/client/new
В поле права выбрать Яндекс.Метрика и отметить "Получение статистики, чтение параметров своих и доверенных счётчиков "
Присоздании нового приложения вы получите :
1. Id приложения = $config['ya_app_id']
2. Пароль приложения = $config['ya_app_password']
