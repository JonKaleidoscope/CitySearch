
//  Copyright © 2018 Jon. All rights reserved.

import UIKit

class CitySearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!

    weak var detailViewController: LocationDetailViewController? = nil
    let searchManager = SearchManager()
    /// Using this to store the complete result of all the location data
    /// Also used to reset back to the complete list
    private (set) var originalLocations = [CityLocation]()
    /// The `SearchManager` update the `cities` object showing the results
    /// on the existing `tableView`. Reloading `tableView` as changes occur.
    var cities = [CityLocation]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? LocationDetailViewController
        }

        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = cities[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! LocationDetailViewController
                controller.annotation = object.annotation
            }
        }
    }

    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let location = cities[indexPath.row]
        cell.textLabel?.text = location.city + ", " + location.country
        return cell
    }

    func configureViewController(withData: [CityLocation]) {
        originalLocations = withData
        cities = withData
        searchManager.locations = withData
    }
}

extension CitySearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {

        guard let text = searchController.searchBar.text, !text.isEmpty else {
            cities = searchManager.locations
            return
        }

        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            guard let strongSelf = self else { return }
            // Updating search results based on input
            // The search results should be reset and save back into `cities`
            // Afterwards the table should be reloaded on the main thread!!!
            strongSelf.cities = strongSelf.searchManager.searchCities(text)
        }
    }

    func configureSearchController() {
        /*
         The simpliest approach was to implement a UISearchController
         and placing it in the navigation bar.
         I origially attempted to pin the UISearchController into
         A container view but I received some strange behavior keeping the view
         in place. As a result, I decided to reduce the height of the container view
         and now there is flare with a nice blue border right below navigation bar.
         There may be some room for potential rework to use the regular search bar in
         the storyboard. Pro's would be always having the search bar pinned.
         */
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter City Name"
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
}
