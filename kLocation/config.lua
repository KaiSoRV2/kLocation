
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config = {

	InputKey = Keys["E"],
	Caution = 250,
	CautionPerteVehicule = 500,
	DistInteraction = 5,

	Blip = {
		Color = 5,
		Type = 77,
		Size = 0.8,
		Label = "Location",
		Ped = {hash ="ig_bankman"},
		Texte = "Appuez sur ~y~[E]~s~ pour parler à l'agent",
	},

	Position = {
		{pos = vector3(-1034.28, -2732.85, 20.16-0.99), HeadingPed = 148.79, spawnveh = vector3(-1031.62, -2729.83, 20.14), spawn_heading = 239.018},
		{pos = vector3(-1086.62, -2593.18, 20.16-0.99), HeadingPed = 248.35, spawnveh = vector3(-1084.26, -2594.77, 20.08), spawn_heading = 156.21},
	},

	Veh = {
		Car = {
			{veh = "brioso", label = "Brioso", price = 100},
			{veh = "blista", label = "Blista", price = 200},
			{veh = "rhapsody", label = "Rhapsody", price = 300},
			{veh = "issi2", label = "Issi", price = 400},
		},

		Bike = {
			{veh = "bmx", label = "BMX", price = 500},
			{veh = "tribike", label = "Tribike", price = 600},
			{veh = "faggio2", label = "Faggio", price = 700},
			{veh = "manchez", label = "Manchez", price = 800},
		},
	},

}