//
//  ContentView.swift
//  SwiftTransition
//
//  Created by Hamal Saefudin on 10/12/22.
//

import SwiftUI

struct ContentView: View {
    @State private var content:[CardView] = cardViews
    @State private var activeIndex:Int = 0;
    @State private var isActive:Bool = false;
    
    private func onContentTap()->Void{
        withAnimation(Animation.spring()){
            if activeIndex == content.count-1{
                activeIndex = 0
            }else{
                activeIndex+=1
            }
            isActive.toggle()
        }
    }
    
    var body: some View {
        VStack {
            Text("Whats new in SwiftUI")
                .font(.system(.largeTitle,design: .rounded))
                .fontWeight(.black)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(0..<content.count) { i in
                if i == activeIndex {
                    CardContentView(content: content[i],onTap: onContentTap).transition(.scaleAndOffset)
                }
            }
            
        }
        .padding(.horizontal,25)
        .onTapGesture {
            onContentTap()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: - ROUNED CORNER ONLY
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//MARK: -CardContentView
struct CardContentView: View {
    //MARK: PROPERTY CONTENTVIEW
    var content:CardView
    var onTap:()->Void
    
    var body: some View {
        ScrollView(showsIndicators: false){
            Image(content.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350,height: 350)
                .clipShape(RoundedCorner(radius: 10, corners: [.topLeft,.topRight]))
                .padding(.bottom,15)
            VStack{
                Text(content.category)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .frame(maxWidth:.infinity,alignment:.leading)
                Spacer()
                    .frame(height: 10)
                Text(content.heading)
                    .font(.system(.largeTitle,design: .rounded))
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(maxWidth:.infinity,alignment:.leading)
                Spacer()
                    .frame(height: 10)
                Text(content.author)
                    .font(.title2)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                    .frame(maxWidth:.infinity,alignment:.leading)
                    .padding(.bottom)
                HStack{
                    ForEach(1...content.rating,id: \.self){ item in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .fontWeight(.black)
                    }
                }
                .padding(.bottom,10)
                .frame(maxWidth: .infinity,alignment: .leading)
                Text(content.excerpt)
                    .foregroundColor(.gray)
                    .lineSpacing(2)
            }.padding(.leading,20)
        }
        .onTapGesture {
            onTap()
        }
    }
}

//MARK: - EXTENSION
extension AnyTransition{
    static var scaleAndOffset:AnyTransition{
        AnyTransition.asymmetric(insertion: .scale(scale: 0,anchor: .bottomTrailing).combined(with: .opacity), removal: .offset(x:500,y:500).combined(with: .scale).combined(with: .opacity))
    }
}
