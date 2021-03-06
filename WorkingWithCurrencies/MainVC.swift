//
//  ViewController.swift
//  WorkingWithCurrencies
//
//  Created by Josh R on 12/16/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    var selectedCurrency: Currency? {
        didSet {
            exampleLbl.text = generateExampleFigures()
            enterAmountTxt.text?.removeAll()
            cleanAmtLbl.text = "0"
            enterAmountTxt.currency = selectedCurrency
            enterAmountTxt.becomeFirstResponder()
            
            detailTableView.reloadData()
        }
    }
    
    fileprivate let cellID = "cellID"
    let detailTableView = UITableView()
    let cellHeight: CGFloat = 45.0  //set as property so it can be used to set the TV constraints
    
    lazy var enterAmountTxt: CurrencyTextField = {
        let textField = CurrencyTextField()
        textField.frame = .zero  //will use auto-layout
        textField.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        textField.textColor = .white
        textField.placeholder = "0.00"
        
        return textField
    }()
    
    lazy var showCurrenciesBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 175, height: 50)
        button.backgroundColor = .white
        button.setTitle("Select Currency", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = button.frame.height / 2  //rounds corners
        button.addTarget(self, action: #selector(currencyBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    lazy var exampleLbl: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.backgroundColor = .clear
        label.numberOfLines = 3
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        
        return label
    }()
    
    lazy var cleanAmtLbl: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.backgroundColor = .clear
        label.textAlignment = .right
        label.text = "0"
        
        return label
    }()
    
    let infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        addViews(infoView, enterAmountTxt, cleanAmtLbl, exampleLbl, showCurrenciesBtn, detailTableView)
        setupViewConstraints()
        setCurrencyOnStart()
        self.view.backgroundColor = .systemBlue
        
        //Pass amount from CurrencyTextField class
        enterAmountTxt.passTextFieldText = { [weak self] enteredStringAmount, amountAsDouble in
            self?.cleanAmtLbl.text = String(amountAsDouble ?? 0.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //NOTE: not called after navigating back from SelectCurrencyTVC due to iOS13s new modal presentation.  You can change it by forcing the presentation style to be fullscreen
    }
    
    //Changes the status bar text color to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK: showCurrenciesBtn selector method
    @objc func currencyBtnTapped() {
        let rootViewController = SelectCurrencyTVC()
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.delegate = self
        self.present(navController, animated: true, completion: nil)
    }

    private func addViews(_ views: UIView...) {
        views.forEach({ self.view.addSubview($0) })
    }
    
    private func setupTableView() {
        detailTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        detailTableView.backgroundColor = .white
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.keyboardDismissMode = .onDrag  //so the user can dismiss the keyboard after entering an amount
        
        detailTableView.layer.cornerRadius = 10
    }
    
    private func setCurrencyOnStart() {
        selectedCurrency = Currency(locale: "en_US", amount: 0.0)
    }
    
    private func generateExampleFigures() -> String {
        var formattedStringAmount = ""
        
        if let selectedCurrency = selectedCurrency {
            let numbers = [0.01, 1, 10, 100, 1000, 10000, 100000]
            
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: selectedCurrency.locale)
            numberFormatter.numberStyle = .currency
            
            for number in numbers {
                let currency = Currency(locale: selectedCurrency.locale, amount: number)
                formattedStringAmount += "\(currency.format)  "
            }
        }
        
        return formattedStringAmount
    }

    fileprivate func setupViewConstraints() {
        enterAmountTxt.translatesAutoresizingMaskIntoConstraints = false
        detailTableView.translatesAutoresizingMaskIntoConstraints = false
        showCurrenciesBtn.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false
        exampleLbl.translatesAutoresizingMaskIntoConstraints = false
        cleanAmtLbl.translatesAutoresizingMaskIntoConstraints = false
        
        enterAmountTxt.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        enterAmountTxt.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 20).isActive = true
        enterAmountTxt.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor,constant: -20).isActive = true
        enterAmountTxt.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        cleanAmtLbl.topAnchor.constraint(equalTo: self.enterAmountTxt.bottomAnchor, constant: 10).isActive = true
        cleanAmtLbl.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 20).isActive = true
        cleanAmtLbl.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor,constant: -20).isActive = true
        
        exampleLbl.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 20).isActive = true
        exampleLbl.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor,constant: -20).isActive = true
        exampleLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        exampleLbl.bottomAnchor.constraint(equalTo: detailTableView.topAnchor, constant: -20).isActive = true
    
        detailTableView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        detailTableView.heightAnchor.constraint(equalToConstant: cellHeight * 5).isActive = true
        detailTableView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 12).isActive = true
        detailTableView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor,constant: -12).isActive = true
        
        showCurrenciesBtn.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 20).isActive = true
        showCurrenciesBtn.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor,constant: -20).isActive = true
        showCurrenciesBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        showCurrenciesBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        showCurrenciesBtn.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -20).isActive = true
    }

}

extension MainVC: PassCurrencyDelegate {
    func pass(_ currency: Currency) {
        selectedCurrency = currency
    }
}

extension MainVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCurrency?.retrieveDetailedInformation().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1 , reuseIdentifier: cellID)
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.textColor = .darkGray
        
        guard let currencyDetail = selectedCurrency?.retrieveDetailedInformation()[indexPath.row] else { return UITableViewCell() }
        
        cell.textLabel?.text = currencyDetail.description
        cell.detailTextLabel?.text = currencyDetail.value
        
        return cell
    }
    
    
}
