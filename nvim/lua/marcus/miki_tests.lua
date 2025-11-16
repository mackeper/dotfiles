local miki = require("marcus.miki")


local MikiTests = {}

MikiTests._relative_path = function()
    local tests = {
        {
            from = "C:/git/wiki/98_Journal/2025-11-02.md",
            to = "C:/git/wiki/01_Work/02_Radiotherapy/01_Vendors/IBA/ProteusONE.md",
            expected = "../01_Work/02_Radiotherapy/01_Vendors/IBA/ProteusONE.md"
        },
        {
            from = "C:/git/wiki/98_Journal/2025-11-02.md",
            to = "C:/git/wiki/98_Journal/2025-11-01.md",
            expected = "2025-11-01.md"
        },
        {
            from = "C:/git/wiki/01_Work/index.md",
            to = "C:/git/wiki/01_Work/02_Radiotherapy/index.md",
            expected = "./02_Radiotherapy/index.md"
        },
    }

    for _, test in ipairs(tests) do
        local result = miki._relative_path(test.from, test.to)
        if result == test.expected then
            vim.notify("Test passed for from: " .. test.from .. " to: " .. test.to, vim.log.levels.INFO)
        else
            vim.notify("Test failed for from: " .. test.from .. " to: " .. test.to ..
                ". Expected: " .. test.expected .. ", got: " .. result, vim.log.levels.ERROR)
        end
    end
end

function MikiTests.run_all()
    vim.notify("Running Miki tests...", vim.log.levels.INFO)
    MikiTests._relative_path()
    vim.notify("Miki tests completed.", vim.log.levels.INFO)
end

MikiTests.run_all()

return MikiTests
