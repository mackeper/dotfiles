local function on_exit(job_id, code, event)
    print("on_exit: job_id=" .. job_id .. ", code=" .. code)
    -- ... (rest of your code)
end

local function on_stdout(job_id, data, event)
    print("on_stdout: " .. vim.fn.join(data, "\n"))
end

local function on_stderr(job_id, data, event)
    print("on_stderr: " .. vim.fn.join(data, "\n"))
end

function MP()
    print("Markdown2Pdf")
    local current_file = vim.fn.expand("%:p")
    local output_file = vim.fn.expand("%:p:r") .. ".html"
    local pandoc_cmd = "pandoc " .. current_file .. " -f markdown -t html -s -o " .. output_file
    
    local pandoc_job = vim.fn.jobstart(pandoc_cmd, {
        on_exit = on_exit,
        on_stdout = on_stdout,
        on_stderr = on_stderr
    })

    if pandoc_job <= 0 then
        print("Failed to start job")
    else
        print("Started job with id " .. pandoc_job)
    end
end
