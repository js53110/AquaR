import Foundation
import UIKit
import SnapKit

class HeaderView: UIView {
    
    private let headerTitleLabel = UILabel()
    private let headerTitle: String = "AquaR"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addViews()
        styleViews()
        setupConstraints()
    }
}

extension HeaderView {
    
    func addViews() {
        addSubview(headerTitleLabel)
    }
    
    func styleViews() {
        backgroundColor = .white
        
        headerTitleLabel.font = .headline1Desktop
        headerTitleLabel.textColor = .colorPrimaryDefault
        headerTitleLabel.textAlignment = .center
        headerTitleLabel.text = headerTitle
    }
    
    func setupConstraints() {
        snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        headerTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(56)
        }
    }
}
