import Foundation
import CoreLocation

public struct PresentedDataViewModel: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let capitalName: String
    public let image: String
    public let curency: CurrencyModel?
    public let latitude: Double
    public let longitude: Double
    
    public var location: CLLocation? {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    public init(model: CountriesListModel) {
        self.id = UUID().uuidString
        self.name = model.name
        self.capitalName = model.capital ?? ""
        self.image = model.flags?.png ?? ""
        self.latitude = model.latlng?.first ?? 0.0
        self.longitude = model.latlng?.last ?? 0.0
        self.curency = model.currencies?.first
    }
    
    public static func == (lhs: PresentedDataViewModel, rhs: PresentedDataViewModel) -> Bool {
        return lhs.name == rhs.name &&
               lhs.capitalName == rhs.capitalName &&
               lhs.image == rhs.image &&
               lhs.latitude == rhs.latitude &&
               lhs.longitude == rhs.longitude &&
               lhs.curency == rhs.curency
    }
}

public extension Array where Element == CountriesListModel {
    func toModels() -> [PresentedDataViewModel] {
        return map { PresentedDataViewModel(model: $0) }
    }
}

// MARK: - Model Definitions

public struct CountriesListModel: Codable {
    let name: String
    let latlng: [Double]?
    let capital: String?
    let nativeName: String?
    let currencies: [CurrencyModel]?
    let flag: String?
    let flags: FlagsModel?
    init(
            name: String,
            latlng: [Double]? = nil,
            capital: String? = nil,
            nativeName: String? = nil,
            currencies: [CurrencyModel]? = nil,
            flag: String? = nil,
            flags: FlagsModel? = nil
        ) {
            self.name = name
            self.latlng = latlng
            self.capital = capital
            self.nativeName = nativeName
            self.currencies = currencies
            self.flag = flag
            self.flags = flags
        }
}

public struct CurrencyModel: Codable, Equatable {
    let code: String?
    let name: String?
    let symbol: String?
}

public struct FlagsModel: Codable {
    let svg: String?
    let png: String?
}
