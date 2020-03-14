//
//  ContentView.swift
//  Bullseye
//
//  Created by Peter Chen on 3/13/20.
//  Copyright © 2020 Peter Chen. All rights reserved.
//

import SwiftUI

func generateRandNumber() -> Int {
    return Int.random(in: 1...100)
}

struct styleGeneral: ViewModifier {
    let color: Color
    let fontSize: CGFloat

    func body(content: Content) -> some View {
        return content
        .foregroundColor(color)
        .font(Font.custom("ArialRoundedMTBold", size: fontSize))
        .shadow(color: Color.black, radius: 5, x: 2, y: 2)
    }
}

struct styleLabel: ViewModifier {
    func body(content: Content) -> some View {
        return content
        .modifier(styleGeneral(color: Color.white, fontSize: 18))
    }
}

struct styleValue: ViewModifier {
    func body(content: Content) -> some View {
        return content
        .modifier(styleGeneral(color: Color.yellow, fontSize: 24))
    }
}

struct styleButtonText: ViewModifier {
    let color: Color
    let fontSize: CGFloat

    func body(content: Content) -> some View {
        return content
        .foregroundColor(color)
        .font(Font.custom("ArialRoundedMTBold", size: fontSize))
    }
}

struct styleButtonLargeText: ViewModifier {
    func body(content: Content) -> some View {
        return content
        .modifier(styleButtonText(color: Color.black, fontSize: 18))
    }
}

struct styleButtonSmallText: ViewModifier {
    func body(content: Content) -> some View {
        return content
        .modifier(styleButtonText(color: Color.black, fontSize: 12))
    }
}

struct styleButton: ViewModifier {
    func body(content: Content) -> some View {
        return content
        .background(Image("Button"))
        .shadow(color: Color.black, radius: 5, x: 2, y: 2)
    }
}

let midNightBlue = Color(red: 0.0/255.0, green: 51.0/255.0, blue: 102.0 / 255.0)

struct ContentView: View {
    @State var alertIsVisible = false
    @State var target = generateRandNumber()
    @State var score = 0
    @State var round = 1
    @State var sliderValue = 50.0
    
    func roundedSliderValue() -> Int {
        return Int(sliderValue.rounded())
    }
    
    func differenceOff() -> Int {
        return abs(roundedSliderValue() - target)
    }
    
    func pointsForCurrentRound() -> Int {
        switch differenceOff() {
        case 0:
            return 200
        case 1:
            return 149
        default:
            return 100 - differenceOff()
        }
    }
    
    func generateTitle() -> String {
        switch differenceOff() {
        case 0:
            return "Perfect!"
        case 1..<5:
            return "You almost had it!"
        case 5..<11:
            return "Not Bad."
        default:
            return "Are you even trying?"
        }
    }
    
    func reset() -> Void {
        target = generateRandNumber()
        score = 0
        round = 1
        sliderValue = 50.0
    }
    
    var body: some View {
        VStack {
            // Target Row
            HStack {
                Text("Put the bullseye as close as you can to").modifier(styleLabel())
                Text("\(target)").modifier(styleValue())
            }
            
            Spacer()
            
            // Slider Row
            HStack {
                Text("1").modifier(styleLabel())
                Slider(value: $sliderValue, in: 1...100)
                .accentColor(Color.green)
                Text("100").modifier(styleLabel())
            }
            
            // Button Row
            Button(action: {
                self.alertIsVisible = true
            }) {
                Text("Hit Me!").modifier(styleButtonLargeText())
            }
            .alert(isPresented: $alertIsVisible) { () -> Alert in
                return Alert(
                    title: Text(generateTitle()),
                    message: Text("The slider's value is \(roundedSliderValue()). \n You scored \(pointsForCurrentRound()) points this round"),
                    dismissButton: .default(Text("Awesome!")){
                        self.score += self.pointsForCurrentRound()
                        self.round += 1
                        self.target = generateRandNumber()
                    })
            }
            .modifier(styleButton())
            
            Spacer()
            
            // Score Row
            HStack() {
                Button(action: {
                    self.reset()
                }) {
                    HStack {
                        Image("StartOverIcon")
                        Text("Start Over")
                        .modifier(styleButtonSmallText())
                    }
                }
                .modifier(styleButton())
                Spacer()
                Text("Score:").modifier(styleLabel())
                Text("\(score)").modifier(styleValue())
                Spacer()
                Text("Round:").modifier(styleLabel())
                Text("\(round)").modifier(styleValue())
                Spacer()
                NavigationLink(destination: AboutView()) {
                    HStack {
                        Image("InfoIcon")
                        Text("Info")
                        .modifier(styleButtonSmallText())
                    }
                }
                .modifier(styleButton())
            }.padding(.bottom, 20)
        }
        .background(Image("Background"), alignment: .center)
        .accentColor(midNightBlue)
        .navigationBarTitle("BullsEye")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
