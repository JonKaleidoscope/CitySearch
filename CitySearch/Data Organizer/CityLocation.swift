//  Copyright © 2018 Jon. All rights reserved.

import Foundation

/**
 Model representing information about a city. Information includes the country, city, id, and coordinates
 Sample JSON structure of from `cities.json`:
    {
         "country": "UA",
         "name": "Hurzuf",
         "_id": 707860,
         "coord": {
             "lon": 34.283333,
             "lat": 44.549999
        }
     }
 */
struct CityLocation: Decodable, Equatable {
    // Conforming to Equatable for easier testing
    static func ==(lhs: CityLocation, rhs: CityLocation) -> Bool {
        return lhs.country == rhs.country && lhs.city == rhs.city &&
            lhs.id == rhs.id && lhs.coordinates == rhs.coordinates
    }

    let country: String
    let city: String
    let id: Double
    let coordinates: Coordinate

    enum JSONKeys: String, CodingKey {
        case country
        case city = "name"
        case id = "_id"
        case coordinate = "coord"
    }

    init(country: String, city: String, id: Double, coordinates: Coordinate) {
        self.country = country
        self.city = city
        self.id = id
        self.coordinates = coordinates
    }

    init(country: String, city: String, id: Double, latitude: Double, longitude: Double) {
        self.country = country
        self.city = city
        self.id = id
        self.coordinates = Coordinate(latitude: latitude, longitude: longitude)
    }

    init(country: String, city: String, id: Double, longitude: Double, latitude: Double) {
        self.country = country
        self.city = city
        self.id = id
        self.coordinates = Coordinate(longitude: longitude, latitude: latitude)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSONKeys.self)
        country = try values.decode(String.self, forKey: .country)
        city = try values.decode(String.self, forKey: .city)
        id = try values.decode(Double.self, forKey: .id)
        coordinates = try values.decode(Coordinate.self, forKey: .coordinate)
    }
}

extension CityLocation: Comparable {
    var completeName: String {
        return (displayName).lowercased()
    }

    var displayName: String {
        return city + ", " + country
    }

    static func <(lhs: CityLocation, rhs: CityLocation) -> Bool {
        guard lhs.completeName == rhs.completeName else {
            // This is the typical case
            return lhs.completeName < rhs.completeName
        }

        // If we got here we reached the rare case where both the complete name is the same
        // Hopefully the id's are unique and we can compare the names using those
        if lhs.id != rhs.id {
            return lhs.id < rhs.id
        } else if lhs.coordinates.latitude != rhs.coordinates.latitude {
            // Comparing by latitude first
            return lhs.coordinates.latitude < rhs.coordinates.latitude
        } else {
            return lhs.coordinates.longitude < rhs.coordinates.longitude
        }
    }
}

/// Model for the representing location coordinate data
struct Coordinate: Decodable, Equatable {
    // Conforming to Equatable for easier testing
    static func ==(lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }

    let longitude: Double
    let latitude: Double

    enum JSONKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSONKeys.self)
        longitude = try values.decode(Double.self, forKey: .longitude)
        latitude = try values.decode(Double.self, forKey: .latitude)
    }
}

