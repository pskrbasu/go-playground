package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
)

type Column struct {
	ColumnName string `json:"column_name"`
}

func main() {
	file1 := "source_files/introspection.json"
	file2 := "source_files/powerpipe.json"

	columns, err := readColumns(file1)
	if err != nil {
		fmt.Println("Error reading File 1:", err)
		return
	}

	records, err := readRecords(file2)
	if err != nil {
		fmt.Println("Error reading File 2:", err)
		return
	}

	missingColumns := findMissingColumns(columns, records)
	fmt.Println("Missing columns in File 2:", missingColumns)
}

// readColumns reads and unmarshals the JSON file containing column names
func readColumns(filePath string) ([]Column, error) {
	var columns []Column
	data, err := ioutil.ReadFile(filePath)
	if err != nil {
		return nil, err
	}
	err = json.Unmarshal(data, &columns)
	return columns, err
}

// readRecords reads and unmarshals the JSON file containing records
func readRecords(filePath string) ([]map[string]interface{}, error) {
	var records []map[string]interface{}
	data, err := ioutil.ReadFile(filePath)
	if err != nil {
		return nil, err
	}
	err = json.Unmarshal(data, &records)
	return records, err
}

// findMissingColumns finds columns that are missing in the records
func findMissingColumns(columns []Column, records []map[string]interface{}) []string {
	var missingColumns []string
	columnNames := make(map[string]bool)

	// Map the column names for easy lookup
	for _, c := range columns {
		columnNames[c.ColumnName] = true
	}

	// Check each record for missing columns
	for _, record := range records {
		for columnName := range columnNames {
			if _, ok := record[columnName]; !ok {
				missingColumns = append(missingColumns, columnName)
			}
		}
	}
	return missingColumns
}
