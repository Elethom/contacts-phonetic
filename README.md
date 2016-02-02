# ContactsUtil-PhoneticName

## General

Add phonetic names to contacts. Supports all CJK characters and multiple formats.

## Install

With [Homebrew](https://github.com/Homebrew/homebrew):

```Shell
$ brew install contacts-phonetic
```

Compile on your own:

```Shell
$ git clone https://github.com/Elethom/ContactsUtil-PhoneticName.git
$ cd ContactsUtil-PhoneticName
$ make install
```

## Usage

```
-i, --ignore-existing
    Ignore existing phonetic names. Use of this option will update all person entries in the address book.

-m, --keep-marks
    Keep accents and diacritcs.

-s, --keep-spaces
    Keep spaces between characters.

-c, --ignore-chinese
    Ignore Chinese. (Will use Japanese Romaji if both are possible.)

-j, --ignore-japanese
    Ignore Japanese. (Will use Chinese Pinyin if both are possible.)

-k, --ignore-korean
    Ignore Korean.
```

Example:

```Shell
$ contacts-phonetic
--------------------
Alice Alstroemeria
--------------------
Dieter Rams
--------------------
Elethom Alstroemeria
--------------------
ことり 椎名
椎名 1. Japanese (shiina); 2. Chinese (chuí míng). Select: Select: 1
Kotori Shiina
--------------------
直人 深澤
直人 1. Japanese (naoto); 2. Chinese (zhí rén). Select: Select: 1
深澤 1. Japanese (fukazawa); 2. Chinese (shēn zé). Select: Select: 1
Naoto Fukazawa
--------------------
研哉 原
研哉 1. Japanese (ken'ya); 2. Chinese (yán zāi). Select: Select: 1
原 1. Japanese (hara); 2. Chinese (yuán). Select: Select: 1
Ken'ya Hara
--------------------
```

## License

This code is distributed under the terms and conditions of the [MIT license](http://opensource.org/licenses/MIT).

## Donate

You can support me by:

* sending me iTunes Gift Cards;
* via [Alipay](https://www.alipay.com): elethomhunter@gmail.com
* via [PayPal](https://www.paypal.com): elethomhunter@gmail.com

:-)

## Contact

* [Telegram](http://telegram.me/elethom)
* [Email](mailto:elethomhunter@gmail.com)
* [Twitter](https://twitter.com/elethomhunter)
* [Blog](http://blog.projectrhinestone.org)
