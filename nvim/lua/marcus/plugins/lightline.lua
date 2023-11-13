return {
    'itchyny/lightline.vim',
    enabled = false,
    config = function()
        vim.g.lightline = {
            theme = 'rosepine',
            active = {
                left = {
                    { 'mode', 'paste' },
                    { 'gitbranch', 'readonly', 'filename', 'modified' }
                },
                right = {
                    { 'lineinfo' },
                    { },
                    { 'fileformat', 'fileencoding', 'filetype' }
                }
            },
            component = {
                gitbranch = '%{FugitiveStatusline()}',
                readonly = '%{&readonly?"":""}',
                filename = '%t',
                modified = '%{&modified?"*":""}',
                lineinfo = '%3l:%-2c',
                percent = '%3p%%',
                fileformat = '%{&fileformat}',
                fileencoding = '%{&fileencoding}',
                filetype = '%{&filetype}'
            }
        }
    end
}
