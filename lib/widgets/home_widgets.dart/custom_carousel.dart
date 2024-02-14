import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:women_saftey_app/widgets/home_widgets.dart/safe_web_view.dart';

import '../../utils/quotes.dart';

class CustomCarousel extends StatelessWidget {
  const CustomCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToRoute(BuildContext context, Widget route) {
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => route,
          ));
    }

    // ignore: avoid_unnecessary_containers
    return Container(
      child: CarouselSlider(
          items: List.generate(
              iamgeSlider.length,
              (index) => Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (index == 0) {
                          navigateToRoute(
                              context,
                              SafeWebView(
                                  url:
                                      'https://r.search.yahoo.com/_ylt=AwrNPrlxjPFk8Q0CTJFXNyoA;_ylu=Y29sbwNiZjEEcG9zAzEEdnRpZANBREVOR1QxXzEEc2VjA3Ny/RV=2/RE=1693580530/RO=10/RU=https%3a%2f%2fgulfnews.com%2fworld%2fasia%2fpakistan%2fwomens-day-10-pakistani-women-inspiring-the-country-1.77696239/RK=2/RS=.oy1W.u1aAGGsDO5whdklF.bsg4-'));
                        } else if (index == 1) {
                          navigateToRoute(
                              context,
                              SafeWebView(
                                  url:
                                      'https://r.search.yahoo.com/_ylt=AwrE.7L2i_FkceoCTyBXNyoA;_ylu=Y29sbwNiZjEEcG9zAzEEdnRpZANBREVOR1QxXzEEc2VjA3Ny/RV=2/RE=1693580407/RO=10/RU=https%3a%2f%2fwww.unwomen.org%2fen%2fwhat-we-do%2fending-violence-against-women/RK=2/RS=Fba5aEEeIy8bj0mEAe7jk.Ta4Bw-'));
                        } else if (index == 2) {
                          navigateToRoute(
                              context,
                              SafeWebView(
                                url:
                                    'https://r.search.yahoo.com/_ylt=AwrNPrlxjPFk8Q0CTJFXNyoA;_ylu=Y29sbwNiZjEEcG9zAzEEdnRpZANBREVOR1QxXzEEc2VjA3Ny/RV=2/RE=1693580530/RO=10/RU=https%3a%2f%2fgulfnews.com%2fworld%2fasia%2fpakistan%2fwomens-day-10-pakistani-women-inspiring-the-country-1.77696239/RK=2/RS=.oy1W.u1aAGGsDO5whdklF.bsg4-',
                              ));
                        } else {
                          navigateToRoute(
                              context,
                              SafeWebView(
                                url:
                                    'https://r.search.yahoo.com/_ylt=AwrEt9PjjPFkhtsCIVBXNyoA;_ylu=Y29sbwNiZjEEcG9zAzEEdnRpZAMEc2VjA3Ny/RV=2/RE=1693580643/RO=10/RU=https%3a%2f%2fwww.therandomvibez.com%2fyou-are-strong-quotes-to-give-you-strength-in-hard-times%2f/RK=2/RS=FEsduepbAVUbepfVzjuz6VQT3aM-',
                              ));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(iamgeSlider[index])),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ])),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                articleTitle[index],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
          options: CarouselOptions(
            aspectRatio: 2.0,
            autoPlay: true,
            enlargeCenterPage: true,
          )),
    );
  }
}
