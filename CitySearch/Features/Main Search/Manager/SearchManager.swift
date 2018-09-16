//  Copyright © 2018 Jon. All rights reserved.

import Foundation

/// Handles the search operations for finding specific cities
class SearchManager {

    var locations = [CityLocation]()

    init(locations: [CityLocation] = []) {
        self.locations = locations
    }

    // Not used, here to help with feeling out the algorithm
    func binarySearch(_ forString: String) -> Bool {
        let target = forString.lowercased()
        var array = locations
        var left = 0
        var right = array.count - 1

        while (left <= right) {
            let mid = (left + right) / 2
            let value = array[mid].completeName

            if (value == target) {
                return true
            }

            if (value < target) {
                left = mid + 1
            }

            if (value > target) {
                right = mid - 1
            }
        }

        return false
    }

    // Not used, same as above. Just here to help with feeling out the algorithm
    func binarySearchForPrefix(_ string: String) -> Bool {
        let target = string.lowercased()
        var array = locations
        var left = 0
        var right = array.count - 1

        while (left <= right) {
            let mid = (left + right) / 2
            let value = array[mid]

            if (value.completeName.hasPrefix(target)) {
                return true
            }

            if (value.completeName < target) {
                left = mid + 1
            }

            if (value.completeName > target) {
                right = mid - 1
            }
        }

        return false
    }

    /// This finds the first occurrence of the string returing the position
    /// in the array of that first occurence.
    func binarySearchFirst(_ string: String) -> Int {
        let target = string.lowercased()
        var array = locations
        var left = 0
        var right = array.count - 1

        while (left <= right) {
            let mid = (left + right) / 2
            let value = array[mid]

            if (left == right && value.completeName.hasPrefix(target)) {
                return left
            }

            if value.completeName.hasPrefix(target) {
                if mid > 0 {
                    if !array[mid - 1].completeName.hasPrefix(target) {
                        return mid
                    }
                } else if mid == 0 {
                    return mid
                }
                right = mid - 1
            } else if value.completeName < target {
                left = mid + 1
            } else if value.completeName > target {
                right = mid - 1
            }
        }

        return -1
    }

    /**
     This does the opposite and finds the last occurrence of the string
     search prefix returing the position in the array of that last occurence.

     - Parameter string: Prefix / whole search string for search city locations
     - Returns: Index positon in the array. Returns `-1` if position does not exists
     */
    func binarySearchLast(_ string: String) -> Int {
        let target = string.lowercased()
        var array = locations
        var left = 0
        var right = array.count - 1

        while (left <= right) {
            let mid = (left + right) / 2
            let value = array[mid].completeName

            if (left == right && value.hasPrefix(target)) {
                return left
            }

            if value.hasPrefix(target) {
                if mid < array.count - 1 {
                    if !array[mid + 1].completeName.hasPrefix(target) {
                        return mid
                    }
                }

                left = mid + 1
            } else if (value < target) {
                left = mid + 1
            } else if (value > target) {
                right = mid - 1
            }
        }

        return -1
    }

    /**
     This function is used to grab the first and last matches found and effective
     return a subset of the orginal array of locations `CityLocation`.
     */
    func searchCities(_ beginningWith: String) -> [CityLocation] {
        let startIndex = binarySearchFirst(beginningWith)
        let endIndex = binarySearchLast(beginningWith)
        // If either of the index's are found that means there
        // are no search results
        guard startIndex != -1, endIndex != -1 else { return [] }

        // I hate that I had to do this iteration
        // I would of loved to just grab the array slice.
        // I just didn't want to deal with the `Stride`, `Range`, etc protocols.
        // Creating a new array and adding all the search results to it.
        var newArray = [CityLocation]()
        for (i, value) in locations.enumerated() {
            if i >= startIndex && i <= endIndex {
                newArray.append(value)
            }
        }

        return newArray
    }
}
