local Language = {}

local Task = require("yabs.task")

local output_types = require("yabs/defaults").output_types

function Language:new(args)
    local state = {
        name = args.name,
        -- command = args.command,
        tasks = args.tasks,
        default_task = args.default_task,
        type = args.type,
        output = args.output,
        opts = args.opts
    }

    self.__index = self
    return setmetatable(state, self)
end

function Language:setup(M, args)
    if not self.output then self.output = M.default_output end
    if not self.type then self.type = M.default_type end

    for task, options in pairs(self.tasks) do
        self:add_task(task, options)
    end

    M.languages[self.name] = self

    if args then
        if args.default == true then
            M.default_language = self
        end
        if args.override == true then
            M.override_language = self
        end
    end
end

function Language:add_task(name, args)
    args.name = name
    local task = Task:new(args)
    task:setup(self)
end

function Language:set_output(output)
    -- Set output of this language to output type `output`
    assert(type(output) == "string", "Type of output argument must be string!")
    output = output_types[output]
    self.output = output
    return output
end

function Language:run_task(task)
    -- self.tasks[task]:run()
    if type(task) == "string" then
        self.tasks[task]:run()
    elseif type(task) == "table" then
        -- TODO: Add error checking for each sequential command
        for _, subtask in ipairs(task) do
            self.tasks[subtask]:run()
        end
    end
end

function Language:run_default_task()
    self:run_task(self.default_task)
end

return Language
