--Sets up our 3x3 board matrix with the numbers above
matrix = {}
n = 1
for i=1,3 do
    matrix[i] = {}
    for j=1,3 do
        matrix[i][j] = n
        n = n + 1
    end
end

--Pressing the mouse gets its location and relates it to a spot on the board
function mousepress()
    x = math.floor(love.mouse.getX() / (love.graphics.getWidth()/3))
    y = math.floor(love.mouse.getY() / (love.graphics.getHeight()/3))
    return matrix[x+1][y+1]
end