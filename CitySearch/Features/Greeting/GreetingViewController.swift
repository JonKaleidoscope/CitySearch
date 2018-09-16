//  Copyright © 2018 Jon. All rights reserved.

import UIKit

/// View controller showing introduction to the application
/// This could potentially be altered after first install in a future state.
class GreetingViewController: UIViewController {

    static var storyboardName = "Greeting"
    static var identifier = String(describing: GreetingViewController.self)

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var coverView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // I was going to load data from this screen/ check the data was
    // loaded but I decided against it.
    func showLoadingScreen() {
        // Bring to the front of the view the Cover and Spinner
        view.bringSubview(toFront: coverView)
        view.bringSubview(toFront: activityIndicator)

        coverView.isHidden = false
        activityIndicator.startAnimating()
    }

    func hideLoadingScreen() {
        coverView.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    @IBAction func getStartedPressed() {
        // Transitioning to loading screen
        let vc = LoadingViewController.createViewController()
        present(vc, animated: true )
    }
}

/// A Loading specific view controller seemed to provide the best experience for me as apposed to
/// an unresponsive or no descriptive view.
class LoadingViewController: UIViewController {

    static let storyboardName = "Greeting"
    static let identifier = String(describing: LoadingViewController.self)

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var coverView: UIView!

    class func createViewController() -> LoadingViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as! LoadingViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Loading data from json file and passing it along to the splitViewController that holds
        // onto the `CitySearchViewController` that consumes the data
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            let splitViewController = CitySearchSplitViewController.createViewController(with: LocationDataOrganizer.init().locationData)
            strongSelf.present(splitViewController, animated: true)
        }
    }
}
