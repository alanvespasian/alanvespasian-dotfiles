return {

  { "nvimdev/dashboard-nvim", enabled = false },
  { "echasnovski/mini.starter", enabled = false },
  -- Dashboard. This runs when neovim starts, and is what displays
  -- the "LAZYVIM" banner.
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    enabled = true,
    init = false,
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
             ]  ___       
              \\||      
             ,'_,-\     
             ;'____\    
             || =\=|    
             ||  - |                               
         ,---'._--''-,,---------.--.----_,         
        / `-._- _--/,,|  ___,,--'--'._<            
       /-._,  `-.__;,,|'                           
      /   ;\      / , ;                            
     /  ,' | _ - ',/, ;
    (  (   |     /, ,,;
     \  \  |     ',,/,;
      \  \ |    /, / ,;
     (| ,^.|   / ,, ,/;
      `-'./ `-._,, ,/,;
           �-._ `-._,,;
           |/,,`-._ `-.
           |, ,;, ,`-._\


      ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      -- stylua: ignore
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file",       "<cmd> Telescope find_files <cr>"),
        dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
        dashboard.button("r", " " .. " Recent files",    "<cmd> Telescope oldfiles <cr>"),
        dashboard.button("g", " " .. " Find text",       "<cmd> Telescope live_grep <cr>"),
        dashboard.button("c", " " .. " Config", "<cmd>e ~/.config/nvim/init.lua<cr>"),
        dashboard.button("q", "  Quit", ":qa")
}
for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          once = true,
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

require("alpha").setup(dashboard.opts)

vim.api.nvim_create_autocmd("User", {
  once = true,
  pattern = "LazyVimStarted",
  callback = function()
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

    -- List of possible phrases
    local phrases = {
      [[    "Imperatorem ait stantem mori oportere" - Titus Flavius Vespasianus ]],
      [[ 🚀 "Cubiculum sine libris est sicut corpus sine anima" - Marcus Tullius Cicero ]], 
      [[     "Omne novum initium ex fine alterius initii venit" - Lucius Annaeus Seneca ]],
     [[ 🔥 "Vir iratus iterum sibi irascitur cum ad rationem redit" - Publilius Syrus ]], 
    }

    -- Select a random phrase
    math.randomseed(os.time()) -- Ensure randomness
    local random_phrase = phrases[math.random(1, #phrases)]

    dashboard.section.footer.val = random_phrase
    pcall(vim.cmd.AlphaRedraw)
  end,
})
    end,
  },
}
