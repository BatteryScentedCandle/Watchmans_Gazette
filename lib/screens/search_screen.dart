import 'package:flutter/material.dart';
import 'package:watchmans_gazette/components/stroked_text.dart';
import 'package:watchmans_gazette/news/sdg_constants.dart';
import 'package:watchmans_gazette/news/search_filter.dart';
import 'package:watchmans_gazette/theme/app_color.dart';

class SearchScreen extends StatefulWidget {
  final SearchFilter? existingFilter;
  const SearchScreen({super.key, this.existingFilter});

  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const double _inputFontSize = 12;
  final TextEditingController _searchController = TextEditingController();
  final List<bool> _sdgChoices = .filled(17, false);

  @override
  void initState() {
    super.initState();
    if (widget.existingFilter != null) {
      setState(() {
        _searchController.text = widget.existingFilter?.search ?? "";
        if (widget.existingFilter == null) {
          return;
        }
        for (int i = 0; i < widget.existingFilter!.sdgFilters.length; i++) {
          _sdgChoices[i] = widget.existingFilter!.sdgFilters[i];
        }
      });
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Container(
        margin: .only(top: 15, bottom: 15),
        child: TextField(
          maxLines: 1,
          controller: _searchController,
          onSubmitted: (input) => _submitSearch(input: input),
          style: TextStyle(
            color: Colors.black,
            fontSize: _inputFontSize,
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.searchBG),
              borderRadius: .all(.circular(50))
            ),
            filled: true,
            hint: Text(
              "Search",
              style: TextStyle(
                color: Colors.black,
                fontSize: _inputFontSize,
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _submitSearch(input: _searchController.text),
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  void _submitSearch({String? input}) {
    if (input != null && input.isEmpty) input = null;
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
                      colors: [Colors.black, Colors.black, Colors.transparent],
                      stops: [0, 0.01, 1],
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
            Padding(
              padding: .only(top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .spaceBetween,
                children: [
                  SizedBox(width: 80),
                  Expanded(
                    child: Text(
                      SDG_TITLES[index],
                      maxLines: 2,
                      textAlign: .center,
                    ),
                  ),
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
