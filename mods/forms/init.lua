forms = {}

forms.get_hotbar_bg = function(x, y)
	local out = ""
	for i= 0, 7, 1 do
		out = out .. "image[" .. x + i ..
				"," .. y .. ";1,1;player_hb_bg.png]"
	end
	return out
end

print("forms loaded")
