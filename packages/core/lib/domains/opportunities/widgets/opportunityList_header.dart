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
import 'package:responsive_framework/responsive_wrapper.dart';
import '../opportunities.dart';

class OpportunityListHeader extends StatelessWidget {
  const OpportunityListHeader({Key? key, required this.search})
      : super(key: key);
  final bool search;

  @override
  Widget build(BuildContext context) {
    final _opportunityBloc = BlocProvider.of<OpportunityBloc>(context);
    String searchString = '';
    return Material(
        child: ListTile(
            onTap: (() {
              _opportunityBloc
                  .add(search ? OpportunitySearchOff() : OpportunitySearchOn());
            }),
            leading: Image.asset('assets/images/search.png', height: 30),
            title: search
                ? Row(children: <Widget>[
                    SizedBox(
                        width:
                            ResponsiveWrapper.of(context).isSmallerThan(TABLET)
                                ? MediaQuery.of(context).size.width - 250
                                : MediaQuery.of(context).size.width - 350,
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: "search in ID, name and lead...",
                          ),
                          onChanged: ((value) {
                            searchString = value;
                          }),
                          onSubmitted: ((value) {
                            _opportunityBloc
                                .add(OpportunityFetch(searchString: value));
                            _opportunityBloc.add(search
                                ? OpportunitySearchOff()
                                : OpportunitySearchOn());
                          }),
                        )),
                    ElevatedButton(
                        child: Text('Search'),
                        onPressed: () {
                          _opportunityBloc.add(
                              OpportunityFetch(searchString: searchString));
                        })
                  ])
                : Column(children: [
                    Row(children: <Widget>[
                      Expanded(
                          child: Text(
                        "Opportunity Name",
                      )),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                        Expanded(
                            child: Text("Est. Amount",
                                textAlign: TextAlign.center)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                        Expanded(
                            child: Text("Est. Probability %",
                                textAlign: TextAlign.center)),
                      Expanded(
                          child: Text("Lead Name & Company",
                              textAlign: TextAlign.left)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                        Expanded(
                            child:
                                Text("Lead Email", textAlign: TextAlign.right)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(TABLET))
                        Expanded(
                            child: Text("Stage", textAlign: TextAlign.center)),
                      if (!ResponsiveWrapper.of(context).isSmallerThan(DESKTOP))
                        Expanded(
                            child:
                                Text("Next Step", textAlign: TextAlign.center)),
                    ]),
                    Divider(color: Colors.black),
                  ]),
            trailing: search ? null : SizedBox(width: 20)));
  }
}
