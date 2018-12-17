# VIM Tips


## Search and Replace

### Substition 

#### Substition wihout search term
You can do a substitution based on the current search term by making the match
portion empty, e.g. `:%s//newName/g`. Makes renaming variables a breeze. `*`
while hovering over oldName to quickly make it your search term (with word
boundaries), then do the substitution. Use `set iskeyword+=<char>` to add to
what `*` matches

#### Search and Replace Across Files
Use `args` followed by `argdo` as described at
https://medium.com/@ahmedelgabri/multiple-files-search-and-replace-in-vim-e5e6bc662582

## Moving Around

### Marks

(See `:h marks` in Vim)

| Action | Shortcut Key                          |
| --     | --                                    |
| `]'`   | Jump to next line with lowercase mark |
| `['`   | Jump to prev line with lowercase mark |
| `]\``  | Jump to next lowercase mark           |
| `[\``  | Jump to prev lowercase mark           |

## Formatting and Alignment

| Action                  | Shortcut Key                               |
| --                      | --                                         |
| `gw{motion}`. Ex `gwip` | formats the lines that `motion` moves over |
| `gww`                   | Formats the current line                   |


## Editing

### Insert Mode Key Mappings




