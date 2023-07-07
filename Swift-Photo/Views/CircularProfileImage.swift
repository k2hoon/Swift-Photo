//
//  CircularProfileImage.swift
//  Swift-Photo
//
//  Created by k2hoon on 2023/07/08.
//

import SwiftUI

struct CircularProfileImage: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    @ViewBuilder var imageView: some View {
        switch self.viewModel.imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding()
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
                .padding()
        }
    }
    
    var body: some View {
        self.imageView
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: 100, height: 100)
            .background {
                Circle().fill(
                    LinearGradient(colors: [.gray, .black], startPoint: .top, endPoint: .bottom)
                )
            }
    }
}

struct CircularProfileImage_Previews: PreviewProvider {
    static var previews: some View {
        CircularProfileImage(viewModel: ProfileViewModel())
    }
}
