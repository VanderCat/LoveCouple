if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("lldebugger").start()
end

function love.conf(t)
    t.identity = "SpaceShmapRemake"     -- Имя папки, в которую LÖVE будет сохранять файлы (строка)
    t.appendidentity = false            -- Искать файлы в корневой папке игры перед их поиском в папке сохранений (логическое)
    t.version = "11.4"                  -- Версия LÖVE для которой была сделана игра (строка)
    t.console = true                   -- Разрешить консольный вывод (boolean, работает только в Windows)
    t.accelerometerjoystick = true      -- Включить акселерометр на Android и iOS устройствах, представив его в виде джойстика (логическое)
    t.externalstorage = false           -- При значении true LÖVE будет сохранять данные на внешнем хранилище Android смартфона (логическое) 
    t.gammacorrect = false              -- Включить гамма-коррекцию, если поддерживается системой (логическое)

    t.audio.mic = false                 -- Запросить прова на микровон Android (boolean)
    t.audio.mixwithsystem = false       -- Не останавливать фоновую музыку при открытии LÖVE (логическое, только для Android и iOS)

    t.window.title = "SpaceShmap Remake"-- Заголовок окна (строка)
    t.window.icon = nil                 -- Путь до файла картинки, которая будет использоваться в качестве иконки окна (строка)
    --t.window.width = 144*2              -- Ширина окна (число)
    --t.window.height = 256*2             -- Высота окна (число)
    t.window.borderless = false         -- Убрать рамки у окна (логическое)
    t.window.resizable = false          -- Разрешить пользователю изменять размер окна (логическое)
    t.window.minwidth = 1               -- Минимально возможная ширина окна (число)
    t.window.minheight = 1              -- Минимально возможная высота окна (число)
    t.window.fullscreen = false         -- Включить полноэкранный режим (логическое)
    t.window.fullscreentype = "desktop" -- Выбор полноэкранного режима "desktop" или "exclusive" (строка)
    t.window.vsync = 0                  -- Использовать вертикальную синхронизацию (число)
    t.window.msaa = 0                   -- Степень мультисемплинга (число)
    t.window.display = 1                -- Номер монитора, на котором будет показано окно игры (число)
    t.window.highdpi = false            -- Включить режим высокой чёткости (логическое, только для Retina дисплеев)
    t.window.x = nil                    -- Расположение окна на дисплее по X, при значении nil - середина ширины дисплея (число)
    t.window.y = nil                    -- Расположение окна на дисплее по Y, при значении nil - середина высоты дисплея (число)

    t.modules.audio = true              -- Включить модуль audio (логическое)
    t.modules.data = true               -- Включить модуль data (логическое)
    t.modules.event = true              -- Включить модуль event (логическое)
    t.modules.font = true               -- Включить модуль font (логическое)
    t.modules.graphics = true           -- Включить модуль graphics (логическое)
    t.modules.image = true              -- Включить модуль image (логическое)
    t.modules.joystick = false          -- Включить модуль oystick (логическое)
    t.modules.keyboard = true           -- Включить модуль keyboard (логическое)
    t.modules.math = true               -- Включить модуль math (логическое)
    t.modules.mouse = true              -- Включить модуль mouse (логическое)
    t.modules.physics = true            -- Включить модуль physics (логическое)
    t.modules.sound = true              -- Включить модуль sound (логическое)
    t.modules.system = true             -- Включить модуль system (логическое)
    t.modules.thread = true             -- Включить модуль thread (логическое)
    t.modules.timer = true              -- Включить модуль timer (логическое, при выключении этого модуля deltatime будет всегда 0)
    t.modules.touch = true              -- Включить модуль touch (логическое)
    t.modules.video = true              -- Включить модуль video (логическое)
    t.modules.window = true             -- Включить модуль window (логическое)

    package.path=package.path..";Libraries/?.lua;Libraries/?/init.lua"
    package.cpath=package.cpath..";Binaries/?.dll"
    Class = require "kikito.middleclass"
    local socket = require("socket")
    local uuid = require("tieske.uuid")
    uuid.seed()
    require "extensions"
    --require "imgui"
    MAX_FPS = 0
    require "Engine.Core.GameLoop"

    require "Engine.LuaExtensions.table"
end