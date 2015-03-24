//
//  Animal.h
//  iDote
//
//  Created by Eduardo Santi on 20/03/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "FXForms.h"

@interface Animal : NSObject <FXForm>

@property NSString *nome;
@property NSInteger idade;
@property NSString *tipo;
@property NSString *porte;
@property NSString *genero;
@property NSString *descricao;

@end
