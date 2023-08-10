//
//  DiscountAndDetailsServices.swift
//  House
//
//  Created by Shahroze Zaheer on 10/19/21.
//  Copyright © 2021 Ahmed samir ali. All rights reserved.
//

import Alamofire
import Foundation
import NetworkingLayer

class DiscountAndDetailsServices {
    let networkManager = NetworkManager()
    
    // MARK: - get Nearby Offer
    
    public func getOfferDetails(request: GetOfferDetailsRequest, completionHandler: @escaping (_ getOffersDetailResponse: OfferDetailsResponse) -> (), failureBlock: @escaping (_ error: ErrorCodeConfiguration?) -> ()) {
        let getOfferDetailsRequest = CouponsAndVoucherRouter.getOfferDetails(request: request)
        
        networkManager.executeRequest(for: OfferDetailsResponse.self, getOfferDetailsRequest, successBlock: { response in
            
            switch response {
            case let .success(list):
                completionHandler(list)
                
            case let .failure(error):
                let errorModel = ErrorCodeConfiguration()
                errorModel.errorCode = (error as NSError).code
                errorModel.errorDescriptionEn = error.localizedDescription
                errorModel.errorDescriptionAr = error.localizedDescription
                failureBlock(errorModel)
            }
            
        }) { error in
            failureBlock(error)
        }
    }
    
    public func addOfferToFavorite(operation: Int, offerId: String, completionHandler: @escaping (_ getDealsResponse: UpdateOfferWishlistResponse) -> (), failureBlock: @escaping (_ error: ErrorCodeConfiguration?) -> ()) {
        let addOfferToFavoriteRequest = HomeRouter.updateWishlist(operation: operation, offerId: offerId)
        
        networkManager.executeRequest(for: UpdateOfferWishlistResponse.self, addOfferToFavoriteRequest, successBlock: { response in
            
            switch response {
            case let .success(list):
                completionHandler(list)
                
            case let .failure(error):
                let errorModel = ErrorCodeConfiguration()
                errorModel.errorCode = (error as NSError).code
                errorModel.errorDescriptionEn = error.localizedDescription
                errorModel.errorDescriptionAr = error.localizedDescription
                failureBlock(errorModel)
            }
            
        }) { error in
            failureBlock(error)
        }
    }
    
    public func createPayment(request: CreatePaymentRequest, completionHandler: @escaping (_ paymentInfoResponse: CreatePaymentResponse) -> (), failureBlock: @escaping (_ error: ErrorCodeConfiguration?) -> ()) {
        let getPaymentInfoRequest = CouponsAndVoucherRouter.createPayment(request: request)
        
        networkManager.executeRequest(for: CreatePaymentResponse.self, getPaymentInfoRequest, successBlock: { response in
            
            switch response {
            case let .success(list):
                completionHandler(list)
                
            case let .failure(error):
                let errorModel = ErrorCodeConfiguration()
                errorModel.errorCode = (error as NSError).code
                errorModel.errorDescriptionEn = error.localizedDescription
                errorModel.errorDescriptionAr = error.localizedDescription
                failureBlock(errorModel)
            }
            
        }) { error in
            failureBlock(error)
        }
    }
    
    public func getPaymentInfo(request: PaymentInfoRequestModel, completionHandler: @escaping (_ paymentInfoResponse: PaymentInfoResponseModel) -> (), failureBlock: @escaping (_ error: ErrorCodeConfiguration?) -> ()) {
        let getPaymentInfoRequest = RestaurantRouter.getPaymentInfo(request: request)
        
        networkManager.executeRequest(for: PaymentInfoResponseModel.self, getPaymentInfoRequest, successBlock: { response in
            
            switch response {
            case let .success(list):
                completionHandler(list)
                
            case let .failure(error):
                let errorModel = ErrorCodeConfiguration()
                errorModel.errorCode = (error as NSError).code
                errorModel.errorDescriptionEn = error.localizedDescription
                errorModel.errorDescriptionAr = error.localizedDescription
                failureBlock(errorModel)
            }
            
        }) { error in
            failureBlock(error)
        }
    }
}
