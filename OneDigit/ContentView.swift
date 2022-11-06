//
//  ContentView.swift
//  OneDigit
//
//  Created by Philip Fisker on 29/10/2022.
//

import SwiftUI
import Foundation
import Combine

struct ContentView: View {
    
    @State var date: Date = Date() {
        didSet {
            setTime(date: date)
            setProgress(date: date)
        }
    }
    
    @State var calendar = Calendar.current
    @State var formatIs12h = false;
    @State var clockProgress: Float = 0.0;
    @State var hourFormatted: Int = 0;
        
    func setTime(date: Date) -> Void {
        let hour: Int = calendar.component(.hour, from: date)
        if (formatIs12h) {
            hourFormatted = hour % 12 == 0 ? 12 : hour % 12
        } else {
            hourFormatted = hour
        }
    }
    
    func setProgress(date: Date) -> Void {
        let minutes: Int = calendar.component(.minute, from: date)
        clockProgress = Float(minutes)/60;
    }
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect().merge(with: Just(Date()))
    
    let fontOptions = UIFont.systemFont(ofSize: 256, weight: .bold)
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.init(red: 1.0, green: 1.0, blue: 1.0), Color.init(red: 0.9, green: 0.9, blue: 0.8)]),
        startPoint: .top, endPoint: .bottom)
            
    var body: some View {
        ZStack{
            backgroundGradient.ignoresSafeArea()
            Text("\(hourFormatted)")
                .foregroundColor(.gray)
                .font(Font(fontOptions))
                .frame(height: fontOptions.capHeight)
                .onReceive(timer) { time in
                    date = Date()
                }
            Text("\(hourFormatted)")
                .font(Font(fontOptions))
                .frame(height: fontOptions.capHeight+8)
                .onReceive(timer) { time in
                    date = Date()
                }
                .mask(alignment: .bottom){
                    Rectangle()
                        .frame(width: .infinity, height: (CGFloat(clockProgress)*1.05) * fontOptions.capHeight)
                }
                .onTapGesture {
                    if (formatIs12h) {
                        formatIs12h = false
                        date = Date()
                    } else {
                        formatIs12h = true
                        date = Date()

                    }
                }
        }
        .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
