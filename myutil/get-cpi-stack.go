//usr/bin/env go run "$0" "$@"; exit
package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"flag"
)

var ip = flag.Int("name", "cmn", "name of stack: [cmn|tmn|ifl|iflmap]")


func main() {
	fmt.Println("vim-go")
}
