//
//  File.swift
//  
//
//  Created by Habib Rehman on 15/02/2024.
//

import Foundation
import Combine
import NetworkingLayer

protocol OffersDetailRespositoryServiceable {
    func getOffersDetail(request: GetOfferDetailsRequest) -> AnyPublisher<OfferDetailsResponse, NetworkError>
}

class OffersDetailRespository: OffersDetailRespositoryServiceable {
    
    private var networkRequest: Requestable
    private var baseUrl: String

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
    }
    
    func getOffersDetail(request: GetOfferDetailsRequest) -> AnyPublisher<OfferDetailsResponse, NetworkError> {
        let endPoint = OffersCategoryListRequestBuilder.getOffersDetail(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl)
        return self.networkRequest.request(request)
    }
  
    
}
