//
//  SectionView.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 06.06.2021.
//

import UIKit
import SnapKit
class SectionView: UITableViewHeaderFooterView {
    
    static let identifier = "oscar_gad_ne_skinul_kak_pisat'_bez_aidi"
    var category: Category? {
        didSet {
            label.text = category?.name
        }
    }
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: UIFont.Weight(600))
        label.textColor = .black        
        return label
    }()
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(label)
        contentView.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    func setupConstraints() {
        label.snp.makeConstraints { make in
            make.bottom.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(15)
        }
    }
    
}
