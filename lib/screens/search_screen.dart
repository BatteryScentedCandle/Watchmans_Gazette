import 'package:flutter/material.dart';
import 'package:watchmans_gazette/news/sdg_constants.dart';
import 'package:watchmans_gazette/news/search_filter.dart';
import 'package:watchmans_gazette/theme/app_color.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const double _inputFontSize = 16;
  final List<bool> _sdgChoices = .filled(17, false);

  AppBar _buildAppBar() {
    return AppBar(
      title: TextField(
        maxLines: 1,
        onSubmitted: (input) => _submitSearch(input: input),
        style: TextStyle(color: AppColors.background, fontSize: _inputFontSize),
        cursorColor: AppColors.background,
        decoration: InputDecoration(
          hint: Text(
            "Search",
            style: TextStyle(
              color: AppColors.backgroundDarker,
              fontSize: _inputFontSize,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(onPressed: () => _submitSearch(), icon: Icon(Icons.search)),
      ],
    );
  }

  void _submitSearch({String? input}) {
    SearchFilter filter = SearchFilter(search: input, sdgFilters: _sdgChoices);
    Navigator.pop(context, filter);
  }

  String _buildSDGImageName(int sdg) {
    String sdgNum = sdg.toString().padLeft(2, "0");
    return "assets/images/E_WEB_$sdgNum.png";
  }

  Widget _buildSDGFilterItem(int index) {
    return GestureDetector(
      onTapUp: (details) {
        setState(() => _sdgChoices[index] = !_sdgChoices[index]);
      },
      child: Card(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: .centerStart,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: .centerLeft,
                      end: .centerRight,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(rect);
                  },
                  blendMode: .dstIn,
                  child: Image.asset(
                    _buildSDGImageName(index + 1),
                    fit: .fitHeight,
                  ),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: .center,
              mainAxisAlignment: .spaceBetween,
              children: [
                SizedBox(),
                Text(SDG_TITLES[index]),
                Checkbox(
                  value: _sdgChoices[index],
                  onChanged: (checked) {
                    if (checked != null) {
                      setState(() => _sdgChoices[index] = checked);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView.builder(
        itemCount: _sdgChoices.length,
        itemBuilder: (context, index) {
          return _buildSDGFilterItem(index);
        },
      ),
    );
  }
}
