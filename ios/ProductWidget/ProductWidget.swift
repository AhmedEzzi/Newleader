import WidgetKit
import SwiftUI
import Foundation

// Structure to hold product data retrieved from Flutter
struct Product: Codable {
    let id: Int
    let name: String
    let image: String
    let price: String
}

// Timeline Provider to handle data loading and refresh
struct ProductTimelineProvider: TimelineProvider {
    let sharedUserDefaults = UserDefaults(suiteName: "group.com.leadercompany.widget")
    
    func placeholder(in context: Context) -> ProductEntry {
        return ProductEntry(date: Date(), product: placeholderProduct)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ProductEntry) -> Void) {
        guard let productData = loadProductData() else {
            completion(ProductEntry(date: Date(), product: placeholderProduct))
            return
        }
        completion(ProductEntry(date: Date(), product: productData))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ProductEntry>) -> Void) {
        // Create a timeline with a one-hour refresh policy
        guard let productData = loadProductData() else {
            let entry = ProductEntry(date: Date(), product: placeholderProduct)
            let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))) // 1 hour
            completion(timeline)
            return
        }
        
        let entry = ProductEntry(date: Date(), product: productData)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))) // 1 hour
        completion(timeline)
    }
    
    // Load product data from UserDefaults (shared with Flutter)
    private func loadProductData() -> Product? {
        guard let sharedDefaults = sharedUserDefaults,
              let productJson = sharedDefaults.string(forKey: "product_data") else {
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let data = productJson.data(using: .utf8),
              let product = try? decoder.decode(Product.self, from: data) else {
            return nil
        }
        
        return product
    }
    
    // Placeholder data if nothing is available
    private var placeholderProduct: Product {
        return Product(
            id: 0,
            name: "Loading Product...",
            image: "",
            price: "$0.00"
        )
    }
}

// Timeline Entry to hold the state for the widget
struct ProductEntry: TimelineEntry {
    let date: Date
    let product: Product
}

// Widget View
struct ProductWidgetEntryView: View {
    var entry: ProductTimelineProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack(spacing: 8) {
                // Product Image
                if let imageUrl = URL(string: entry.product.image) {
                    AsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 80, height: 80)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        @unknown default:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 80, height: 80)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }
                
                // Product Name
                Text(entry.product.name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 8)
                
                // Product Price
                Text(entry.product.price)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.orange)
                    .padding(.bottom, 8)
            }
            .padding(.vertical, 12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(12)
    }
}

// Widget Configuration
struct ProductWidget: Widget {
    let kind = "ProductWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: ProductTimelineProvider()
        ) { entry in
            ProductWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Product Widget")
        .description("Show best selling products from Melamine El-Sherif.")
        .supportedFamilies([.systemSmall])
    }
}

// Preview Provider
struct ProductWidget_Previews: PreviewProvider {
    static var previews: some View {
        let previewProduct = Product(
            id: 1,
            name: "Example Product",
            image: "https://example.com/image.jpg",
            price: "$99.99"
        )
        
        return ProductWidgetEntryView(
            entry: ProductEntry(date: Date(), product: previewProduct)
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
} 