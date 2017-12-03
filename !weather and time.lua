script_name("Weather and Time")
script_version("1.2")
script_author("James_Bond/rubbishman/Coulson")
local LIP = {};
local dlstatus = require('moonloader').download_status
local mod_submenus_sa = {
	{
		title = 'Информация о скрипте',
		onclick = function()
			wait(100)
			cmdScriptInfo()
		end
	},
	{
		title = ' '
	},
	{
		title = '{AAAAAA}Функции погоды'
	},
	{
		title = 'Случайный выбор погоды',
		onclick = function()
			wait(100)
			cmdWeather1Toggle()
		end
	},
	{
		title = 'Изменить погоду (стабильная)',
		onclick = function()
			wait(100)
			cmdChangeWeatherDialog()
		end
	},
	{
		title = 'Изменить погоду (нестабильная)',
		onclick = function()
			wait(100)
			cmdSetCustomWeather()
		end
	},
	{
		title = 'Открыть галерею ID погоды',
		onclick = function()
			cmdHelpWeather()
		end
	},
	{
		title = ' '
	},
	{
		title = '{AAAAAA}Функции времени'
	},
	{
		title = 'Синхронизация локального времени',
		onclick = function()
			cmdTimeNot()
		end
	},
	{
		title = ' '
	},
	{
		title = '{AAAAAA}Настройки'
	},
	{
		title = 'Настройки скрипта',
		submenu = {
			{
				title = 'Включить/выключить уведомление при запуске',
				onclick = function()
					cmdWeatherInform()
				end
			},
		}
	},
	{
		title = ' '
	},
	{
		title = '{AAAAAA}Обновления'
	},
	{
		title = 'История обновлений',
		onclick = function()
			changelog()
		end
	},
	{
		title = 'Принудительно обновить',
		onclick = function()
			lua_thread.create(goupdate)
		end
	},
}
require 'lib.moonloader'
require 'lib.sampfuncs'
--MAIN function
function main()
	if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	lua_thread.create(checkversion)
	while goplay == 0 or goplay == 2 do wait(100) end
	firstload()
	onload()
	while true do
		wait(0)
		if menutrigger ~= nil then menu() menutrigger = nil end
		if weatherrandom12:status() == 'dead' then weatherrandom12:run() end
		if timesync:status() == 'dead' then timesync:run() end
		if addweather ~= nil then forceWeatherNow(addweather) end
	end
end
--ИНИЦИАЛИЗАЦИЯ ИНИКА
function firstload()
	if not doesDirectoryExist("moonloader\\config") then createDirectory("moonloader\\config") end
	if not doesFileExist("moonloader\\config\\weather and time.ini") then
		local data =
		{
			options =
			{
				startmessage = 1,
				timebycomp = 1,
				weatherrandom1 = 0,
			},
		};
		LIP.save('moonloader\\config\\weather and time.ini', data);
		sampAddChatMessage(('Первый запуск скрипта. Был создан .ini: moonloader\\config\\weather and time.ini'), 0x348cb2)
	end
	data = LIP.load('moonloader\\config\\weather and time.ini');
	if data.options.weatherrandom1 == nil then data.options.weatherrandom1 = 0 end
	LIP.save('moonloader\\config\\weather and time.ini', data);
end
--ПРИ ЗАГРУЗКЕ
function onload()
	data = LIP.load('moonloader\\config\\weather and time.ini');
	LIP.save('moonloader\\config\\weather and time.ini', data);
	sampRegisterChatCommand("weather", watmenu)
	sampRegisterChatCommand("wat", watmenu)
	sampRegisterChatCommand("sw", cmdSetWeather)
	sampRegisterChatCommand("setweather", cmdSetCustomWeather)
	sampRegisterChatCommand("timenot", cmdTimeNot)
	sampRegisterChatCommand("weatherhelp", cmdHelpWeather)
	sampRegisterChatCommand("weathernot", cmdWeatherInform)
	sampRegisterChatCommand("weatherlog", changelog)
	if data.options.startmessage == 1 then sampAddChatMessage(('Weather and Time запущен. v '..thisScript().version), 0x348cb2) end
	if data.options.startmessage == 1 then sampAddChatMessage(('Подробнее - /weather. Отключить это сообщение - /weathernot'), 0x348cb2) end
	weatherrandom12 = lua_thread.create_suspended(weatherrandom1)
	weatherrandom12:terminate()
	timesync = lua_thread.create_suspended(timesync)
	timesync:terminate()
end
--TOGGLE MENU
function watmenu()
	menutrigger = 1
end
--MENU
function menu()
	submenus_show(mod_submenus_sa, '{348cb2}Weather & Time v'..thisScript().version..'', 'Выбрать', 'Закрыть', 'Назад')
end
--СИНХРОНИЗАЦИЯ ЛОКАЛЬНОГО ВРЕМЕНИ
function timesync()
	while true do
		wait(0)
		if data.options.timebycomp == 1 then setTimeOfDay(os.date("%H"), os.date("%M")) end
	end
end
--АЛГОРИТМ РАНДОМНОГО ВЫБОРА ПОГОДЫ
function weatherrandom1()
	while true do
		wait(0)
		if data.options.weatherrandom1 == 1 then
			addweather = math.random(0, 20)
			wait(math.random(240000, 480000))
		end
	end
end
--ДИАЛОГ /SETWEATHER
function cmdChangeWeatherUnstableDialog()
	sampShowDialog(987, "Изменить погоду", string.format("Введите ID погоды"), "Выбрать", "Закрыть", 1)
	while sampIsDialogActive() do wait(100) end
	cmdSetCustomWeather(sampGetCurrentDialogEditboxText(987))
end
--ДИАЛОГ /SW
function cmdChangeWeatherDialog()
	sampShowDialog(838, "/sw - изменить погоду: ", "ID\tОписание\n00\tСтандартная погода\n01\tСтандартная погода\n02\tСтандартная погода\n03\tСтандартная погода\n04\tСтандартная погода\n05\tСтандартная погода\n06\tСтандартная погода\n07\tСтандартная погода\n08\tДождь, гроза\n09\tОблачная, туманная погода\n10\tЧистое небо\n11\tОбжигающая жара\n12\tТусклая погода\n13\tТусклая погода\n14\tТусклая погода\n15\tТусклая, бесцветная погода\n16\tТусклая, дождливая\n17\tОбжигающая жара\n18\tОбжигающая жара\n19\tПесчаная буря\n20\tТуманная\n21\tОчень тёмная, пурпурная\n22\tОчень тёмная, зеленая", "Выбрать", "Закрыть", 5)
	while sampIsDialogActive() do wait(0) end
	sampCloseCurrentDialogWithButton(0)
	local resultMain, buttonMain, typ, tryyy = sampHasDialogRespond(838)
	if resultMain then
		if buttonMain == 1 then
			addweather = typ
			if data.options.weatherrandom1 == 1 then cmdWeather1Toggle() end
		end
	end
end
--ФУНКЦИЯ /SW
function cmdSetWeather(param)
	local newweather = tonumber(param)
	if newweather == nil then
		lua_thread.create(cmdChangeWeatherDialog)
	end
	if newweather ~= nil and newweather > - 1 and newweather < 23 and newweather ~= nil then
		addweather = newweather
		if data.options.weatherrandom1 == 1 then cmdWeather1Toggle() end
	end
end
--ФУНКЦИЯ /SETWEATHER
function cmdSetCustomWeather(param)
	local newweather = tonumber(param)
	print(newweather)
	if newweather == nil then
		lua_thread.create(cmdChangeWeatherUnstableDialog)
	end
	if newweather ~= nil then
		addweather = newweather
		if data.options.weatherrandom1 == 1 then cmdWeather1Toggle() end
	end
end
--ОКНО С ИНФОРМАЦИЕЙ О СКРИПТЕ
function cmdScriptInfo()
	sampShowDialog(2342, "{348cb2}Weather and Time. Автор: James_Bond/rubbishman/Coulson.", "{ffcc00}Для чего этот скрипт?\n{ffffff}Многих игроков раздражает стандартная погода на серверах SA:MP. Её не любят менять из-за того, что\nне у всех людей в "..os.date("%Y").." году достаточно мощный компьютер, чтобы рендерить дождь игры 2004 года.\nДанный скрипт призван устранить эту проблему, дав возможность управлять погодой и временем.\n{AAAAAA}Функции погоды:\n{348cb2}Случайный выбор погоды: {ffffff}искусственный интеллект выбирает случайную погоду каждые 4-8 минут.\n{348cb2}Изменить погоду (стабильная): {ffffff}изменение погоды на стабильную (0-22) через диалоговое окно.\n{348cb2}Изменить погоду (нестабильная): {ffffff}изменение погоды на нестабильную (любой id) через диалоговое окно.\n{348cb2}Открыть галерею ID погоды: {ffffff}открыть в браузере галерею с id'ами погоды.\n{AAAAAA}Функции времени:\n{348cb2}Синхронизация локального времени: {ffffff}функция меняет время игры на время компьютера.\n{ffcc00}Доступные команды:\n{00ccff}/weather {ffffff}или {00ccff}/wat{ffffff} - меню скрипта\n{00ccff}/sw {ffffff}- изменить погоду через диалоговое окно\n{00ccff}/sw [0-22] {ffffff}- изменить погоду по id (стабильная погода)\n{00ccff}/setweather {ffffff}- изменить погоду через диалоговое окно (нестабильная погода)\n{00ccff}/setweather [любой id] {ffffff}- изменить погоду по id (нестабильная погода)\n{00ccff}/weatherhelp {ffffff}- открыть галерею id'ов в браузере\n{00ccff}/timenot {ffffff}- включить/выключить функцию синхронизации локального времени\n{00ccff}/weathernot {ffffff}- включить/выключить уведомление при запуске SA:MP\n{00ccff}/weatherlog {ffffff}- changelog скрипта\n", "Лады")
end
--ФУНКЦИЯ ОТКРЫВАЕТ В БРАУЗЕРЕ ГАЛЕРЕЮ ПОГОД
function cmdHelpWeather()
	local ffi = require 'ffi'
	ffi.cdef [[
					void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
					uint32_t __stdcall CoInitializeEx(void*, uint32_t);
				]]
	local shell32 = ffi.load 'Shell32'
	local ole32 = ffi.load 'Ole32'
	ole32.CoInitializeEx(nil, 2 + 4) -- COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE
	print(shell32.ShellExecuteA(nil, 'open', 'http://dev.prineside.com/gtasa_weather_id/', nil, nil, 1))
end
--СHANGELOG
function changelog()
	sampShowDialog(2342, "{348cb2}Weather & Time v"..thisScript().version.."", "{ffcc00}v1.2 [03.11.17]\n{ffffff}У скрипта появилось меню.\n{ffcc00}v1.1 [26.10.17]\n{ffffff}Общие исправления.\n{ffcc00}v1.0 [23.10.17]\n{ffffff}Первый релиз скрипта.", "Закрыть")
end
-- ИЗМЕНЕНИЕ НАСТРОЕК
-- ИЗМЕНЕНИЕ НАСТРОЕК
function cmdWeather1Toggle()
	if data.options.weatherrandom1 == 1 then
		data.options.weatherrandom1 = 0 sampAddChatMessage(('Алгоритм изменения погоды деактивирован'), 0x348cb2)
	else
		data.options.weatherrandom1 = 1 sampAddChatMessage(('Алгоритм изменения погоды активирован'), 0x348cb2)
	end
	LIP.save('moonloader\\config\\weather and time.ini', data);
	data = LIP.load('moonloader\\config\\weather and time.ini');
end
function cmdWeatherInform()
	if data.options.startmessage == 1 then
		data.options.startmessage = 0 sampAddChatMessage(('Уведомление активации Weather and Time при запуске игры отключено'), 0x348cb2)
	else
		data.options.startmessage = 1 sampAddChatMessage(('Уведомление активации Weather and Time при запуске игры включено'), 0x348cb2)
	end
	LIP.save('moonloader\\config\\weather and time.ini', data);
	data = LIP.load('moonloader\\config\\weather and time.ini');
end
function cmdTimeNot()
	if data.options.timebycomp == 1 then
		data.options.timebycomp = 0 sampAddChatMessage(('Синхронизация локального времени отключена'), 0x348cb2)
	else
		data.options.timebycomp = 1 sampAddChatMessage(('Синхронизация локального времени включена'), 0x348cb2)
	end
	LIP.save('moonloader\\config\\weather and time.ini', data);
	data = LIP.load('moonloader\\config\\weather and time.ini');
end
-- DO NOT TOUCH
-- DO NOT TOUCH
-- DO NOT TOUCH
-- DO NOT TOUCH
--функция отвечает за удобные менюшки, спасибо фипу
function submenus_show(menu, caption, select_button, close_button, back_button)
	select_button, close_button, back_button = select_button or 'Select', close_button or 'Close', back_button or 'Back'
	prev_menus = {}
	function display(menu, id, caption)
		local string_list = {}
		for i, v in ipairs(menu) do
			table.insert(string_list, type(v.submenu) == 'table' and v.title .. '  >>' or v.title)
		end
		sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, 4)
		repeat
			wait(0)
			local result, button, list = sampHasDialogRespond(id)
			if result then
				if button == 1 and list ~= -1 then
					local item = menu[list + 1]
					if type(item.submenu) == 'table' then -- submenu
						table.insert(prev_menus, {menu = menu, caption = caption})
						if type(item.onclick) == 'function' then
							item.onclick(menu, list + 1, item.submenu)
						end
						return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
					elseif type(item.onclick) == 'function' then
						local result = item.onclick(menu, list + 1)
						if not result then return result end
						return display(menu, id, caption)
					end
				else -- if button == 0
					if #prev_menus > 0 then
						local prev_menu = prev_menus[#prev_menus]
						prev_menus[#prev_menus] = nil
						return display(prev_menu.menu, id - 1, prev_menu.caption)
					end
					return false
				end
			end
		until result
	end
	return display(menu, 31337, caption or menu.title)
end
--функция загрузки из иника
function LIP.load(fileName)
	assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
	local file = assert(io.open(fileName, 'r'), 'Error loading file : ' .. fileName);
	local data = {};
	local section;
	for line in file:lines() do
		local tempSection = line:match('^%[([^%[%]]+)%]$');
		if(tempSection)then
			section = tonumber(tempSection) and tonumber(tempSection) or tempSection;
			data[section] = data[section] or {};
		end
		local param, value = line:match('^([%w|_]+)%s-=%s-(.+)$');
		if(param and value ~= nil)then
			if(tonumber(value))then
				value = tonumber(value);
			elseif(value == 'true')then
				value = true;
			elseif(value == 'false')then
				value = false;
			end
			if(tonumber(param))then
				param = tonumber(param);
			end
			data[section][param] = value;
		end
	end
	file:close();
	return data;
end
--функция сохранения в иник
function LIP.save(fileName, data)
	assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
	assert(type(data) == 'table', 'Parameter "data" must be a table.');
	local file = assert(io.open(fileName, 'w+b'), 'Error loading file :' .. fileName);
	local contents = '';
	for section, param in pairs(data) do
		contents = contents .. ('[%s]\n'):format(section);
		for key, value in pairs(param) do
			contents = contents .. ('%s=%s\n'):format(key, tostring(value));
		end
		contents = contents .. '\n';
	end
	file:write(contents);
	file:close();
end
--функция проверки версии
function checkversion()
	goplay = 0
	local fpath = os.getenv('TEMP') .. '\\weather-version.json'
	downloadUrlToFile('http://rubbishman.ru/dev/samp/weather%20and%20time/version.json', fpath, function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
		local f = io.open(fpath, 'r')
		if f then
			local info = decodeJson(f:read('*a'))
			updatelink = info.updateurl
			if info and info.latest then
				version = tonumber(info.latest)
				if version > tonumber(thisScript().version) then
					sampAddChatMessage(('[Weather and Time]: Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь..'), 0x348cb2)
					sampAddChatMessage(('[Weather and Time]: Текущая версия: '..thisScript().version..". Новая версия: "..version), 0x348cb2)
					goplay = 2
					lua_thread.create(goupdate)
				end
			end
		end
	end
end)
wait(1000)
if goplay ~= 2 then goplay = 1 end
end
--функция обновления
function goupdate()
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
	if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
	sampAddChatMessage(('[Weather and Time]: Обновление завершено! Подробнее об обновлении - /weatherlog.'), 0x348cb2)
	goplay = 1
	thisScript():reload()
end
end)
end
