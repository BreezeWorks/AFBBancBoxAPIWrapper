/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDateFormatter (Utilities)

+ (NSDateFormatter *) shortDateFormatter;
+ (NSDateFormatter *) microDateFormatter;
+ (NSDateFormatter *) microDateTimeFormatter;
+ (NSDateFormatter *) microDateTimeFormatterWithAt;
+ (NSDateFormatter *) mediumDateFormatter;
+ (NSDateFormatter *) longDateFormatter;
+ (NSDateFormatter *) birthdateFormatter;
+ (NSDateFormatter *) longDateFormatterNoYear;
+ (NSDateFormatter *) shortTimeFormatter;

@end

@interface NSDate (Utilities)

// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;
+ (NSDate *) startOfToday;
+ (NSDate *) startOfTomorrow;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameMonthAsDate: (NSDate *) aDate; 
- (BOOL) isThisMonth;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isEarlierThanOrEqualToDate:(NSDate *)aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanOrEqualToDate:(NSDate *)aDate;
- (BOOL) isBetweenDate: (NSDate *) aDate andDate: (NSDate *) bDate;

// Date roles
- (BOOL) isTypicallyWorkday;
- (BOOL) isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

// Convenience methods for related times
- (NSDate *)beginningOfHour;
- (NSDate *)beginningOfNextHour;
- (NSDate *)endOfHour;
- (NSDate *)beginningOfDay;
- (NSDate *)beginningOfNextDay;
- (NSDate *)endOfDay;
- (NSDate *)beginningOfYesterday;
- (NSDate *)beginningOfTomorrow;
- (NSDate *)beginningOfWeek;
- (NSDate *)endOfWeek;
- (NSDate *)beginningOfMonth;
- (NSDate *)endOfMonth;
- (NSDate *)beginningOfYear;
- (NSDate *)endOfYear;

+ (NSDate *)dateFromISO8601:(NSString *)string;
- (NSString *)ISO8601;

@end
