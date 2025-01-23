Custom Enum Library for Roblox
Overview
The Custom Enum Library for Roblox allows you to define and manage custom enumerations in your Roblox games, providing an efficient and flexible way to handle constant values associated with specific categories or types. This library leverages hashing and metatables to ensure that enum items are uniquely identified and easy to use while offering excellent performance. You can create custom enums, check valid enum items, and retrieve values by name or hash.

Features
Custom Enum Creation: Define and register your own enums with unique names and values.
Efficient Hashing: Each enum and enum item is hashed for quick access and uniqueness.
Read-only Enums: Ensures that once an enum is created, its values cannot be modified, enforcing immutability.
Strong Type Safety: Ensures enums and enum items are handled correctly with type-checking functions.
Error Handling: Provides meaningful error messages when invalid operations or values are encountered.
Usage
Create a Custom Enum
You can create a custom enum by using the newEnum function. Define your enum name and its items.

```lua
local MyEnum = Enum.new("MyEnum", {
    Item1 = 1,
    Item2 = 2,
    Item3 = 3
})
```
Access Enum Items
To access a specific enum item by its name:

```lua
local item = MyEnum.Item1
print(item)  -- Output: the corresponding value of Item1 (1)
```
Check if a Value is a Valid Enum Item
You can check if a value is a valid enum item:

```lua
if Enum.isEnumItem(MyEnum.Item2) then
    print("Item2 is a valid enum item!")
end
```
Get Enum Item by Value
You can retrieve an enum item using its numeric value:

```lua
local item = MyEnum:FromValue(2)
print(item)  -- Output: the corresponding enum item for value 2
```
Get Enum Name from Value
You can get the name of an enum item based on its value:

```lua
local name = MyEnum:GetNameFromValue(2)
print(name)  -- Output: Item2
```
Enum Item Count
You can get the total number of enum items in an enum:

```lua
local count = #MyEnum
print(count)  -- Output: the number of items in the enum
```
Get All Registered Enums
To get a list of all registered enums:

```lua
local enums = Enum.getRegisteredEnums()
for _, enum in ipairs(enums) do
    print(enum)
end
```
API Documentation
- **newEnum(enumName: string, enumItems: table):**
Creates a new enum with the given name and items. Each item should have a unique value, either a number or a string.

- **Enum:FromValue(value: number):**
Returns the enum item corresponding to the given value. Throws an error if the value is invalid.

- **Enum:GetNameFromValue(value: number):**
Returns the name of the enum item associated with the provided value.

- **Enum:GetEnumItems():**
Returns a list of all enum item names in the enum.

- **Enum.isEnum(enum: Enum):**
Checks if the provided object is a valid enum.

- **Enum.isEnumItem(enumItem: EnumItem):**
Checks if the provided object is a valid enum item.

- **__len():**
Returns the number of enum items in the enum.

- **__tostring():**
Returns the string representation of the enum name.

License
This library is open-source and licensed under the MIT License.
