#define VERSION_STRING "contacts-phonetic version 0.3 Copyright (c) 2016 Elethom Hunter\n"
#define HELP_STRING VERSION_STRING "\
\n\
Usage: contacts-phonetic [arguments]\n\
\n\
Arguments:\n\
    -v, --version\n\
        Display current version.\n\
    \n\
    -h, --help\n\
        Display this help text.\n\
    \n\
    -i, --overwrite-existing\n\
        Overwrite existing phonetic names.\n\
    \n\
    --ignore-existing\n\
        Deprecated. Same as --overwrite-existing.\n\
     \n\
    -m, --keep-marks\n\
        Keep accents and diacritcs.\n\
    \n\
    -s, --keep-spaces\n\
        Keep spaces between characters.\n\
    \n\
    -c, --ignore-chinese\n\
        Ignore Chinese. (Will use Japanese Romaji if both are possible.)\n\
    \n\
    -j, --ignore-japanese\n\
        Ignore Japanese. (Will use Chinese Pinyin if both are possible.)\n\
    \n\
    -k, --ignore-korean\n\
        Ignore Korean.\n"
