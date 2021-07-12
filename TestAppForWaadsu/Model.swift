//
//  Dispose.swift
//  TestAppForWaadsu
//
//  Created by Михаил Липунцов on 10.07.2021.
//

import Foundation
import MapKit

struct Model: Decodable {
    
    let coordinates: [CLLocationCoordinate2D]
    let multiPolygon: MKMultiPolygon
    let type: String
    let features: [Feature]
    
    enum CodingKeys: CodingKey {
        case type, features, coordinates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        features = try container.decode([Feature].self, forKey: .features)
        
        var polygons: [MKPolygon] = []
        var coordinates: [CLLocationCoordinate2D] = []
        
        features[0].geometry.coordinates.forEach({ multipolygon in
            var locationCoordinates: [CLLocationCoordinate2D] = []
            multipolygon.forEach { polygon in
                polygon.forEach { point in
                    let lc = CLLocationCoordinate2D(latitude: point[1], longitude: point[0])
                    if CLLocationCoordinate2DIsValid(lc) {
                        locationCoordinates.append(lc)
                        coordinates.append(lc)
                    }
                }
            }
            let polygon = MKPolygon(coordinates: locationCoordinates, count: locationCoordinates.count)
            polygons.append(polygon)
        })
        
        self.coordinates = coordinates
        self.multiPolygon = MKMultiPolygon(polygons)
    }
}

// MARK: - Feature
struct Feature: Decodable {
    let type: String
    let properties: Properties
    let geometry: Geometry
}

// MARK: - Geometry
struct Geometry: Decodable {
    let type: String
    let coordinates: [[[[Double]]]]
}

// MARK: - Properties
struct Properties: Decodable {
    let scalerank: Int
    let featurecla: String
    let labelrank: Int
    let sovereignt, sovA3: String
    let adm0DIF, level: Int
    let type, admin, adm0A3: String
    let geouDIF: Int
    let geounit, guA3: String
    let suDIF: Int
    let subunit, suA3: String
    let brkDiff: Int
    let name, nameLong, brkA3, brkName: String
    let brkGroup: JSONNull?
    let abbrev, postal, formalEn: String
    let formalFr, noteAdm0, noteBrk: JSONNull?
    let nameSort: String
    let nameAlt: JSONNull?
    let mapcolor7, mapcolor8, mapcolor9, mapcolor13: Int
    let popEst, gdpMdEst, popYear, lastcensus: Int
    let gdpYear: Int
    let economy, incomeGrp: String
    let wikipedia: Int
    let fips10_, isoA2, isoA3, isoN3: String
    let unA3, wbA2, wbA3: String
    let woeID, woeIDEh: Int
    let woeNote, adm0A3Is, adm0A3Us: String
    let adm0A3Un, adm0A3Wb: Int
    let continent, regionUn, subregion, regionWb: String
    let nameLen, longLen, abbrevLen, tiny: Int
    let homepart: Int
    let filename: String
    
    enum CodingKeys: String, CodingKey {
        case scalerank, featurecla, labelrank, sovereignt
        case sovA3 = "sov_a3"
        case adm0DIF = "adm0_dif"
        case level, type, admin
        case adm0A3 = "adm0_a3"
        case geouDIF = "geou_dif"
        case geounit
        case guA3 = "gu_a3"
        case suDIF = "su_dif"
        case subunit
        case suA3 = "su_a3"
        case brkDiff = "brk_diff"
        case name
        case nameLong = "name_long"
        case brkA3 = "brk_a3"
        case brkName = "brk_name"
        case brkGroup = "brk_group"
        case abbrev, postal
        case formalEn = "formal_en"
        case formalFr = "formal_fr"
        case noteAdm0 = "note_adm0"
        case noteBrk = "note_brk"
        case nameSort = "name_sort"
        case nameAlt = "name_alt"
        case mapcolor7, mapcolor8, mapcolor9, mapcolor13
        case popEst = "pop_est"
        case gdpMdEst = "gdp_md_est"
        case popYear = "pop_year"
        case lastcensus
        case gdpYear = "gdp_year"
        case economy
        case incomeGrp = "income_grp"
        case wikipedia
        case fips10_ = "fips_10_"
        case isoA2 = "iso_a2"
        case isoA3 = "iso_a3"
        case isoN3 = "iso_n3"
        case unA3 = "un_a3"
        case wbA2 = "wb_a2"
        case wbA3 = "wb_a3"
        case woeID = "woe_id"
        case woeIDEh = "woe_id_eh"
        case woeNote = "woe_note"
        case adm0A3Is = "adm0_a3_is"
        case adm0A3Us = "adm0_a3_us"
        case adm0A3Un = "adm0_a3_un"
        case adm0A3Wb = "adm0_a3_wb"
        case continent
        case regionUn = "region_un"
        case subregion
        case regionWb = "region_wb"
        case nameLen = "name_len"
        case longLen = "long_len"
        case abbrevLen = "abbrev_len"
        case tiny, homepart, filename
    }
}

class JSONNull: Codable {
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
