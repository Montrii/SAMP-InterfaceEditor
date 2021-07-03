script_name("Govno_Ebannoe")
script_author("Azller")
require "lib.moonloader"

function main()
while true do
wait (0)
  if isKeyDown(104) and not sampIsCursorActive() then
  X, Y, Z = getOffsetFromCharInWorldCoords(PLAYER_PED, 0.0, 1.0, -0.9855)
  wait (10)
  setCharCoordinates(PLAYER_PED, X, Y, Z)
  end
  if isKeyDown(102) and not sampIsCursorActive() then
  X, Y, Z = getOffsetFromCharInWorldCoords(PLAYER_PED, 1.0, 0.0, -0.9855)
  wait (10)
  setCharCoordinates(PLAYER_PED, X, Y, Z)
  end
  if isKeyDown(100) and not sampIsCursorActive() then
  X, Y, Z = getOffsetFromCharInWorldCoords(PLAYER_PED, -1.0, 0.0, -0.9855)
  wait (10)
  setCharCoordinates(PLAYER_PED, X, Y, Z)
  end
  if isKeyDown(101) and not sampIsCursorActive() then
  X, Y, Z = getOffsetFromCharInWorldCoords(PLAYER_PED, 0.0, 0.0, 0.3)
  wait (10)
  setCharCoordinates(PLAYER_PED, X, Y, Z)
  end
  if isKeyDown(96) and not sampIsCursorActive() then
  X, Y, Z = getOffsetFromCharInWorldCoords(PLAYER_PED, 0.0, 0.0, -2.0)
  wait (10)
  setCharCoordinates(PLAYER_PED, X, Y, Z)
  end
  if isKeyDown(98) and not sampIsCursorActive() then
  X, Y, Z = getOffsetFromCharInWorldCoords(PLAYER_PED, 0.0, -1.0, -0.9855)
  wait (10)
  setCharCoordinates(PLAYER_PED, X, Y, Z)
  end
end
end
