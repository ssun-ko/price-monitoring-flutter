import 'package:flutter/material.dart';
import 'package:price/core/constants/color_constants.dart';
import 'package:price/core/constants/string_constants.dart';
import 'package:price/models/geo_model.dart';
import 'package:price/providers/data_provider.dart';
import 'package:price/screens/dashboard/components/widget_title.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class OilWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OilWidgetState();
}

class _OilWidgetState extends State<OilWidget> {
  late MapShapeSource _dataSource;
  late List<GeoModel> data;

  @override
  void initState() {
    data = <GeoModel>[
      GeoModel("Seoul", "11", bgColor, "서울", "0.0"),
      GeoModel("Busan", "21", bgColor, "부산", "0.0"),
      GeoModel("Daegu", "22", bgColor, "대구", "0.0"),
      GeoModel("Incheon", "23", bgColor, "인천", "0.0"),
      GeoModel("Gwangju", "24", bgColor, "광주", "0.0"),
      GeoModel("Daejeon", "25", bgColor, "대전", "0.0"),
      GeoModel("Ulsan", "26", bgColor, "울산", "0.0"),
      GeoModel("Sejongsi", "29", bgColor, "세종", "0.0"),
      GeoModel("Gyeonggi-do", "31", bgColor, "경기", "0.0"),
      GeoModel("Gangwon-do", "32", bgColor, "강원", "0.0"),
      GeoModel("Chungcheongbuk-do", "33", bgColor, "충북", "0.0"),
      GeoModel("Chungcheongnam-do", "34", bgColor, "충남", "0.0"),
      GeoModel("Jeollabuk-do", "35", bgColor, "전북", "0.0"),
      GeoModel("Jeollanam-do", "36", bgColor, "전남", "0.0"),
      GeoModel("Gyeongsangbuk-do", "37", bgColor, "경북", "0.0"),
      GeoModel("Gyeongsangnam-do", "38", bgColor, "경남", "0.0"),
      GeoModel("Jeju-do", "39", bgColor, "제주", "0.0")
    ];

    _dataSource = MapShapeSource.asset('map/korea-provinces-2018-geo.json',
        shapeDataField: 'name_eng',
        dataCount: data.length,
        primaryValueMapper: (int index) => data[index].name,
        shapeColorValueMapper: (int index) => data[index].color);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, dataProvider, _) {
      if (dataProvider.oilData.isEmpty) {
        return Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        String _getGeoPrice(int index) {
          return dataProvider.oilData.last[index].toString();
        }

        Color _getGeoColor(int index) {
          double average =
              double.tryParse(dataProvider.oilData.last[1].toString()) ?? 0.0;
          double value =
              double.tryParse(dataProvider.oilData.last[index].toString()) ??
                  0.0;
          double diffValue = (value - average) / value * 100;

          if (diffValue > 1) return Colors.redAccent.shade400;
          if (diffValue > 0.5) return Colors.redAccent.shade200;
          if (diffValue > 0) return Colors.redAccent.shade100;
          if (diffValue < -1) return Colors.blueAccent.shade400;
          if (diffValue < -0.5) return Colors.blueAccent.shade200;
          return Colors.blueAccent.shade100;
        }

        data = <GeoModel>[
          GeoModel("Seoul", "11", _getGeoColor(2), "서울", _getGeoPrice(2)),
          GeoModel("Busan", "21", _getGeoColor(12), "부산", _getGeoPrice(12)),
          GeoModel("Daegu", "22", _getGeoColor(11), "대구", _getGeoPrice(11)),
          GeoModel("Incheon", "23", _getGeoColor(4), "인천", _getGeoPrice(4)),
          GeoModel("Gwangju", "24", _getGeoColor(13), "광주", _getGeoPrice(13)),
          GeoModel("Daejeon", "25", _getGeoColor(10), "대전", _getGeoPrice(10)),
          GeoModel("Ulsan", "26", _getGeoColor(12), "울산", _getGeoPrice(12)),
          GeoModel("Sejongsi", "29", _getGeoColor(9), "세종", _getGeoPrice(9)),
          GeoModel("Gyeonggi-do", "31", _getGeoColor(3), "경기", _getGeoPrice(3)),
          GeoModel("Gangwon-do", "32", _getGeoColor(5), "강원", _getGeoPrice(5)),
          GeoModel("Chungcheongbuk-do", "33", _getGeoColor(6), "충북",
              _getGeoPrice(6)),
          GeoModel("Chungcheongnam-do", "34", _getGeoColor(6), "충남",
              _getGeoPrice(6)),
          GeoModel(
              "Jeollabuk-do", "35", _getGeoColor(7), "전북", _getGeoPrice(7)),
          GeoModel(
              "Jeollanam-do", "36", _getGeoColor(7), "전남", _getGeoPrice(7)),
          GeoModel(
              "Gyeongsangbuk-do", "37", _getGeoColor(8), "경북", _getGeoPrice(8)),
          GeoModel(
              "Gyeongsangnam-do", "38", _getGeoColor(8), "경남", _getGeoPrice(8)),
          GeoModel("Jeju-do", "39", _getGeoColor(15), "제주", _getGeoPrice(15))
        ];

        return Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              WidgetTitle(title: oilWidgetTitle),
              SizedBox(
                  height: 600,
                  width: double.infinity,
                  child: SfMaps(layers: [
                    MapShapeLayer(
                        source: _dataSource,
                        shapeTooltipBuilder: (BuildContext context, int index) {
                          return Container(
                            color: bgColor,
                            child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(data[index].label +
                                    ": " +
                                    data[index].price +
                                    " (원/L)")),
                          );
                        })
                  ]))
            ]));
      }
    });
  }
}
