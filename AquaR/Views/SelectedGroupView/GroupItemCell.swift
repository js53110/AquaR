import Foundation
import UIKit
import SnapKit

protocol GroupItemCellDelegate: AnyObject {
    func groupItemCellDidTap(shower: Device, isBusy: String)
}

class GroupItemCell: UICollectionViewCell {
    
    static let identifier = "GroupItemCell"
    
    weak var delegate: GroupItemCellDelegate?
    
    private let groupItemContainer = UIView()
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let colorIndicator = UIView()
    private var data: Device?
    private var isBusy: String = "false"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        styleViews()
        setupConstraints()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        contentView.addSubview(groupItemContainer)
        groupItemContainer.addSubview(titleLabel)
        groupItemContainer.addSubview(statusLabel)
        groupItemContainer.addSubview(colorIndicator)
    }
    
    private func styleViews() {
        groupItemContainer.backgroundColor = .colorPrimaryHighlight
        groupItemContainer.layer.cornerRadius = 10
        groupItemContainer.clipsToBounds = true
        titleLabel.textColor = .black
        statusLabel.textColor = .black
        titleLabel.textAlignment = .center
        statusLabel.textAlignment = .center
        colorIndicator.layer.cornerRadius = 4
    }
    
    private func setupConstraints() {
        groupItemContainer.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
            $0.height.equalTo(20)
        }
        
        statusLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(35)
            $0.height.equalTo(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        colorIndicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(8)
            $0.top.equalTo(statusLabel.snp.bottom).offset(10)
        }
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        groupItemContainer.addGestureRecognizer(tapGesture)
    }
    
    func configure(title: String, data: Device, isBusy: String?) {
        titleLabel.text = title
        if(isBusy != nil) {
            self.isBusy = isBusy ?? "false"
            statusLabel.text = isBusy == "true" ? "Busy" : "Available"
            colorIndicator.backgroundColor = isBusy == "true" ? .red : .green
        }
        self.data = data
    }
}

extension GroupItemCell {
    
    @objc private func cellTapped() {
        if(data != nil && data?.type == "shower") {
            delegate?.groupItemCellDidTap(shower: data!, isBusy: isBusy)
        }
    }
}


