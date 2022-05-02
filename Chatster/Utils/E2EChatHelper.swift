//
//  E2EChatHelper.swift
//  Chatster
//
//  Created by Nikolajus Karpovas on 06/04/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

import Foundation
import CommonCrypto
import CryptoSwift

class E2EChatHelper {
    
    init() {
        print("Initializer called")
    }
    
    func executeObjcFunc() {
        
        let e2eHelper = E2EHelper.init("Hello from an Objective C in Swift class")
        print(e2eHelper.message)
        
    }
    
    func appendHMACSignaturePBKTo(encryptedMessage: Array<UInt8>, hmac: Array<UInt8>, signature: Array<UInt8>, senderPublicKey: Array<UInt8>) -> Array<UInt8> {
        
        var result = Array<UInt8>()
        result.append(contentsOf: encryptedMessage)
        result.append(contentsOf: hmac)
        result.append(contentsOf: signature)
        result.append(contentsOf: senderPublicKey)
        
        return result
        
    }
    
    func getMessageFrom(msgHMACSignaturePublicKey: Array<UInt8>) -> Array<UInt8> {
        return Array(msgHMACSignaturePublicKey[0..<160])
    }
    
    func getHMACFrom(msgHMACSignaturePublicKey: Array<UInt8>) -> Array<UInt8> {
        
        let from = msgHMACSignaturePublicKey.count - 160
        let to = msgHMACSignaturePublicKey.count - 96
        return Array(msgHMACSignaturePublicKey[from..<to])
        
    }
    
    func getSignatureFrom(msgHMACSignaturePublicKey: Array<UInt8>) -> Array<UInt8> {
        
        let from = msgHMACSignaturePublicKey.count - 96
        let to = msgHMACSignaturePublicKey.count - 32
        return Array(msgHMACSignaturePublicKey[from..<to])
        
    }
    
    func getPublicKeyFrom(msgHMACSignaturePublicKey: Array<UInt8>) -> Array<UInt8> {
        
        let from = msgHMACSignaturePublicKey.count - 32
        let to = msgHMACSignaturePublicKey.count
        return Array(msgHMACSignaturePublicKey[from..<to])
        
    }
    
    func e2eTest() {
        
        let e2eHelper = E2EHelper.init("Hello from an Objective C in Swift class")
        
        let encryptSharedSecret = e2eHelper.generateSharedSecret(e2eHelper.theirKeyPair.publicKey(), andKeyPair: e2eHelper.myKeyPair)
        
        let iv: Array<UInt8> = AES.randomIV(AES.blockSize)
        
        let input: Array<UInt8> = Array(e2eHelper.message.utf8)
        
        do {
            // In combined mode, the authentication tag is directly appended to the encrypted message. This is usually what you want.
            let gcm = GCM(iv: iv, mode: .combined)
            let aes = try AES(key: encryptSharedSecret.bytes, blockMode: gcm, padding: .noPadding)
            let encrypted = try aes.encrypt(input)
            
            let hmacBeforeDecrypt = e2eHelper.message.hmacBytes(key: encryptSharedSecret.hexString)
            
            let signature = e2eHelper.generateSignature(Data(encrypted), with: e2eHelper.myKeyPair)
            
            let msgHMACSignaturePublicKey = appendHMACSignaturePBKTo(
                encryptedMessage: encrypted,
                hmac: hmacBeforeDecrypt.bytes,
                signature: signature.bytes,
                senderPublicKey: e2eHelper.myKeyPair.publicKey()!.bytes
            )
            
            let signatureFromMessageHMACSignaturePublicKey = getSignatureFrom(msgHMACSignaturePublicKey: msgHMACSignaturePublicKey)
            let publicKeyFromMessageHMACSignaturePublicKey = getPublicKeyFrom(msgHMACSignaturePublicKey: msgHMACSignaturePublicKey)
            let messageFromMessageHMACSignaturePublicKey = getMessageFrom(msgHMACSignaturePublicKey: msgHMACSignaturePublicKey)
            let hmacFromMessageHMACSignaturePublicKey = getHMACFrom(msgHMACSignaturePublicKey: msgHMACSignaturePublicKey)
            
            let signatureIsValid = e2eHelper.verifySignature(
                Data(signatureFromMessageHMACSignaturePublicKey),
                publicKey: Data(publicKeyFromMessageHMACSignaturePublicKey),
                data: Data(messageFromMessageHMACSignaturePublicKey)
            )
            
            if signatureIsValid {
                print("The signature is valid!")
            } else {
                print("The signature is invalid!")
            }
            
            let decryptSharedSecret = e2eHelper.generateSharedSecret(
                Data(publicKeyFromMessageHMACSignaturePublicKey),
                andKeyPair: e2eHelper.theirKeyPair
            )
            
            // In combined mode, the authentication tag is appended to the encrypted message. This is usually what you want.
            let gcm2 = GCM(iv: iv, mode: .combined)
            let aes2 = try AES(key: decryptSharedSecret.bytes, blockMode: gcm2, padding: .noPadding)
            let decrypted = try aes2.decrypt(encrypted)
            
            let hmacAfterDecrypt = e2eHelper.message.hmacBytes(key: decryptSharedSecret.hexString)
            
            let hmacIsValid = (Data(hmacFromMessageHMACSignaturePublicKey).hexString == hmacAfterDecrypt.hexString)
            
            if hmacIsValid {
                print("The HMAC is valid!")
            } else {
                print("The HMAC is invalid!")
            }
            
            let str = String(data: Data(decrypted), encoding: String.Encoding.utf8) as String?
            print("Decrypted: \(str ?? "did not work")")
        } catch {
            print(error)
        }

    }
    
}
