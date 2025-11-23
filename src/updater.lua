os.execute("clear")
print("Datum:", os.date())
print("Diese Paketen können geupdated werden:")
print("--------------------------------------")
os.execute("apt list --upgradable")
print("")

print("Soll ich updaten? (y/N)")
local answer = io.read()
if answer == "y" then
	os.execute("clear")
	os.execute("sudo apt update")
else
	print("Exiting...")
	os.execute("clear")
	os.exit()
end

print("Soll ich eine umfassendes Update machen? (y/N)")

local answer_2 = io.read()

if answer_2 == "y" then
	os.execute("clear")
	os.execute("sudo apt full-upgrade")
	os.execute("clear")
else
	os.execute("clear")
	os.exit()
end
