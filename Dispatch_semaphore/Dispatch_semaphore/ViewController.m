//
//  ViewController.m
//  Dispatch_semaphore
//
//  Created by WindyCheng on 2018/11/23.
//  Copyright © 2018年 WindyCheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    理解这个概念之前，先抛出一个问题
//
//    问题描述：
//
//    假设现在系统有两个空闲资源可以被利用，但同一时间却有三个线程要进行访问，这种情况下，该如何处理呢？
//
//    或者
//
//    我们要下载很多图片，并发异步进行，每个下载都会开辟一个新线程，可是我们又担心太多线程肯定cpu吃不消，那么我们这里也可以用信号量控制一下最大开辟线程数。
//
    
 /*   定义：
    
    1、信号量：就是一种可用来控制访问资源的数量的标识，设定了一个信号量，在线程访问之前，加上信号量的处理，则可告知系统按照我们指定的信号量数量来执行多个线程。
    
    其实，这有点类似锁机制了，只不过信号量都是系统帮助我们处理了，我们只需要在执行线程之前，设定一个信号量值，并且在使用时，加上信号量处理方法就行了。*/
    
   // 2、信号量主要有3个函数，分别是：
    
    //创建信号量，参数：信号量的初值，如果小于0则会返回NULL
//    dispatch_semaphore_create（信号量值）
//
//    //等待降低信号量
//    dispatch_semaphore_wait（信号量，等待时间）
//
//    //提高信号量
//    dispatch_semaphore_signal(信号量)
//
//
//    注意，正常的使用顺序是先降低然后再提高，这两个函数通常成对使用。　（具体可参考下面的代码示例）
    

    [self dispatchSignal2];
   
}



//3、那么就开头提的问题，我们用代码来解决

-(void)dispatchSignal{
    //crate的value表示，最多几个资源可访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);
    });
    //任务2
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    //任务3
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
}


//总结：由于设定的信号值为2，先执行两个线程，等执行完一个，才会继续执行下一个，保证同一时间执行的线程数不超过2。
//2018-11-23 14:31:49.482721+0800 Dispatch_semaphore[74707:6661771] run task 1
//2018-11-23 14:31:49.482721+0800 Dispatch_semaphore[74707:6661769] run task 2
//2018-11-23 14:31:50.487168+0800 Dispatch_semaphore[74707:6661769] complete task 2
//2018-11-23 14:31:50.487189+0800 Dispatch_semaphore[74707:6661771] complete task 1
//2018-11-23 14:31:50.487428+0800 Dispatch_semaphore[74707:6661770] run task 3
//2018-11-23 14:31:51.492027+0800 Dispatch_semaphore[74707:6661770] complete task 3

-(void)dispatchSignal1{
    //crate的value表示，最多几个资源可访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);
    });
    //任务2
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    //任务3
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
}

//一次只能执行一个，只能一个接一个
//2018-11-23 14:34:20.143791+0800 Dispatch_semaphore[74780:6672688] run task 1
//2018-11-23 14:34:21.147842+0800 Dispatch_semaphore[74780:6672688] complete task 1
//2018-11-23 14:34:21.148104+0800 Dispatch_semaphore[74780:6672686] run task 2
//2018-11-23 14:34:22.150604+0800 Dispatch_semaphore[74780:6672686] complete task 2
//2018-11-23 14:34:22.150804+0800 Dispatch_semaphore[74780:6672687] run task 3
//2018-11-23 14:34:23.154009+0800 Dispatch_semaphore[74780:6672687] complete task 3


-(void)dispatchSignal2{
    //crate的value表示，最多几个资源可访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);
    });
    //任务2
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    //任务3
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
}

//其实设定为3，就是不限制线程执行了，因为一共才只有3个线程。
//2018-11-23 14:36:20.496126+0800 Dispatch_semaphore[74831:6680645] run task 1
//2018-11-23 14:36:20.496126+0800 Dispatch_semaphore[74831:6680644] run task 3
//2018-11-23 14:36:20.496135+0800 Dispatch_semaphore[74831:6680641] run task 2
//2018-11-23 14:36:21.497426+0800 Dispatch_semaphore[74831:6680644] complete task 3
//2018-11-23 14:36:21.497446+0800 Dispatch_semaphore[74831:6680641] complete task 2
//2018-11-23 14:36:21.497451+0800 Dispatch_semaphore[74831:6680645] complete task 1


//接下来我解释一下多网络请求信号量理解：
- (void)dispatchSignalMutil{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
//    [MBProgressHUD showMessage:@"加载中..."];
    
    dispatch_group_async(group, queue, ^{
   
        
        //网络请求1
//        NSString * urlStr = [HSTools Joint:URL_GUBRIIR];
//        NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
//        parameter[@"region_id"] = [NSNumber numberWithInt:region_id];
//        parameter[@"property_id"] = [NSNumber numberWithInt:self.property_id];
//        parameter[@"m_or_d_type"] = _isDate?[NSNumber numberWithInt:0]:[NSNumber numberWithInt:1];
//
//        [JSCHttpTool GET:urlStr parameters:parameter success:^(id responseObject) {
//            [MBProgressHUD hideHUD];
//            if ([[responseObject objectForKey:@"code"]integerValue] == 1) {
//
//                dispatch_semaphore_signal(semaphore);//a
//
//                for (NSDictionary *dict in responseObject[@"units"]) {
//                    FormUnitModel *model = [FormUnitModel FormUnitModelWithdict:dict];
//                    [self.unitdataSource addObject:model];
//                }
//
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD hideHUD];
//        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//1
        
    });
    dispatch_group_async(group, queue, ^{
        
        
       //网络请求2
//        NSString * urlStr = [HSTools Joint:URL_GOUIR];
//        NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
//        parameter[@"property_id"] = [NSNumber numberWithInt:self.property_id];
//        parameter[@"m_or_d_type"] = _isDate?[NSNumber numberWithInt:0]:[NSNumber numberWithInt:1];
//
//        [JSCHttpTool GET:urlStr parameters:parameter success:^(id responseObject) {
//            [MBProgressHUD hideHUD];
//            if ([[responseObject objectForKey:@"code"]integerValue] == 1) {
//                dispatch_semaphore_signal(semaphore);//b
//                for (NSDictionary *dict in responseObject[@"units"]) {
//                    FormUnitModel *model = [FormUnitModel FormUnitModelWithdict:dict];
//                    [self.unitdataSource addObject:model];
//                }
//
//            }
//        } failure:^(NSError *error) {
//            [MBProgressHUD hideHUD];
//        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//2
        
    });
    
    //刷新UI
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"dispatch_group_notify");
//        [MBProgressHUD hideHUD];
        
    });
    //这里我标记1,2和a,b来说明，首先我们将信号量总数设置为0，为什么呢？因为这个和上一个不一样。首先程序进来，异步并发，1和2同时走到，但是发现信号量为0，所以1和2都不会执行。这时候group也就都没有走完，因此也不会走notify，等有一个网络请求成功之后，假设第一个先成功了，那么a处发送一个信号量，给信号量总数＋1，那么这时候信号量总数为1，这是1和2处会有且只能有一个开始走线程，假设为1，那么也就是相当于第一个网络请求和group组任务一执行完了，但是这时候如果1执行了，那么又回让信号量－1，这时候信号量又为0，2处代码还是不能执行，因此group依然不能走notify，等待第二个网络请求成功了，这时候b处发送一个信号量，给信号量总数＋1，信号量总数为1，那么2处开始执行代码，到此时，正好group全部执行完，开始走notify。
    //这里还提醒大家一点，调试的时候千万别看semaphore的value，如果我们看value，会发现其实不是这样，1和2处好像全部都执行了，value值为－2，但是group组不算执行，当有一个网络请求成功之后value值为－1，开始执行一个组方法完毕，可是按照信号量解释，为0或者小于0都不能执行的，反正越看越混淆。当然大神有深入了解的随便了。
    
    
    
}



@end
