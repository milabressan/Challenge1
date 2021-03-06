//
//  RegisterInstitutionViewController.m
//  iDote
//
//  Created by Tainara Specht on 3/23/15.
//  Copyright (c) 2015 Bepid. All rights reserved.
//

#import "RegisterInstitutionViewController.h"
#import "UIImage+Resize.h"


@interface RegisterInstitutionViewController() <MFMailComposeViewControllerDelegate>

@end
@implementation RegisterInstitutionViewController{
    
    Institution *institution;
    CGFloat _initialConstant;

}

static CGFloat _keyboardHeightOffset = 15.0f;


- (void)viewDidLoad{
    [super viewDidLoad];
    //telephone with area code
    self.maskInstitutionPhone.mask = @"(##) ####-#####";

}

//method for replacing the telephone field with mask;
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([textField isEqual: _txtFieldInstitutionPhone]){
        return [_maskInstitutionPhone shouldChangeCharactersInRange: range replacementString:string];}
    return YES;
}

//pick an image for registering
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [UIImage cropImageWithInfo:info];
   
    [_addInstPic setBackgroundImage:image forState:UIControlStateNormal];
    [_addInstPic setTitle:@"" forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)setFirstImage:(id)sender {
    _addInstPic = sender;
    UIImagePickerController *imagePickerControllerMain = [[UIImagePickerController alloc] init];
    imagePickerControllerMain.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerControllerMain.delegate = self;
    imagePickerControllerMain.allowsEditing = YES;
    
    [self presentViewController:imagePickerControllerMain animated:NO completion:nil];
}


- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if ([emailTest evaluateWithObject:candidate] == YES)
        return YES;
    else
    {
        UIAlertView *alertIncorrectEmail = [[UIAlertView alloc] initWithTitle:@"Email incorreto" message:@"Por favor, insira um e-mail válido." delegate: self cancelButtonTitle:@"OK"otherButtonTitles: nil];
        [alertIncorrectEmail show];
        return NO;
    }
}

- (BOOL) institutionPhotoDoesExist
{
    if ([_addInstPic backgroundImageForState:UIControlStateNormal] == nil)
        return NO;
    else
        return YES;
}

-(BOOL) emptyTextFieldExistent
{
    if ([_txtFieldInstitutionName.text length] == 0 ||
        [_txtFieldInstitutionPhone.text length] == 0 ||
        [_txtFieldInstitutionEmail.text length] == 0 ||
        [_txtFieldInstitutionResponsible.text length] == 0 ||
        //[_txtFieldInstitutionAddress.text length] == 0 || not being used because this field is not mandatory right now
        [_txtViewInstitutionDescription.text length] == 0 ||
        ![self institutionPhotoDoesExist ]){
        UIAlertView *alertEmptyFields = [[UIAlertView alloc] initWithTitle:@"Campos incompletos" message:@"Por favor, preencha todos os campos e/ou a imagem." delegate: self cancelButtonTitle:@"OK"otherButtonTitles: nil];
        [alertEmptyFields show];
        return YES;
    }
    return NO;
}

- (IBAction)emailButtonPushed:(id)sender {

    
    if ([self emptyTextFieldExistent] == NO  &&
        [self validateEmail: _txtFieldInstitutionEmail.text] == YES){
        
        
        [self cadastrarInst];
        [institution save];
    
    NSString *email = [NSString stringWithFormat:@"Nome: %@\nTelefone: %@\nEmail: %@\nResponsável: %@\nEndereço: %@\nDescrição: %@", _txtFieldInstitutionName.text, _txtFieldInstitutionPhone.text, _txtFieldInstitutionEmail.text,_txtFieldInstitutionResponsible.text, _txtFieldInstitutionAddress.text, _txtViewInstitutionDescription.text];

    NSLog(@"%@", email);
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            [mailCont setSubject:@"Cadastro de Instituições"];
            [mailCont setToRecipients:[NSArray arrayWithObject:@"idoteteam@gmail.com"]];
            [mailCont setMessageBody:[NSString stringWithFormat:@"Verifique seu cadastro antes de enviar!\n\n %@ \n\nPor favor, aguarde até 48h úteis para receber um retorno da nossa equipe.\niDote Team agradece o seu interesse!", email]  isHTML:NO];
            [self presentViewController:mailCont animated:YES completion:nil];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if([textField isEqual: _txtFieldInstitutionName])
        [_txtFieldInstitutionResponsible becomeFirstResponder];
    else if([textField isEqual: _txtFieldInstitutionResponsible])
        [_txtFieldInstitutionPhone becomeFirstResponder];
    else if([textField isEqual: _txtFieldInstitutionPhone])
        [_txtFieldInstitutionEmail becomeFirstResponder];
    else if([textField isEqual: _txtFieldInstitutionEmail])
        [_txtFieldInstitutionAddress becomeFirstResponder];
    else if([textField isEqual: _txtFieldInstitutionAddress])
        [_txtViewInstitutionDescription becomeFirstResponder];
    else if ([textField isEqual: _txtViewInstitutionDescription])
        [self cadastrarInst];
        return YES;
}


- (void) cadastrarInst {
    
    institution = [[Institution alloc] init];
    
    institution.institutionName = _txtFieldInstitutionName.text;
    institution.institutionPhone = _txtFieldInstitutionPhone.text;
    institution.institutionEmail = [_txtFieldInstitutionEmail.text lowercaseString];
    institution.institutionResponsible = _txtFieldInstitutionResponsible.text;
    institution.institutionAddress = _txtFieldInstitutionAddress.text;
    institution.institutionDescription = _txtViewInstitutionDescription.text;
    institution.mainImage = [_addInstPic backgroundImageForState:UIControlStateNormal];
    
}


- (IBAction)clickOnBackground:(id)sender {
    [self.view endEditing:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    //handle any error
    [controller dismissViewControllerAnimated:YES completion:nil];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
