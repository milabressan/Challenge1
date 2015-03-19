//
//  User.m
//  iDote
//
//  Created by Eduardo Santi on 19/03/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "User.h"

@implementation User

- (void) cadastrar {
  _object = [[PFUser alloc] init];
  _object.username = _email;
  _object.password = _senha;
  [_object signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    if (succeeded) {
    
    } else {
      //TODO: erro cadastro
    }
  }];
}

- (void) login {
  [PFUser logInWithUsernameInBackground:_email password:_senha
          block:^(PFUser *user, NSError *error) {
            if (!error) {
              _object = user;
            } else {
              //TODO: Tratar erro
            }
  }];

}

@end
