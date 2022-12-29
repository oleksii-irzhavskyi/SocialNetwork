//
//  View+Extension.swift
//  SocialNework
//
//  Created by Oleksii Irzhavskyi on 29.12.2022.
//

import SwiftUI

//View Extension For UI Building
extension View{
    //Closing All Active Keyboards
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    //Disabling with opacity
    func disableWithOpacity(_ condition: Bool)-> some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func hAlign(_ aligmnet: Alignment)->some View{
        self
            .frame(maxWidth: .infinity, alignment: aligmnet)
    }
    
    func vAlign(_ aligmnet: Alignment)->some View{
        self
            .frame(maxHeight: .infinity, alignment: aligmnet)
    }
    
    //Custom Border with padding
    func border(_ width: CGFloat,_ color: Color)->some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    //Custom Fill view with padding
    func fillView(_ color: Color)->some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
}
