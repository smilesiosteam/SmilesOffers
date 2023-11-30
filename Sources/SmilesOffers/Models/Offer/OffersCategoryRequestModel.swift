//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 11/07/2023.
//

import Foundation
import SmilesBaseMainRequestManager

public class OffersCategoryRequestModel: SmilesBaseMainRequest {
    
    // MARK: - Model Variables
    
    var pageNo: Int?
    var categoryId: String?
    var searchByLocation: Bool?
    var sortingType: String?
    var subCategoryId: String?
    var subCategoryTypeIdsList: [String]?
    var categoryTypeIdsList: [String]?
    var isGuestUser: Bool?
    var tag: String?
    var latitude : Double?
    var longitude : Double?
    // MARK: - Model Keys
    
    enum CodingKeys: CodingKey {
        case pageNo
        case categoryId
        case searchByLocation
        case sortingType
        case subCategoryId
        case tag
        case subCategoryTypeIdsList
        case isGuestUser
        case categoryTypeIdsList
        case latitude
        case longitude
    }
    
    public init(pageNo: Int? = nil, categoryId: String?, searchByLocation: Bool? = nil, sortingType: String? = nil, subCategoryId: String? = nil, subCategoryTypeIdsList: [String]? = nil, isGuestUser: Bool? = nil, tag:String? = nil, categoryTypeIdsList : [String]? = nil, latitude:Double? = nil, longitude:Double? = nil) {
        super.init()
        self.pageNo = pageNo
        self.categoryId = categoryId
        self.searchByLocation = searchByLocation
        self.sortingType = sortingType
        self.subCategoryId = subCategoryId
        self.tag = tag
        self.categoryTypeIdsList = categoryTypeIdsList
        self.subCategoryTypeIdsList = subCategoryTypeIdsList
        self.isGuestUser = isGuestUser
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.pageNo, forKey: .pageNo)
        try container.encodeIfPresent(self.categoryId, forKey: .categoryId)
        try container.encodeIfPresent(self.searchByLocation, forKey: .searchByLocation)
        try container.encodeIfPresent(self.sortingType, forKey: .sortingType)
        try container.encodeIfPresent(self.subCategoryId, forKey: .subCategoryId)
        try container.encodeIfPresent(self.subCategoryTypeIdsList, forKey: .subCategoryTypeIdsList)
        try container.encodeIfPresent(self.isGuestUser, forKey: .isGuestUser)
        try container.encodeIfPresent(self.tag, forKey: .tag)
        try container.encodeIfPresent(self.categoryTypeIdsList, forKey: .categoryTypeIdsList)
        try container.encodeIfPresent(self.latitude, forKey: .latitude)
        try container.encodeIfPresent(self.longitude, forKey: .longitude)
    }
}
