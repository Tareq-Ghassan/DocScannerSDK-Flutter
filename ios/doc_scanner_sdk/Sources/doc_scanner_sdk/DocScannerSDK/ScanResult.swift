import Foundation

public struct ScanResult: Sendable {
    public let frontImagePath: String?
    public let backImagePath: String?
    public let isSuccess: Bool
    public let errorMessage: String?

    public init(
        frontImagePath: String? = nil,
        backImagePath: String? = nil,
        isSuccess: Bool,
        errorMessage: String? = nil
    ) {
        self.frontImagePath = frontImagePath
        self.backImagePath = backImagePath
        self.isSuccess = isSuccess
        self.errorMessage = errorMessage
    }
}
