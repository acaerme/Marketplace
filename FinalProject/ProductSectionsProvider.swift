//
//  ProductSectionsProvider.swift
//  FinalProject
//
//  Created by Islam Elikhanov on 19/05/2023.
//

struct ProductSectionsProvider {
    
    static func createSections () -> [Section] {
        [
            Section(
                title: "Title 1",
                products: [
                    Product(
                        image: "green",
                        title: "One",
                        price: "99",
                        characteristics: [
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray"),
                            Characteristic(title: "color", description: "space gray")
                        ]
                    ),
                    Product(image: "green", title: "Two", price: "60"),
                    Product(image: "green", title: "Three", price: "75"),
                    Product(image: "green", title: "Four", price: "12"),
                    Product(image: "green", title: "Five", price: "33"),
                    Product(image: "green", title: "Six", price: "67"),
                    Product(image: "green", title: "Seven", price: "56"),
                    Product(image: "green", title: "Eight", price: "58"),
                    Product(image: "green", title: "Nine", price: "9")
                ]
            ),
            Section(
                title: "Title 2",
                products: [
                    Product(image: "green", title: "Product 4", price: "5"),
                    Product(image: "green", title: "Product 5", price: "17"),
                    Product(image: "green", title: "Product 6", price: "23")
                ]
            ),
            Section(
                title: "Title 3",
                products: [
                    Product(image: "green", title: "Product 7", price: "30"),
                    Product(image: "green", title: "Product 8", price: "53"),
                    Product(image: "green", title: "Product 9", price: "67")
                ]
            )
        ]
    }
}
