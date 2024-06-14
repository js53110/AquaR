import Foundation
import UIKit
import SnapKit

class GroupItemsGrid: UIView {
    
    private let collectionView: UICollectionView
    
    weak var delegate: GroupItemCellDelegate?
    
    private var items: [Any] = []
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        setupCollectionView()
        addViews()
        styleViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        collectionView.register(GroupItemCell.self, forCellWithReuseIdentifier: GroupItemCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func addViews() {
        addSubview(collectionView)
    }
    
    func styleViews() {
        collectionView.backgroundColor = .surfaceSurface0
        collectionView.layer.cornerRadius = 10
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with items: [Any]) {
        self.items = items
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension GroupItemsGrid: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupItemCell.identifier, for: indexPath) as? GroupItemCell else {
            fatalError("Failed to dequeue GroupItemCell")
        }
        
        cell.delegate = self
        
        if let device = items[indexPath.item] as? Device {
            if device.type == "toilet" {
                getToiletStatus(deviceId: device.id.id) { status in
                    cell.configure(title: device.name, data: device, isBusy: status)
                }
            } else if device.type == "shower" {
                getShowerStatus(deviceId: device.id.id) { status in
                    cell.configure(title: device.name, data: device, isBusy: status)
                }
            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GroupItemsGrid: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 3
        return CGSize(width: width, height: width)
    }
}

extension GroupItemsGrid: GroupItemCellDelegate {
    func groupItemCellDidTap(shower: Device, isBusy: String) {
        delegate?.groupItemCellDidTap(shower: shower, isBusy: isBusy)
    }
}

extension GroupItemsGrid {
    
    func getToiletStatus(deviceId: String, completion: @escaping (String?) -> Void) {
        Task {
            do {
                let api = ThingsBoardApi.shared
                let token = try await api.obtainJWTToken()
                
                let telemetryResponse = try await api.fetchToiletStatus(jwtToken: token, deviceId: deviceId)
                switch telemetryResponse {
                case .success(let data):
                    completion(data.isLocked.first?.value)
                case .failure:
                    print("Failure fetching telemetry data")
                    completion(nil)
                }
                
            } catch {
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    
    func getShowerStatus(deviceId: String, completion: @escaping (String?) -> Void) {
        Task {
            do {
                let api = ThingsBoardApi.shared
                let token = try await api.obtainJWTToken()
                
                let telemetryResponse = try await api.fetchShowerStatus(jwtToken: token, deviceId: deviceId)
                switch telemetryResponse {
                case .success(let data):
                    completion(data.isOccupied.first?.value)
                case .failure:
                    print("Failure fetching telemetry data")
                    completion(nil)
                }
                
            } catch {
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
}
