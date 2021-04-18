import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      'R\$${cart.totalAmount}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (ctx, i) => CartItemWidget(cartItems[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.cart.totalAmount == 0
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false)
                  .addOrder(widget.cart);
              setState(() {
                isLoading = false;
              });
              widget.cart.clear();
            },
      style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
      child: isLoading
          ? CircularProgressIndicator()
          : Text(
              'COMPRAR',
            ),
    );
  }
}
