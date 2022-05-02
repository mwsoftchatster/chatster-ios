//
//  E2EHelper.h
//  Chatster
//
//  Created by Nikolajus Karpovas on 06/04/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Curve25519.h"
#import "Ed25519.h"
#import <SignalCoreKit/Randomness.h>

NS_ASSUME_NONNULL_BEGIN

@interface E2EHelper : NSObject

@property (nonnull, nonatomic, strong) NSString *message;
@property (nonnull, nonatomic, strong) ECKeyPair *myKeyPair;
@property (nonnull, nonatomic, strong) ECKeyPair *theirKeyPair;

- (nonnull instancetype)init:(nonnull NSString *)message;
- (NSData*)generateSharedSecret:(NSData*)theirPublicKey andKeyPair:(ECKeyPair*)keyPair;
- (NSData*)generateSignature:(NSData*)encryptedMessage withKeyPair:(ECKeyPair*)senderKeyPair;
- (BOOL)verifySignature:(NSData*)signature publicKey:(NSData*)senderPublicKey data:(NSData*)message;

@end

NS_ASSUME_NONNULL_END
