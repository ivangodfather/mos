//
//  TitleView.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import SwiftUI

struct TitleView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .foregroundStyle(
                LinearGradient(
                    colors: [.mosRed,.mosCyan],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(text: "Meditations")
    }
}
