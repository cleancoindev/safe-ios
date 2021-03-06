//
//  BalanceTableViewCell.swift
//  Multisig
//
//  Created by Dmitry Bespalov on 22.10.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import UIKit
import Kingfisher

class BalanceTableViewCell: UITableViewCell {
    @IBOutlet private weak var cellMainLabel: UILabel!
    @IBOutlet private weak var cellDetailLabel: UILabel!
    @IBOutlet private weak var cellSubDetailLabel: UILabel!
    @IBOutlet private weak var cellImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        cellMainLabel.setStyle(.body)
        cellDetailLabel.setStyle(.body)
        cellSubDetailLabel.setStyle(.footnote2)
    }

    func setMainText(_ value: String) {
        cellMainLabel.text = value
    }

    func setDetailText(_ value: String) {
        cellDetailLabel.text = value
    }

    func setSubDetailText(_ value: String) {
        cellSubDetailLabel.text = value
    }

    func setImage(with url: URL?, placeholder: UIImage) {
        if let url = url {
            cellImageView.kf.setImage(with: url, placeholder: placeholder)
        } else {
            setImage(placeholder)
        }
    }

    func setImage(_ image: UIImage) {
        cellImageView.image = image
    }
}
