package main

import (
	"fmt"

	goshopify "github.com/bold-commerce/go-shopify/v3"
)

func main() {
	// Create an app somewhere.
	// app := goshopify.App{
	// 	ApiKey:    "",
	// 	ApiSecret: "",
	// }
	// Create a new API client
	client := goshopify.NewClient(goshopify.App{}, "test-turbot-pc-1", "")
	// Fetch the number of products
	numProducts, err := client.Product.Count(nil)
	if err != nil {
		panic(err)
	}
	fmt.Printf("Total number of products: %v\n\n", numProducts)

	// fetch the products
	products, _, err := client.Product.ListWithPagination(nil)
	if err != nil {
		panic(err)
	}
	fmt.Println(">>>> Products: ")
	for _, prod := range products {
		fmt.Println(prod.AdminGraphqlAPIID)
	}

	// fetch the orders
	orders, err := client.Order.List(nil)
	if err != nil {
		panic(err)
	}
	fmt.Println(">>>> Orders: ")
	for _, ord := range orders {
		fmt.Println(ord.Name)
	}

	// or, err := client.Order.Get(5367225057575, nil)

	// if err != nil {
	// 	panic(err)
	// }
	// fmt.Printf(">>>> order detail: %v", or.CreatedAt)
	// fmt.Println()

	// fetch the customers
	// customers, err := client.Customer.List(nil)
	// if err != nil {
	// 	panic(err)
	// }
	// fmt.Println(">>>> Customers: ")
	// for _, cus := range customers {
	// 	fmt.Println(cus.Metafields)
	// }

	// fetch the companies
	// companies, err := client.Co
	// if err != nil {
	// 	panic(err)
	// }
	// fmt.Println(">>>> Customers: ")
	// for _, cus := range customers {
	// 	fmt.Println(cus.FirstName)
	// }

}
