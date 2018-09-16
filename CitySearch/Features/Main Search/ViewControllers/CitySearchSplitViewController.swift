//  Copyright © 2018 Jon. All rights reserved.

import UIKit

class CitySearchSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    static let storyboardName = "CitySearch"
    static let identifier = String(describing: CitySearchSplitViewController.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    class func createViewController(with cities: [CityLocation]) -> CitySearchSplitViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! CitySearchSplitViewController
        viewController.preferredDisplayMode = .allVisible
        let citySearchVC = (viewController.viewControllers.first as? UINavigationController)?.viewControllers.first as? CitySearchViewController
        citySearchVC?.cities = cities
        citySearchVC?.searchManager.locations = cities
        
        return viewController
    }

    // MARK: - UISplitViewControllerDelegate
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }

        guard let topAsDetailController = secondaryAsNavController.topViewController as? LocationDetailViewController else { return false }

        if topAsDetailController.annotation == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }

        return false
    }
}
