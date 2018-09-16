//  Copyright © 2018 Jon. All rights reserved.

import XCTest
@testable import CitySearch

class CityLocationTests: XCTestCase {

    // {"country":"UA","name":"Hurzuf","_id":707860,"coord":{"lon":34.283333,"lat":44.549999}
    let firstCity = CityLocation(country: "UA", city: "Hurzuf", id: 707860, longitude: 34.283333, latitude: 44.549999)

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testCityLocationDecodable() {
        let citiesJSON = """
[
    {"country":"UA","name":"Hurzuf","_id":707860,"coord":{"lon":34.283333,"lat":44.549999}},
    {"country":"RU","name":"Novinki","_id":519188,"coord":{"lon":37.666668,"lat":55.683334}},
    {"country":"NP","name":"Gorkhā","_id":1283378,"coord":{"lon":84.633331,"lat":28}},
    {"country":"IN","name":"State of Haryāna","_id":1270260,"coord":{"lon":76,"lat":29}},
    {"country":"UA","name":"Holubynka","_id":708546,"coord":{"lon":33.900002,"lat":44.599998}}
]
""".data(using: .utf8)!

        guard let cityData = try? JSONDecoder().decode([CityLocation].self, from: citiesJSON) else {
            XCTFail("Unable to decode city data from json result.")
            return
        }

        let city0 = CityLocation(country: "UA", city: "Hurzuf", id: 707860, longitude: 34.283333, latitude: 44.549999)
        let city1 = CityLocation(country: "RU", city: "Novinki", id: 519188, longitude: 37.666668, latitude: 55.683334)
        let city2 = CityLocation(country: "NP", city: "Gorkhā", id: 1283378, longitude: 84.633331, latitude: 28)
        let city3 = CityLocation(country: "IN", city: "State of Haryāna", id: 1270260, longitude: 76, latitude: 29)
        let city4 = CityLocation(country: "UA", city: "Holubynka", id: 708546, longitude: 33.900002, latitude: 44.599998)

        XCTAssertEqual(cityData.count, 5, "There should be 5 cities")
        XCTAssertEqual(cityData[0], city0)
        XCTAssertEqual(cityData[1], city1)
        XCTAssertEqual(cityData[2], city2)
        XCTAssertEqual(cityData[3], city3)
        XCTAssertEqual(cityData[4], city4)
    }

    func testReadingJsonFromSmallFile() {
        var jsonData: Data?
        do {
            jsonData = try LocationDataOrganizer.readDataFromFile("some_cities", fileType: "json")
        } catch {
            XCTFail("Unable to read file receiving error: \(error)")
        }

        guard let cityData = try? JSONDecoder().decode([CityLocation].self, from: jsonData!) else {
            XCTFail("Unable to decode city data from json result.")
            return
        }

        XCTAssertEqual(cityData.count, 49)
        XCTAssertEqual(cityData[0], firstCity)
    }

    func testReadingJsonFromMediumFile() {
        // Doing a santiy check with this test
        // If these test pass its safe to assume the data is complete
        // The `JSONDecoder` will fail if there is even one typo in the result
        guard let jsonData = try? LocationDataOrganizer.readDataFromFile("medium_cities", fileType: "json") else {
            XCTFail("Unable to read json data from file")
            return
        }

        guard let cityData = try? JSONDecoder().decode([CityLocation].self, from: jsonData) else {
            XCTFail("Unable to decode city data from json result.")
            return
        }

        XCTAssertEqual(cityData.count, 619)
        XCTAssertEqual(cityData[0], firstCity)
    }

    func testReadingJsonFromLargeFile() {
        // Doing a santiy check with this test
        // If these test pass its safe to assume the data is complete
        // The `JSONDecoder` will fail if there is even one typo in the result
        guard let jsonData = try? LocationDataOrganizer.readDataFromFile("cities", fileType: "json") else {
            XCTFail("Unable to read json data from file")
            return
        }

        guard let cityData = try? JSONDecoder().decode([CityLocation].self, from: jsonData) else {
            XCTFail("Unable to decode city data from json result.")
            return
        }

        XCTAssertEqual(cityData.count, 209557)
        XCTAssertEqual(cityData[0], firstCity)
    }
    
    func testPerformanceOfReadingLargeJsonFile() {
        // Curiousity Test. On average, how long does it takes to read and decode json
        self.measure {
            let jsonData = try! LocationDataOrganizer.readDataFromFile("cities", fileType: "json")
            let _ = try! JSONDecoder().decode([CityLocation].self, from: jsonData)
        }
        // First run had an average of 10.3s
        // Times that by 10 thats 103s or ~ 1 minute and 72 seconds
        // As a result this test will take about that long to complete
    }

    func testSortingCityByName_WithBuiltInSort() {
        let city0 = CityLocation(country: "UA", city: "Hurzuf", id: 707860, longitude: 34.283333, latitude: 44.549999)
        let city1 = CityLocation(country: "RU", city: "Novinki", id: 519188, longitude: 37.666668, latitude: 55.683334)
        let city2 = CityLocation(country: "NP", city: "Gorkhā", id: 1283378, longitude: 84.633331, latitude: 28)
        let city3 = CityLocation(country: "IN", city: "State of Haryāna", id: 1270260, longitude: 76, latitude: 29)
        let city4 = CityLocation(country: "UA", city: "Holubynka", id: 708546, longitude: 33.900002, latitude: 44.599998)
        let unsortedArray = [city0, city1, city2, city3, city4]

        let actualArray = LocationDataOrganizer.sortCityByFullName(unsortedArray)
        //  "`Gorkhā, NP` -> `Holubynka, UA` -> `Hurzuf, UA` -> `Novinki, RU` ->  `State of Haryāna, IN`"
        //                              G, Ho, Hu, N, S
        let expectedArray = [city2, city4, city0, city1, city3]

        XCTAssertEqual(actualArray[0], city2, "`Gorkhā, NP` should be first")
        XCTAssertEqual(actualArray, expectedArray,
                       "`Gorkhā, NP` -> `Holubynka, UA` -> `Hurzuf, UA` -> `Novinki, RU` ->  `State of Haryāna, IN`")
        let sortedArray2 = unsortedArray.sorted()
        XCTAssertEqual(sortedArray2, expectedArray )

        let sameLocations = [city2, city2, city3]
        let expectedWithDuplicates = LocationDataOrganizer.sortCityByFullName(sameLocations)
        XCTAssertEqual(sameLocations, expectedWithDuplicates, "Should already be in order")
    }
    
    func testingComparableCityLocation_Different_id() {
        let cityA = CityLocation(country: "US", city: "Brooklyn", id: 123456, latitude: 40.6782, longitude: 73.9442)
        let cityB = CityLocation(country: "US", city: "Brooklyn", id: 987654, latitude: 40.6782, longitude: 73.9442)
        XCTAssertLessThan(cityA, cityB)
        XCTAssertGreaterThan(cityB, cityA)
        XCTAssertNotEqual(cityA, cityB)
    }
    
    func testingComparableCityLocation_Different_Latitude() {
        let cityA = CityLocation(country: "US", city: "Brooklyn", id: 123456, latitude: 40.6782, longitude: 73.9442)
        let cityB = CityLocation(country: "US", city: "Brooklyn", id: 123456, latitude: 40.6793, longitude: 73.9442)
        XCTAssertLessThan(cityA, cityB)
        XCTAssertGreaterThan(cityB, cityA)
        XCTAssertNotEqual(cityA, cityB)
    }
    
    func testingComparableCityLocation_Different_Longitude() {
        let cityA = CityLocation(country: "US", city: "Brooklyn", id: 123456, latitude: 40.6782, longitude: 73.9442)
        let cityB = CityLocation(country: "US", city: "Brooklyn", id: 123456, latitude: 40.6782, longitude: 73.9453)
        XCTAssertLessThan(cityA, cityB)
        XCTAssertGreaterThan(cityB, cityA)
        XCTAssertNotEqual(cityA, cityB)
    }
    
    func testingPerformancingOfSortingData_SortCityByFullNameOnly() {
        let jsonData = try! LocationDataOrganizer.readDataFromFile("cities", fileType: "json")
        let locations = try! JSONDecoder().decode([CityLocation].self, from: jsonData)
        self.measure {
            let _ = LocationDataOrganizer.sortCityByFullName(locations)
        }
        // First run average time of 17.6s
    }

    func testingPerformancingOfSortingData_WithComparable() {
        let jsonData = try! LocationDataOrganizer.readDataFromFile("cities", fileType: "json")
        let locations = try! JSONDecoder().decode([CityLocation].self, from: jsonData)

        self.measure {
            let _ = locations.sorted()
        }
        // First run average time of 17.63s
        // After adding complete check of other values in compararble time average went up to 31.151s
    }

}
