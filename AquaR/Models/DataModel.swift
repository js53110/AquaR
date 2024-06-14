import Foundation

struct toiletStatusResponseModel: Codable {
    let isLocked: [statusModel]
}

struct showerStatusResponseModel: Codable {
    let isOccupied: [statusModel]
}

struct statusModel: Codable {
    let ts: Int
    let value: String
}

struct DeviceListResponse: Codable {
    let data: [Device]
    let totalPages: Int
    let totalElements: Int
    let hasNext: Bool
}

struct Device: Codable {
    let id: DeviceID
    let createdTime: Int64
    let additionalInfo: AdditionalInfo
    let tenantId: EntityID
    let customerId: EntityID
    let name: String
    let type: String
    let label: String
    let deviceProfileId: EntityID
    let deviceData: DeviceData
    let firmwareId: String?
    let softwareId: String?
    let externalId: String?
}

struct DeviceID: Codable {
    let entityType: String
    let id: String
}

struct AdditionalInfo: Codable {
    let gateway: Bool
    let overwriteActivityTime: Bool
    let description: String
}

struct EntityID: Codable {
    let entityType: String
    let id: String
}

struct DeviceData: Codable {
    let configuration: Configuration
    let transportConfiguration: Configuration
}

struct Configuration: Codable {
    let type: String
}

struct CustomerListResponse: Codable {
    let data: [Customer]
}

struct Customer: Codable {
    let id: CustomerId
}

struct CustomerId: Codable {
    let id: String
}
