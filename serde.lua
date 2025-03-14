-- serde.lua

local m = {}

local function try_parse_num(str)
    local num = tonumber(str)

    if num == nil then
        return nil
    else
        return num
    end
end

local function unpack_tagged_pair(item, str, index)
    local tag, k, v, i = string.unpack(item, str, index)
    if tag == '__FUNCTION__' then
        v = load(v)
    elseif tag == '__TABLE__' then
        v = m.de(v)
    else
        -- pass, no-op
    end

    -- if the key can be parsed to a number, it is an integer index
    if try_parse_num(k) ~= nil then
        k = try_parse_num(k)
    end

    return k, v, i + 1 -- all terms are padded with 1 byte, so we skip that
end

local function unpack_pair(item, str, index)
    local k, v, i = string.unpack(item, str, index)
    if item == 'sb' then
        -- handle bools
        if v == 0 then
            v = false
        elseif v == 1 then
            v = true
        else
            v = nil
        end
    end

    if try_parse_num(k) ~= nil then
        k = try_parse_num(k)
    end

    return k, v, i + 1
end

---Serializes a table and returns a packed string. Supported member types for the table are:
---string, number, boolean, nil, table, and function
---@param tbl any
---@return string
m.ser = function(tbl)
    local packedData = ''
    local encodeFormat = ''

    for k, v in pairs(tbl) do
        if type(v) == 'string' then
            encodeFormat = encodeFormat .. 'ssx'
            packedData = packedData .. string.pack('ssx', k, v)
        elseif type(v) == 'number' then
            encodeFormat = encodeFormat .. 'snx'
            packedData = packedData .. string.pack('snx', k, v)
        elseif type(v) == 'boolean' then
            encodeFormat = encodeFormat .. 'sbx'
            packedData = packedData .. string.pack('sbx', k, v and 1 or 0)
        elseif type(v) == 'nil' then
            encodeFormat = encodeFormat .. 'sbx'
            packedData = packedData .. string.pack('sbx', k, 2)
        elseif type(v) == 'function' then
            encodeFormat = encodeFormat .. 'sssx'
            packedData = packedData .. string.pack('sssx', '__FUNCTION__', k, string.dump(v))
        elseif type(v) == 'table' then
            encodeFormat = encodeFormat .. 'sssx'
            packedData = packedData .. string.pack('sssx', '__TABLE__', k, m.ser(v))
        end
    end

    packedData = string.pack('s', encodeFormat) .. packedData
    return packedData
end

---Deserializes a string packed by ser and returns the unpacked table.
---@param str (string)
---@return table
m.de = function(str)
    local unpackedData = {}
    local index = 1
    local encodeFormat = ''

    encodeFormat, index = string.unpack('s', str, index)

    for item in string.gmatch(encodeFormat, '([^x]+)x') do
        if #item == 3 then
            local k, v, i = unpack_tagged_pair(item, str, index)
            unpackedData[k] = v
            index = i
        else
            local k, v, i = unpack_pair(item, str, index)
            unpackedData[k] = v
            index = i
        end
    end

    return unpackedData
end

return m
