//
//  RPFContactManager.swift
//  RapidFund
//
//  Created by 毛亚恒 on 2024/7/23.
//

import UIKit
import Contacts

class RPFContactManager {    
    
    static let shared = RPFContactManager()
    
    var status: CNAuthorizationStatus?
    var contacts: [CNContact] = []
    
    private init() {

    }
    
    func openSettings() {
        guard let appSettings = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }
    
    func requestAccessForContacts() -> Bool{
        
        
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined:
            // 权限尚未请求，我们需要请求权限
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { (granted, error) in
                if let error = error {
                    print("Error requesting access: \(error.localizedDescription)")
//                    return false
                } else {
                    print("Access granted: \(granted)")
                    if granted {
                        // 访问被授权，可以获取通讯录数据
//                        return true
                    }
//                    return false
                }
            }
            return false
        case .restricted, .denied:
            // 访问受限或被拒绝，可以提示用户或者采取其他行动
            return false
           
        case .authorized:
            // 已经授权，可以获取通讯录数据
            return true
           
            
        @unknown default:
            return false
            
        }
    }
    
    func fetchContacts(completion: @escaping (([[String: Any]], Error?) -> Void)){
        
        let store = CNContactStore()
        var keysToFetch: [CNKeyDescriptor] = [
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactNicknameKey as CNKeyDescriptor,
//            CNContactOrganizationNameKey as CNKeyDescriptor,
//            CNContactJobTitleKey as CNKeyDescriptor,
//            CNContactDepartmentNameKey as CNKeyDescriptor,
//            CNContactBirthdayKey as CNKeyDescriptor,
//            CNContactNonGregorianBirthdayKey as CNKeyDescriptor,
            CNContactDatesKey as CNKeyDescriptor,
//            CNContactTypeKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
//            CNContactEmailAddressesKey as CNKeyDescriptor,
//            CNContactPostalAddressesKey as CNKeyDescriptor,
//            CNContactInstantMessageAddressesKey as CNKeyDescriptor,
//            CNContactSocialProfilesKey as CNKeyDescriptor,
//            CNContactUrlAddressesKey as CNKeyDescriptor,
        ]

        if #available(iOS 13.0, *) {
            
        } else {
            keysToFetch.append(CNContactNoteKey as CNKeyDescriptor)
        }
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contactArr = [[String : Any]]()
        DispatchQueue.global(qos: .userInitiated).async {
            
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    let name = "\(contact.familyName)\(contact.givenName)"
                    var note = ""
                    var dateStr = ""
                    
                    if contact.isKeyAvailable(note) {
                        note = contact.note
                    }
                    
                    for cnDate in contact.dates {
                        if let date = cnDate.value.date {
                            let label = CNLabeledValue<NSString>.localizedString(forLabel: cnDate.label ?? "")
                            if !label.isEmpty {
                                dateStr = "\(Int(date.timeIntervalSince1970) * 1000)"
                            }
                        }
                    }
                    
//                    {
//                      "lonely": "+6281296611393,+6281296611393",
//                      "across": "1653818330000",
//                      "faced": "",
//                      "toput": "",
//                      "roomed": "",
//                      "morelike": "1653818095000",
//                      "wasan": "ayah"
//                    }
                    
                    for phoneNumber in contact.phoneNumbers {
                        contactArr.append([
                            "lonely": phoneNumber.value.stringValue,
                            "wasan": name.isEmpty ? "" : name,
                            "morelike": "",
                            "faced": "",
                            "toput": "",
                            "roomed": "",
                            "across": ""
                            
                        ])
                    }
                }
                print(contactArr)
                completion(contactArr, nil)
     
            } catch {
                completion([[:]], error)
                print("Error fetching contacts: \(error)")
            }
        }
        
            
        
    }
}


