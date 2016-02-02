//
//  main.m
//  ContactsUtil-PhoneticName
//
//  Created by Elethom Hunter on 02/02/2016.
//  Copyright © 2016 Project Rhinestone. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "multitones_dict.h"

@interface NSString (PhoneticAdditions)

- (NSString *)phoneticString;
- (NSString *)phoneticStringFromLanguage:(NSString *)language;
- (NSString *)stringByRemovingCombiningMarks;
- (NSString *)stringByRemovingSpaces;

@end

@implementation NSString (PhoneticAdditions)

- (NSString *)phoneticString
{
    NSMutableString *mutableSelf = self.mutableCopy;
    CFStringTransform((CFMutableStringRef)mutableSelf,
                      NULL,
                      kCFStringTransformToLatin,
                      false);
    return mutableSelf.copy;
}

- (NSString *)phoneticStringFromLanguage:(NSString *)language
{
    if ([language hasPrefix:@"ja"]) {
        NSMutableString* phoneticString = [[NSMutableString alloc] init];
        CFLocaleRef locale = CFLocaleCreate(kCFAllocatorDefault, CFSTR("Japanese"));
        CFStringTokenizerRef tokenizer = CFStringTokenizerCreate(NULL,
                                                                 (CFStringRef)self,
                                                                 CFRangeMake(0,self.length),
                                                                 kCFStringTokenizerUnitWord,
                                                                 locale);
        CFRelease(locale);
        CFStringTokenizerTokenType tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer);
        while(tokenType !=kCFStringTokenizerTokenNone){
            CFOptionFlags attribute = kCFStringTokenizerAttributeLatinTranscription;
            CFTypeRef transcription = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, attribute);
            [phoneticString appendFormat:@"%@", transcription];
            CFRelease(transcription);
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer);
        }
        CFRelease(tokenizer);
        return [NSString stringWithString:phoneticString];
    }
    return self.phoneticString;
}

- (NSString *)stringByRemovingCombiningMarks
{
    NSMutableString *mutableSelf = self.mutableCopy;
    CFStringTransform((CFMutableStringRef)mutableSelf,
                      NULL,
                      kCFStringTransformStripCombiningMarks,
                      false);
    return mutableSelf.copy;
}

- (NSString *)stringByRemovingSpaces
{
    return [self stringByReplacingOccurrencesOfString:@" "
                                           withString:@""];
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Parse arguments
        NSArray *arguments = NSProcessInfo.processInfo.arguments;
        BOOL ignoreJapanese = ([arguments containsObject:@"--ignore-japanese"] ||
                               [arguments containsObject:@"-j"]);
        BOOL ignoreKorean = ([arguments containsObject:@"--ignore-korean"] ||
                             [arguments containsObject:@"-k"]);
        BOOL ignoreChinese = ([arguments containsObject:@"--ignore-chinese"] ||
                              [arguments containsObject:@"-c"]);
        BOOL keepSpaces = ([arguments containsObject:@"--keep-spaces"] ||
                           [arguments containsObject:@"-s"]);
        BOOL keepCombiningMarks = ([arguments containsObject:@"--keep-marks"] ||
                                   [arguments containsObject:@"-m"]);
        BOOL ignoreExistingPhonetics = ([arguments containsObject:@"--ignore-existing"] ||
                                        [arguments containsObject:@"-i"]);
        
        // Init dict
        NSDictionary *multitones = @MULTITONES;
        
        // Phonetic util block
        NSString* (^phoneticFromString)(NSString*) = ^NSString*(NSString *string){
            if (!string) return nil;
            
            NSUInteger length = string.length;
            
            // Detect language
            NSString *language = (NSString *)CFBridgingRelease(CFStringTokenizerCopyBestStringLanguage((CFStringRef)string,
                                                                                                       CFRangeMake(0, string.length)));
            
            // Korean
            if (ignoreKorean) {
                return nil;
            }
            if ([language hasPrefix:@"ko"]) {
                return string.phoneticString;
            }
            
            // Latin
            NSString *phoneticString = string.phoneticString;
            if ([string isEqualToString:phoneticString]) {
                return phoneticString;
            }
            
            // Japanese or Chinese
            NSString *japanesePhoneticString = nil;
            if (!ignoreJapanese) {
                japanesePhoneticString = [string phoneticStringFromLanguage:@"ja"];
            }
            NSString *chinesePhoneticString = nil;
            if (!ignoreChinese) {
                chinesePhoneticString = [string phoneticStringFromLanguage:@"zh"];
            }
            
            if (japanesePhoneticString.length &&
                !chinesePhoneticString.length) {
                return japanesePhoneticString;
            } else if (chinesePhoneticString.length &&
                !japanesePhoneticString.length) {
                return chinesePhoneticString;
            } else if ([japanesePhoneticString isEqualToString:chinesePhoneticString]) {
                return japanesePhoneticString;
            } else if (!japanesePhoneticString && !chinesePhoneticString) {
                return nil;
            }
            
            // Select
            printf("\x1b[36m%s\x1b[0m 1. Japanese (%s); 2. Chinese (%s). Select: ", string.UTF8String, japanesePhoneticString.UTF8String, chinesePhoneticString.UTF8String);
            NSUInteger selectedIdx = 0;
            do {
                printf("Select: ");
                scanf("%ld", &selectedIdx);
                selectedIdx -= 1;
            } while (selectedIdx >= 2);
            if (selectedIdx == 0) {
                return japanesePhoneticString;
            }
            
            // Scan for multi-tone characters for Chinese
            NSMutableArray *phoneticComponents = [NSMutableArray arrayWithCapacity:length];
            for (NSUInteger loc = 0; loc < length; loc++) {
                NSString *character = [string substringWithRange:NSMakeRange(loc, 1)];
                if ([multitones.allKeys containsObject:character]) {
                    NSArray *tones = [multitones[character] componentsSeparatedByString:@","];
                    NSMutableString *prompt = [NSMutableString stringWithFormat:@"%@\x1b[36m%@\x1b[0m%@ ", [string substringToIndex:loc], character, [string substringFromIndex:loc + 1]];
                    for (NSUInteger i = 0; i < tones.count; i++) {
                        [prompt appendFormat:@"%ld. %@; ", i + 1, tones[i]];
                    }
                    printf("%s\b\b. ", prompt.UTF8String);
                    NSUInteger selectedIdx = 0;
                    do {
                        printf("Select: ");
                        scanf("%ld", &selectedIdx);
                        selectedIdx -= 1;
                    } while (selectedIdx >= tones.count);
                    NSString *tone = tones[selectedIdx];
                    [phoneticComponents addObject:tone];
                } else {
                    [phoneticComponents addObject:character.phoneticString];
                }
            }
            return [phoneticComponents componentsJoinedByString:@" "];
        };
        
        printf("--------------------\n");
        
        // Read address book
        ABAddressBook *addressBook = ABAddressBook.sharedAddressBook;
        for (ABPerson *person in addressBook.people) {
            NSString *firstName = [person valueForProperty:kABFirstNameProperty];
            NSString *firstNamePhonetic = [person valueForProperty:kABFirstNamePhoneticProperty];
            NSString *lastName = [person valueForProperty:kABLastNameProperty];
            NSString *lastNamePhonetic = [person valueForProperty:kABLastNamePhoneticProperty];
            
            if (!(firstName || lastName)) continue;
            
            // Display name
            printf("%s %s\n", firstName.UTF8String, lastName.UTF8String);
            
            // Get phonetics
            if (ignoreExistingPhonetics || !firstNamePhonetic.length) {
                firstNamePhonetic = phoneticFromString(firstName);
            }
            if (ignoreExistingPhonetics || !lastNamePhonetic.length) {
                lastNamePhonetic = phoneticFromString(lastName);
            }
            
            // Modify
            !keepCombiningMarks ? ({
                firstNamePhonetic = firstNamePhonetic.stringByRemovingCombiningMarks;
                lastNamePhonetic = lastNamePhonetic.stringByRemovingCombiningMarks;
            }) : nil;
            !keepSpaces ? ({
                firstNamePhonetic = firstNamePhonetic.stringByRemovingSpaces;
                lastNamePhonetic = lastNamePhonetic.stringByRemovingSpaces;
            }) : nil;
            firstNamePhonetic = firstNamePhonetic.capitalizedString;
            lastNamePhonetic = lastNamePhonetic.capitalizedString;
            
            // Remove if unchanged
            [firstNamePhonetic isEqualToString:firstName] ? (firstNamePhonetic = nil) : nil;
            [lastNamePhonetic isEqualToString:lastName] ? (lastNamePhonetic = nil) : nil;
            
            // Display phonetic names
            if (firstNamePhonetic || lastNamePhonetic) {
                printf("\r%s %s\n", firstNamePhonetic.UTF8String, lastNamePhonetic.UTF8String);
            }
            printf("--------------------\n");
            
            // Update names
            if (firstNamePhonetic) {
                [person setValue:firstNamePhonetic
                     forProperty:kABFirstNamePhoneticProperty];
            } else {
                [person removeValueForProperty:kABFirstNamePhoneticProperty];
            }
            if (lastNamePhonetic) {
                [person setValue:lastNamePhonetic
                     forProperty:kABLastNamePhoneticProperty];
            } else {
                [person removeValueForProperty:kABLastNamePhoneticProperty];
            }
        }
        [addressBook save];
    }
    return 0;
}
