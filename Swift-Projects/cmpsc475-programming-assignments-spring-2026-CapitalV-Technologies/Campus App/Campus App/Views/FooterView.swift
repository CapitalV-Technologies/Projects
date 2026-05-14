//
//  FooterView.swift
//  Campus App
//
//  Created by LiasPub on 3/8/26.
//

import SwiftUI

struct FooterView: View {
    @Environment(CampusAppViewModel.self) var manager: CampusAppViewModel
    var body: some View {
        @Bindable var manager = manager
        let width: CGFloat = .infinity
        let height: CGFloat = 50
        Picker("MapStyle", selection: $manager.mapInfo.mapStyle) {
            ForEach(MapStyles.allCases) { style in
                Text(style.rawValue)
                    .tag(style)
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .font(.title)
        .frame(maxWidth: width)
        .frame(height: height)
    }
}
    
#Preview {
    FooterView()
        .environment(CampusAppViewModel())
}
