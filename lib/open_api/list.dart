import 'package:flutter/material.dart';
import 'package:health_taylor/open_api/ev.dart';
import 'package:health_taylor/open_api/ev_provider.dart';
import 'package:provider/provider.dart';

class ListWidget extends StatelessWidget {
  ListWidget({Key? key}) : super(key: key);

  late EvProvider _evProvider;

  Widget _makeEvOne(Ev ev) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ev.height.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ev.weight.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ))
      ],
    );
  }

  Widget _makeListView(List<Ev> evs) {
    return ListView.separated(
      itemCount: evs.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            height: 300, color: Colors.white, child: _makeEvOne(evs[index]));
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _evProvider = Provider.of<EvProvider>(context, listen: false);
    _evProvider.loadEvs();

    return Scaffold(
        appBar: AppBar(
          title: Text("건강검진 데이터"),
        ),
        body: Consumer<EvProvider>(builder: (context, provider, wideget) {
          if (provider.evs != null && provider.evs.length > 0) {
            return _makeListView(provider.evs);
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
