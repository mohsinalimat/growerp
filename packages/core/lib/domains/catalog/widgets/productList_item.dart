/*
 * This GrowERP software is in the public domain under CC0 1.0 Universal plus a
 * Grant of Patent License.
 * 
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any
 * warranty.
 * 
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software (see the LICENSE.md file). If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import '../catalog.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({Key? key, required this.product, required this.index})
      : super(key: key);

  final Product product;
  final int index;

  @override
  Widget build(BuildContext context) {
    String classificationId = GlobalConfiguration().get("classificationId");
    final _productBloc = BlocProvider.of<ProductBloc>(context);
    return Material(
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: product.image != null
                  ? Image.memory(
                      product.image!,
                      height: 100,
                    )
                  : Text("${product.productName![0]}"),
            ),
            title: Row(
              children: <Widget>[
                Expanded(
                    child:
                        Text("${product.productName}", key: Key('name$index'))),
                if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                  Expanded(
                      child: Text("${product.description}",
                          key: Key('description$index'),
                          textAlign: TextAlign.center)),
                Expanded(
                    child: Text("${product.price}",
                        key: Key('price$index'), textAlign: TextAlign.center)),
                if (classificationId != 'AppHotel')
                  Expanded(
                      child: Text("${product.category!.categoryName}",
                          key: Key('categoryName$index'),
                          textAlign: TextAlign.center)),
                Expanded(
                    child: Text("${product.assetCount}",
                        key: Key('assetCount$index'),
                        textAlign: TextAlign.center)),
              ],
            ),
            onTap: () async {
              await showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider.value(
                        value: _productBloc, child: ProductDialog(product));
                  });
            },
            trailing: IconButton(
              key: Key('delete$index'),
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                _productBloc.add(ProductDelete(product));
              },
            )));
  }
}
