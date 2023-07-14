//
//  GetSortingListResponseModel.swift
//  House
//
//  Created by Hanan Ahmed on 11/8/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import Foundation

public struct GetSortingListResponseModel: Codable {
    public let sortingList: [FilterDO]?
    
    public init(sortingList: [FilterDO]? = nil) {
        self.sortingList = sortingList
    }
}
