//
//  EmailCorrect.m
//  EmailCorrect
//
//  Created by Jarod Luebbert on 11/19/11.
//  Copyright (c) 2011 Jarod Luebbert. All rights reserved.
//

#import "EmailCorrect.h"

static EmailCorrect *sharedInstance = nil;

@interface EmailCorrect ()
@property (nonatomic, retain) NSSet *topLevelDomains;
@end

@implementation EmailCorrect

@synthesize topLevelDomains;

#pragma mark -
#pragma mark Singleton methods

// Taken from: http://iphone.galloway.me.uk/iphone-sdktutorials/singleton-classes/
+ (id)sharedInstance
{
    @synchronized(self)
    {
        if(sharedInstance == nil)
            sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX; //denotes an object that cannot be released
}

- (oneway void)release
{
    // never release
}

- (id)autorelease
{
    return self;
}

#pragma mark -
#pragma mark Set up

- (id)init
{
    if ((self = [super init]))
    {
        self.topLevelDomains = [NSSet setWithObjects:@".aero", @".asia", @".biz",
                                @".cat", @".com", @".coop", @".edu", @".gov",
                                @".info", @".int", @".jobs", @".mil", @".mobi",
                                @".museum", @".name", @".net", @".org", @".pro",
                                @".tel", @".travel", @".ac", @".ad", @".ae",
                                @".af", @".ag", @".ai", @".al", @".am", @".an",
                                @".ao", @".aq", @".ar", @".as", @".at", @".au",
                                @".aw", @".ax", @".az", @".ba", @".bb", @".bd",
                                @".be", @".bf", @".bg", @".bh", @".bi", @".bj",
                                @".bm", @".bn", @".bo", @".br", @".bs", @".bt",
                                @".bv", @".bw", @".by", @".bz", @".ca", @".cc",
                                @".cd", @".cf", @".cg", @".ch", @".ci", @".ck",
                                @".cl", @".cm", @".cn", @".co", @".cr", @".cu",
                                @".cv", @".cx", @".cy", @".cz", @".de", @".dj",
                                @".dk", @".dm", @".do", @".dz", @".ec", @".ee",
                                @".eg", @".er", @".es", @".et", @".eu", @".fi",
                                @".fj", @".fk", @".fm", @".fo", @".fr", @".ga",
                                @".gb", @".gd", @".ge", @".gf", @".gg", @".gh",
                                @".gi", @".gl", @".gm", @".gn", @".gp", @".gq",
                                @".gr", @".gs", @".gt", @".gu", @".gw", @".gy",
                                @".hk", @".hm", @".hn", @".hr", @".ht", @".hu",
                                @".id", @".ie", @" No", @".il", @".im", @".in",
                                @".io", @".iq", @".ir", @".is", @".it", @".je",
                                @".jm", @".jo", @".jp", @".ke", @".kg", @".kh",
                                @".ki", @".km", @".kn", @".kp", @".kr", @".kw",
                                @".ky", @".kz", @".la", @".lb", @".lc", @".li",
                                @".lk", @".lr", @".ls", @".lt", @".lu", @".lv",
                                @".ly", @".ma", @".mc", @".md", @".me", @".mg",
                                @".mh", @".mk", @".ml", @".mm", @".mn", @".mo",
                                @".mp", @".mq", @".mr", @".ms", @".mt", @".mu",
                                @".mv", @".mw", @".mx", @".my", @".mz", @".na",
                                @".nc", @".ne", @".nf", @".ng", @".ni", @".nl",
                                @".no", @".np", @".nr", @".nu", @".nz", @".om",
                                @".pa", @".pe", @".pf", @".pg", @".ph", @".pk",
                                @".pl", @".pm", @".pn", @".pr", @".ps", @".pt",
                                @".pw", @".py", @".qa", @".re", @".ro", @".rs",
                                @".ru", @".rw", @".sa", @".sb", @".sc", @".sd",
                                @".se", @".sg", @".sh", @".si", @".sj", @".sk",
                                @".sl", @".sm", @".sn", @".so", @".sr", @".st",
                                @".su", @".sv", @".sy", @".sz", @".tc", @".td",
                                @".tf", @".tg", @".th", @".tj", @".tk", @".tl",
                                @".tm", @".tn", @".to", @".tp", @".tr", @".tt",
                                @".tv", @".tw", @".tz", @".ua", @".ug", @".uk",
                                @".us", @".uy", @".uz", @".va", @".vc", @".ve",
                                @".vg", @".vi", @".vn", @".vu", @".wf", @".ws",
                                @".ye", @".yt", @".za", @".zm", @".zw", nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark Helpers

- (BOOL)isValidEmail:(NSString *)emailAddress;
{
    NSString *regex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}"; 
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; 
    return [test evaluateWithObject:emailAddress];
}

- (BOOL)isValidDomain:(NSString *)topLevelDomain
{
    return [topLevelDomains containsObject:topLevelDomain];
}

- (NSString *)correctionForDomain:(NSString *)invalidDomain
{
    if ([self isValidDomain:invalidDomain])
        return nil;
    NSString *correction = nil;
    int minimumDistance = [invalidDomain length];
    for (NSString *validDomain in [topLevelDomains allObjects])
    {
        int distance = [self similarityBetween:validDomain and:invalidDomain];
        if (distance < minimumDistance)
        {
            correction = validDomain;
            minimumDistance = distance;
        }
    }
    return correction;
}

- (int)similarityBetween:(NSString *)firstDomain and:(NSString *)secondDomain
{
    int distances[[firstDomain length] + 1][[secondDomain length] + 1];
    
    for (int i = 0; i < [firstDomain length] + 1; i++)
        distances[i][0] = i;
    for (int j = 0; j < [secondDomain length] + 1; j++)
        distances[0][j] = j;
    
    for (int j = 1; j < [secondDomain length] + 1; j++)
    {
        for (int i = 1; i < [firstDomain length] + 1; i++)
        {
            NSString *firstLetter = [firstDomain substringWithRange:NSMakeRange(i - 1, 1)];
            NSString *secondLetter = [secondDomain substringWithRange:NSMakeRange(j - 1, 1)];
            if ([firstLetter isEqualToString:secondLetter])
                distances[i][j] = distances[i - 1][j - 1];
            else
            {
                distances[i][j] = MIN(MIN(distances[i - 1][j] + 1,
                                          distances[i][j - 1] + 1),
                                      distances[i - 1][j - 1] + 1);
            }
        }
    }
    
    return distances[[firstDomain length]][[secondDomain length]];
}

- (void)validateEmailAddress:(NSString *)emailAddress
              successHandler:(EmailSuccessHandler)successHandler
                 failHandler:(EmailFailureHandler)failHandler
           correctionHandler:(EmailCorrectionHandler)correctionHandler
{
    if ([self isValidEmail:emailAddress])
    {
        successHandler();
    }
    else
    {
        failHandler();
    }
}

#pragma mark -
#pragma mark Clean up

- (void)dealloc
{
    self.topLevelDomains = nil;
    [super dealloc];
}

@end
