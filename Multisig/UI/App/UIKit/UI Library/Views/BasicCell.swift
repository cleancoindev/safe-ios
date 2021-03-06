//
//  BasicCell.swift
//  Multisig
//
//  Created by Andrey Scherbovich on 05.11.20.
//  Copyright © 2020 Gnosis Ltd. All rights reserved.
//

import UIKit

class BasicCell: UITableViewCell {
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var disclosureImageView: UIImageView!

    static let rowHeight: CGFloat = 60

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLable.setStyle(.body)
    }

    func setTitle(_ value: String) {
        titleLable.text = value
    }

    func setDisclosureImage(_ image: UIImage?) {
        disclosureImageView.image = image
    }
}
