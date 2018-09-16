//  Copyright © 2018 Jon. All rights reserved.

import XCTest
@testable import CitySearch

/**
    These tests are the golden ticket for making sure the underling searching functionality is working.
 */
class SearchManagerTests: XCTestCase {

    func testBinarySearch() {
        let city0 = CityLocation(country: "UA", city: "Hurzuf", id: 707860, longitude: 34.283333, latitude: 44.549999)
        let city1 = CityLocation(country: "RU", city: "Novinki", id: 519188, longitude: 37.666668, latitude: 55.683334)
        let city2 = CityLocation(country: "NP", city: "Gorkhā", id: 1283378, longitude: 84.633331, latitude: 28)
        let city3 = CityLocation(country: "IN", city: "State of Haryāna", id: 1270260, longitude: 76, latitude: 29)
        let city4 = CityLocation(country: "UA", city: "Holubynka", id: 708546, longitude: 33.900002, latitude: 44.599998)
        let city5 = CityLocation(country: "US", city: "Brooklyn", id: 987654, latitude: 40.6782, longitude: 73.9442)

        let sortedLocations = [city0, city1, city2, city3, city4, city5].sorted()
        let searchManager = SearchManager(locations: sortedLocations)
        XCTAssertTrue(searchManager.binarySearch("Brooklyn, US"))
        XCTAssertTrue(searchManager.binarySearch("State of Haryāna, IN"))
        // Testing Case Insensitive Search
        XCTAssertTrue(searchManager.binarySearch("brooklyn, us"))
        XCTAssertFalse(searchManager.binarySearch("Brooklyn"))
    }

    func testBinarySearchForPrefix() {
        let city0 = CityLocation(country: "GH", city: "ABCDEF", id: 707860, longitude: 34.283333, latitude: 44.549999)
        let city1 = CityLocation(country: "MM", city: "MMMMMM", id: 519188, longitude: 37.666668, latitude: 55.683334)
        let city2 = CityLocation(country: "LL", city: "LLLLLL", id: 1283378, longitude: 84.633331, latitude: 28)
        let city3 = CityLocation(country: "NN", city: "LLLNNN", id: 1270260, longitude: 76, latitude: 29)
        let city4 = CityLocation(country: "AA", city: "LAAAAA", id: 708546, longitude: 33.900002, latitude: 44.599998)
        let city5 = CityLocation(country: "IO", city: "ABCDEF", id: 987654, latitude: 40.6782, longitude: 73.9442)
        let sortedLocations = [city0, city1, city2, city3, city4, city5].sorted()
        let searchManager = SearchManager(locations: sortedLocations)

        XCTAssertTrue(searchManager.binarySearchForPrefix("ABC"))
        XCTAssertTrue(searchManager.binarySearchForPrefix("MMMM"))
        // Testing Case Insensitive Search
        XCTAssertTrue(searchManager.binarySearchForPrefix("laaaaa, aa"))
        XCTAssertTrue(searchManager.binarySearchForPrefix("mmm"))

        // Testing Error Scenarios
        XCTAssertFalse(searchManager.binarySearchForPrefix("XXXX"))
        XCTAssertFalse(searchManager.binarySearchForPrefix("ABCDEFGH"))
        XCTAssertFalse(searchManager.binarySearchForPrefix("AAAAAAL"))
    }

    func testBinarySearchFirst() {
        let city0 = CityLocation(country: "AA", city: "AAAAAA", id: 707860, longitude: 34.283333, latitude: 44.549999)
        let city1 = CityLocation(country: "BB", city: "BBBBBB", id: 519188, longitude: 37.666668, latitude: 55.683334)
        let city2 = CityLocation(country: "CC", city: "CCCCCC", id: 1283378, longitude: 84.633331, latitude: 28)
        let city3 = CityLocation(country: "CC", city: "CCCCCC", id: 1270260, longitude: 76, latitude: 29)
        let city4 = CityLocation(country: "EE", city: "EEEEEE", id: 708546, longitude: 33.900002, latitude: 44.599998)
        let city5 = CityLocation(country: "FF", city: "FFFFFF", id: 987654, latitude: 40.6782, longitude: 73.9442)
        let sortedLocations = [city0, city1, city2, city3, city4, city5].sorted()
        let searchManager = SearchManager(locations: sortedLocations)

        XCTAssertEqual(searchManager.binarySearchFirst("A"), 0)
        XCTAssertEqual(searchManager.binarySearchFirst("AAAAAA"), 0)
        XCTAssertEqual(searchManager.binarySearchFirst("AAAAAA, AA"), 0)
        XCTAssertEqual(searchManager.binarySearchFirst("B"), 1)
        XCTAssertEqual(searchManager.binarySearchFirst("CCC"), 2)
        XCTAssertEqual(searchManager.binarySearchFirst("F"), 5)
        XCTAssertEqual(searchManager.binarySearchFirst("FFFFFF, FF"), 5)

        // Testing Case Insensitive Search
        XCTAssertEqual(searchManager.binarySearchFirst("a"), 0)
        XCTAssertEqual(searchManager.binarySearchFirst("aaaaaa"), 0)
        XCTAssertEqual(searchManager.binarySearchFirst("eeEeEE"), 4)

        // Testing Error Scenarios, Function will return -1 if an index can not be found
        XCTAssertEqual(searchManager.binarySearchFirst("XXXX"), -1)
        XCTAssertEqual(searchManager.binarySearchFirst("ABCDEFGH"), -1)
        XCTAssertEqual(searchManager.binarySearchFirst("AAAAAAL"), -1)
        XCTAssertEqual(searchManager.binarySearchFirst("CCCCCC,CC"), -1)
    }

    func testBinarySearchLast() {
        let city0 = CityLocation(country: "AA", city: "AAAAAA", id: 707860, longitude: 34.283333, latitude: 44.549999)
        let city1 = CityLocation(country: "BB", city: "BBBBBB", id: 519188, longitude: 37.666668, latitude: 55.683334)
        let city2 = CityLocation(country: "CC", city: "CCCCCC", id: 1283378, longitude: 84.633331, latitude: 28)
        let city3 = CityLocation(country: "CC", city: "CCCCCC", id: 1270260, longitude: 76, latitude: 29)
        let city4 = CityLocation(country: "EE", city: "FFFFFF", id: 708546, longitude: 33.900002, latitude: 44.599998)
        let city5 = CityLocation(country: "FF", city: "FFFFFF", id: 987654, latitude: 40.6782, longitude: 73.9442)
        let sortedLocations = [city0, city1, city2, city3, city4, city5].sorted()
        let searchManager = SearchManager(locations: sortedLocations)

        XCTAssertEqual(searchManager.binarySearchLast("A"), 0)
        XCTAssertEqual(searchManager.binarySearchLast("AAAAAA, AA"), 0)
        XCTAssertEqual(searchManager.binarySearchLast("B"), 1)
        XCTAssertEqual(searchManager.binarySearchLast("CCC"), 3)
        XCTAssertEqual(searchManager.binarySearchLast("F"), 5)
        XCTAssertEqual(searchManager.binarySearchLast("FFFFFF, FF"), 5)

        // Testing Case Insensitive Search
        XCTAssertEqual(searchManager.binarySearchLast("a"), 0)
        XCTAssertEqual(searchManager.binarySearchLast("aaaaaa"), 0)
        XCTAssertEqual(searchManager.binarySearchLast("bbBbBB"), 1)

        // Testing Error Scenarios, Function will return -1 if an index can not be found
        XCTAssertEqual(searchManager.binarySearchLast("XXXX"), -1)
        XCTAssertEqual(searchManager.binarySearchLast("ABCDEFGH"), -1)
        XCTAssertEqual(searchManager.binarySearchLast("AAAAAAL"), -1)
        XCTAssertEqual(searchManager.binarySearchLast("CCCCCC,CC"), -1)
    }

    func testBinarySearchCitiesBeginingWith() {
        let city0 = CityLocation(country: "AA", city: "AAAAAA", id: 707860, longitude: 34.283333, latitude: 44.549999)
        let city1 = CityLocation(country: "BB", city: "BBBBBB", id: 519188, longitude: 37.666668, latitude: 55.683334)
        let city2 = CityLocation(country: "CC", city: "CCCCCC", id: 1283378, longitude: 84.633331, latitude: 28)
        let city3 = CityLocation(country: "CC", city: "CCCCCC", id: 1270260, longitude: 76, latitude: 29)
        let city4 = CityLocation(country: "EE", city: "FFFFFF", id: 708546, longitude: 33.900002, latitude: 44.599998)
        let city5 = CityLocation(country: "FF", city: "FFFFFF", id: 987654, latitude: 40.6782, longitude: 73.9442)
        let sortedLocations = [city0, city1, city2, city3, city4, city5].sorted()
        let searchManager = SearchManager(locations: sortedLocations)

        XCTAssertEqual(searchManager.searchCities("A"), [city0])
        XCTAssertEqual(searchManager.searchCities("AAAAAA, AA"), [city0])
        XCTAssertEqual(searchManager.searchCities("B"), [city1])
        XCTAssertEqual(searchManager.searchCities("CCC"), [city3, city2], "Order is different based on `id`")
        XCTAssertEqual(searchManager.searchCities("F"), [city4, city5])
        XCTAssertEqual(searchManager.searchCities("FFFFFF, FF"), [city5])

        // Testing Case Insensitive Search
        XCTAssertEqual(searchManager.searchCities("a"), [city0])
        XCTAssertEqual(searchManager.searchCities("aaaaaa"), [city0])
        XCTAssertEqual(searchManager.searchCities("bbBbBB"), [city1])

        // Testing Error Scenarios, Function will return an empty array if an index can not be found
        XCTAssertEqual(searchManager.searchCities("XXXX"), [])
        XCTAssertEqual(searchManager.searchCities("ABCDEFGH"), [])
        XCTAssertEqual(searchManager.searchCities("AAAAAAL"), [])
        XCTAssertEqual(searchManager.searchCities("CCCCCC,CC"), [])
    }

    func testBinarySearchCitiesBeginingWith_AdditonalScenarios() {
        let city0 = CityLocation(country: "AA", city: "AAAAAA", id: 111111, longitude: 34.283333, latitude: 44.549999)
        let city1 = CityLocation(country: "AA", city: "AAAAAA", id: 222222, longitude: 37.666668, latitude: 55.683334)
        let city2 = CityLocation(country: "CC", city: "AAAAAC", id: 3383378, longitude: 84.633331, latitude: 28)
        let city3 = CityLocation(country: "CC", city: "CCCCCC", id: 1270260, longitude: 76, latitude: 29)
        let city4 = CityLocation(country: "EE", city: "FFFFFF", id: 708546, longitude: 33.900002, latitude: 44.599998)
        let city5 = CityLocation(country: "FF", city: "FFFFFF", id: 987654, latitude: 40.6782, longitude: 73.9442)
        let sortedLocations = [city0, city1, city2, city3, city4, city5].sorted()
        let searchManager = SearchManager(locations: sortedLocations)

        XCTAssertEqual(searchManager.searchCities("A"), [city0, city1, city2])
        XCTAssertEqual(searchManager.searchCities("AAAAAA"), [city0, city1])
        XCTAssertEqual(searchManager.searchCities("AAAAAC"), [city2])
        XCTAssertEqual(searchManager.searchCities("CCC"), [city3])
        XCTAssertEqual(searchManager.searchCities("F"), [city4, city5])
        XCTAssertEqual(searchManager.searchCities("FFFFFF, F"), [city5])
        searchManager.locations = [city5]
        XCTAssertEqual(searchManager.searchCities("FFFFF"), [city5])
    }
    
}
