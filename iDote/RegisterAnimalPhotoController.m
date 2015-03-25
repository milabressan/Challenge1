//
//  RegisterAnimalPhotoController.m
//  iDote
//
//  Created by Jonathan Andrade on 23/03/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "RegisterAnimalPhotoController.h"

@interface RegisterAnimalPhotoController ()

@property UIButton *imageHolder;

@end

@implementation RegisterAnimalPhotoController{
    UINavigationController *_navController;
    Animal *_animal;
}

- (IBAction)backFromRegisterAnimal:(UIStoryboardSegue *)segue {
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [_imageHolder setBackgroundImage:image forState:UIControlStateNormal];
    [_imageHolder setTitle:@"" forState:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)setFirstImage:(UIButton *)sender {
    _imageHolder = sender;
    UIImagePickerController *imagePickerControllerMain = [[UIImagePickerController alloc] init];
    imagePickerControllerMain.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerControllerMain.delegate = self;
    [self presentViewController:imagePickerControllerMain animated:NO completion:nil];
}

- (IBAction)clickButtonNext:(id)sender {
    
    FXFormViewController *controller = [[FXFormViewController alloc] init];
    controller.formController.form = [[Animal alloc] init];
    
    _navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Voltar" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    controller.navigationItem.title = @"Dados do Animal";
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Salvar" style:UIBarButtonItemStyleDone target:self action:@selector(save:)];
    
    [self presentViewController:_navController animated:YES completion:nil];
}

- (void)dismiss:(id)sender {
    [_navController dismissViewControllerAnimated:YES completion:^{
    }];
}

-(BOOL) emptyTextFieldExistent
{
    if ( _animal.nome == nil ||
        _animal.descricao == nil ||
        _animal.tipo == nil ||
        _animal.genero == nil ||
        _animal.porte == nil
        )
    {
        UIAlertView *alertEmptyFields = [[UIAlertView alloc] initWithTitle:@"Campos incompletos" message:@"Por favor, preencha todos os campos." delegate: self cancelButtonTitle:@"OK"otherButtonTitles: nil];
        [alertEmptyFields show];
        return YES;
    }
    else
        return NO;
}

- (void)save:(id)sender {
    FXFormViewController *formQueVoltou = (FXFormViewController*)_navController.topViewController;
    _animal = formQueVoltou.formController.form;
    
    if ([self emptyTextFieldExistent] == NO){
        [_navController dismissViewControllerAnimated:YES completion:^{
            [_animal save];
        }];
        [self performSegueWithIdentifier:@"segueReturnFromRegisterAnimal" sender:sender];
    }
    
    
}

@end
