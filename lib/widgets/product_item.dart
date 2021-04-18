import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          product.imageUrl,
        ),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.PRODUCT_FORM,
                    arguments: product,
                  );
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text('Tem certeza?'),
                          content: Text('Que deseja excluir o produto?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(false),
                              child: Text('Não'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(true),
                              child: Text('Sim'),
                            ),
                          ],
                        );
                      }).then((value) async {
                    if (value) {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .deleteProducts(product.id);
                      } catch (error) {
                        scaffold.showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text(
                              error.toString(),
                            ),
                          ),
                        );
                      }
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }
}
