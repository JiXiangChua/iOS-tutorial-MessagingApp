//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by JI XIANG on 14/7/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//


struct K { //in the wild, K refers to constants in short form
    static let appName = "⚡️FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    
    //static turns "let registerSegue", which is an instance property, to a type property by declaring the keyword static infront.
    //So this allos you to call the property by refering to the name of the struct/class/protocol, example: K.registerSegue
    
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
