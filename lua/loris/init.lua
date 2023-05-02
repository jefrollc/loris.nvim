local M = {}

M.setup = function(opts)
	print("Setup options: ", opts)
end

P = function(v)
	print(vim.inspect(v))
	return v
end

M.parse_block = function()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_line = cursor_pos[1]
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

	local start_pos = -1
	local end_pos = -1
	local language = ""

	-- Start at the current line and walk backwards until we find ``` in the line
	for i = current_line - 1, 0, -1 do
		local delimiter = string.find(lines[i], "```")
		if delimiter then
			start_pos = i
			break
		end
	end

	if start_pos == -1 then
		print("Unable to find start of the code block. Cursor is not within a valid code block.")
		return
	end

	-- Start at the current line and walk forwards until we find ``` in the line
	for i = current_line, #lines do
		local delimiter = string.find(lines[i], "```")
		if delimiter then
			end_pos = i
			break
		end
	end

	if end_pos == -1 then
		print("Unable to find end of the code block. Cursor is not within a valid code block.")
		return
	end

	local first_line = lines[start_pos]
	local delimiter = string.find(first_line, "```")
	if delimiter then
		language = string.sub(first_line, delimiter + 3)
		print("Language: ", language)
	end

	if language == "" then
		print("Unable to find language. Must add a language to the code block.")
		return
	end

	-- Get the code block
	local code_block = table.concat(lines, "\n", start_pos + 2, end_pos - 1)

	print("Creating " .. language .. " file")
	print("With code block:\n", code_block)

	local file = io.open("/tmp/temp", "w")
	if file == nil then
		print("Unable to open temp file")
		return
	end
	file:write(code_block)
	file:close()
end


return M
