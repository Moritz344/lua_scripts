-- generate password
SPECIAL_CHANCE = 0.3
UPPERCASE_CHANCE = 0.3
PASSWORD_LENGTH = 12
CHARS = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l" }
SPECIAL_CHARS = { "!", "@", "$", "%", "&" }
UPPERCASE = true
SPECIAL = true

function help()
	print("Usage: lua password.lua <password_length> ")
	os.exit()
end

function handleArgv()
	local password_length = arg[1]

	if #arg < 1 then
		help()
	end

	if password_length == nil then
		password_length = "12"
	else
		PASSWORD_LENGTH = password_length
	end
end

function main()
	handleArgv()

	local password = {}

	math.randomseed(os.time())

	for _ = 1, PASSWORD_LENGTH, 1 do
		local char = CHARS[math.random(1, #CHARS)]
		if UPPERCASE and math.random() < UPPERCASE_CHANCE then
			char = string.upper(char)
		else
			if SPECIAL and math.random() < SPECIAL_CHANCE then
				char = SPECIAL_CHARS[math.random(1, #SPECIAL_CHARS)]
			end
		end
		table.insert(password, char)
	end
	print("Password:", table.concat(password))
end

main()
