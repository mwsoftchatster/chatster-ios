//
//  PhoneContacts.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 30/06/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation
import ContactsUI
import PhoneNumberKit

class PhoneContacts {
    
    class func getContacts() -> [User] {
        
        let phoneNumberKit = PhoneNumberKit()
        let contactStore = CNContactStore()
        var users = [User]()
        let keys = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey
            ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                for phoneNumber in contact.phoneNumbers {
                    if let number = phoneNumber.value as? CNPhoneNumber, let _ = phoneNumber.label {
                        do {
                            let phoneNumber = try phoneNumberKit.parse(number.stringValue)
                            let userId = "\(phoneNumber.countryCode)\(phoneNumber.nationalNumber)"
                            let user = User(userId: userId, userName: contact.givenName, statusMessage: "Hi, my name is \(contact.givenName)")
                            users.append(user)
                        } catch {
                            print("error parsing phone number")
                        }

                    }
                }
            }
        } catch {
            print("unable to fetch contacts")
        }
        
        return users
    }
}
