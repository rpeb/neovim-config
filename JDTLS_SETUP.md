# JDTLS Configuration for Neovim

This document explains the jdtls (Java Debug Tool Language Server) configuration for your neovim setup.

## Overview

jdtls provides full LSP support for Java development in neovim, including:
- Code completion and IntelliSense
- Go to definition and references
- Refactoring (extract variable/method, rename)
- Testing support (run tests, navigate between test and implementation)
- Code generation (getters, setters, toString)
- Debugging support

## Setup Components

### 1. Installation

The jdtls plugin is already installed in your pack directory at:
```
~/.config/nvim/pack/plugins/start/nvim-jdtls/
```

To install the jdtls language server via Mason:
```vim
:MasonInstall jdtls
```

### 2. Configuration Files

**Main Configuration**: [lua/plugins/jdtls.lua](lua/plugins/jdtls.lua)

The configuration:
- Auto-attaches jdtls when you open a Java file
- Sets up a workspace directory for jdtls metadata
- Configures Java language settings (formatting, code generation, imports)
- Defines keymaps for common operations

## Key Bindings

### LSP Navigation (Standard)
- `gd` - Go to definition
- `gr` - Show references
- `gi` - Go to implementation
- `K` - Hover documentation
- `<leader>vd` - Show diagnostics

### Java Refactoring
- `<leader>jo` - Organize imports
- `<leader>jev` - Extract variable
- `<leader>jem` - Extract method
- `<leader>vrn` - Rename symbol
- `<leader>vca` - Code actions

### Testing
- `<leader>jtc` - Test class (run all tests in current class)
- `<leader>jtn` - Test nearest method (run current test)

## Configuration Details

### Java Settings

The configuration includes:

**Code Formatting**
- google-java-format integration
- Automatic import organization
- Configure via: `~/.config/eclipse/eclipse-java-google-style.xml`

**Source Management**
- Star threshold for import optimization (set to 9999 to prevent wildcards)
- Full decompiled source browsing

**Code Generation**
- Enhanced toString() templates
- hashCodeEquals using Java 7 Objects utility
- Block-style code

**Debugging**
- Debug adapter is configured on port 5005
- Integration with nvim-dap for breakpoints and step execution

### Workspace Management

Workspaces are created per project in:
```
~/.local/share/nvim/jdtls_workspace/[project-name]/
```

This allows jdtls to maintain separate metadata for each project.

### Performance Settings

- Concurrent analysis processes: 5
- Memory: 1GB min, 2GB max
- Includes all system modules via `--add-modules=ALL-SYSTEM`

## Dependencies

Make sure these are installed:
- `java` (JDK 11+)
- Mason (for installing jdtls)
- google-java-format (already in your Mason setup)
- nvim-dap (for debugging - already in your plugins)

## First Use

1. Open a Java file:
   ```bash
   nvim src/Main.java
   ```

2. jdtls will auto-attach and index your project (this may take a moment)

3. You'll see LSP features available (hover `K`, goto definition `gd`, etc.)

## Troubleshooting

### jdtls not found
```vim
:MasonInstall jdtls
```

### Slow indexing
- First run on a project may be slow as it indexes all dependencies
- Subsequent opens are much faster

### Project detection
The configuration looks for these markers to identify a project root:
- `.git`
- `gradlew` (Gradle)
- `mvnw` (Maven)
- `pom.xml` (Maven)
- `build.gradle` (Gradle)

### Memory issues
Edit [lua/plugins/jdtls.lua](lua/plugins/jdtls.lua) and adjust:
```lua
"-Xms1g",  -- Initial heap size
"-Xmx2G",  -- Maximum heap size
```

## Advanced Configuration

### Adding Java Runtime Configurations

Edit the `settings.java.configuration.runtimes` in [lua/plugins/jdtls.lua](lua/plugins/jdtls.lua):

```lua
runtimes = {
  {
    name = "JavaSE-21",
    path = "/path/to/jdk-21",
  },
  {
    name = "JavaSE-17",
    path = "/path/to/jdk-17",
  },
}
```

### Custom Code Style

Replace the formatter configuration URL in [lua/plugins/jdtls.lua](lua/plugins/jdtls.lua) with your Eclipse style file:
```lua
url = "file://" .. os.getenv("HOME") .. "/.config/eclipse/eclipse-java-google-style.xml",
```

## Related Documentation

- [nvim-jdtls docs](https://github.com/mfussenegger/nvim-jdtls)
- [LSP setup](lua/plugins/lsp.lua)
- [Mason tool installer](lua/plugins.lua) - for jdtls installation

---

For questions or issues, refer to the nvim-jdtls repository or neovim LSP documentation.
