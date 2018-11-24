comet = {}

-- local composer = require("composer")

-- local scene = composer.newScene()

-- Дохуя
local comet_anim_options =
{
  width =500,
  height = 2500,
  numFrames = 10,
  sheetContentWidth = 5000,
  sheetContentHeight = 2500
}

local forward_comet_sheet = graphics.newImageSheet("images/default/forward.png", comet_anim_options)

local left_comet_sheet_1 = graphics.newImageSheet( "images/default/left_1.png", comet_anim_options)
local right_comet_sheet_1 = graphics.newImageSheet( "images/default/right_1.png", comet_anim_options)
local left_comet_sheet_2 = graphics.newImageSheet( "images/default/left_2.png", comet_anim_options)
local right_comet_sheet_2 = graphics.newImageSheet( "images/default/right_2.png", comet_anim_options)


comet_data =
{
  {
    name = "left",
    sheet = left_comet_sheet_1,
    start = 1,
    count = 10,
    time = 250,
    loopCount = 0
  },
  {
    name = "right",
    sheet = right_comet_sheet_1,
    start = 1,
    count = 10,
    time = 250,
    loopCount = 0
  },
  {
    name = "high_left",
    sheet = left_comet_sheet_2,
    start = 1,
    count = 10,
    time = 250,
    loopCount = 0
  },
  {
    name = "high_right",
    sheet = right_comet_sheet_2,
    start = 1,
    count = 10,
    time = 250,
    loopCount = 0
  },
  {
    name = "forward",
    sheet = forward_comet_sheet,
    start = 1,
    count = 10,
    time = 250,
    loopCount = 0
  }
}

function comet:new(folder_name, power, x, y)
    local obj= {}
    obj.folder = folder_name -- Местоположение текущего скина
    obj.scale = 0.1
    obj.power = power
    obj.sprite = display.newSprite(forward_comet_sheet, comet_data) -- Сам спрайт кометы
    obj.sprite.x = x
    obj.sprite.y = y
    obj.poses_list = {} -- здесь будут позиции для плавной анимации

    setmetatable(obj, self)
    self.__index = self
    return obj
  end

function comet:animate(command)
    self.sprite:setSequence(command)
    self.sprite:scale(self.scale, self.scale)
    self.sprite:play()
  end

function comet:get_pos()
  for i = 1,#self.poses_list do
    print(self.poses_list[i])
  end
end

--local comet = display.newSprite(forward_comet_sheet, comet_data);
-- return scene

function comet:move(x)
  self.sprite.x = self.sprite.x + x
end

function comet:new_list(f_x) -- Положение касания, чтобы дальше него не заходить
  local l_x = self.sprite.x
  if f_x - l_x < 0 then
    c_sign = -1
  else
    c_sign = 1
  end

  local check_f_x = l_x

  for i = 1, 10 do -- цикл от 1 до 10 с шагом 1
    if math.abs(check_f_x - f_x) >= self.power then
      self.poses_list[i] = c_sign  * (self.power + c_sign * math.min(0, 8 - i)) -- чтобы было +х, +х, а в конце +х -1, +х -2
      check_f_x = check_f_x + self.poses_list[i]
    end
  end
end

function comet:next_position()
    if #self.poses_list == 0 then
      result = self.sprite.x
    else
      result = self.sprite.x + self.poses_list[1]
      table.remove(self.poses_list, 1)
    end
    return result
end

function comet:move()
    self.sprite.x = self:next_position()
end
