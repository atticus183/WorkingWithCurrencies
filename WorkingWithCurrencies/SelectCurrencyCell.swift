//
//  SelectCurrencyCell.swift
//  WorkingWithCurrencies
//
//  Created by Josh R on 12/17/19.
//  Copyright © 2019 Josh R. All rights reserved.
//

import UIKit

class SelectCurrencyCell: UITableViewCell {
    
    var currency: Currency? {
        didSet {
            localeLbl.text = currency?.locale
            codeLbl.text = currency?.code
            amountLbl.text = currency?.format
        }
    }

    lazy var localeLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    lazy var codeLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    let verticalSV: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 2
        sv.distribution = .fill
        
        return sv
    }()
    
    lazy var amountLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .right
        label.sizeToFit()
        
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addLblsToCell(labels: verticalSV, amountLbl)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLblsToCell(labels: UIView...) {
        verticalSV.addArrangedSubview(localeLbl)
        verticalSV.addArrangedSubview(codeLbl)
        
        labels.forEach({ self.addSubview($0) })
    }
    
    private func setConstraints() {
        verticalSV.translatesAutoresizingMaskIntoConstraints = false
        amountLbl.translatesAutoresizingMaskIntoConstraints = false

        verticalSV.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        verticalSV.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        amountLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12).isActive = true
        amountLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
