import UIKit
import SnapKit

class SelectedRoomViewController: UIViewController {
    
    private var data: Device
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let reserveButton = UIButton()
    
    private var selectedTimeSlot: String = ""
    private let isBusy: String
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(data: Device, isBusy: String) {
        self.data = data
        self.isBusy = isBusy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        styleViews()
        setupConstraints()
        configureData()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(closeButton)
        if(isBusy=="false") {
            view.addSubview(reserveButton)
            reserveButton.snp.makeConstraints {
                $0.top.equalTo(closeButton.snp.top).offset(-100)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(200)
                $0.height.equalTo(50)
            }
        }
    }
    
    private func styleViews() {
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        descriptionLabel.text = "This unit is available, reserve for next 30 minutes"
        descriptionLabel.font = .systemFont(ofSize: 40, weight: .regular)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .center
        
        reserveButton.setTitle("Reserve", for: .normal)
        reserveButton.backgroundColor = .systemBlue
        reserveButton.setTitleColor(.white, for: .normal)
        reserveButton.layer.cornerRadius = 10
        reserveButton.addTarget(self, action: #selector(reserveButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    private func configureData() {
        if(isBusy=="true") {
            descriptionLabel.text = "This unit is currently busy"
        }
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func reserveButtonTapped() {
        
        Task {
            do {
                let api = ThingsBoardApi.shared
                let token = try await api.obtainJWTToken()
                
                let currentDate = Date()
                let date30SecondsFromNow = currentDate.addingTimeInterval(30)
                let timestamp30SecondsFromNow = date30SecondsFromNow.timeIntervalSince1970
                
                let reservationResponse = try await api.makeReservation(jwtToken: token, deviceId: data.id.id, timestamp: timestamp30SecondsFromNow)
//                switch reservationResponse {
//                case .success(let reservation):
//                    print("Success")
//                case .failure:
//                    print("Failure")
//                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
