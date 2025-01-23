local RBXEnum = Enum
local EnumInstance = setmetatable({}, {__tostring = function() return 'Enum' end, __metatable = 'this metatable is locked', __newindex = function(self, key: string) error(("%q is read only"):format(tostring(self))) end, __index = function(self, key: string) 	error(('%s is not a valid member of %q'):format(key, tostring(self)), 2) end})

local RegisteredMember = {
	Enums = {},
	UniqueNames = {},
	RegisteredValues = {}
}

local HASH_SCALE = script:GetAttribute('HashScale') or 16

local function isEnum (enum: Enum)
	if typeof (enum) == 'Enum' then
		return true
	end
	
	if getmetatable(enum) == EnumInstance then
		return true
	end

	return false
end

local function isEnumItem (enumItem: EnumItem)
	if typeof(enumItem) == 'EnumItem' then
		return true
	end
	
	if typeof(enumItem) == 'number' then
		return GetEnumFromValue(enumItem) ~= nil
	end
	
	return false
end

local function IsNumberic(key: any)
	return typeof(key) == 'number'
end

local function HashString(name: string) : number
	local hash = 0
	for i = 1, #name do
		hash = hash + string.byte(name, i)
	end

	return math.floor(hash * HASH_SCALE)
end

local function newEnum <A> (enumName: string, enumItems: A)
	if RegisteredMember.UniqueNames[enumName] then
		error(('Enum %q is registered'):format(enumName), 2)
	end
	
	local hash = HashString(enumName)
	
	export type StringName = keyof<A>
	
	local enum = {}
	local added_values = {}
	local value_to_hash = {}
	local InternalEnumItems = {}
	local max_hash = hash
	local value_name = {}
	local item_count = 0

	function enum:GetEnumItems () : {StringName}
		return InternalEnumItems
	end

	function enum:FromName (name: StringName) : number
		return self[name]
	end

	function enum:FromValue (value: number) : number
		for key, hashValue in pairs(value_to_hash) do
			if key == value or hashValue == value then
				return hashValue
			end
		end

		error(('%s is not a valid member of %q'):format(value, tostring(self)), 2)
	end
	
	function enum:GetNameFromValue (value: number) : string
		local value = self:FromValue(value)
		if value then
			return value_name[value]
		end
	end
	


	local Enum = setmetatable({}, {
		__index = function(self, key: string)
			local value = enum[key]
			if value == nil then
				error(('%s is not a valid member of %q'):format(key, tostring(self)), 2)
			end

			return value
		end,

		__newindex = function(self, key: string)
			local value = enum[key]
			if value ~= nil then
				error(('Unable to assign property %s. Property is read only'):format(key), 2)
			end
			
			error(('%s is not a valid member of %q'):format(key, tostring(self)), 2)
		end,

		__tostring = function()
			return enumName
		end,

		__len = function() 
			return item_count
		end,
		
		__metatable = EnumInstance
	})


	export type Enum = typeof(enum)
	
	local idx = 0
	local max = math.floor(hash / HASH_SCALE) - 1
	
	for key, value in pairs(enumItems) do
		local name = key
		local enumValue = idx + 1
		if IsNumberic(key) then
			name = value
		else
			if value > 0 then
				
				if value > max then
					error(('%s: %q value is out of range. It should be between 1 and %d'):format(enumName, name, max), 2)
				end
				enumValue = math.clamp(value, 1, max)
			end
		end

		if InternalEnumItems[name] then
			warn(('EnumItem %q is a duplicate and will be ignored for %q'):format(name, enumName), 2)
			continue
		end

		while added_values[enumValue] and enumValue <= max do
			enumValue += 1
		end

		added_values[enumValue] = true
		max_hash = (hash + enumValue) - 1
		enum[name] = max_hash
		
		if RegisteredMember.RegisteredValues[max_hash] then
			error(('%s: EnumItem %q hash is already registered by another EnumItem'):format(enumName, name), 2)
		end

		value_to_hash[enumValue] = max_hash
		RegisteredMember.RegisteredValues[max_hash] = Enum
		table.insert(InternalEnumItems, name)
		item_count += 1
		
		value_name[max_hash] = name
		value_name[enumValue] = name
		
		idx = enumValue
	end

	
	table.insert(RegisteredMember.Enums, Enum)
	RegisteredMember.UniqueNames[enumName] = true

	return Enum :: Enum & A
end

local Def = {}
export type Enum = typeof(newEnum("Enum", Def))


function GetRegisteredEnums () : {[number]: Enum}
	return RegisteredMember.Enums
end

function GetEnumFromValue (value: number) : Enum
	local Enum = RegisteredMember.RegisteredValues[value]
	if Enum == nil then
		error(('%s is not a registered member of Enum'):format(value), 2)
	end
	
	return Enum
end

function GetEnumItemNameFromValue (value: number) : string
	local Enum = GetEnumFromValue(value)
	if Enum then
		return Enum:GetNameFromValue(value)
	end
end

return {
	new = newEnum,
	isEnum = isEnum,
	isEnumItem = isEnumItem,
	RBXEnum = RBXEnum,
	getEnumFromValue = GetEnumFromValue,
	getRegisteredEnums = GetRegisteredEnums,
	getEnumItemNameFromValue = GetEnumItemNameFromValue
}