//
//  Crypto.swift
//  CryptoNews
//
//  Created by Alexey Kurto on 14.11.23.
//

import UIKit

// MARK: - Crypto
struct Crypto: Codable {
    var status: Status?
    var data: [Currency]?
}

// MARK: Crypto convenience initializers and mutators

extension Crypto {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Crypto.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        status: Status?? = nil,
        data: [Currency]?? = nil
    ) -> Crypto {
        return Crypto(
            status: status ?? self.status,
            data: data ?? self.data
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Currency
struct Currency: Codable {
    var id: Int?
    var name, symbol, slug: String?
    var numMarketPairs: Int?
    var dateAdded: String?
    var tags: [String]?
    var maxSupply, circulatingSupply, totalSupply: Double?
    var platform: Platform?
    var cmcRank: Int?
    var selfReportedCirculatingSupply, selfReportedMarketCap: Double?
    var lastUpdated: String?
    var quote: Quote?

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug
        case numMarketPairs = "num_market_pairs"
        case dateAdded = "date_added"
        case tags
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case platform
        case cmcRank = "cmc_rank"
        case selfReportedCirculatingSupply = "self_reported_circulating_supply"
        case selfReportedMarketCap = "self_reported_market_cap"
        case lastUpdated = "last_updated"
        case quote
    }
}

// MARK: Currency convenience initializers and mutators

extension Currency {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Currency.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int?? = nil,
        name: String?? = nil,
        symbol: String?? = nil,
        slug: String?? = nil,
        numMarketPairs: Int?? = nil,
        dateAdded: String?? = nil,
        tags: [String]?? = nil,
        maxSupply: Double?? = nil,
        circulatingSupply: Double?? = nil,
        totalSupply: Double?? = nil,
        platform: Platform?? = nil,
        cmcRank: Int?? = nil,
        selfReportedCirculatingSupply: Double?? = nil,
        selfReportedMarketCap: Double?? = nil,
        lastUpdated: String?? = nil,
        quote: Quote?? = nil
    ) -> Currency {
        return Currency(
            id: id ?? self.id,
            name: name ?? self.name,
            symbol: symbol ?? self.symbol,
            slug: slug ?? self.slug,
            numMarketPairs: numMarketPairs ?? self.numMarketPairs,
            dateAdded: dateAdded ?? self.dateAdded,
            tags: tags ?? self.tags,
            maxSupply: maxSupply ?? self.maxSupply,
            circulatingSupply: circulatingSupply ?? self.circulatingSupply,
            totalSupply: totalSupply ?? self.totalSupply,
            platform: platform ?? self.platform,
            cmcRank: cmcRank ?? self.cmcRank,
            selfReportedCirculatingSupply: selfReportedCirculatingSupply ?? self.selfReportedCirculatingSupply,
            selfReportedMarketCap: selfReportedMarketCap ?? self.selfReportedMarketCap,
            lastUpdated: lastUpdated ?? self.lastUpdated,
            quote: quote ?? self.quote
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Platform
struct Platform: Codable {
    var id: Int?
    var name, symbol, slug, tokenAddress: String?

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, slug
        case tokenAddress = "token_address"
    }
}

// MARK: Platform convenience initializers and mutators

extension Platform {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Platform.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: Int?? = nil,
        name: String?? = nil,
        symbol: String?? = nil,
        slug: String?? = nil,
        tokenAddress: String?? = nil
    ) -> Platform {
        return Platform(
            id: id ?? self.id,
            name: name ?? self.name,
            symbol: symbol ?? self.symbol,
            slug: slug ?? self.slug,
            tokenAddress: tokenAddress ?? self.tokenAddress
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Quote
struct Quote: Codable {
    var usd: Usd?

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

// MARK: Quote convenience initializers and mutators

extension Quote {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Quote.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        usd: Usd?? = nil
    ) -> Quote {
        return Quote(
            usd: usd ?? self.usd
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Usd
struct Usd: Codable {
    var price, volume24H, volumeChange24H, percentChange1H: Double?
    var percentChange24H, percentChange7D, percentChange30D, percentChange60D: Double?
    var percentChange90D, marketCap, marketCapDominance, fullyDilutedMarketCap: Double?
    var lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case price
        case volume24H = "volume_24h"
        case volumeChange24H = "volume_change_24h"
        case percentChange1H = "percent_change_1h"
        case percentChange24H = "percent_change_24h"
        case percentChange7D = "percent_change_7d"
        case percentChange30D = "percent_change_30d"
        case percentChange60D = "percent_change_60d"
        case percentChange90D = "percent_change_90d"
        case marketCap = "market_cap"
        case marketCapDominance = "market_cap_dominance"
        case fullyDilutedMarketCap = "fully_diluted_market_cap"
        case lastUpdated = "last_updated"
    }
}

// MARK: Usd convenience initializers and mutators

extension Usd {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Usd.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        price: Double?? = nil,
        volume24H: Double?? = nil,
        volumeChange24H: Double?? = nil,
        percentChange1H: Double?? = nil,
        percentChange24H: Double?? = nil,
        percentChange7D: Double?? = nil,
        percentChange30D: Double?? = nil,
        percentChange60D: Double?? = nil,
        percentChange90D: Double?? = nil,
        marketCap: Double?? = nil,
        marketCapDominance: Double?? = nil,
        fullyDilutedMarketCap: Double?? = nil,
        lastUpdated: String?? = nil
    ) -> Usd {
        return Usd(
            price: price ?? self.price,
            volume24H: volume24H ?? self.volume24H,
            volumeChange24H: volumeChange24H ?? self.volumeChange24H,
            percentChange1H: percentChange1H ?? self.percentChange1H,
            percentChange24H: percentChange24H ?? self.percentChange24H,
            percentChange7D: percentChange7D ?? self.percentChange7D,
            percentChange30D: percentChange30D ?? self.percentChange30D,
            percentChange60D: percentChange60D ?? self.percentChange60D,
            percentChange90D: percentChange90D ?? self.percentChange90D,
            marketCap: marketCap ?? self.marketCap,
            marketCapDominance: marketCapDominance ?? self.marketCapDominance,
            fullyDilutedMarketCap: fullyDilutedMarketCap ?? self.fullyDilutedMarketCap,
            lastUpdated: lastUpdated ?? self.lastUpdated
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Status
struct Status: Codable {
    var timestamp: String?
    var errorCode: Int?
    var errorMessage: String?
    var elapsed, creditCount: Int?
    var notice: String?
    var totalCount: Int?

    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
        case notice
        case totalCount = "total_count"
    }
}

// MARK: Status convenience initializers and mutators

extension Status {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Status.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        timestamp: String?? = nil,
        errorCode: Int?? = nil,
        errorMessage: String?? = nil,
        elapsed: Int?? = nil,
        creditCount: Int?? = nil,
        notice: String?? = nil,
        totalCount: Int?? = nil
    ) -> Status {
        return Status(
            timestamp: timestamp ?? self.timestamp,
            errorCode: errorCode ?? self.errorCode,
            errorMessage: errorMessage ?? self.errorMessage,
            elapsed: elapsed ?? self.elapsed,
            creditCount: creditCount ?? self.creditCount,
            notice: notice ?? self.notice,
            totalCount: totalCount ?? self.totalCount
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

