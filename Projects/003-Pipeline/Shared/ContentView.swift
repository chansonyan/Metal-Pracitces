//
//  ContentView.swift
//  Shared
//
//  Created by Cyan on 2022/8/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        Text("Hello, world!")
//            .padding()
        VStack {
            MetalView()
                .border(Color.black, width: 2)
            Text("Hello, Metal!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
