


local turno = true

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

function someone_won()
  -- orizzontali
  if (game_table[1][1] == game_table[1][2] and game_table[1][1] == game_table[1][3] and game_table[1][3] ~= "-") then
    return true
  end
  if (game_table[2][1] == game_table[2][2] and game_table[2][1] == game_table[2][3] and game_table[2][3] ~= "-") then
    return true
  end
  if (game_table[3][1] == game_table[3][2] and game_table[3][1] == game_table[3][3] and game_table[3][3] ~= "-") then
    return true
  end
  
  -- verticali
  if (game_table[1][1] == game_table[2][1] and game_table[1][1] == game_table[3][1] and game_table[1][1] ~= "-") then
    return true
  end
  if (game_table[1][2] == game_table[2][2] and game_table[1][2] == game_table[3][2] and game_table[1][2] ~= "-") then
    return true
  end
  if (game_table[1][3] == game_table[2][3] and game_table[1][3] == game_table[3][3] and game_table[1][3] ~= "-") then
    return true
  end
  
  -- obliqui
  if (game_table[1][1] == game_table[2][2] and game_table[1][1] == game_table[3][3] and game_table[2][2] ~= "-") then
    return true
  end
  if (game_table[1][3] == game_table[2][2] and game_table[2][2] == game_table[3][1] and game_table[2][2] ~= "-") then
    return true
  end
  
  return false

end


function AI()
  return 1,1
end



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
  if (someone_won()) then
    -- TODO: implement winning
    print("we have a winner!!!")
  end
  
  turno = not(turno)
  
  -- computer move
  local ai_row, ai_col = AI()
  
  -- computer cell set
  gre.set_value("clickable_areas.cell"..ai_row.."_"..ai_col..".image", "images/O.png")
    game_table[ai_row][ai_col] = "O"
  
  -- check if someone has won
  if (someone_won()) then
    -- TODO: implement winning
    print("we have a winner!!!")
  end
  
  turno = not(turno)
  
end
