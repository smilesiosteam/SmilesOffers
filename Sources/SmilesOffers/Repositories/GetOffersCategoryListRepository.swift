//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 13/10/2023.
//

import Foundation
import Combine
import NetworkingLayer

protocol GetOffersCategoryListServiceable {
    func getOffersCategoryListService(request: OffersCategoryRequestModel) -> AnyPublisher<OffersCategoryResponseModel, NetworkError>
}

class GetOffersCategoryListRepository: GetOffersCategoryListServiceable {
    
    private var networkRequest: Requestable
    private var baseUrl: String

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
    }
  
    func getOffersCategoryListService(request: OffersCategoryRequestModel) -> AnyPublisher<OffersCategoryResponseModel, NetworkError> {
        let endPoint = OffersCategoryListRequestBuilder.getOffersCategoryList(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl)
        
        return self.networkRequest.request(request)
    }
}
