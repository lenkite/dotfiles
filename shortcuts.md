# Cross Platform Editor / IDE Shortcuts

## Pre-Requisites and Assumptions

* You are using _JetBrains Intellij_ as IDE and _VIM_ as editor. These
  shortcuts will also supported on _Visual Studio Code_  aka `vscode` in the
  future but this is not current the case at the time of writing.
* You have installed the Intellij `ideavim` plugin. https://plugins.jetbrains.com/plugin/164-ideavim
* You have a some basic level of experience with VIM editing, movement and VIM terminology. 

## Installation

### Import Settings

Change directory to `~/dotfiles/scripts` and invoke `./pack-settings`. This
will create an Intellij `settings.jar` inside the dotfiles dir.  Now go to
`Intellij > Import Settings`, pick-up`settings.jar` and ensure that keymaps are
selected for import and confirm the import.

### Choose Right KeyMap

It is not possile to have the same keymap on both Windows/Linux/Mac due to
different modifier keys.  These keymappings have been optimized to work in same
finger positions across MacOS and Windows keyboards. For example Cmd in Mac is
usually at the Alt position in Windows keyboards. Hence the keymappings for
windows uses Alt as a replacement for the Cmd key

There are currently two key-maps: `TarunsMacOSKeyMap.xml` and
`TarunsWinLinKeyMap.xml`.  (NOTE: `TarunsWinLinKeyMap.xml` is currenly under
development). Depending on your OS, goto to the Intellij preferences and select
the right keymap.

### (Mac) Enabling Fn Keys instad of Touchbar 

 For Macbooks, the `Fn` keys don't show up in the touchbar and must be
 explicitly enabled for Intellij. See
 https://medium.com/@geapi/permanent-function-keys-intellij-macbook-pro-w-touchbar-d6fc78781b90.
 Also do the same for the `Terminal` app so that youc an use `Fn` Keys inside
 the terminal. It might be necessary to restart program after enabling this.

 Open `Preferences` (via `Cmd-,`.), Navigate to `Keymap` and select `Always
 show function keys`. Please _un-install_ the _Karabiner Elements_ app as it prevents use
 of `Shift` key with `Fn` keys!! Use `System Preferences > Keyboard > Modifier
 Keys`  in order to map `Esc` to `Capslock`.

## Notes
* Assume you have `ideamvim` installed and my dotfiles has been setup via `setup/setup.sh`
* For a given line, all shortcuts are applicable for GUI programs. Terminal
  programs due to legacy reasons cannot use `Cmd` or `Alt` modifiers effectively.
* * The `(I)` suffix means the shortcut is valid only in insert mode.
* The `(N)` suffix means the shortcut is valid only in normal mode.
* Traditional vi editing, navigation shortcuts are not covered here. Search
  Google for the truckload of VIM resources.
* Also see ideavim referene at:
  https://github.com/JetBrains/ideavim/blob/master/src/com/maddyhome/idea/vim/package-info.java
* Currently the VIM Leader is configured as `\\` (backslash). I did look into
* using space as leader but that requires existing insert mode. 



## File Navigation


| Action                              | Shortcut Key (Mac) | Shortcut (Win/Lin) | VIM Shortcut   |
| --                                  | ---                | --                 | --             |
| Goto Quick Definition (Preview)     | `Cmd-D`            | same               | `gd`           |
| Goto Implementation with Choice     | `Cmd-Shift-D`      | same               | `Ctrl-Shift-[` |
| Goto 1rst Implmentation, Push stack | `CTRL-]`(N)        | same               | same           |
| Pop stack                           | `CTRL-T`(N)        | same               | same           |
|                                     |                    |                    |                |
| Navigate Back                       | `Cmd-[`            | `Alt-[`            | `Ctrl-O`       |
| Navigate Forward                    | `Cmd-]`            | `Alt-]`            | `Ctrl-I`       |
|                                     |                    |                    |                |
| Navigate File                       | `Cmd-P`            | `Alt-P`            | `Ctrl-P`       |
| Navigate Class/Type                 | `Cmd-Shift-P`      | `Alt-Shift-P`      |                |
| Navigate Symbol                     | `Cmd-Ctrl-P`       | `Alt-Ctrl-P`       |                |
| Navigate Recent Files               | `Cmd-P`            | `Alt-P`            | `Ctrl-P`       |
|                                     |                    |                    |                |
| Open File Structure/Outline         | `Cmd-Shift-O`      | `Alt-Shift-O`      |                |
| Navigate Related/Linked File/Symb   | `Cmd-Ctrl-O`       | `Alt-Ctrl-O`       | `:A`           |
|                                     |                    |                    |                |
| Navigate Call Hierarchy             | `Cmd-Y`            | `Alt-Y`            | NA             |
| Navigate Super Method               | `Cmd-Shift-Y`      | `Alt-Shift-Y`      | NA             |
| Navigate Sub Method                 | `Cmd-Shift-H`      | `Alt-Shift-H`      | NA             |
| Navigate Type Hierarchy             | `Cmd-Ctrl-H`       | `Alt-Ctrl-H`       | NA             |
|                                     |                    |                    |                |
| Next Error                          | `Ctrl-,`           | same               | `]q`           |
| Prev Error                          | `Ctrl-Shift-,`     | same               | `[q`           |
| Next Method                         | `Cmd-J`            | `Alt-J`            | `]m`           |
| Prev Method                         | `Cmd-K`            | `Alt-K`            | `[m`           |
| Open File for Edit                  | `Cmd-O`            | Open File          | `:e`           |
|                                     |                    |                    |                |
| Navigate Last Edit Location         | `Cmd-E`            | `Alt-E`            | `g;`           |
| Navigate Next Edit Location         | `Cmd-Shift-E`      | `Alt-Shift-E`      | `g,`           |


## Editing

| Action                       | Shortcut Key (Mac) | Shortcut (Win/Lin) | VIM Shortcut              |
| --                           | --                 | --                 | --                        |
| Complete Word Forward        | `Cmd-/`            | `Alt-/`            | `Ctrl-N`                  |
| Complete Word Backward       | `Cmd-Shift-/`      | `Alt-Shift-/`      | `Ctrl-P`                  |
| Complete Word Backward       | `Cmd-Shift-/`      | `Alt-Shift-/`      | same                      |
|                              |                    |                    |                           |
| Extend Selection             | `Cmd-T`            | `Alt-T`            |                           |
| Shrink Selection             | `Cmd-Shift-T`      | `Alt-Shift-T`      |                           |
|                              |                    |                    |                           |
| Reformat Code                | `Cmd-Shift-M`      | `Alt-Shift-M`      | `gg=G`(N)                 |
| Reformat Code (with options) | `Ctrl-Shift-M`     |                    |                           |
|                              |                    |                    |                           |
| Optimize Imports             | `Ctrl-Shift-O`     | same               |                           |
|                              |                    |                    |                           |
| Paste from buffers           | `Cmd-Shift-V`      | `Alt-Shift-V`      | `[a-z]p` (register paste) |
|                              |                    |                    |                           |
| Delete till beg of line      | `Ctrl-U`(I)        | same(I)            | same(I)                   |
| Delete till beg of word      | `Ctrl-W`(I)        | same(I)            | same(I)                   |
| Insert char below cursor     | `Ctrl-E`(I)        | same(I)            | same(I)                   |
| Insert char above cursor     | `Ctrl-Y`(I)        | same(I)            | same(I)                   |

# Find / Search / Replace

| Action                          | Shortcut Key (Mac) | Shortcut (Win/Lin) | VIM Shortcut      |
| --                              | --                 | --                 | --                |
| Find                            | `Cmd-F`            | `Alt-F`            | `/`(N)            |
| Next Occurence                  | `Cmd-G`            | `Alt-G`            | `n`(N)            |
| Prev Occurence                  | `Cmd-Shift-G`      | `Alt-Shift-G`      | `N`(N)            |
| Find in Path                    | `Cmd-Shift-F`      | `Alt-Shift-F`      | `:Ag`             |
| Replace                         | `Cmd-L`            | `Alt-L`            | `:s`              |
| Replace In Path                 | `Cmd-Shift-L`      | `Alt-Shift-L`      | `:args`, `:argdo` |
|                                 |                    |                    |                   |
| Preview Usages (References)     | `Cmd-U`            | `Alt-U`            |                   |
| Find Usages (References)        | `Cmd-Shift-U`      | `Alt-Shift-U`      |                   |
| Show Recent Find Usages (Popup) | `Cmd-Ctrl-U`       | `Alt-Ctrl-U`       |                   |
| Search Everywhere               | Double Shift       | same               |                   |

## Information / Documentation

| Action               | Shortcut Key (Mac) | Shortcut (Win/Lin) | VIM Shortcut  |
| --                   | --                 | --                 | --            |
| Show Parameter Info  | `Cmd-I`            | `Alt-I`            | `<Leder>i`(N) |
| Show Context Info    | `Cmd-Shift-I`      | `Alt-Shift-I`      | `<Leder>I`(N) |
| External Docu Lookup | `gK`(N)            | same               | same          |
| Quick Docu Lookup    | `K`(N)             | same               | same          |
| External Docu Lookup | `gK`(N)            | same               | same          |

## Build / Run / Debug

| Action                         | Shortcut Key (Mac) | Shortcut (Win/Lin) | VIM Shortcut    |
| --                             | --                 | --                 | --              |
| _Build/Compile_                |                    |                    |                 |
| Build Projct                   | `Cmd-B B`          | `Alt-B B`          | `<Leader>bb`(N) |
| Build Module                   | `Cmd-B M`          | `Alt-B M`          | `<Leader>bm`(N) |
| ReBuild Project                | `Cmd-B R`          | `Alt-B R`          | `<Leader>br`(N) |
| _Run/Execute_                  |                    |                    |                 |
| Run Last                       | `F9`               | same               | `<Leader>xx`    |
| Run Configure                  | `S-F9`             | same               | `<Leader>X`     |
| Run with Coverage              | `Ctrl-F9`          | same               | `<Leader>xc`    |
| _Debugging_                    |                    |                    |                 |
| Debug Last                     | `F10`              | same               | `<Leader>dd`    |
| Debug Configure                | `S-F10`            | same               | `<Leader>D`     |
| Debug Attach to Process        | `Ctrl-F10`         | same               | `<Leader>da`    |
| (Attach only works for Go atm) |                    |                    |                 |
| _Breakpoints/Stepping_         |                    |                    |                 |
| Toggle Line Breakpoint         | `Ctrl-S-B`         | same               | same            |
| Toggle Method Breakpoint       | `Cmd-S-B`          | `Alt-S-B`          | same            |
| Step Over                      | `F6`               | same               | same            |
| Force Step Over                | `Ctrl-F6`          | same               | same            |
| Step Into                      | `F5`               | same               | same            |
| Force Step Into                | `Ctrl-F5`          | same               | same            |
| Step Out                       | `F7`               | same               | same            |
| Resume                         | `F8`               | same               | same            |
         


## Generation

| Action                        | Shortcut Key (Mac) | Shortcut Key (Win/Lin) Action | VIM                 |
| --                            | ---                | --                            | --                  |
| Generate get/set/etc   Popup  | `Cmd-N`            | `Alt-N`                       |                     |
| New Class/File/Resource Popup | `Cmd-Shift-N`      | `Alt-Shift-N`                 |                     |
| Surround with (try/etc)Popup  | `Cmd-Shift-S`      | `Alt-Shift-S`                 | Use surround plugin |

## Completion

| Action                      | Shortcut Key (Mac) | Shortcut Key (Win/Lin) |
| --                          | ---                | --                     |
| Smart Code Completion       | Ctrl+ Shift+ Space | same                   |
| Show Intention Action Popup | Cmd-Enter          | Alt-Enter              |
| Complete Statement          | Cmd-Shift-Enter    | Alt-Shift-Enter        |

## TODO
* Make f2 shortcuts for ide bookmarks for convenience.
* Other breakpoint actions, including field watches
* Switching Buffers, Choosing diff Buffer buffers in both vim and intellij
* Ensure there is a shortcut for quick definition (one of the gD stuff I think)
* Debug / Run shortcuts include breakpoints, step over, step out, etc
* Structural movement shorcuts
* Structural Selection
* Panel shortcuts (sidebar/run/debug panels, etc)
* Study Intellij Structural Search/Replace and introduce shortuts
* Commenting code, going backward/forwards
* map backspace to most recent buffer
* next/previous errors
*  refactor: extract parameter shortcut was initially assinged to meta-alt-p
