//
//  NSDictionary+MLNKVO.m
//  MLN
//
//  Created by Dai Dongpeng on 2020/3/12.
//

#import "NSDictionary+MLNKVO.h"
#import "NSObject+MLNReflect.h"

@implementation NSDictionary (MLNKVO)

- (NSMutableDictionary *)mln_mutalbeCopy {
    NSMutableDictionary *copy = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (NSString *key in self.allKeys) {
        NSDictionary *value = [self objectForKey:key];
        if ([value respondsToSelector:@selector(mln_mutalbeCopy)]) {
            [copy setObject:value.mln_mutalbeCopy forKey:key];
        } else {
            [copy setObject:value forKey:key];
        }
    }
    return copy;
}

- (NSDictionary *)mln_convertToLuaTableAvailable {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSObject*  _Nonnull obj, BOOL * _Nonnull stop) {
        NSObject *n = [obj mln_convertToLuaObject];
        if (n) {
            [dic setObject:n forKey:key];
        }
    }];
    return dic.count > 0 ? dic.copy : self.copy;
}
@end

@implementation NSMutableDictionary (MLNKVO)

- (NSMutableArray *)mln_allMutableKeys {
    NSMutableArray *keys = [NSMutableArray array];
    for (NSString *key in self.allKeys) {
        NSMutableDictionary *dic = [self objectForKey:key];
        if ([dic isKindOfClass:[NSMutableDictionary class]]) {
            [keys addObject:key];
        }
    }
    return keys;
}

- (NSDictionary *)mln_copy {
    NSMutableArray *keypaths = [self mln_allMutableKeys];
    [keypaths enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = [self valueForKey:key];
        NSAssert([dic isKindOfClass:[NSMutableDictionary class]], @"should be mutable");
        [self setValue:dic.mln_copy forKey:key];
    }];
    
    return self.copy;
}

@end
