function table.DrG_Pack(...)
  return {...}, select("#", ...)
end

function table.DrG_Unpack(tbl, size, i)
  if not isnumber(i) then i = 1 end
  if i < size then
    return tbl[i], table.DrG_Unpack(tbl, size, i+1)
  elseif i == size then return tbl[i] end
end