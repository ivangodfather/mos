//
//  MeditationListRowView.swift
//  MomentsOfSpace
//
//  Created by Ivan on 2/9/23.
//

import SwiftUI

private enum Layout {
    static let cornerRadius = CGFloat(16)
}

struct MeditationListRowView: View {
    let mediation: Meditation
    
    var body: some View {
        HStack(spacing: .zero) {
            HStack {
                VStack(alignment: .leading, spacing: .Padding.medium) {
                    Text(mediation.title)
                    Text(mediation.subtitle)
                        .foregroundColor(.gray3)
                }
                .padding(.Padding.big)
                Spacer()
            }
            .background(Color.gray1)

            Text("\(mediation.durationInMinutes) min")
                .padding(.Padding.big)
                .background {
                    Image("wave")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                }
        }
        .font(.title3)
        .foregroundColor(.gray4)
        .cornerRadius(Layout.cornerRadius)
    }
}

struct MeditationListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationListRowView(mediation: .mock)
            .previewLayout(.sizeThatFits)
    }
}
