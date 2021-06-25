//
//  OrderTableViewCell.swift
//  QrRestaurantMenuApp
//
//  Created by ryan on 6/20/21.
//
import UIKit
import SnapKit

class OrderTableViewCell: UITableViewCell {
    static var identifier = "1"
    
    var orderItem: OrderItem? {
        didSet {
            guard let url = orderItem?.imageUrl else {return}
            downloadImage(from: URL(string: url))
            orderName.text = orderItem?.name
            orderDesc.text = orderItem?.description
            guard let price = orderItem?.price else {return}
            orderPrice.text = "\(price)"
            guard let count = orderItem?.count else {return}
            orderCount.text = "x\(count)"
        }
    }
    
    private let orderImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let orderName: UILabel = {
        let label = UILabel()
        label.text = "Триумф"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        return view
    }()
    
    private let orderDesc: UILabel = {
        let label = UILabel()
        label.text = "Калифорния классическая, Филадельфия лайт, Бостон, Зеленая миля"
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    private let orderPrice: UILabel = {
        let label = UILabel()
        label.text = "\(11980) \u{20B8}"
        label.font = .boldSystemFont(ofSize: 14)

        label.textColor = .black
        return label
    }()

    private let orderCount: UILabel = {
        let label = UILabel()
        label.text = "x2"
        label.font = .systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func downloadImage(from url: URL?) {
        print("Download Started")
       guard let url = url else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
           print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
    
            DispatchQueue.main.async() { [weak self] in
                guard let image = UIImage(data: data) else {return}
                self?.orderImage.image = image
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
       }

    private func setupConstraints() {
        contentView.addSubview(orderImage)
        contentView.addSubview(orderName)
        contentView.addSubview(orderPrice)
        contentView.addSubview(orderDesc)
        contentView.addSubview(orderCount)
        contentView.addSubview(borderView)

        orderImage.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(10)
            $0.left.equalTo(orderDesc.snp.right).offset(10)
            $0.height.width.equalTo(66)
        }
        orderName.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(10)
        }
        orderDesc.snp.makeConstraints {
            $0.top.equalTo(orderName.snp.bottom).offset(10)
            //$0.right.equalTo(orderImage.snp.left).inset(10)
            $0.left.equalToSuperview().inset(10)
        }
        orderPrice.snp.makeConstraints {
            $0.top.equalTo(orderDesc.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
        orderCount.snp.makeConstraints {
            $0.top.equalTo(orderDesc.snp.bottom).offset(10)
            $0.left.equalTo(orderPrice.snp.right).offset(10)
        }
        borderView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }

}
