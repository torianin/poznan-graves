//
//  GraveCell.swift
//  PoznanGraves
//
//  Created by Robert Ignasiak on 21.05.2017.
//  Copyright © 2017 Torianin. All rights reserved.
//

import Foundation
import UIKit

class GraveCell: UITableViewCell {
    
    static let Identifier = "GraveCell"
    
    var grave: Grave? {
        didSet {
            if let gravePrintName = grave?.printName, let gravePrintSurname = grave?.printSurname {
                nameLabel.text = "\(gravePrintName ) \(gravePrintSurname )"
            }
        }
    }
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        addSubview(nameLabel)
        
        addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
