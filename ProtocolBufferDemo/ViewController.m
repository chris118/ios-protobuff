//
//  ViewController.m
//  ProtocolBufferDemo
//
//  Created by xiaopeng on 2017/6/5.
//  Copyright © 2017年 putao. All rights reserved.
//

#import "ViewController.h"
#import "Person.pbobjc.h"  //模型

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *info_lb;
@property (nonatomic, strong) NSData *myData; //数据

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)serialize:(id)sender {
    // 创建对象
    Person *per = [[Person alloc] init];
    per.name = @"王大锤";
    per.age = 18;
    per.deviceType = Person_DeviceType_Ios;
    
    //对象数组属性：Person_Result
    Person_Result *result1 = [[Person_Result alloc] init];
    result1.title = @"百度";
    result1.URL = @"http://baidu.com";
    
    Person_Result *result2 = [[Person_Result alloc] init];
    result2.title = @"博客园";
    result2.URL = @"http://cnblogs.com";
    
    [per.resultsArray addObjectsFromArray:@[result1, result2]]; //将对象添加到数组中
    
    //对象数组属性：Ani
    Animal *an1 = [[Animal alloc] init];
    an1.weight = 80;
    an1.price = 1000;
    an1.namme = @"小狗";
    
    [per.animalsArray addObject:an1];
    
    //对象序列化：存储或传递
    NSData *data = [per delimitedData];
    self.myData = data;
    
    self.info_lb.text = @"数据序列化成功！";
    
}
- (IBAction)deserialize:(id)sender {
    //二进制数据反序列化为对象
    GPBCodedInputStream *inputStream = [GPBCodedInputStream streamWithData:self.myData];
    
    NSError *error;
    Person *per = [Person parseDelimitedFromCodedInputStream:inputStream extensionRegistry:nil error:&error];
    
    if (error){
        self.info_lb.text = @"解析数据失败！";
        return;
    }
    
    //展示数据
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:@"二进制数据反序列化为对象\n"];
    [str appendFormat:@"name: %@, age: %d \n", per.name, per.age];
    
    for (Person_Result *item in per.resultsArray) {
        [str appendFormat:@"result.title: %@, result.url: %@\n", item.title, item.URL];
    }
    
    for (Animal *item in per.animalsArray) {
        [str appendFormat:@"animal.name: %@, animal.price: %.2f, animal.weight: %.2f\n", item.namme, item.price, item.weight];
    }
    
    self.info_lb.text = str;
}

@end
