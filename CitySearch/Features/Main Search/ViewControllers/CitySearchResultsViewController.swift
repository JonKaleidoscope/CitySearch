//  Copyright © 2018 Jon. All rights reserved.

import UIKit

class CitySearchResultsViewController: UIViewController {

    static let storyboardName = "CitySearchResults"
    static let identifier = String(describing: CitySearchResultsViewController.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    class func create() -> CitySearchResultsViewController {
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! CitySearchResultsViewController
        return viewController
    }

}
