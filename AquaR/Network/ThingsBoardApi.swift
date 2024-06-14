import Foundation

struct ThingsBoardConfig {
    static let serverURL = "http://161.53.19.19:45080"
    static let username = "jakov.sikiric@fer.hr"
    static let password = "IntStvAquaQ"
}

enum NetworkError: Error {
    case invalidURL
    case invalidData
}

class ThingsBoardApi {
    
    private var jwtToken: String?
    
    static let shared = ThingsBoardApi()
    private let urlSession = URLSession.shared
    
    func obtainJWTToken() async throws -> String {
        let loginEndpoint = "\(ThingsBoardConfig.serverURL)/api/auth/login"
        guard let url = URL(string: loginEndpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = [
            "username": ThingsBoardConfig.username,
            "password": ThingsBoardConfig.password
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        
        let (data, _) = try await urlSession.data(for: request)
        
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let token = json["token"] as? String
        else {
            throw NetworkError.invalidData
        }
        
        jwtToken = token
        return token
    }
    
    func fetchCustomersData(jwtToken: String) async throws -> Result<CustomerListResponse, NetworkError> {
        let deviceEndpoint = "\(ThingsBoardConfig.serverURL)/api/customers?pageSize=100&page=0"
        
        guard let url = URL(string: deviceEndpoint) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await urlSession.data(for: request)
            let eventResponse = try JSONDecoder().decode(CustomerListResponse.self, from: data)
            return .success(eventResponse)
        } catch {
            print("Failure fetching device data: \(error)")
            return .failure(.invalidData)
        }
    }
    
    func fetchDeviceData(jwtToken: String) async throws -> Result<DeviceListResponse, NetworkError> {
        let deviceEndpoint = "\(ThingsBoardConfig.serverURL)/api/tenant/devices?pageSize=100&page=0"
        
        guard let url = URL(string: deviceEndpoint) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await urlSession.data(for: request)
            let eventResponse = try JSONDecoder().decode(DeviceListResponse.self, from: data)
            return .success(eventResponse)
        } catch {
            print("Failure fetching device data: \(error)")
            return .failure(.invalidData)
        }
    }
    
    func fetchCustomerDevices(jwtToken: String, customerId: String) async throws -> Result<DeviceListResponse, NetworkError> {
        
        let deviceEndpoint = "\(ThingsBoardConfig.serverURL)/api/customer/\(customerId)/devices?pageSize=100&page=0"
        
        guard let url = URL(string: deviceEndpoint) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await urlSession.data(for: request)
            let eventResponse = try JSONDecoder().decode(DeviceListResponse.self, from: data)
            return .success(eventResponse)
        } catch {
            print("Failure fetching device data: \(error)")
            return .failure(.invalidData)
        }
    }
    
    func fetchToiletStatus(jwtToken: String, deviceId: String) async throws -> Result<toiletStatusResponseModel, NetworkError> {
        
        let endTs = Int(Date().timeIntervalSince1970 * 1000)
        let startTs = endTs - 3600000
        
        let deviceEndpoint = "\(ThingsBoardConfig.serverURL)/api/plugins/telemetry/DEVICE/\(deviceId)/values/timeseries?keys=isLocked&startTs=\(startTs)&endTs=\(endTs)&limit=1"
        
        guard let url = URL(string: deviceEndpoint) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await urlSession.data(for: request)
            let eventResponse = try JSONDecoder().decode(toiletStatusResponseModel.self, from: data)
            return .success(eventResponse)
        } catch {
            print("Failure fetching device data: \(error)")
            return .failure(.invalidData)
        }
    }
    
    func fetchShowerStatus(jwtToken: String, deviceId: String) async throws -> Result<showerStatusResponseModel, NetworkError> {
        
        
        let endTs = Int(Date().timeIntervalSince1970 * 1000)
        let startTs = endTs - 3600000
    
        let deviceEndpoint = "\(ThingsBoardConfig.serverURL)/api/plugins/telemetry/DEVICE/\(deviceId)/values/timeseries?keys=isOccupied&startTs=\(startTs)&endTs=\(endTs)&limit=1"
        
        guard let url = URL(string: deviceEndpoint) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await urlSession.data(for: request)
            let eventResponse = try JSONDecoder().decode(showerStatusResponseModel.self, from: data)
            return .success(eventResponse)
        } catch {
            print("Failure fetching device data: \(error)")
            return .failure(.invalidData)
        }
    }
    
    func makeReservation(jwtToken: String, deviceId: String, timestamp: Double) async throws {
        let deviceEndpoint = "\(ThingsBoardConfig.serverURL)/api/plugins/telemetry/DEVICE/\(deviceId)/your-endpoint"

        guard let url = URL(string: deviceEndpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(jwtToken)", forHTTPHeaderField: "Authorization")

        let parameters: [String: Any] = [
            "timestamp": timestamp,
            "deviceId": deviceId
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidURL
        }
    }
}
