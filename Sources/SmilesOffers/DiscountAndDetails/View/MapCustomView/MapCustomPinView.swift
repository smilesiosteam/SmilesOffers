//
//  CustomPinView.swift
//  House
//
//  Created by Usman Tarar on 19/08/2020.
//  Copyright © 2020 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesUtilities

class MapCustomPinView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    
    
    var restaurant: Restaurant?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func loadViewFromNib() -> UIView {
        return UINib(nibName: "MapCustomPinView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    static func instantiate() -> MapCustomPinView {
        let view: MapCustomPinView = UINib(nibName: "MapCustomPinView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MapCustomPinView
        return view
    }
    
}
