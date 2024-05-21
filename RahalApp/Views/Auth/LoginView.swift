import SwiftUI
import AuthenticationServices
import CloudKit

struct LoginView: View {
    @ObservedObject var loginViewModel = LoginViewModel()
    var User: UserInfo?
    @State private var navigateToSelectDestinationView = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("img_untitled_artwork").resizable().brightness(-0.4).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .center) {
                        emailView(email: $loginViewModel.email)
                        passwordView(password: $loginViewModel.password)

                        Spacer(minLength: 30)
                        Button(action: {
                            navigateToSelectDestinationView = true
                            loginViewModel.fetchUserByEmailAndPassword(email: loginViewModel.email, password: loginViewModel.password) { userInfo in
                                if let userInfo = userInfo {
                                    // User was found and returned
                                    print("User logged in: \(userInfo.firstName) \(userInfo.lastName)")
                                    loginViewModel.showingAccountView = true
                                } else {
                                    // No user found or an error occurred
                                    print("Invalid credentials or user not found")
                                }
                            }
                        }, label: {
                            ButtonWidget(text: "تسجيل الدخول")
                        })
                        Spacer(minLength: 20)
                        NavigationLink(destination: UserSignUp()) {
                            HStack {
                                Text("سجل معنا").underline(color: Color("tivany"))
                                    .foregroundColor(Color("tivany"))
                                Text("ليس لديك حساب؟").foregroundColor(Color("WhiteA7001")).fontWeight(.heavy)
                            }
                        }
                        
                        
                        HStack{
                            line
                            Text("أو").foregroundColor(.whiteA7001)
                            line
                        }.frame(width: 300)
                        
                        
                        
                        
                        
                        SignInWithAppleButton(
                            
                            .signUp,
                            onRequest: configureAppleSignInRequest,
                            onCompletion: handleAppleSignInResult
                        )
                        .signInWithAppleButtonStyle(.white) // Set the button style to white
                        .frame(width: 300, height: 40)
                        .padding()
                        .environment(\.locale, .init(identifier: "ar"))
                        
                        
                    }                .navigationDestination(isPresented: $navigateToSelectDestinationView) {
                        UserInformationView()
                    }
                }.safeAreaPadding(.top, 180)
            }
            .ignoresSafeArea()
        }
    }

    var line: some View {
        VStack { Divider().background(.whiteA7001) }.padding(10)
    }
    
    private func configureAppleSignInRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    private func handleAppleSignInResult(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            guard let _ = authResults.credential as? ASAuthorizationAppleIDCredential else {
                return
            }

            navigateToSelectDestinationView = true
        case .failure(let error):
            print("Authentication error: \(error.localizedDescription)")
        }
    }
    
    
    private func emailView(email: Binding<String>) -> some View {
        VStack(alignment: .trailing) {
            Text("البريد الالكتروني").foregroundColor(Color("WhiteA7001")).fontWeight(.heavy)
            TextField("", text: email)
                .multilineTextAlignment(.trailing)
                .padding()
                .frame(width: 300, height: 35)
                .foregroundColor(Color.black)
                .background(Color("WhiteA7001"))
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("WhiteA7001")).frame(width: 300, height: 35))
        }
    }

    private func passwordView(password: Binding<String>) -> some View {
        VStack(alignment: .trailing) {
            Text("كلمة المرور").foregroundColor(Color("WhiteA7001")).fontWeight(.heavy)
            SecureField("", text: password)
                .foregroundColor(Color.black)
                .multilineTextAlignment(.trailing)
                .padding()
                .frame(width: 300, height: 35)
                .background(Color("WhiteA7001"))
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color("WhiteA7001")).frame(width: 300, height: 35))
        }
    }
}

 class LoginViewModel: ObservableObject {
    @Published var showingAccountView = false
    @Published var isSigninigIn = false

    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    
    func configureAppleSignInRequest(request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleAppleSignInResult(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential else {
                return
            }
            firstName = appleIDCredential.fullName?.givenName ?? ""
            lastName = appleIDCredential.fullName?.familyName ?? ""
            email = appleIDCredential.email ?? ""
            showingAccountView = true
            isSigninigIn = true
        case .failure(let error):
            print("Authentication error: \(error.localizedDescription)")
        }
    }
    
     func fetchUserByEmailAndPassword(email: String, password: String, completion: @escaping (UserInfo?) -> Void) {
         let encryptedPassword = encryptPassword(password)
         let predicate = NSPredicate(format: "Email == %@ AND encryptedPass == %@", email, encryptedPassword)
         let query = CKQuery(recordType: "UserRecords", predicate: predicate)

         CKContainer(identifier: "iCloud.com.macrochallange.test.TripManagement").publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
             DispatchQueue.main.async {
                 if let error = error {
                     print("Failed to fetch user: \(error)")
                     completion(nil)  // Corrected to return nil on error
                 } else if let record = records?.first {
                     // Construct UserInfo from the record if found
                     let userInfo = UserInfo(
                         idUser: record.recordID.recordName,
                         firstName: record["firstName"] as? String ?? "",
                         lastName: record["lastName"] as? String ?? "",
                         Email: record["Email"] as? String ?? "",
                         confirmEmail: record["confirmEmail"] as? String ?? "",
                         encryptedPass: record["encryptedPass"] as? String ?? "",
                         confirmPassword: record["confirmPassword"] as? String ?? "",
                         comingTrips: record["comingTrips"] as? String ?? "",
                         onTrip: record["onTrip"] as? Bool ?? false,
                         record: record
                     )
                     completion(userInfo)  // Return the found UserInfo
                 } else {
                     print("No user found or wrong password.")
                     completion(nil)  // Corrected to return nil if no user is found
                 }
             }
         }
     }

    private func encryptPassword(_ password: String) -> String {
        let data = password.data(using: .utf8)!
        return data.base64EncodedString()
    }
    
    
    struct ButtonWidget: View {
        var text: String
        
        var body: some View {
            Text(text)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
