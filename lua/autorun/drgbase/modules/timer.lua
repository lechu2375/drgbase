
function timer.DrG_Loop(delay, callback)
  timer.Simple(delay, function()
    if callback() then timer.DrG_Loop(delay, callback) end
  end)
end
