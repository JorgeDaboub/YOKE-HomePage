//
//  ContentView.swift
//  YOKE HomeScreen
//
//  Created by Jorge Daboub on 7/29/20.
//  Copyright © 2020 Jorge Daboub. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    // Main Home View
    @State var indx: Int = 0
    
    var body: some View {
        
        VStack(spacing: 0) {
            // Header bar
            appBar()
            Spacer()
            // Check Index Select Correct Screen
            containedView()
            Spacer()
            // Footer bar, with nav
            appFooter(index: self.$indx)
            
        }.edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    func containedView() -> AnyView {
        switch indx {
        case 1:
            return AnyView(discover())
        case 2:
            return AnyView(challenges())
        case 3:
            return AnyView(profile())
        default:
            return AnyView(appBody())
        }
    }
}

struct discover: View{
    var body: some View{
        Text("Discover")
    }
}

struct challenges: View{
    var body: some View{
        Text("Challenges")
    }
}

struct profile: View{
    var body: some View{
        Text("Profile")
    }
}

struct starView : View {
    // Display a Stars Card
    var star: Star
    @State var showingDetail = false
    
    var body: some View{
        Button(action: {
            self.showingDetail.toggle()
        }) {
            ZStack{
                
                Image("defaultPerson")
                    .resizable()
                    .frame(width: 189, height: 409)
                    .cornerRadius(15)
                
                VStack{
                    Text(self.star.name)
                        .foregroundColor(.white)
                        .frame(alignment: .topLeading)
                    
                    Spacer()
                    
                    Text("Follow..")
                        .foregroundColor(.white)
                        .frame(alignment: .topLeading)
                }
            }
        }.sheet(isPresented: $showingDetail) {
            ZStack{
                
                Image("defaultPerson")
                    .resizable()
                    .frame(width: 340, height: 735)
                    .cornerRadius(15)
                
                VStack{
                    HStack {
                        Button(action : {
                            self.showingDetail = false
                        }) {
                            Image(systemName: "xmark")
                        }
                        .frame(alignment: .topLeading)
                        
                        Text(self.star.name)
                            .foregroundColor(.black)
                            .frame(alignment: .center)
                    }
                    
                    Spacer()
                    
                    Button( action: {
                        // Follow Function?
                    }) {
                        Text("Follow Button")
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct appBody: View {
    @ObservedObject var stars = homeData()
    
    var body: some View{
        ScrollView {
            VStack{
                Text("Live Now")
                    .font(.system(size: 25, weight: .heavy, design: .serif))
                    .frame(alignment: .leading)
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(stars.data.onlineStars ?? [Star()], id: \.name) { star in
                            starView(star: star)
                        }
                    }
                }
                Spacer()
                
                Text("Featured")
                    .font(.system(size: 25, weight: .heavy, design: .serif))
                    .frame(alignment: .leading)
                ScrollView(.horizontal){
                    HStack{
                        ForEach(stars.data.stars, id: \.name) { star in
                            starView(star: star)
                        }
                    }
                }
            }
        }
    }
}


struct appFooter: View {
    @Binding var index: Int
    
    var body: some View{
        VStack(spacing:5){
            Text("")
            HStack{
                
                Button( action: {
                    self.index = 0
                }) {
                    VStack{
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width:25, height: 25)
                            .foregroundColor(self.index == 0 ? .blue : .gray)
                        
                        Text("Home")
                            .font(.system(size: 12))
                            .foregroundColor(self.index == 0 ? .blue : .gray)
                    }
                }
                
                Spacer()
                
                Button( action: {
                    self.index = 1
                }) {
                    VStack{
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width:25, height: 25)
                            .foregroundColor(self.index == 1 ? .blue : .gray)
                        
                        Text("Discover")
                            .font(.system(size: 12))
                            .foregroundColor(self.index == 1 ? .blue : .gray)
                    }
                }
                
                Spacer()
                Button( action: {
                    self.index = 2
                }) {
                    VStack{
                        Image(systemName: "bolt")
                            .resizable()
                            .frame(width:15, height: 25)
                            .foregroundColor(self.index == 2 ? .blue : .gray)
                        
                        Text("Challenges")
                            .font(.system(size: 12))
                            .foregroundColor(self.index == 2 ? .blue : .gray)
                    }
                }
                
                Spacer()
                Button( action: {
                    self.index = 3
                }) {
                    VStack{
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width:25, height: 25)
                            .foregroundColor(self.index == 3 ? .blue : .gray)
                        
                        Text("Profile")
                            .font(.system(size: 12))
                            .foregroundColor(self.index == 3 ? .blue : .gray)
                    }
                }
                
            }
        }.padding(.horizontal)
            .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 10)
            
            .background(Color("YokeBlue"))
    }
}

struct appBar: View {
    
    var body: some View {
        
        VStack(spacing:25){
            HStack{
                Image("Logo")
                    .resizable()
                    .frame(width: 110, height: 40)
                
                Spacer(minLength: 0)
                
                Image(systemName: "bitcoinsign.circle")
                    .resizable()
                    .frame(width:18, height: 18)
                    .foregroundColor(.white)
                
                Text("0")
                    .foregroundColor(.white)
                
                Button( action: {
                    // Pull Up Buy Coins
                    // Screen...
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width:18, height: 18)
                        .foregroundColor(.green)
                }
                
            }
        }.padding(.horizontal)
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 10)
            .background(Color("YokeBlue"))
    }
    
}
