//
//  E2EHelper.m
//  Chatster
//
//  Created by Nikolajus Karpovas on 06/04/2019.
//  Copyright © 2019 Nikolajus Karpovas. All rights reserved.
//

#import "E2EHelper.h"


@implementation E2EHelper

- (instancetype)init:(NSString *)message {
    
    if (self = [super init]) {
        _message = message;
        _myKeyPair = [Curve25519 generateKeyPair];
        _theirKeyPair = [Curve25519 generateKeyPair];
    }
    
    return self;
    
}

- (NSData *) generateSharedSecret:(NSData*)theirPublicKey andKeyPair:(ECKeyPair*)keyPair {
    return [Curve25519 generateSharedSecretFromPublicKey:theirPublicKey andKeyPair:keyPair];
}

- (NSData*)generateSignature:(NSData*)encryptedMessage withKeyPair:(ECKeyPair*)senderKeyPair {
    return [Ed25519 sign:encryptedMessage withKeyPair:senderKeyPair];
}

- (BOOL)verifySignature:(NSData*)signature publicKey:(NSData*)senderPublicKey data:(NSData*)message {
    return [Ed25519 verifySignature:signature publicKey:senderPublicKey data:message];
}

@end
