


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
  
  return ""

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
  if (someone_won(game_table) ~= "") then
    -- TODO: implement winning
    print("we have a winner!!!" .. someone_won(game_table).."")
  end
  
  turno = not(turno)
  
  -- computer move
  local ai_row, ai_col = AI()
  
  -- computer cell set
  gre.set_value("clickable_areas.cell"..ai_row.."_"..ai_col..".image", "images/O.png")
    game_table[ai_row][ai_col] = "O"
  
  -- check if someone has won
  if (someone_won(game_table) ~= "") then
    -- TODO: implement winning
    print("we have a winner!!!" .. someone_won(game_table).."")
  end
  
  turno = not(turno)
  
end
