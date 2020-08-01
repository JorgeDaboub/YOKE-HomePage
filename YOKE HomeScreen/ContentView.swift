//
//  ContentView.swift
//  YOKE HomeScreen
//
//  Created by Jorge Daboub on 7/29/20.
//  Copyright © 2020 Jorge Daboub. All rights reserved.
//

import SwiftUI
import CoreHaptics


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
            
            // Check Index Select Correct Screen
            containedView()
            
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
        ScrollView{
            Text("Discover")
        }
    }
}

struct challenges: View{
    var body: some View{
        ScrollView{
            Text("Challenges")
        }
    }
}

struct profile: View{
    var body: some View{
        ScrollView{
            Text("Profile")
        }
    }
}

struct starView : View {
    // Display a Stars Card
    @State var star: Star
    @State var showingDetail = false
    var buttonSize = CGFloat(20)
    @State private var engine: CHHapticEngine?
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func oneTapHap() {
        /* Funct From: https:www.hackingwithswift.com/books/ios-swiftui/making-vibrations-with-uinotificationfeedbackgenerator-and-core-haptics
        */
        
        // Make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // Create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)

        // Convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
    
    var body: some View{
        Button(action: {
            self.showingDetail.toggle()
            self.oneTapHap()
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
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.yellow)
                            .frame(width: 140, height: 40)
                        
                        Text( self.star.isFollowing ?? false ? "Following" : "Follow" )
                            .foregroundColor(.white)
                            .frame(alignment: .topLeading)
                    }.padding(10)
                }.padding(5)
            }
        }.onAppear(perform: prepareHaptics)
        .sheet(isPresented: $showingDetail) {
            ZStack(){
                Image("defaultPerson")
                    .resizable()
                    .edgesIgnoringSafeArea(.bottom)
                
                VStack{
                    HStack() {
                        Button(action : {
                            self.showingDetail = false
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: self.buttonSize, height: self.buttonSize, alignment: .leading)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        
                        Text(self.star.name)
                            .foregroundColor(.white)
                            .frame(alignment: .center)
                            .padding(.leading, -self.buttonSize)
                        
                        Spacer()
                        
                        Button(action : {
                            self.star.isFollowing = !(self.star.isFollowing ?? false)
                        }) {
                            Image(systemName: self.star.isFollowing ?? false ? "star.fill" : "star")
                                .resizable()
                                .frame(width: self.buttonSize, height: self.buttonSize, alignment: .leading)
                                .foregroundColor(.white)
                        }
                    }.padding(20)
                    
                    Spacer()
                    
                    Button( action: {
                        self.star.isFollowing = !(self.star.isFollowing ?? false)
                    }) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color.yellow)
                                .frame(width: 140, height: 40)
                            
                            Text(self.star.isFollowing ?? false ? "Following" : "Follow" )
                                .foregroundColor(.white)
                                .frame(alignment: .topLeading)
                        }.padding(10)
                    }
                }.padding(5)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct appBody: View {
    @ObservedObject var stars = homeData()
    
    
    var body: some View{
        ScrollView {
            VStack(alignment: .leading){
                Text("Live Now")
                    .font(.system(size: 25, weight: .heavy, design: .serif))
                
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
                ScrollView(.horizontal){
                    HStack{
                        ForEach(stars.data.stars, id: \.name) { star in
                            starView(star: star)
                        }
                    }
                }
            }
            .padding(10)
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
        VStack(spacing:20){
            HStack{
                Image("Logo")
                    .resizable()
                    .frame(width: 126, height: 37)
                
                Spacer(minLength: 0)
                
                Image("coin")
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
