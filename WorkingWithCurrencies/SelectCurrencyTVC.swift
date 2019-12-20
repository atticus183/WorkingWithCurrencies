//
//  SelectCurrencyTVC.swift
//  WorkingWithCurrencies
//
//  Created by Josh R on 12/17/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import UIKit

protocol PassCurrencyDelegate: class {
    func pass(_ currency: Currency)
}

class SelectCurrencyTVC: UITableViewController {
    
    var currencies = [Currency]()
    var filteredCurrencies = [Currency]()
    
    var isFiltering = false
    
    weak var delegate: PassCurrencyDelegate?
    
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        currencies = Currencies.retrieveAllCurrencies()
        setupSearchTable()
        searchBar.becomeFirstResponder()
        tableView.register(SelectCurrencyCell.self, forCellReuseIdentifier: SelectCurrencyCell.identifier)
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearchTable() {
        self.navigationItem.titleView = searchBar
        searchBar.placeholder = "Search for a Currency"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barStyle = .default
        
        searchBar.delegate = self
    }

    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCurrencies.count : currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectCurrencyCell.identifier, for: indexPath) as! SelectCurrencyCell

        cell.currency = isFiltering ? filteredCurrencies[indexPath.row] : currencies[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = isFiltering ? filteredCurrencies[indexPath.row] : currencies[indexPath.row]
        delegate?.pass(currency)
        dismiss(animated: true, completion: nil)
    }

}

extension SelectCurrencyTVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFiltering = true
        
        let formattedSearchText = searchText.lowercased()

        filteredCurrencies = currencies.filter({ $0.locale.lowercased().contains(formattedSearchText) || $0.code!.lowercased().contains(formattedSearchText)})
        
        if searchBar.text == "" {
            isFiltering = false
        }
        
        tableView.reloadData()
    }
}
