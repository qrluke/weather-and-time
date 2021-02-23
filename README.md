<h1 align="center">weather-and-time</h1>

<p align="center">

<img src="https://img.shields.io/badge/made%20for-GTA%20SA--MP-blue" >

<img src="https://img.shields.io/badge/Server-Any-red">

<img src="https://img.shields.io/github/languages/top/qrlk/weather-and-time">

<img src="https://img.shields.io/badge/dynamic/json?color=blueviolet&label=users%20%28active%29&query=result&url=http%3A%2F%2Fqrlk.me%2Fdev%2Fmoonloader%2Fusers_active.php%3Fscript%3Dwat">

<img src="https://img.shields.io/badge/dynamic/json?color=blueviolet&label=users%20%28all%20time%29&query=result&url=http%3A%2F%2Fqrlk.me%2Fdev%2Fmoonloader%2Fusers_all.php%3Fscript%3Dwat">

<img src="https://img.shields.io/badge/moonloader-v.026.5--beta-blue" >

</p>

A **[moonloader](https://gtaforums.com/topic/890987-moonloader/)** script that allows you to manage the weather and time in **[gta samp](https://sa-mp.com/)**.  

It also requires **[CLEO 4+](http://cleo.li/?lang=ru)** and **[SAMPFUNCS 5+](https://blast.hk/threads/17/)**.

---

**The following description is in Russian, because it is the main language of the user base**.

# Описание 
Скрипт добавляет кучу возможностей для управления погодой и временем. Отличается от похожих стабильностью, некоторыми уникальными функциями, удобством использования (не нужно учить таблицу погоды) и сохранением настроек (если установил погоду/время, то она никогда не "слетит", даже после релога).

**Требования:** [CLEO 4+](http://cleo.li/?lang=ru), [SAMPFUNCS 5+](https://blast.hk/threads/17/), [MoonLoader](https://blast.hk/threads/13305/).  
**Активация:** Скрипт активируется автоматом, а настроить его можно в собственной менюшке (/weather или /wat). В скрипте реализовано автообновление (можно отключить в настройках).  


# Ссылки
* **Автор:** [qrlk](https://qrlk.me/).  
* **Тема на BlastHack:** [ссылка](https://www.blast.hk/threads/19459/).
* **Страница в группе VK:** [ссылка](https://vk.com/qrlk.mods?w=page-168860334_54271682).
* **Список скриптов QRLK MODS:** [ссылка](https://vk.com/qrlk.mods?w=page-168860334_54271482).

P.S. Группа VK не обновляется.
## Функции погоды:

* **Случайный выбор погоды.**
  * Если функция активна, скрипт будет автоматически менять погоду каждые 3-10 минут. Обычный рандом, погода не зависит от местности и циклов, как это было в одиночной игре. Если погода не понравилась, можно перейти к следующей, нажав **END**.

* **Изменить погоду (стабильная).**
  * Даёт возможность менять погоду на стабильную, т.е. она будет "адекватной" в любое время. В GTA:SA таких погод всего 23, хотя можно установить любое значение.
  + Команда **/sw** открывает диалог с описанием идов, из которого можно быстро установить нужную погоду. Диалог открывается, если выбрать из меню.
  * Команда **/sw [0-22]** быстро меняет погоду (должна быть стабильной).

* **Изменить погоду (нестабильная).**
  * Даёт возможность установить любой ид погоды через меню, команду **/setweather**, **/setweather [id]**.

* **Открыть галерею ID погоды.**
  * Открывает в браузере галерею ID погоды GTA:SA, где можно найти какой-нибудь красивый ID и посмотреть, в какое время он адекватно работает.

* **Случайный выбор погоды.**
  * Нажмите **END** на клавиатуре, чтобы быстро изменить погоду на случайную. Если активен режим "Случайный выбор погоды", то этой клавишей можно перейти к следующей рандомной погоде.


## Функции времени:

* **Синхронизация локального времени.**
  * Если функция активна, время вашего компьютера будет влиять на время игры. Если у вас 20 часов, то и в игре 20 часов. Меня всегда бесило, что у тебя ночь, а в игре день.

* **Изменить время вручную.**
  * Устанавливает время **0-23** часа через меню или команду **/st [0-23]**.

# Скриншоты
![https://i.imgur.com/EcCpOim.png?1](https://i.imgur.com/EcCpOim.png?1)  
![https://i.imgur.com/zXQlH89.jpg?2](https://i.imgur.com/zXQlH89.jpg?2)  
![https://i.imgur.com/7lQrOZq.jpg?2](https://i.imgur.com/7lQrOZq.jpg?2)  
