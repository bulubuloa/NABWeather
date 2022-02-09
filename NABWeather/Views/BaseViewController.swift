//
//  BaseViewController.swift
//  NABWeather
//
//  Created by Omnimobile on 1/26/22.
//

import Foundation
import RxSwift

class BaseViewController : UIViewController {
    let disposeBag = DisposeBag()
    
    func setupUI() {
        
    }
    
    func setupBinding() {
        
    }
    
    override func viewDidLoad() {
        setupUI()
        setupBinding()
    }
}
