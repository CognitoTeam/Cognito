import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class GradebookItem extends StatefulWidget {
  @override
  _GradebookItemState createState() => _GradebookItemState();
}

class _GradebookItemState extends State<GradebookItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color(0xFF34ACE0),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0)
            )]
        ),
        child: getUngradedWidget()
    );
  }

  Widget getUngradedWidget()
  {
      return Container(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 200,
              child: Text(
                "Assignment 11111111111111111",
                overflow: TextOverflow.fade,
                softWrap: false,
                style: GoogleFonts.poppins(
                    color: Theme.of(context).backgroundColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          gradeInput()
          ],
        ),
      );
  }

  Widget gradeInput()
  {
      double height = 27;
      double fontSize = 17;
      TextEditingController _controller = new TextEditingController(text: '50');
      return Row(
          children: [
            SizedBox(
              height: height,
              width: 50,
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                  color: Theme.of(context).backgroundColor,
                  fontSize: fontSize,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: -25, horizontal: 0),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).backgroundColor
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).backgroundColor
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).backgroundColor
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ], //// Only numbers can
              ),
            ),
            Text(
              " / ",
              style: GoogleFonts.poppins(
                  color: Theme.of(context).backgroundColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(
              height: height,
              width: 50,
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                  color: Theme.of(context).backgroundColor,
                  fontSize: fontSize,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: -25, horizontal: 0),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).backgroundColor
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).backgroundColor
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).backgroundColor
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ], //// Only numbers can
              ),
            ),
            Text(
              "pts",
              style: GoogleFonts.poppins(
                color: Theme.of(context).backgroundColor,
                fontSize: 15,
              ),
            )
          ],
      );
  }
}
