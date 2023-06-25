//
//  ClassBindable.swift
//  DiagnalTest
//
//  Created by Pratyush Pratik Sinha on 22/06/23.
//

/**
 MARK: Importing modules
 */
import Foundation

/**
 MARK: Bindable
 - Defination of class Bindable.
 - Created for observer design pattern.
 */
final class Bindable<T> {
    
    //variable observer
    var observer: ((T?) -> ())?

    //variable value is created to set the generic value of observer
    var value: T? {
        didSet {
            observer?(value)
        }
    }
        
    //bind function is created to provide a block wherever we want to read the changes whenever new value is assigned to observer
    final func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
