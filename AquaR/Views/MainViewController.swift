import Foundation
import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    private var data: DeviceListResponse?
    private var devices: [Device] = []
    private var toilets: [Device] = []
    private var showers: [Device] = []
    private let customerToken: String?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let toiletsTitleLabel = UILabel()
    private let showersTitleLabel = UILabel()
    private let toiletsGridView = GroupItemsGrid()
    private let logoutButton = UIButton()
    private let refreshControl = UIRefreshControl()
    
    init() {
        customerToken = UserDefaultsService.retrieveDataFromUserDefaults()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = false
        
        toiletsGridView.delegate = self
        
        setupViews()
        styleViews()
        setupConstraints()
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        if let token = self.customerToken {
            getData(customerToken: token)
        }
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(toiletsTitleLabel)
        contentView.addSubview(toiletsGridView)
        contentView.addSubview(logoutButton)
    }
    
    private func styleViews() {
        toiletsTitleLabel.text = "Devices"
        toiletsTitleLabel.textAlignment = .left
        toiletsTitleLabel.textColor = .black
        toiletsTitleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.backgroundColor = .systemBlue
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 10
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        toiletsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        toiletsGridView.snp.makeConstraints {
            $0.top.equalTo(toiletsTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(200)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(toiletsGridView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(50)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
}

extension MainViewController: GroupItemCellDelegate {
    
    func groupItemCellDidTap(shower: Device, isBusy: String) {
        let newViewController = SelectedRoomViewController(data: shower, isBusy: isBusy)
        present(newViewController, animated: true, completion: nil)
    }
}

extension MainViewController {
    
    func getData(customerToken: String) {
        Task {
            do {
                let api = ThingsBoardApi.shared
                let token = try await api.obtainJWTToken()
                
                let telemetryResponse = try await api.fetchCustomerDevices(jwtToken: token, customerId: customerToken)
                switch telemetryResponse {
                case .success(let data):
                    self.devices = data.data
                    
                    self.toilets = self.devices.filter { $0.type == "toilet" }
                    self.showers = self.devices.filter { $0.type == "shower" }
                case .failure:
                    print("Failure fetching telemetry data")
                }
                
                DispatchQueue.main.async {
                    
                    self.refreshControl.endRefreshing()
                }
                self.toiletsGridView.configure(with: self.devices)
                
            } catch {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    @objc private func logoutButtonTapped() {
        UserDefaultsService.saveDataToUserDefaults(id: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func refreshData() {
        if let token = self.customerToken {
            getData(customerToken: token)
        }
    }
}
