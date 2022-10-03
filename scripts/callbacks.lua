
local game_table = { {"-","-","-"},{"-","-","-"},{"-","-","-"} }

-- debug function
function print_game_table()
  local line = ""
  for i = 1,3 do
    for g = 1,3 do
      line = line .. (game_table[i][g])
     end
     print(line)
     line = ""
  end
end

-- check if someone won the game
-- returns: 
-- "X", "O", "tie"
function someone_won(tris_board)
  -- orizzontali
  if (tris_board[1][1] == tris_board[1][2] and tris_board[1][1] == tris_board[1][3] and tris_board[1][3] ~= "-") then
    return tris_board[1][1]
  end
  if (tris_board[2][1] == tris_board[2][2] and tris_board[2][1] == tris_board[2][3] and tris_board[2][3] ~= "-") then
    return tris_board[2][1]
  end
  if (tris_board[3][1] == tris_board[3][2] and tris_board[3][1] == tris_board[3][3] and tris_board[3][3] ~= "-") then
    return tris_board[3][1]
  end
  
  -- verticali
  if (tris_board[1][1] == tris_board[2][1] and tris_board[1][1] == tris_board[3][1] and tris_board[1][1] ~= "-") then
    return tris_board[1][1]
  end
  if (tris_board[1][2] == tris_board[2][2] and tris_board[1][2] == tris_board[3][2] and tris_board[1][2] ~= "-") then
    return tris_board[1][2]
  end
  if (tris_board[1][3] == tris_board[2][3] and tris_board[1][3] == tris_board[3][3] and tris_board[1][3] ~= "-") then
    return tris_board[1][3]
  end
  
  -- obliqui
  if (tris_board[1][1] == tris_board[2][2] and tris_board[1][1] == tris_board[3][3] and tris_board[2][2] ~= "-") then
    return tris_board[1][1]
  end
  if (tris_board[1][3] == tris_board[2][2] and tris_board[2][2] == tris_board[3][1] and tris_board[2][2] ~= "-") then
    return tris_board[2][2]
  end
  
  for i = 1,3 do
    for g = 1,3 do
      if(tris_board[i][g] == "-") then return "" end
    end
  end
  return "tie"

end

----------------- AI SECTION --------------
function minimax(tris_board, depth, isAIgo)
  if(someone_won(tris_board) == "O") then
    return 1
  end
  if(someone_won(tris_board) == "X") then
    return -1
  end
  if(someone_won(tris_board) == "tie") then
    return 0
  end
  
  if(isAIgo) then
    local best_score = -100
    for i = 1,3 do -- maximizing process
      for g = 1,3 do
        -- impossible negative value
        if(tris_board[i][g] == "-") then
          tris_board[i][g] = "O"
          local score = minimax(tris_board, depth + 1, false)
          tris_board[i][g] = "-"
          best_score = math.max(score,best_score)
        end
      end
    end
    return best_score
    
  else -- minimazing function
    local lower_score = 100
    for i = 1,3 do -- maximizing process
      for g = 1,3 do
        -- impossible negative value
        if(tris_board[i][g] == "-") then
          tris_board[i][g] = "X"
          local score = minimax(tris_board, depth + 1, true)
          tris_board[i][g] = "-"
          lower_score = math.min(score,lower_score)
        end
      end
    end
    return lower_score
  end
   
  
end

function AI(tris_board)
  local best_score = -1000
  local move_x = 0
  local move_y = 0
  for i = 1,3 do
    for g = 1,3 do
      if(tris_board[i][g] == "-") then
        tris_board[i][g] = "O"
        local score = minimax(tris_board, 0, false)
        tris_board[i][g] = "-"
        if (score > best_score) then 
          best_score = score
          move_x = i
          move_y = g
        end
      end
    end
  end
  return move_x, move_y
end

-------------------------------------------

-- when a cell is pressed
function cell_pressed(mapargs)
  local row = tonumber(mapargs.row)
  local col = tonumber(mapargs.col)
  local cell = "clickable_areas.cell"..row.."_"..col..".image"
  
  -- change image 
    
  if(gre.get_value(cell) == "") then
    gre.set_value(cell, "images/X.png")
    game_table[row][col] = "X"
    -- print_game_table()
  end
  
  -- check if someone has won
  if (someone_won(game_table) ~= "") then
    on_winner( someone_won(game_table))
    return
  end
  
  -- computer move
  local ai_row, ai_col = AI(game_table)
  
  -- computer cell set
  gre.set_value("clickable_areas.cell"..ai_row.."_"..ai_col..".image", "images/O.png")
    game_table[ai_row][ai_col] = "O"
  
  -- check if someone has won
  if (someone_won(game_table) ~= "") then
    on_winner( someone_won(game_table))
    return
  end  
end


function tobool(value)
  if (value == 1) then return true
  else return false end
end

local ai_starts = false

-- when switch is selected
function start_function(mapargs)
  ai_starts = tobool(gre.get_value("buttons.AI_player_switch.player_start"))
end

-- starts when AI must perform first move
function game_onload(mapargs)
  if(ai_starts) then
  print("calculating")
    local ai_row, ai_col = AI(game_table)
  
  -- computer cell set
    gre.set_value("clickable_areas.cell"..ai_row.."_"..ai_col..".image", "images/O.png")
    game_table[ai_row][ai_col] = "O"
  end
end
 
 
-- animation if someone wins
function on_winner(winner)
  gre.set_value("game_end.replay_btn.grd_x", 50)

  local comp = "game_end.end_image.image"
  gre.set_value("game_end.end_image.grd_x", 50)
  if(winner == "X") then -- tanto è impossibile vincere ahahha
    gre.set_value(comp, "images/win.jpg")
  elseif (winner == "O") then
    gre.set_value(comp, "images/evil pc.png")
  else -- tie
    gre.set_value(comp, "images/29082018_braccio-di-ferro_03.jpg")  
  end
end

function restart(mapargs)
  gre.set_value("game_end.replay_btn.grd_x", 400)
  gre.set_value("game_end.end_image.grd_x", 400)
  
  for i=1,3 do
    for g=1,3 do
      game_table[i][g] = "-"
      gre.set_value("clickable_areas.cell"..i.."_"..g..".image", "")
    end
  end
  
  game_onload()

end
 