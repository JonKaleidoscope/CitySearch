//  Copyright © 2018 Jon. All rights reserved.

import Foundation

typealias LocationData = [CityLocation]
typealias DataFetchCompletion = (_ locationData: LocationData?,_ fetchError: DataFetchError?)->()

/**
 This turned out to be more overkill and uneeded code.
 I was attempting to cache completion blocks so that loading the data could
 happening immediately from the back ground and by the time you click though
 the screens some time would have elasped.

 Operations for structuring and organizing json data are located here.
 JSON data orginally obtained from a [zip file](https://s3-eu-west-1.amazonaws.com/uploads-eu.hipchat.com/128845/1765144/LqgK6ORrJR4VZ1G/cities.json.zip)

 */
class LocationDataManager: DataFetchManageable {

    // MARK: - DataFetchManageable
    typealias DataFetchResult = [CityLocation]?
    typealias DataFetchCompletionBlockType = (_ locationData: DataFetchResult, _ fetchStaus: DataFetchStatus,_ fetchError: DataFetchError?) -> ()
    var data: [CityLocation]?
    var status: DataFetchStatus = .notStarted
    var fetchError: DataFetchError? = nil
    var completionBlocks: [(LocationDataManager.DataFetchResult, DataFetchStatus, DataFetchError?) -> ()] = []

    // MARK: Other Properties
    let jsonFileName = "cities"
    var locationData = [CityLocation]()

    func checkInitialStatus() {
        if status == .notStarted {
            status = .inProgress
        }
    }

    func executeTask(completion: DataFetchCompletionBlockType? = nil) {
        checkInitialStatus()
        if let validCompletion = completion {
            registerCompletionBlock(validCompletion)
        }

        let mainBundle = Bundle(for: AppDelegate.self)
        guard let fileUrl = mainBundle.url(forResource: jsonFileName, withExtension: "json") else {
            status = .error
            fetchError = .fileNotFound
            if let validCompletion = completion {
                registerCompletionBlock(validCompletion)
            }

            return
        }

        guard let jsonData = try? Data(contentsOf: fileUrl, options: .mappedRead) else {

            status = .error
            fetchError = .readingError
            runCompletionBlocks()

            return
        }

        guard let parsedData = try? JSONDecoder().decode([CityLocation].self, from: jsonData) else {

            status = .error
            fetchError = .parsingError
            runCompletionBlocks()

            return
        }

        // Sorting Data With A Shortcut
        let sortedData = LocationDataManager.sortCityByFullNameAndId(parsedData)
        locationData = sortedData
        data = sortedData
        // If we reached here we have successfully loaded, parsed and sorted
        status = .complete
        fetchError = nil
        if let _ = completion {
            runCompletionBlocks()
        }
    }

    func registerCompletionBlock(_ completion: @escaping DataFetchCompletionBlockType) {
        guard status != .destroyed else {
            return
        }

        completionBlocks.append(completion)
    }

    private func runCompletionBlocks() {
        guard status != .destroyed else { return }
        for completion in completionBlocks {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                completion(strongSelf.data, strongSelf.status, strongSelf.fetchError)
            }
        }

    }

    func readJSONDataFromDisk(completion: @escaping DataFetchCompletion) {
        let mainBundle = Bundle(for: AppDelegate.self)
        guard let fileUrl = mainBundle.url(forResource: jsonFileName, withExtension: "json") else {

            completion(nil, .fileNotFound)
            return
        }

        guard let jsonData = try? Data(contentsOf: fileUrl, options: .mappedRead) else {

            completion(nil, .readingError)
            return
        }

        guard let parsedData = try? JSONDecoder().decode([CityLocation].self, from: jsonData) else {
            completion(nil, .parsingError)
            return
        }

        let sortedData = parsedData.sorted()
        locationData = sortedData

        completion(sortedData, nil)
    }

    /// Shortcut sorting using built in sorted(by:_)
    /// Using for baseline for custom algorithm
    static func sortCityByFullNameAndId(_ data: [CityLocation]) -> [CityLocation] {
        return data.sorted(by: { (location1, location2) -> Bool in
            let combinedName1 = (location1.city + location1.country).lowercased()
            let combinedName2 = (location2.city + location2.country).lowercased()
            if combinedName1 != combinedName2 {
                return combinedName1 < combinedName2
            }

            return location1.id < location2.id
        })
    }

}

enum DataFetchError: Error {
    case fileNotFound
    case readingError
    case parsingError
}

enum DataFetchStatus {
    case notStarted
    case inProgress
    case complete
    case error
    case destroyed
}

protocol DataFetchManageable {
    var status: DataFetchStatus { get set }
    var fetchError: DataFetchError? { get set }
    associatedtype DataFetchResult
    var data: DataFetchResult { get set }
    associatedtype DataFetchCompletionBlockType // where DataFetchCompletionBlockType == NonEas
    var completionBlocks: [DataFetchCompletionBlockType] { get set }
    // TODO: Figure out a way to have an associate type bounded to function type
    //func registerCompletionBlock(_ completion: @escaping DataFetchCompletionBlockType)
    //func executeTask(completion: @escaping DataFetchCompletionBlockType)
}
