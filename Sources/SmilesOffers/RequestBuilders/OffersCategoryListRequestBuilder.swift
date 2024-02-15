//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 13/10/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities


// if you wish you can have multiple services like this in a project
enum OffersCategoryListRequestBuilder {
    
    // organise all the end points here for clarity
    case getOffersCategoryList(request: OffersCategoryRequestModel)
    case getOffersDetail(request: GetOfferDetailsRequest)
    
    // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getOffersCategoryList:
            return .POST
        case .getOffersDetail:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(baseUrl: String) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(baseUrl: baseUrl), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getOffersCategoryList(let request):
            return request
        case .getOffersDetail(request: let request):
            return request
        }
    }
    
    // compose urls for each request
    func getURL(baseUrl: String) -> String {
        switch self {
        case .getOffersCategoryList:
            return baseUrl + "home/get-offers-category-list"
        case .getOffersDetail:
            return baseUrl + "home/v1/offer-details"
        }
        
    }
}

