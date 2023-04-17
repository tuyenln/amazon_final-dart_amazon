import 'package:dart_amazon/authen/generation_token.dart';
import 'package:dart_amazon/dart_amazon.dart';
import 'package:puppeteer/puppeteer.dart';
import 'dart:math';
import 'package:dotenv/dotenv.dart';

void main() async {
  final browser = await puppeteer.launch(
      ignoreDefaultArgs: ["--enable-automation"],
      headless: false,
      timeout: Duration(seconds: 15000) // sets the timeout to 60 seconds
      );
  final page = await browser.newPage();
  final pages = await browser.pages;

  if (pages.length > 1) {
    await pages[0].close();
  }

  List<String> listAgent = [
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36',
  ];

  final random = Random();
  String agent = await getRandomAgentFromArray(listAgent, random);

  await page.setUserAgent(agent);

  // Add Headers
  await page.setExtraHTTPHeaders({
    'user-agent': '$agent',
    'upgrade-insecure-requests': '1',
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
    'accept-encoding': 'gzip, deflate, br',
    'accept-language': 'en-US,en;q=0.9,en;q=0.8'
  });

  // await page.setViewport(DeviceViewport(width: 1920, height: 1080));

  await page.goto('https://www.amazon.com');

  await page.waitForSelector(
      'a[href*="/s?"]:not([hidden]):not([aria-hidden="true"])');

  // Scroll down to the bottom of the page
  // await page.evaluate('window.scrollTo(0, document.body.scrollHeight -300)');
  await toBottomSmooth(page);

  // Wait for the page to load
  await Future.delayed(Duration(seconds: 5));

  // Scroll back up to the top of the page
  // await page.evaluate('window.scrollTo(0, 0)');
  await toTopSmooth(page);

  await Future.delayed(Duration(seconds: 10));

  bool flagCate = false;
  bool flagProduct = false;
  bool childFlag = true;
  bool isAuthenticated = false;

  isAuthenticated = await authentication('test@gmail.com');
  if (isAuthenticated == true) {
    flagCate = await clickCategory(page);
  }

  if (flagCate == true) {
    flagProduct = await clickProductDetail(page);
  }

  if (flagProduct == true) {
    var num = 1;
    while (num <= 4 && childFlag) {
      childFlag = await clickRelated(page);
      print("this child number $num");
      num++;
    }
  }

  await Future.delayed(Duration(seconds: 10));

  print('Done');

  await browser.close();
}
