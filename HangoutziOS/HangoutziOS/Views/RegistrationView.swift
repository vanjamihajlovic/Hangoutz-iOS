//
//  RegistrationView.swift
//  HangoutziOS
//
//  Created by User01 on 11/15/24.
//

import SwiftUI


struct RegistrationView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var registrationViewModel = RegistrationViewModel()
    @State private var showAlert = false
    @State private var alertMessage = ""
    

    var body: some View {
        NavigationStack(){
            ZStack {
                VStack(spacing: 20){
                    GlobalLogoView()
                        .padding(.bottom,60)
                    VStack(alignment: .leading, spacing: 5) {
                        TextField("", text: $registrationViewModel.nameRegistration,
                                  prompt: Text("Name")
                            .foregroundColor(.white)
                        )
                        .accessibilityIdentifier("nameField")
                        .autocapitalization(.none)
                        .frame(width: 320, height: 25, alignment: .center)
                        .foregroundColor(.white)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(registrationViewModel.isNameValid ? Color.white : Color("ErrorColor"), lineWidth: 3)
                        )
                        
                        if !registrationViewModel.isNameValid && registrationViewModel.allFieldsFilled {
                            Text("Name must be between 3 and 25 characters.")
                                .foregroundColor(Color.white)
                                .font(.system(size: 17))
                                .padding(.leading, 5)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        TextField("", text: $registrationViewModel.emailRegistration, prompt: Text("Email")
                            .foregroundColor(.white)
                        )
                        .accessibilityIdentifier("emailField")
                        .autocapitalization(.none)
                        .frame(width: 320, height: 25, alignment: .center)
                        .foregroundColor(.white)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(registrationViewModel.isEmailValid ? Color.white : Color("ErrorColor"), lineWidth: 3)
                        )
                        if !registrationViewModel.isEmailValid && registrationViewModel.allFieldsFilled{
                            Text("Enter a valid email address.")
                                .foregroundColor(Color.white)
                                .font(.system(size: 17))
                                .padding(.leading, 5)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        SecureField("", text: $registrationViewModel.passwordRegistration,
                                    prompt: Text("Password")
                            .foregroundColor(.white)
                        )
                        .accessibilityIdentifier("passwordField")
                        .textContentType(.password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .frame(width: 320, height: 25, alignment: .center)
                        .foregroundColor(.white)
                        .padding()
                        .onChange(of: registrationViewModel.passwordRegistration) { newValue in
                                registrationViewModel.passwordRegistration = newValue.replacingOccurrences(of: " ", with: "")
                            }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(registrationViewModel.isPasswordValid ? Color.white : Color("ErrorColor"), lineWidth: 3)
                        )
                        
                        if !registrationViewModel.isPasswordValid && registrationViewModel.allFieldsFilled {
                            Text("At least 8 characters and digit")
                                .foregroundColor(Color.white)
                                .font(.system(size: 17))
                                .padding(.leading, 5)
                        }
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        SecureField("", text: $registrationViewModel.password2Registration, prompt: Text("Re-enter password")
                            .foregroundColor(.white)
                        )
                        .accessibilityIdentifier("confirmPasswordField")
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .frame(width: 320, height: 25, alignment: .center)
                        .foregroundColor(.white)
                        .padding()
                        .onChange(of: registrationViewModel.password2Registration) { newValue in
                               registrationViewModel.password2Registration = newValue.replacingOccurrences(of: " ", with: "")
                           }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(registrationViewModel.isPassword2Valid ? Color.white : Color("ErrorColor"), lineWidth: 3)
                        )
                        
                        if !registrationViewModel.isPassword2Valid && registrationViewModel.allFieldsFilled{
                            Text("Passwords do not match.")
                                .foregroundColor(Color.white)
                                .font(.system(size: 17))
                                .padding(.leading, 5)
                        }
                    }
                    if registrationViewModel.showGlobalError {
                        Text(registrationViewModel.globalErrorMessage)
                            .foregroundColor(.white)
                            .font(.system(size: 17))
                    }
                    
                    Button(action: {
                        registrationViewModel.nameRegistration = registrationViewModel.nameRegistration.trimmingCharacters(in: .whitespaces)
                                registrationViewModel.emailRegistration = registrationViewModel.emailRegistration.trimmingCharacters(in: .whitespaces)

                        if registrationViewModel.validateFields(){
                            Task{
                                let result = await registrationViewModel.registerUser()
                                if result == 409 {
                                    alertMessage = "Email already in use."
                                    showAlert.toggle()
                                } else {
                                    dismiss()
                                }
                            }
                        }
                    }
                    ){
                        Text("Create Account")
                            .padding()
                            .foregroundColor(Color("ButtonFontColor"))
                            .frame(width:310)
                            .background(Color("LoginButton"))
                            .cornerRadius(20)
                            .bold()
                    }
                    .accessibilityIdentifier("createAccountButton")
                    .padding(.top, 40)
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Error"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .applyGlobalBackground()
        }
    }
}


#Preview {
    RegistrationView()
}
