//
//  MostViewedArticleResponseModel.swift
//  NY Times Articles
//
//  Created by Zuhaib Imtiaz on 7/1/22.
//

import Foundation


struct MostPopularArticleResponseModel : Codable {
    let status : String?
    let copyright : String?
    let numResults : Int?
    let results : [MostPopularArticleModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case copyright = "copyright"
        case numResults = "num_results"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
        numResults = try values.decodeIfPresent(Int.self, forKey: .numResults)
        results = try values.decodeIfPresent([MostPopularArticleModel].self, forKey: .results)
    }

}

struct MostPopularArticleModel : Codable {
    let uri : String?
    let url : String?
    let id : Int?
    let assetId : Int?
    let source : String?
    let publishedDate : String?
    let updated : String?
    let section : String?
    let subsection : String?
    let nytdsection : String?
    let adxKeywords : String?
    let column : String?
    let byline : String?
    let type : String?
    let title : String?
    let abstract : String?
    let desFacet : [String]?
    let orgFacet : [String]?
    let perFacet : [String]?
    let geoFacet : [String]?
    let media : [MediaModel]?
    let etaId : Int?

    enum CodingKeys: String, CodingKey {

        case uri = "uri"
        case url = "url"
        case id = "id"
        case assetId = "asset_id"
        case source = "source"
        case publishedDate = "published_date"
        case updated = "updated"
        case section = "section"
        case subsection = "subsection"
        case nytdsection = "nytdsection"
        case adxKeywords = "adx_keywords"
        case column = "column"
        case byline = "byline"
        case type = "type"
        case title = "title"
        case abstract = "abstract"
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case media = "media"
        case etaId = "eta_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        assetId = try values.decodeIfPresent(Int.self, forKey: .assetId)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        publishedDate = try values.decodeIfPresent(String.self, forKey: .publishedDate)
        updated = try values.decodeIfPresent(String.self, forKey: .updated)
        section = try values.decodeIfPresent(String.self, forKey: .section)
        subsection = try values.decodeIfPresent(String.self, forKey: .subsection)
        nytdsection = try values.decodeIfPresent(String.self, forKey: .nytdsection)
        adxKeywords = try values.decodeIfPresent(String.self, forKey: .adxKeywords)
        column = try values.decodeIfPresent(String.self, forKey: .column)
        byline = try values.decodeIfPresent(String.self, forKey: .byline)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        abstract = try values.decodeIfPresent(String.self, forKey: .abstract)
        desFacet = try values.decodeIfPresent([String].self, forKey: .desFacet)
        orgFacet = try values.decodeIfPresent([String].self, forKey: .orgFacet)
        perFacet = try values.decodeIfPresent([String].self, forKey: .perFacet)
        geoFacet = try values.decodeIfPresent([String].self, forKey: .geoFacet)
        media = try values.decodeIfPresent([MediaModel].self, forKey: .media)
        etaId = try values.decodeIfPresent(Int.self, forKey: .etaId)
    }

}
struct MediaModel : Codable {
    let type : String?
    let subtype : String?
    let caption : String?
    let copyright : String?
    let approvedForSyndication : Int?
    let mediaMetaData : [MediaMetaModel]?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case subtype = "subtype"
        case caption = "caption"
        case copyright = "copyright"
        case approvedForSyndication = "approved_for_syndication"
        case mediaMetaData = "media-metadata"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        subtype = try values.decodeIfPresent(String.self, forKey: .subtype)
        caption = try values.decodeIfPresent(String.self, forKey: .caption)
        copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
        approvedForSyndication = try values.decodeIfPresent(Int.self, forKey: .approvedForSyndication)
        mediaMetaData = try values.decodeIfPresent([MediaMetaModel].self, forKey: .mediaMetaData)
    }

}

struct MediaMetaModel : Codable {
    let url : String?
    let format : String?
    let height : Int?
    let width : Int?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case format = "format"
        case height = "height"
        case width = "width"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        format = try values.decodeIfPresent(String.self, forKey: .format)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
    }

}
