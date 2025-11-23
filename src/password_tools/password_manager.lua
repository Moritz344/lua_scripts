-- manage passwords

local json = require("dkjson")
local configFile = "passwords.json"

local bcrypt = require("bcrypt")

local file = io.open(configFile, "r")
if file == nil then
	os.execute("touch passwords.json")
end
local content = file:read("*a")
file:close()

CONFIG, POS, ERR = json.decode(content, 1, nil)

os.execute("clear")

function is_root()
	return os.getenv("USER") == "root" or os.getenv("UID") == "0"
end

function encrypt(password, log_rounds)
	local digest = bcrypt.digest(password, log_rounds)
	return digest
end

function verify(password, digest)
	return assert(bcrypt.verify(password, digest))
end

function savePassword(key, new)
	CONFIG[key] = new
	local newContent = json.encode(CONFIG, { indent = true })
	file = io.open(configFile, "w")
	file:write(newContent)
	file:close()
end

function showPasswords(show)
	if show == "all" then
		local file = io.open(configFile, "r")
		local content = file:read("*a")
		print(content)
		file:close()
	else
		if CONFIG[show] == nil then
			print("There is no password with this key.")
		else
			print(CONFIG[show])
		end
	end
end

PASSWORDS = {}

function checkIfMaster()
	return CONFIG["master"]
end

function askMasterPassword()
	-- check if master password is there
	local master = checkIfMaster()
	if master ~= nil then
		print("Whats the master password?")
		local pass = io.read()
		local r = verify(pass, master)

		if r then
			print("Correct password!")
			main()
		end
	else
		print("It is required to make a master password")
		print("master password: ")
		local pass = io.read()
		local hashed_pass = encrypt(pass, 9)
		savePassword("master", hashed_pass)
		askMasterPassword()
	end
end

function main()
	os.execute("clear")
	while true do
		print("Show Passwords [0]")
		print("Add Password [1]")
		print("Generate Password [2]")
		print("Exit [3]")

		local answer = io.read()

		if answer == "1" then
			print("Whats the password for?(Enter the key)")
			local key = io.read()
			print("What should be the password? ")
			local new_password = io.read()
			os.execute("clear")
			print("How should I store this?")
			print("[0] Hash password")
			print("[1] Plaintext")
			local answer = io.read()
			if answer == "0" then
				local encrypted_password = encrypt(new_password, 9)
				savePassword(key, encrypted_password)
				os.execute("clear")
			else
				if answer == "1" then
					savePassword(key, new_password)
					os.execute("clear")
				end
			end
		else
			if answer == "0" then
				os.execute("clear")
				print("[0] Show all")
				print("[1] Show specific")
				local answer = io.read()
				if answer == "0" then
					showPasswords("all")
				else
					if answer == "1" then
						os.execute("clear")
						print("What is the password for?(key)")
						local key = io.read()
						showPasswords(key)
					end
				end
			else
				if answer == "2" then
					os.execute("clear")
					print("What should be the length of the password?")
					local length = io.read()
					if length then
						os.execute("lua password.lua " .. length)
					end
				else
					os.exit()
				end
			end
		end
	end
end

if not is_root() then
	print("You have to be the root user to run this tool!")
	os.exit(1)
else
	askMasterPassword()
end
