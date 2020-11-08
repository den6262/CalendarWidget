
import SwiftUI
import Combine

struct MainView: View {
    
    @ObservedObject var manager: WidgetManager
    @State private var gradientInfo: Bool = false
    @State private var showImgPicker: Bool = false
    
    init(manager: WidgetManager) {
        self.manager = manager
        UINavigationBar.appearance().backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
//                        Text("Widget Plus")
//                            .font(.largeTitle)
//                            .bold()
                        Text("Build your own calendar style of widget")
                            .font(.system(size: 20))
                            .bold()
                            //.opacity(0.5)
                            .foregroundColor(Color.init(#colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)))
                    }
                    Spacer()
                }.padding(20)
                
                WidgetMainView(entry: CalendarEntry(date: Date()), manager: manager)
                    .frame(height: 160).cornerRadius(20)
                    .padding(.leading, 20).padding(.trailing, 20)
                    .padding(.bottom, 30)
                    .shadow(radius: 13)
                
                ScrollView {
                    Spacer(minLength: 25)
                    TextAlignmentView
                    TextColor
                    TextFont
                    BackgroundImg
                    BackgroundGradient
                    NavigationLink(destination: CustomViewControllerRepresentation(), label: {
                        Text("Draw Image for Background")
                            //.foregroundColor(.red)
                            .font(.system(size: 19.5))
                            .bold()
                            .padding()
                    })
                    .accentColor(Color.init(#colorLiteral(red: 1, green: 0.1494086981, blue: 0.002408611588, alpha: 1)))
                    .background(Color.init(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    .cornerRadius(10)
                    .shadow(radius: 7.7)
                    .padding(.bottom, 15)
                }
                .background(Color.init(#colorLiteral(red: 1, green: 0.6431372549, blue: 0, alpha: 0.88)))
                Spacer()
            }
            .background(Color.init(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
            .navigationBarTitle("Widget Plus")
            .onAppear {
                if let imgData = UserDefaults.standard.data(forKey: "draw") {
                    let img = UIImage(data: imgData)
                    
                    manager.backgroundImage = img
                    manager.updateBackgroundImage(img)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .alert(isPresented: $gradientInfo, content: {
                Alert(title: Text("How To Use"), message: Text("Double-Tap a color to confirm your selection, then proceed with the next color"), dismissButton: .cancel(Text("OK")))
            })
            .sheet(isPresented: $showImgPicker, content: {
                UnsplashImagePicker(selectedImage: { image in
                    UserDefaults.standard.removeObject(forKey: "draw")
                    UserDefaults.standard.synchronize()
                    manager.updateBackgroundImage(image)
                })
            })
        }
    }
    
    /// Change text alignment
    private var TextAlignmentView: some View {
        VStack {
            setupSection(title: "Text Alignment")
            Picker(selection: $manager.widgetTextAlignmentIndex, label: Text("Status")) {
                ForEach(0..<3, id: \.self, content: { index in
                    Text(index == 0 ? "Left" : index == 1 ? "Center" : "Right")
                })
            }
            .onChange(of: manager.widgetTextAlignmentIndex) { index in
                manager.updateTextAlignment(index: index)
            }
            .pickerStyle(SegmentedPickerStyle())
        }.padding(.leading, 20).padding(.trailing, 20)
    }
    
    /// Change text color
    private var TextColor: some View {
        colorSelector(title: "Text Color")
    }
    
    /// Change text font
    private var TextFont: some View {
        VStack {
            setupSection(title: "Font Style").padding(.leading, 20).padding(.trailing, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    Spacer(minLength: -2)
                    ForEach(0..<manager.fonts.count, id: \.self, content: { index in
                        Button(action: {
                            manager.updateTextFont(index: index)
                        }, label: {
                            Text(manager.fonts[index]).font(.custom(manager.fonts[index], size: 20))
                                .foregroundColor(manager.selectedFont != manager.fonts[index] ? .black : .white)
                                .padding()
                        })
                        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(manager.selectedFont == manager.fonts[index] ? .black : .white))
                    })
                    Spacer(minLength: -2)
                }
            }
        }.padding(.top, 30)
    }
    
    /// Background gradient
    private var BackgroundGradient: some View {
        colorSelector(title: "Background Gradient", gradientSelector: true)
            .padding(.bottom, 30)
    }
    
    /// Background image
    private var BackgroundImg: some View {
        VStack {
            setupSection(title: "Background Image")
            Button(action: {
                showImgPicker.toggle()
            }, label: {
                Image(uiImage: manager.backgroundImage ?? UIImage(named: "imgView")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(15)
            })
            Button(action: {
                manager.updateBackgroundImage(nil)
                UserDefaults.standard.removeObject(forKey: "draw")
                UserDefaults.standard.synchronize()
            }, label: {
                Text("Remove Image")
                    .foregroundColor(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
            }).padding(.top, 10)
        }
        .padding(.leading, 20).padding(.trailing, 20)
        .padding(.top, 30)
    }
}

// MARK: - Commong functions
extension MainView {
    private func setupSection(title: String) -> some View {
        HStack {
            Text(title).foregroundColor(Color.init(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                .bold()
            Spacer()
        }
    }
    
    private func colorSelector(title: String, gradientSelector: Bool = false) -> some View {
        VStack {
            setupSection(title: title).padding(.leading, 20).padding(.trailing, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    Spacer(minLength: 02)
                    ForEach(0..<manager.colors.count, id: \.self, content: { index in
                        Button(action: {
                            if !gradientSelector { manager.updateTextColor(index: index) } else {
                                if manager.isShowGradientInfo {
                                    gradientInfo.toggle()
                                } else {
                                    manager.updateGradientSelection(index: index)
                                }
                            }
                        }, label: {
                            ZStack {
                                Circle().stroke(index == 0 ? Color.secondary : Color.clear, lineWidth: 2)
                                    .background(manager.colors[index])
                                    .clipShape(Circle())
                                if gradientSelector {
                                    if manager.widgetGradientColors.contains(index) {
                                        Image(systemName: "checkmark").accentColor(.primary)
                                    }
                                } else {
                                    if manager.selectedTextColorIndex == index {
                                        Image(systemName: "checkmark").accentColor(.primary)
                                    }
                                }
                            }
                            .frame(width: 58, height: 60)
                        })
                    })
                    Spacer(minLength: -2)
                }
            }
        }.padding(.top, 30)
    }
}

// MARK: - Render the UI
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(manager: WidgetManager())
    }
}
