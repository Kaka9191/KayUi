KayUI — Documentation

KayUI 1.0.0
Mobile Friendly UI Library

KayUI é uma biblioteca de interface gráfica para Roblox, desenvolvida em Lua, com foco em simplicidade, personalização e compatibilidade com dispositivos móveis.

Ela oferece janelas personalizáveis, abas, componentes interativos, temas visuais e notificações.

---

Índice

1. "Características" (#características)
2. "Instalação" (#instalação)
3. "Criando uma janela" (#criando-uma-janela)
4. "Criando abas" (#criando-abas)
5. "Componentes" (#componentes)
   - AddSection
   - AddLabel
   - AddButton
   - AddToggle
   - AddSlider
   - AddDropdown
   - AddKeybind
6. "Notificações" (#notificações)
7. "Temas" (#temas)
8. "Exemplo completo" (#exemplo-completo)
9. "Compatibilidade" (#compatibilidade)

---

Características

- Interface adaptável para dispositivos móveis.
- Sistema de abas com navegação.
- Janela arrastável.
- Sistema para fechar e reabrir a interface.
- Componentes interativos.
- Animações com TweenService.
- Três temas visuais.
- Notificações personalizáveis.
- Dropdown com seleção de opções.
- Keybind com configuração de teclas.

Instalação

Para carregar a biblioteca diretamente do GitHub:

local KayUI_URL =
    "https://raw.githubusercontent.com/Kaka9191/KayUi/refs/heads/main/kayUI.lua"

local Success, KayUI = pcall(function()
    return loadstring(game:HttpGet(KayUI_URL))()
end)

if not Success then
    warn("Não foi possível carregar a KayUI:", KayUI)
    return
end

Após carregar, a biblioteca estará disponível na variável "KayUI".

Criando uma janela

Use "CreateWindow()" para criar a interface principal.

local Window = KayUI:CreateWindow({
    Name = "Minha Interface",
    Theme = "Blue",
    Width = 540,
    Height = 370
})

Parâmetros

Parâmetro| Descrição| Padrão
Name| Nome exibido na janela| KAYUI
Theme| Tema visual| Blue
Width| Largura da janela| 540
Height| Altura da janela| 370

A biblioteca utiliza dimensões adaptáveis para ajustar a interface à tela.

Criando abas

Para adicionar uma aba:

local MainTab = Window:CreateTab("Principal")

Cada aba possui seus próprios componentes.

É possível criar várias abas na mesma janela.

Componentes

AddSection

Cria um título de seção dentro da aba.

MainTab:AddSection("Informações")

O texto é automaticamente convertido para letras maiúsculas.

AddLabel

Adiciona um texto informativo.

MainTab:AddLabel("Bem-vindo à minha interface!")

AddButton

Cria um botão que executa uma função ao ser pressionado.

MainTab:AddButton({
    Name = "Executar ação",

    Callback = function()
        print("Botão pressionado!")
    end
})

Parâmetros:

- "Name": texto exibido no botão.
- "Callback": função executada ao clicar.

AddToggle

Cria um interruptor para ativar ou desativar uma função.

MainTab:AddToggle({
    Name = "Ativar sistema",
    Default = false,

    Callback = function(Value)
        print("Estado:", Value)
    end
})

Parâmetros:

- "Name": nome do Toggle.
- "Default": estado inicial ("true" ou "false").
- "Callback": recebe o novo estado.

O componente também retorna métodos para controlar seu estado:

local Toggle = MainTab:AddToggle({
    Name = "Meu Toggle",
    Default = false
})

Toggle:Set(true)

print(Toggle:Get())

AddSlider

Cria um controle deslizante para selecionar valores numéricos.

MainTab:AddSlider({
    Name = "Velocidade",
    Min = 0,
    Max = 100,
    Default = 50,

    Callback = function(Value)
        print("Valor:", Value)
    end
})

Parâmetros:

- "Name": nome do Slider.
- "Min": valor mínimo.
- "Max": valor máximo.
- "Default": valor inicial.
- "Callback": recebe o valor selecionado.

O Slider retorna "Set()" e "Get()":

local Slider = MainTab:AddSlider({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Default = 50
})

Slider:Set(75)

print(Slider:Get())

AddDropdown

Cria uma lista de opções selecionáveis.

MainTab:AddDropdown({
    Name = "Selecionar opção",

    Options = {
        "Opção 1",
        "Opção 2",
        "Opção 3"
    },

    Default = "Opção 1",

    Callback = function(Value)
        print("Selecionado:", Value)
    end
})

Parâmetros:

- "Name": nome do Dropdown.
- "Options": tabela contendo as opções.
- "Default": opção selecionada inicialmente.
- "Callback": recebe a opção escolhida.

O Dropdown retorna:

local Dropdown = MainTab:AddDropdown({
    Name = "Escolher",
    Options = {"A", "B", "C"},
    Default = "A"
})

print(Dropdown:Get())

Dropdown:Set("B")

"Set()" só seleciona valores que existem na lista de opções.

AddKeybind

Cria um componente para configurar uma tecla de atalho.

MainTab:AddKeybind({
    Name = "Atalho",
    Default = Enum.KeyCode.F,

    Callback = function()
        print("Tecla pressionada!")
    end
})

Parâmetros:

- "Name": nome do Keybind.
- "Default": tecla inicial.
- "Callback": função executada quando a tecla é pressionada.

O Keybind retorna:

local Keybind = MainTab:AddKeybind({
    Name = "Meu atalho",
    Default = Enum.KeyCode.F
})

print(Keybind:Get())

Keybind:Set(Enum.KeyCode.G)

Também possui "Destroy()" para desconectar o evento e remover o componente.

Observação: o sistema atual utiliza eventos de teclado. O funcionamento do Keybind depende de entrada por teclado.

---

Notificações

A KayUI possui um sistema próprio de notificações.

KayUI:Notify(
    "Minha Interface",
    "Sistema iniciado!",
    3
)

Parâmetros:

Parâmetro| Descrição
title| Título da notificação
message| Mensagem exibida
duration| Tempo de exibição em segundos

O tempo padrão é de 3 segundos.

Temas

A KayUI possui três temas disponíveis:

Tema| Característica
Blue| Azul
Purple| Roxo
Red| Vermelho

Para selecionar um tema:

local Window = KayUI:CreateWindow({
    Name = "Minha Interface",
    Theme = "Purple"
})

Se o tema informado não existir, a biblioteca utiliza o tema Blue como padrão.

Exemplo completo

O exemplo abaixo demonstra a criação de uma interface com abas e componentes diferentes.

local Window = KayUI:CreateWindow({
    Name = "Minha Interface",
    Theme = "Blue",
    Width = 540,
    Height = 370
})

local MainTab = Window:CreateTab("Principal")
local SettingsTab = Window:CreateTab("Configurações")

MainTab:AddSection("Início")

MainTab:AddLabel("Bem-vindo à KayUI!")

MainTab:AddButton({
    Name = "Enviar notificação",

    Callback = function()
        KayUI:Notify(
            "KayUI",
            "Funcionando corretamente!",
            3
        )
    end
})

MainTab:AddToggle({
    Name = "Ativar sistema",
    Default = false,

    Callback = function(Value)
        print("Sistema:", Value)
    end
})

SettingsTab:AddSection("Personalização")

SettingsTab:AddSlider({
    Name = "Intensidade",
    Min = 0,
    Max = 100,
    Default = 50,

    Callback = function(Value)
        print("Intensidade:", Value)
    end
})

SettingsTab:AddDropdown({
    Name = "Modo",

    Options = {
        "Normal",
        "Avançado",
        "Personalizado"
    },

    Default = "Normal",

    Callback = function(Value)
        print("Modo selecionado:", Value)
    end
})

SettingsTab:AddKeybind({
    Name = "Atalho",
    Default = Enum.KeyCode.F,

    Callback = function()
        print("Atalho acionado!")
    end
})

Compatibilidade

A KayUI foi desenvolvida com suporte a interações por toque e mouse, buscando oferecer uma experiência adequada para dispositivos móveis e computadores.

O comportamento de determinados componentes pode depender do dispositivo e do ambiente de execução.

Informações do projeto

Informação| Valor
Biblioteca| KayUI
Versão| 1.0.0
Linguagem| Lua
Plataforma| Roblox
Interface| Mobile Friendly
Autor| Kayron

Repositório oficial:
https://github.com/Kaka9191/KayUi

Arquivo principal:
"kayUI.lua"

---

KayUI — Simple, customizable and mobile-friendly UI library.
