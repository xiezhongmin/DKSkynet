//
//  NSDate+DKFormat.h
//  DKDebugerExample
//
//  Created by admin on 2021/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (DKFormat)

#pragma mark - Component Properties -

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger nanosecond; ///< Nanosecond component
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, readonly) NSInteger weekdayOrdinal; ///< WeekdayOrdinal component
@property (nonatomic, readonly) NSInteger weekOfMonth; ///< WeekOfMonth component (1~5)
@property (nonatomic, readonly) NSInteger weekOfYear; ///< WeekOfYear component (1~53)
@property (nonatomic, readonly) NSInteger yearForWeekOfYear; ///< YearForWeekOfYear component
@property (nonatomic, readonly) NSInteger quarter; ///< Quarter component
@property (nonatomic, readonly) BOOL isLeapMonth; ///< whether the month is leap month
@property (nonatomic, readonly) BOOL isLeapYear; ///< whether the year is leap year
@property (nonatomic, readonly) BOOL isToday; ///< whether date is today (based on current locale)
@property (nonatomic, readonly) BOOL isYesterday; ///< whether date is yesterday (based on current locale)


#pragma mark - Date Format -

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format   String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)dk_stringWithFormat:(NSString *)format;


/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)dk_dateWithString:(NSString *)dateString format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
