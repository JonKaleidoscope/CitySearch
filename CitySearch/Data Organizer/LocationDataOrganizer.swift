//  Copyright © 2018 Jon. All rights reserved.

import Foundation

/**
 Operations for structuring and organizing json data are located here.
 JSON data orginally obtained from a [zip file](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/128845/1765144/LqgK6ORrJR4VZ1G/cities.json.zip)

 */
struct LocationDataOrganizer {

    enum FilePathError : Error {
        case fileNotFound
    }

    /**
     This function will assist in reading data from files that are store with the main bundle.
     This function is safe to use from the testing target.
     */
    static func readDataFromFile(_ fileName: String, fileType: String) throws -> Data {
        // Using the AppDelegate class to get the main bundle since it is for sure going to be in the main bundle
        let mainBundle = Bundle(for: AppDelegate.self)
        guard let fileUrl = mainBundle.url(forResource: fileName, withExtension: fileType) else { throw FilePathError.fileNotFound }

        return try Data(contentsOf: fileUrl, options: .mappedRead)
    }

    /// Shortcut sorting using built in sorted(by:_)
    /// Using for baseline for custom algorithm
    static func sortCityByFullName(_ data: [CityLocation]) -> [CityLocation] {
      return data.sorted(by: { (location1, location2) -> Bool in
            let combinedName1 = (location1.city + location1.country).lowercased()
            let combinedName2 = (location2.city + location2.country).lowercased()
            return combinedName1 < combinedName2
        })
    }

    static var locationData: [CityLocation] {
        let fileName = "cities"
        let fileType = ".json"
        guard let jsonData = try? LocationDataOrganizer.readDataFromFile(fileName, fileType: fileType),
        let cityLocationData = try? JSONDecoder().decode([CityLocation].self, from: jsonData) else {
            assertionFailure()
            return []
        }

        // Returning sorted cities
        return LocationDataOrganizer.sortCityByFullName(cityLocationData)
    }

    let locationData: [CityLocation]
    
    init(file: String? = nil) {
        let fileName = file ?? "cities"
        let fileType = ".json"
        if let jsonData = try? LocationDataOrganizer.readDataFromFile(fileName, fileType: fileType),
             let cityLocationData = try? JSONDecoder().decode([CityLocation].self, from: jsonData) {
            // Sorting the cities first because this takes a lot of time in
            // additon to reading the contents from file.
            // In order for the binary search to work the list of cities
            // must be sorted fist.
           locationData = LocationDataOrganizer.sortCityByFullName(cityLocationData)
        } else {
            assertionFailure("Unable to load data from json file")
            locationData = []
        }
    }

}
