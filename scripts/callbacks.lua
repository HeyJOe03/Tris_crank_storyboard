
local game_table = { {"-","-","-"},{"-","-","-"},{"-","-","-"} }

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

--- @param gre#context mapargs
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
    -- TODO: implement winning
    print("we have a winner!!!" .. someone_won(game_table).."")
    return
  end
  
  -- computer move
  local ai_row, ai_col = AI(game_table)
  
  -- computer cell set
  gre.set_value("clickable_areas.cell"..ai_row.."_"..ai_col..".image", "images/O.png")
    game_table[ai_row][ai_col] = "O"
  
  -- check if someone has won
  if (someone_won(game_table) ~= "") then
    -- TODO: implement winning
    print("we have a winner!!!" .. someone_won(game_table).."")
    return
  end  
end


function on_load(mapargs)
  print("hello world")
end