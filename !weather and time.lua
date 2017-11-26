script_name("Weather and Time")
script_version("1.1")
script_author("James_Bond/rubbishman/Coulson")
local LIP = {};
local dlstatus = require('moonloader').download_status
local mod_submenus_sa = {
	{
		title = 'Информация о скрипте',
		onclick = function()
			wait(100)
			cmdInfo()
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
				title = 'Изменить клавишу активации',
				onclick = function()
					cmdHotKey()
				end
			},
			{
				title = 'Включить/выключить уведомление при запуске',
				onclick = function()
					cmdInform()
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
function main()
	if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	lua_thread.create(checkversion)
	while goplay == 0 or goplay == 2 do wait(100) end
	firstload()
	onload()
	while true do
		wait(0)
		if data.options.timebycomp == 1 then setTimeOfDay(os.date("%H"), os.date("%M")) end
	end
end

function firstload()
	if not doesDirectoryExist("moonloader\\config") then createDirectory("moonloader\\config") end
	if not doesFileExist("moonloader\\config\\weather and time.ini") then
		local data =
		{
			options =
			{
				startmessage = 1,
				timebycomp = 1,
			},
		};
		LIP.save('moonloader\\config\\weather and time.ini', data);
		sampAddChatMessage(('Первый запуск скрипта. Был создан .ini: moonloader\\config\\weather and time.ini'), 0x348cb2)
	end
end
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
end

function watmenu()
	menutrigger = 1
end
function menu()
	submenus_show(mod_submenus_sa, '{348cb2}Weather & Time v'..thisScript().version..'', 'Выбрать', 'Закрыть', 'Назад')
end


function cmdSetWeather(param)
	local newweather = tonumber(param)
	if newweather == nil then
		lua_thread.create(cmdChangeWeatherDialog)
	end
	if newweather ~= nil and newweather > - 1 and newweather < 23 and newweather ~= nil then
		forceWeatherNow(newweather)
	end
end
function cmdChangeWeatherDialog()
	sampShowDialog(838, "/sw - изменить погоду: ", "ID\tОписание\n00\tСтандартная погода\n01\tСтандартная погода\n02\tСтандартная погода\n03\tСтандартная погода\n04\tСтандартная погода\n05\tСтандартная погода\n06\tСтандартная погода\n07\tСтандартная погода\n08\tДождь, гроза\n09\tОблачная, туманная погода\n10\tЧистое небо\n11\tОбжигающая жара\n12\tТусклая погода\n13\tТусклая погода\n14\tТусклая погода\n15\tТусклая, бесцветная погода\n16\tТусклая, дождливая\n17\tОбжигающая жара\n18\tОбжигающая жара\n19\tПесчаная буря\n20\tТуманная\n21\tОчень тёмная, пурпурная\n22\tОчень тёмная, зеленая", "Выбрать", "Закрыть", 5)
	while sampIsDialogActive() do wait(0) end
	sampCloseCurrentDialogWithButton(0)
	local resultMain, buttonMain, typ, tryyy = sampHasDialogRespond(838)
	if resultMain then
		if buttonMain == 1 then
			forceWeatherNow(typ)
		end
	end
end
function cmdSetCustomWeather(param)
	local newweather = tonumber(param)
	if newweather ~= nil then
		forceWeatherNow(newweather)
	end
end
function cmdScriptInfo()
	sampShowDialog(2342, "{ffbf00}Weather and Time. Автор: James_Bond/rubbishman/Coulson.", "{ffcc00}Для чего этот скрипт?\n{ffffff}Многих игроков раздражает стандартная погода на серверах SA:MP. Её не любят менять из-за того, что\nне у всех людей в "..os.date("%Y").." году достаточно мощный компьютер, чтобы рендерить дождь игры 2004 года.\nДанный скрипт призван устранить эту проблему, дав возможность владельцам 1080 ti нормально поиграть.\n{ffcc00}А что изменилось-то?\n{ffffff}Теперь время вашего компьютера будет влиять на время игры с точностью до минуты.\nКроме того, вы можете сами установить нужную вам погоду через команду в чате или диалог. \n{ffcc00}Доступные команды:\n{00ccff}/weather {ffffff}- это окно\n{00ccff}/sw {ffffff}- изменить погоду через диалоговое окно\n{00ccff}/sw [0-22] {ffffff}- изменить погоду по id (стабильная погода)\n{00ccff}/setweather [любое число] {ffffff}- изменить погоду по id (нестабильная погода)\n{00ccff}/weatherhelp {ffffff}- открыть базу в браузере\n{00ccff}/timenot {ffffff}- включить/выключить функцию смены игрового времени на время компьютера\n{00ccff}/weathernot {ffffff}- включить/выключить уведомление при запуске SA:MP\n{00ccff}/weatherlog {ffffff}- changelog скрипта\n\nP.S. Играясь с нестабильной погодой, нужно помнить, что id'ы выше 22 могут мешать конфортной игре\nв определённое время. Подробнее - {00ccff}/weatherhelp\n\n{ffffff}Скоро уёбищная пародия на оригинальные погодные циклы GTA San Andreas будет автоматически\nменять погоду в зависимости от длины вашего члена. В разработке..", "Лады")
end
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
function changelog()
	sampShowDialog(2342, "{ffbf00}Weather and Time: История версий.", "{ffcc00}v1.0 [23.10.17]\n{ffffff}Первый релиз скрипта.\nСкрипт уже умеет менять погоду по id.\nСкрипт уже умеет менять погоду через диалог.\nСкрипт уже умеет менять время игры по времени системы.\nСкрипт уже имеет настройки.\nСкрипт уже имеет автообновление.\nСкрипт уже имеет этот changelog.", "Закрыть")
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
		data.options.timebycomp = 0 sampAddChatMessage(('Изменение времени через время компьютера отключено'), 0x348cb2)
	else
		data.options.timebycomp = 1 sampAddChatMessage(('Изменение времени через время компьютера включено'), 0x348cb2)
	end
	LIP.save('moonloader\\config\\weather and time.ini', data);
	data = LIP.load('moonloader\\config\\weather and time.ini');
end

-- do not touch
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
