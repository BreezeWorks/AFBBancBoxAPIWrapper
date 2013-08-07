/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 */

/*
 #import <humor.h> : Not planning to implement: dateByAskingBoyOut and dateByGettingBabysitter
 ----
 General Thanks: sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki. Emanuele Vulcano, jcromartiej, Blagovest Dachev, Matthias Plappert,  Slava Bushtruk, Ali Servet Donmez, Ricardo1980, pip8786, Danny Thuerin, Dennis Madsen
*/

#import "NSDate+Utilities.h"

#import <time.h>
#import <xlocale.h>

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDateFormatter (Utilities)

static locale_t gmtlocale;

+ (void)initialize {
    gmtlocale = newlocale(LC_ALL_MASK, "UTC", NULL);
}


+ (NSDateFormatter *) shortDateFormatter
{
    return [self commonDateFormatterWithFormat:@"EEEE, MMM d, h:mma" amSymbol:@"a" pmSymbol:@"p"];
}

+ (NSDateFormatter *) microDateFormatter
{
    return [self commonDateFormatterWithFormat:@"M/d/yy" amSymbol:@"a" pmSymbol:@"p"];
}

+ (NSDateFormatter *) microDateTimeFormatter
{
    return [self commonDateFormatterWithFormat:@"M/d/yy h:mma" amSymbol:@"a" pmSymbol:@"p"];
}

+ (NSDateFormatter *) microDateTimeFormatterWithAt
{
    return [self commonDateFormatterWithFormat:@"M/d/yy @ h:mma" amSymbol:@"a" pmSymbol:@"p"];
}

+ (NSDateFormatter *) mediumDateFormatter
{
    return [self commonDateFormatterWithFormat:@"EEEE, MMM d, yyyy" amSymbol:nil pmSymbol:nil];
}

+ (NSDateFormatter *) longDateFormatter
{
    return [self commonDateFormatterWithFormat:@"EEEE, MMMM d, yyyy" amSymbol:nil pmSymbol:nil];
}

+ (NSDateFormatter *) birthdateFormatter
{
    return [self commonDateFormatterWithFormat:@"MMMM d, yyyy" amSymbol:nil pmSymbol:nil];
}

+ (NSDateFormatter *) longDateFormatterNoYear
{
    return [self commonDateFormatterWithFormat:@"EEEE, MMMM d" amSymbol:nil pmSymbol:nil];
}

+ (NSDateFormatter *) shortTimeFormatter
{
    return [self commonDateFormatterWithFormat:@"h:mma" amSymbol:@"a" pmSymbol:@"p"];
}

+ (NSDateFormatter *) commonDateFormatterWithFormat:(NSString *)format amSymbol:(NSString *)amSymbol pmSymbol:(NSString *)pmSymbol
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (amSymbol) [dateFormatter setAMSymbol:amSymbol];
    if (pmSymbol) [dateFormatter setPMSymbol:pmSymbol];
    [dateFormatter setDateFormat:format];
    return dateFormatter;
}

@end

@implementation NSDate (Utilities)

#pragma mark Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

+ (NSDate *) startOfToday
{
    return [[NSDate date] beginningOfDay];
}

+ (NSDate *) startOfTomorrow
{
    return [[NSDate date] beginningOfTomorrow];
}

#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) && 
			(components1.day == components2.day));
}

- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if (components1.week != components2.week) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (abs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isSameMonthAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return ((components1.month == components2.month) &&
            (components1.year == components2.year));
}

- (BOOL) isThisMonth
{
    return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return (components1.year == components2.year);
}

- (BOOL) isThisYear
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL) isEarlierThanOrEqualToDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedAscending || [self compare:aDate] == NSOrderedSame);
}

- (BOOL) isLaterThanOrEqualToDate:(NSDate *)aDate
{
    return ([self compare:aDate] == NSOrderedDescending || [self compare:aDate] == NSOrderedSame);
}

- (BOOL) isBetweenDate: (NSDate *) aDate andDate: (NSDate *) bDate
{
    NSDate *earlierDate = [aDate earlierDate:bDate];
    NSDate *laterDate = [aDate laterDate:bDate];
    return ([self isLaterThanDate:earlierDate] && [self isEarlierThanDate:laterDate]);
}

#pragma mark Roles
- (BOOL) isTypicallyWeekend
{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

- (BOOL) isTypicallyWorkday
{
    return ![self isTypicallyWeekend];
}

#pragma mark Adjusting Dates

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
	return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;			
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	components.hour = 0;
	components.minute = 0;
	components.second = 0;
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

#pragma mark Decomposing Dates

- (NSInteger) nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return components.hour;
}

- (NSInteger) hour
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.hour;
}

- (NSInteger) minute
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.minute;
}

- (NSInteger) seconds
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.second;
}

- (NSInteger) day
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.day;
}

- (NSInteger) month
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.month;
}

- (NSInteger) week
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.week;
}

- (NSInteger) weekday
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekday;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekdayOrdinal;
}
- (NSInteger) year
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.year;
}

#pragma mark Convenience methods for related times

// Some sourced from https://github.com/mattt/CupertinoYankee

- (NSDate *)beginningOfHour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfNextHour {
    return [[self beginningOfHour] dateByAddingTimeInterval:D_HOUR];
}

- (NSDate *)endOfHour {
    return [[self beginningOfNextHour] dateByAddingTimeInterval:-1];
}

- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfNextDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    
    return [calendar dateByAddingComponents:components toDate:[self beginningOfDay] options:0];
}

- (NSDate *)endOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    
    return [[calendar dateByAddingComponents:components toDate:[self beginningOfDay] options:0] dateByAddingTimeInterval:-1];
}

- (NSDate *)beginningOfYesterday
{
    return [[NSDate dateYesterday] beginningOfDay];
}

- (NSDate *)beginningOfTomorrow
{
    return [[NSDate dateTomorrow] beginningOfDay];
}

- (NSDate *)beginningOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    NSUInteger offset = ([components weekday] == [calendar firstWeekday]) ? 6 : [components weekday] - 2;
    [components setDay:[components day] - offset];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeek:1];
    
    return [[calendar dateByAddingComponents:components toDate:[self beginningOfWeek] options:0] dateByAddingTimeInterval:-1];}

- (NSDate *)beginningOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:1];
    
    return [[calendar dateByAddingComponents:components toDate:[self beginningOfMonth] options:0] dateByAddingTimeInterval:-1];
}

- (NSDate *)beginningOfYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:1];
    
    return [[calendar dateByAddingComponents:components toDate:[self beginningOfYear] options:0] dateByAddingTimeInterval:-1];
}

+ (NSDate *)dateFromISO8601:(NSString *)string {
    if(!string) return nil;
    if (![string isKindOfClass:[NSString class]]) return nil;
    struct tm time;
    strptime_l([string UTF8String], "%FT%TZ", &time, gmtlocale);
    return [NSDate dateWithTimeIntervalSince1970:timegm(&time)];
}

- (NSString *)ISO8601 {
    struct tm time;
    time_t interval = [self timeIntervalSince1970];
    gmtime_r(&interval, &time);
    char *x = calloc(1, 21);
    strftime_l(x, 20, "%FT%TZ", &time, gmtlocale);
    NSString *string = [NSString stringWithUTF8String:x];
    free(x);
    return string;
}

@end
