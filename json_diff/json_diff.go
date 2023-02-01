package json_diff

import (
	"fmt"
	"io/ioutil"
	"log"
	"strings"

	"github.com/wI2L/jsondiff"
)

func main() {
	source, err := ioutil.ReadFile("source_files/source.json")
	if err != nil {
		log.Fatal(err)
	}
	target, err := ioutil.ReadFile("source_files/target.json")
	if err != nil {
		log.Fatal(err)
	}
	patch, err := jsondiff.CompareJSON(source, target)
	if err != nil {
		log.Fatal(err)
	}
	var flag int
	for _, op := range patch {
		fmt.Printf("%s\n", op)
		if op.Path.String() == "/end_time" || op.Path.String() == "/start_time" || strings.Contains(op.Path.String(), "/search_path") {
			continue
		} else {
			flag = 1
		}
	}
	if flag == 0 {
		fmt.Println("identical")
	} else {
		fmt.Printf("not identical")
	}
}
