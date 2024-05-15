//
//  UserInformationView.swift
//  RahalApp
//
//  Created by Juman Dhaher on 27/10/1445 AH.
//

import SwiftUI

struct UserInformationView: View {
    @State private var firstName = "جمان"
    @State private var lastName = "يوسف"
    @State private var email = "juman@hotmail.com"
    
    var body: some View {
        ZStack{
            Color(.background).ignoresSafeArea()
            VStack{
                HeaderView
                FirstNameView
                LastNameView
                EmailView
                
                NavigationLink(destination: RestPasswordView(), label: {
                    Text("تواصل معنا")
                        .foregroundColor(.blue).frame(width: 300, alignment: .trailing).padding(.top)
                })
                NavigationLink(destination: RestPasswordView(), label: {
                    Text("حذف الحساب")
                        .foregroundColor(.blue).frame(width: 300, alignment: .trailing).padding(.top)
                })
                
                
//                NavigationLink(destination: RestPasswordView(), label: {
//                    Text("اعادة تعيين كلمة المرور؟").foregroundColor(.blue).frame(width: 300, alignment: .trailing).padding(.top)
//                })
//
               
                Spacer()
//                ButtonWidget(text: "حفظ")
                
            }.padding(.top,30)
        }.navigationTitle("معلومات الحساب")
    }
}

#Preview {
    UserInformationView()
}

extension UserInformationView {
    private var HeaderView: some View{
        HStack{
            Text("جمان يوسف").fontWeight(.bold)
                .font(FontScheme.kSFArabicBold(size: 24.0))
                
                
            Image(systemName: "person.crop.circle")
                .resizable()
                .foregroundColor(ColorConstants.IconColor)
                .frame(width: 55.0, height: 55.0)
            
            
        }.frame(width: 340,height:100, alignment: .trailing)
            .padding(.trailing , 35)
    }
    
    private var FirstNameView: some View{
        VStack(alignment: .trailing){
            Text("الأسم الأول").foregroundColor( Color(.black900))
            TextField("", text: $firstName)
                .multilineTextAlignment(.trailing)
                    .padding()
                .frame(width: 300, height: 35)
            
            .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color("WhiteA700"))
                        .frame(width: 300, height: 35))
        }
    }
    
    private var LastNameView: some View{
        VStack(alignment: .trailing){
            Text("الأسم الأخير").foregroundColor( Color(.black900))
            
            TextField("", text: $lastName)
                .multilineTextAlignment(.trailing)
                    .padding()
            
                .frame(width: 300, height: 35)
            
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color("WhiteA700"))
                        .frame(width: 300, height: 35))
        }
    }
    
    private var EmailView: some View{
        VStack(alignment: .trailing){
            Text("البريد الالكتروني").foregroundColor( Color(.black900))
            
            TextField("", text: $email)                 .multilineTextAlignment(.trailing)
                .padding()
                .frame(width: 300, height: 35,alignment: .trailing)
            
                .background(Color("WhiteA700"))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color("WhiteA700"))
                        .frame(width: 300, height: 35))
        }
    }
    
}


