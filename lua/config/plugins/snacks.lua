return
{
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        local bkp_data = require('bookeeping.data')
        local bkp_utils = require('bookeeping.utils')
        local note = bkp_data.load_notes()
        local note_text = ""
        local bookeeping_height = 6
        if note then
            local text_array = bkp_utils.get_note_text(note)
            local maximum_notes = math.min(bookeeping_height, #text_array - 1)
            for idx = #text_array - 1, #text_array - maximum_notes, -1 do
                local unfmt_text = text_array[idx]
                local formatted_text = ''
                while string.len(unfmt_text) > 60 do
                    formatted_text = string.sub(unfmt_text, 1, 60) .. '\n'
                    unfmt_text = string.sub(unfmt_text, 61, string.len(unfmt_text))
                end
                formatted_text = formatted_text .. unfmt_text
                note_text = formatted_text .. '\n' .. note_text
            end
        else
            note_text = "No notes available"
        end
        require('snacks').setup({
            dashboard = {
                enabled = true,
                sections = {
                    {
                        section = 'terminal',
                        cmd = 'img2art "~/Pictures/berserk.png" --scale .06 --with-color --threshold 60',
                        height = 14,
                        padding = {2, 1},
                        width = 60,
                        indent = 30,
                    },
                    { section = "keys", title = '  Shortcuts', icon = '  ➨', padding = 1 },
                    { pane = 2, text = '', padding = 15 },
                    { pane = 2, icon = "   ", title = "Recent Files", section = "recent_files", padding = 1 },
                    { pane = 2, icon = "   ", title = "Projects", section = "projects", padding = 1 },
                    {
                        pane = 2,
                        icon = "   ",
                        title = "Git Status",
                        section = "terminal",
                        enabled = function()
                            return Snacks.git.get_root() ~= nil
                        end,
                        cmd = "git status --short --branch --renames",
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                    },
                    {
                        title = "Bookeeping",
                        icon = "   ",
                    },
                    {
                        text = note_text,
                        padding = 11,
                        height = bookeeping_height
                    },
                    { section = "startup", indent = 5 * 11 },
                    function()
                        return {
                            text = vim.version()
                        }
                    end,
                    function()
                        return {
                            text = { { ' ' .. os.date('%X') .. '\n', hl = 'SnacksDashboardFooter' }, { ' ' .. os.date('%x'), hl = 'SnacksDashboardFooter' } },
                            indent = 5 * 11
                        }
                    end
                }
            },
        })
    end,
}
