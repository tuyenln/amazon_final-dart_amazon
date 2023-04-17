import 'dart:math';

import 'package:puppeteer/puppeteer.dart';

Future<bool> clickCategory(Page page) async {
  await page.waitForSelector(
      'a[href*="/s?"]:not([hidden]):not([aria-hidden="true"])');

  final cateElement =
      await page.$('a[href*="/s?"]:not([hidden]):not([aria-hidden="true"])');

  if (cateElement != false) {
    var categories =
        await page.$$('a[href*="/s?"]:not([hidden]):not([aria-hidden="true"])');

    await Future.delayed(Duration(seconds: 7));

    var randomCategoryIndex = Random().nextInt(categories.length);
    await categories[randomCategoryIndex].click();
    return true;
  }
  return false;
}

Future<String> getRandomAgentFromArray(
    List<String> links, Random random) async {
  var randomProductLink = links[random.nextInt(links.length)];
  return randomProductLink;
}

Future<void> scrollToDown(Page page) async {
  int index = 5;
  for (var i = 0; i < index; i++) {
    await page.keyboard.press(Key.arrowDown);
  }
}

Future<void> higtlightElement(Page page) async {
  // Find the text element and get its bounding box
  var selectorText = '#feature-bullets';

  // await page.evaluate('window.scrollTo(0, document.body.scrollHeight /3)');
  await Future.delayed(Duration(seconds: 5));

  final elementExists = await page.$(selectorText) != null;

  if (elementExists) {
    await page.waitForSelector(selectorText);

    final textElement = await page.$(selectorText);
    if (textElement != false) {
      final textBox = await textElement.boundingBox;

      final x = textBox?.left;
      final y = textBox?.top;

      // Get the width and height of the bounding box
      final width = textBox?.width;
      final height = textBox?.height;

      // Calculate the center point of the bounding box
      final centerX = x! + width! / 2;
      final centerY = y! + height! / 2;

      // Move the mouse cursor to the center of the element
      print(centerX);
      print(centerY);

      await page.mouse.move(Point(centerX, centerY));

      // Highlight the contents of the text element
      await page.evaluate('''() => {
      const selection = window.getSelection();
      const range = document.createRange();
      range.selectNodeContents(document.querySelector("#feature-bullets"));
      selection.removeAllRanges();
      selection.addRange(range);
    }
  ''');
    }
  } else {
    print('element $selectorText not found');
  }
}

Future<bool> clickProductDetail(Page page) async {
  await page.waitForSelector(
      'a[href*="/dp/"]:not([hidden]):not([aria-hidden="true"])');
  final productElement =
      await page.$('a[href*="/dp/"]:not([hidden]):not([aria-hidden="true"])');

  if (productElement != false) {
    var products = await page
        .$$('a[href*="/dp/"]:not([hidden]):not([aria-hidden="true"])');
    var randomProductIndex = Random().nextInt(products.length);
    await products[randomProductIndex].click();
    await page.waitForSelector('#productTitle');

    await Future.delayed(Duration(seconds: 6));

    // Scroll down to the bottom of the page
    await page.evaluate('window.scrollTo(0, document.body.scrollHeight)');

    // Wait for the page to load
    await Future.delayed(Duration(seconds: 5));

    // Scroll back up to the top of the page
    await page.evaluate('window.scrollTo(0, 0)');

    await Future.delayed(Duration(seconds: 5));

    // Check if the selector exists
    final button = await page.$('#productTitle');
    if (button != false) {
      print('Selector found');

      // Define the JavaScript function to mark the text
      await higtlightElement(page);

      await Future.delayed(Duration(seconds: 5));

      // await page.evaluate('window.scrollTo(0, 200)');

      // Find the first related product link and click it
      final relatedProducts = await page.$$('.a-carousel-card');
      if (relatedProducts.isNotEmpty) {
        final firstProduct = relatedProducts[0];
        await firstProduct.click();
      }
      print('moving related');

      await Future.delayed(Duration(seconds: 6));

      return true;
    } else {
      print('Selector not found');
    }
  }
  return false;
}

Future<bool> clickRelated(Page page) async {
  await page.waitForSelector(
      'a[href*="/gp/"]:not([hidden]):not([aria-hidden="true"])');

  await Future.delayed(Duration(seconds: 6));

  // Scroll down to the bottom of the page
  await page.evaluate('window.scrollTo(0, document.body.scrollHeight -300)');

  // Wait for the page to load
  await Future.delayed(Duration(seconds: 5));

  // Scroll back up to the top of the page
  await page.evaluate('window.scrollTo(0, 0)');

  await Future.delayed(Duration(seconds: 6));

  var related =
      await page.$('a[href*="/gp/"]:not([hidden]):not([aria-hidden="true"])');
  if (related != false) {
    var productsRelated = await page
        .$$('a[href*="/gp/"]:not([hidden]):not([aria-hidden="true"])');

    await page.waitForSelector(
        'a[href*="/gp/"]:not([hidden]):not([aria-hidden="true"])');

    await Future.delayed(Duration(seconds: 6));

    // Define the JavaScript function to mark the text
    await higtlightElement(page);

    print('debug related');

    await Future.delayed(Duration(seconds: 10));

    var button =
        await page.$('a[href*="/gp/"]:not([hidden]):not([aria-hidden="true"])');
    if (button != false) {
      print('Selector found');
      // Find the first related product link and click it
      final relatedProducts = await page.$$('.a-carousel-card');
      int count = await getRandomNumberInRange(relatedProducts.length);
      // print(count);
      if (relatedProducts.isNotEmpty) {
        final firstProduct = relatedProducts[count];
        await firstProduct.click();
      }
      print('to next related');

      await Future.delayed(Duration(seconds: 6));

      return true;
    } else {
      print('Selector not found');
    }
    print('click product related');
    return true;
  }
  return false;
}

Future<int> getRandomNumberInRange(int number) async {
  var random = Random();
  int min = 0;
  int max = number;
  int randomNumber = random.nextInt(max - 1);
  return randomNumber;
}

Future<void> toTopSmooth(Page page) async {
  // Scroll smoothly to the top of the page
  // await page.evaluate('''
  //   const distanceTop = document.body.scrollHeight;
  //   const delayTop = 20;
  //   const intervalTop = setInterval(() => {
  //     if (window.scrollY === 0) {
  //       clearInterval(intervalTop);
  //     } else {
  //       window.scrollBy(0, -distanceTop);
  //     }
  //   }, delayTop);
  // ''');

  await page.evaluate('''
    window.scrollTo({
      'top': 0,
      'behavior': 'smooth'
    });
  ''');
}

Future<void> toBottomSmooth(Page page) async {
  // Scroll smoothly to a target position on the page
  // await page.evaluate('''
  //   const targetY = document.body.scrollHeight;
  //   const distance = 100;
  //   const delay = 10;
  //   const interval = setInterval(() => {
  //     const currentY = window.scrollY;
  //     const diff = targetY - currentY;
  //     const maxDistance = Math.abs(diff) < distance ? Math.abs(diff) : distance;
  //     if (currentY === targetY) {
  //       clearInterval(interval);
  //     } else {
  //       window.scrollBy(0, diff > 0 ? maxDistance : -maxDistance);
  //     }
  //   }, delay);
  // ''');

  // Scroll smoothly to the bottom of the page with an offset
  // await page.evaluate('''
  //   const distance = 100;
  //   const delay = 20;
  //   const target = document.body.scrollHeight;
  //   const interval = setInterval(() => {
  //     if (window.scrollY >= target) {
  //       clearInterval(interval);
  //     } else {
  //       window.scrollBy(0, distance);
  //     }
  //   }, delay);
  // ''');


  await page.evaluate('''
  window.scrollTo({'top': document.body.scrollHeight, 'behavior': 'smooth'});
  ''');
}
