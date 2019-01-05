//
//  Property.swift
//  Lost&Found
//
//  Created by gauri chavan on 4/27/18.
//  Copyright © 2018 gauri chavan. All rights reserved.
//

import Foundation
class Property {
   // var id:String
   // var propertyFoundlongitude:String
    var propertyFoundOrLost:String
    var propertyDescription:String
    var propertyId:String
    var propertyImageURL:NSURL
   /* var propertyFoundlatitude:String
    var propertyFoundDate:String
    var userId:String*/
    var propertyName:String

    /*init(id:String, propertyFoundlongitude:String,propertyFoundOrLost:String,propertyDescription:String,propertyImageURL:String,propertyFoundlatitude:String,propertyFoundDate:String,userId:String,propertyName:String) {
        self.id = id
        self.propertyFoundlongitude = propertyFoundlongitude
        self.propertyFoundOrLost = propertyFoundOrLost
        self.propertyDescription = propertyDescription
        self.propertyImageURL = propertyImageURL
        self.propertyFoundlatitude = propertyFoundlatitude
        self.propertyFoundDate = propertyFoundDate
        self.userId = userId
        self.propertyName = propertyName
    }*/
    
    init(propertyDescription:String,propertyName:String,propertyFoundOrLost:String,propertyId:String,propertyImageURL:URL) {
        self.propertyDescription = propertyDescription
        self.propertyName = propertyName
        self.propertyFoundOrLost = propertyFoundOrLost
        self.propertyId = propertyId
        self.propertyImageURL = propertyImageURL as NSURL

    }
}
