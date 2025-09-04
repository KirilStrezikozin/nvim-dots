local status, gitblame = pcall(require, "gitblame")
if not status then
    return
end

-- For configuration options, see:
-- <https://github.com/f-person/git-blame.nvim?tab=readme-ov-file>
gitblame.setup {
    enabled = false, -- disable in files by default
    message_template = " <summary> • <date> • <author> • <<sha>>",
    date_format = "%r",
    delay = 1000, -- 1 seconds
    qgitblame_display_virtual_text = 1,
    gitblame_max_commit_summary_length = 10,
}
