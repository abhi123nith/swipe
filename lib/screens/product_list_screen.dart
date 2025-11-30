import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../utils/navigation_utils.dart';
import '../widgets/product_card.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider productProvider;
  TextEditingController searchController = TextEditingController();
  List<Product> filteredProducts = [];
  String _sortOption = 'default'; // default, lowToHigh, highToLow

  @override
  void initState() {
    super.initState();
    // Schedule the loading for after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productProvider = Provider.of<ProductProvider>(context, listen: false);
      productProvider.loadProducts();
      productProvider.loadLocalProducts();
    });
    searchController.addListener(_filterAndSortProducts);
  }

  void _filterAndSortProducts() {
    setState(() {
      if (mounted) {
        
        filteredProducts = productProvider.filterProducts(
          searchController.text,
        );
      
        _sortProducts();
      }
    });
  }

  void _sortProducts() {
    switch (_sortOption) {
      case 'lowToHigh':
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'highToLow':
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
       
        break;
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_filterAndSortProducts);
    searchController.dispose();
    super.dispose();
  }

  void _refreshProducts() {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.loadProducts();
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Sort by Price',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('Default'),
                trailing: _sortOption == 'default'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _sortOption = 'default';
                    _filterAndSortProducts();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price: Low to High'),
                trailing: _sortOption == 'lowToHigh'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _sortOption = 'lowToHigh';
                    _filterAndSortProducts();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Price: High to Low'),
                trailing: _sortOption == 'highToLow'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() {
                    _sortOption = 'highToLow';
                    _filterAndSortProducts();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.sort), onPressed: _showSortOptions),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProducts,
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.products.isNotEmpty) {
            filteredProducts = provider.filterProducts(searchController.text);
            _sortProducts();
          }

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    setState(() {
                      filteredProducts = provider.filterProducts(value);
                      _sortProducts();
                    });
                  },
                ),
              ),
              Expanded(
                child: provider.isLoading
                    ? const Center(
                        child: SpinKitCircle(color: Colors.blue, size: 50.0),
                      )
                    : provider.errorMessage.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.errorMessage,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _refreshProducts,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await provider.loadProducts();
                        },
                        child: ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                              product: filteredProducts[index],
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            NavigationUtils.createSlideRoute(const AddProductScreen()),
          );
          if (result == true) {
            _refreshProducts();
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
