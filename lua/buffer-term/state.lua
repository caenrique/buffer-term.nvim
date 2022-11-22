local State = {}

function State.default()
  return {
    id = {},
    buffer = {},
    last = nil,
  }
end

local this = State.default()

function State.set(term)
  vim.pretty_print(term)
  this.id[term.id] = term
  this.buffer[term.terminal_buffer] = term
end

function State.find_by_id(id)
  return this.id[id]
end

function State.find_by_buffer(buffer)
  return this.buffer[buffer]
end

function State.delete(buf)
  local term = this.buffer[buf]

  this.buffer[buf] = nil
  this.id[term.id] = nil

  if this.last == term.id then
    this.last = nil
  end
end

return setmetatable(this, {__index = State})
