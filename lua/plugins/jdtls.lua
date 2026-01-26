return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  config = function()
    local jdtls = require("jdtls")
    local path = require("jdtls.path")
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls_workspace/" .. project_name

    -- Find jdtls installation
    local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
    
    -- Check if jdtls is installed via mason
    if vim.fn.isdirectory(jdtls_path) == 0 then
      vim.notify("jdtls not found. Please install with: :MasonInstall jdtls", vim.log.levels.ERROR)
      return
    end

    local config_path = jdtls_path .. "/config_linux"
    local plugins_path = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
    local launcher_jar = vim.fn.glob(plugins_path)

    if vim.fn.empty(launcher_jar) == 1 then
      vim.notify("jdtls launcher jar not found", vim.log.levels.ERROR)
      return
    end

    local config = {
      cmd = {
        "java",
        "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=NONE",
        "-Xms1g",
        "-Xmx2G",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        launcher_jar,
        "-configuration",
        config_path,
        "-data",
        workspace_dir,
      },
      root_dir = jdtls.setup.find_root({ ".git", "gradlew", "mvnw", "pom.xml", "build.gradle" }),
      settings = {
        java = {
          home = os.getenv("JAVA_HOME"),
          eclipse = {
            downloadSources = true,
            updateBuildConfiguration = "interactive",
          },
          configuration = {
            updateBuildConfiguration = "interactive",
            runtimes = {},
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          format = {
            enabled = true,
            settings = {
              url = "file://" .. os.getenv("HOME") .. "/.config/eclipse/eclipse-java-google-style.xml",
              profile = "GoogleStyle",
            },
          },
          saveActions = {
            organizeImports = true,
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            hashCodeEquals = {
              useJava7Objects = true,
            },
            useBlocks = true,
          },
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          extendedClientCapabilities = jdtls.extendedClientCapabilities,
          maxConcurrentAnalyzes = 5,
          templates = {
            typeCommentSnippet = {},
          },
          symbols = {
            includeSourceMethodResolutions = true,
          },
        },
      },
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      init_options = {
        bundles = {},
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
      },
      on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }

        -- Standard LSP keymaps
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Show references" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Show diagnostics" }))

        -- jdtls specific keymaps
        vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
        vim.keymap.set("n", "<leader>jtc", jdtls.test_class, vim.tbl_extend("force", opts, { desc = "Test class" }))
        vim.keymap.set("n", "<leader>jtn", jdtls.test_nearest_method, vim.tbl_extend("force", opts, { desc = "Test nearest method" }))
        vim.keymap.set("n", "<leader>jev", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
        vim.keymap.set("v", "<leader>jev", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
        vim.keymap.set("n", "<leader>jem", jdtls.extract_method, vim.tbl_extend("force", opts, { desc = "Extract method" }))
        vim.keymap.set("v", "<leader>jem", jdtls.extract_method, vim.tbl_extend("force", opts, { desc = "Extract method" }))
      end,
    }

    jdtls.start_or_attach(config)
  end,
}
