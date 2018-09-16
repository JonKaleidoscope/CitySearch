//  Copyright © 2018 Jon. All rights reserved.

import Foundation

/// This was me taking a stab at creating a singleton that would serve
/// as bridge to retreive the data from the respective data manager as needed.
/// This essential was not needed.
final class SessionManager {

    static let shared = SessionManager()
    private init() {
        dataManager = LocationDataManager()
    }

    var dataManager: LocationDataManager
}
