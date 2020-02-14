/*
  Copyright (C) 2017 - 2020 MWSOFT
  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.
  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

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
