# PrintValue

PrintValue is a library, which can print suitable value of any object, especially perform well in model. you can use it in NSLog and LLDB

----


##version 1.1
introduce print any var function from [DeveloperLx/LxDBAnything](https://github.com/DeveloperLx/LxDBAnything)。you can use `LcPrint()` instead of `LcPrintObj()` to print any var in code.  but if you want to print object in LLDB,  you must use `LcPrintObj()`, because `LcPrint()` is macro, which is not supported in LLDB console. and if you want to print basic var(not a NSObject instance) in LLDB, using `p var` direct print it.

##Usage
###use `LcPrint()` print any var in code
   
print basic type:
  
    LcPrint((int)1);
    LcPrint((short)1);
    LcPrint((long)1);
    LcPrint((unsigned int)1);
    LcPrint((unsigned short)1);
    LcPrint((unsigned long)1);
    LcPrint((float)1.72);
    LcPrint((double)1.432);
    LcPrint(YES);
    LcPrint((char)'c');
    LcPrint((unsigned char)'a');
    LcPrint([self class]);
    
	---------result----------
	
	❤️ViewController.m, -[ViewController test], Line:40
	(int)1 = (int)1
	❤️ViewController.m, -[ViewController test], Line:41
	(short)1 = (short)1
	❤️ViewController.m, -[ViewController test], Line:42
	(long)1 = (long)1
	❤️ViewController.m, -[ViewController test], Line:43
	(unsigned int)1 = (unsigned int)1
	❤️ViewController.m, -[ViewController test], Line:44
	(unsigned short)1 = (unsigned short)1
	❤️ViewController.m, -[ViewController test], Line:45
	(unsigned long)1 = (unsigned long)1
	❤️ViewController.m, -[ViewController test], Line:46
	(float)1.72 = (float)-2
	❤️ViewController.m, -[ViewController test], Line:47
	(double)1.432 = (double)1.432
	❤️ViewController.m, -[ViewController test], Line:48
	__objc_yes = (BOOL)YES
	❤️ViewController.m, -[ViewController test], Line:49
	(char)'c' = (char)'c'
	❤️ViewController.m, -[ViewController test], Line:50
	(unsigned char)'a' = (unsigned char)'a'
	❤️ViewController.m, -[ViewController test], Line:51
	[self class] = (Class)ViewController    

print system struct type:

    CGPoint point = CGPointMake(3.8, 4.1);
    CGSize size = CGSizeMake(8.3, 9.9);
    CGVector vector = CGVectorMake(0.4, 7.4);
    NSRange range = NSMakeRange(3, 4);
    CFRange cfRange = CFRangeMake(2, 6.6);
    CGAffineTransform transform = CGAffineTransformMake(1.3, 2.4, 4.5, 3, 6, 6.3);
    CATransform3D transform3D = CATransform3DIdentity;
    UIOffset offset = UIOffsetMake(5.2, 2);
    UIEdgeInsets insets = UIEdgeInsetsMake(9.3, 3.2, 2.1, 4.5);
    CGRect rect = CGRectMake(0, 0.4, 8.3, 8.1);

    LcPrint(point);
    LcPrint(size);
    LcPrint(vector);
    LcPrint(range);
    LcPrint(cfRange);
    LcPrint(transform);
    LcPrint(transform3D);
    LcPrint(offset);
    LcPrint(insets);
    LcPrint(rect);

   	---------result---------- 
   	   	
    ❤️ViewController.m, -[ViewController test], Line:64
	point = (CGPoint){x = 3.8, y = 4.1}
	❤️ViewController.m, -[ViewController test], Line:65
	size = (CGSize){width = 8.3, height = 9.9}
	❤️ViewController.m, -[ViewController test], Line:66
	vector = (CGVector){dx = 0.4, dy = 7.4}
	❤️ViewController.m, -[ViewController test], Line:67
	range = (NSRange){location = 3, length = 4}
	❤️ViewController.m, -[ViewController test], Line:68
	cfRange = (CFRange){location = 2, length = 6}
	❤️ViewController.m, -[ViewController test], Line:69
	transform = (CGAffineTransform){
		a = 1.3, b = 2.4, c = 4.5, d = 3
		tx = 6, ty = 6.3
	}
	❤️ViewController.m, -[ViewController test], Line:70
	transform3D = (CATransform3D){
		m11 = 1, m12 = 0, m13 = 0, m14 = 0
		m21 = 0, m22 = 1, m23 = 0, m24 = 0
		m31 = 0, m32 = 0, m33 = 1, m34 = 0
		m41 = 0, m42 = 0, m43 = 1, m44 = 0
	}
	❤️ViewController.m, -[ViewController test], Line:71
	offset = (UIOffset){horizontal = 5.2, vertical = 2}
	❤️ViewController.m, -[ViewController test], Line:72
	insets = (UIEdgeInsets){top = 9.3, left = 3.2, bottom = 2.1, right = 4.5}
	❤️ViewController.m, -[ViewController test], Line:73
	rect = (CGRect){
		CGPoint = {x = 0, y = 0.4}
		CGSize  = {width = 8.3, height = 8.1}
	}

print object :
        
    Model *model = [Model new];
    model.string = @"modelString";
    model.number = @(3.54);
    model.URL = [NSURL URLWithString:@"http://www.baidu.com"];
    model.date = [NSDate date];
    model.array = @[@"a",@"b",@"c"];
    model.dictionary = @{@"key":@"valur"};
    model.set = [NSSet setWithObjects:@"set1",@"set2", nil];
    model.point = point;
    model.size = size;
    model.vector = vector;
    model.nsRange = range;
    model.cfRange = cfRange;
    model.transform = transform;
    model.transform3D = transform3D;
    model.offset = offset;
    model.edge = insets;
    model.rect = rect;
    
    LcPrint(model);
   	---------result---------- 

	❤️ViewController.m, -[ViewController test], Line:94
	model = (Model *){
		string = (NSString *)modelString
		number = (double)3.54
		URL = (NSURL *)http://www.baidu.com
		date = (NSDate *)2015-11-06 04:20:46 +0000
		array = (NSArray *)[
			(NSString *)a
			(NSString *)b
			(NSString *)c
		]
		set = (NSSet *)[
			(NSString *)set1
			(NSString *)set2
		]
		dictionary = {
			key:(NSString *)valur
		}
		point = (CGPoint){x = 3.8, y = 4.1}
		size = (CGSize){width = 8.3, height = 9.9}
		vector = (CGVector){dx = 0.4, dy = 7.4}
		rect = (CGRect){
			CGPoint = {x = 0, y = 0.4}
			CGSize  = {width = 8.3, height = 8.1}
		}
		nsRange = (NSRange){location = 3, length = 4}
		cfRange = (CFRange){location = 2, length = 6}
		transform = (CGAffineTransform){
			a = 1.3, b = 2.4, c = 4.5, d = 3
			tx = 6, ty = 6.3
		}
		transform3D = (CATransform3D){
			m11 = 1, m12 = 0, m13 = 0, m14 = 0
			m21 = 0, m22 = 1, m23 = 0, m24 = 0
			m31 = 0, m32 = 0, m33 = 1, m34 = 0
			m41 = 0, m42 = 0, m43 = 1, m44 = 0
		}
		offset = (UIOffset){horizontal = 5.2, vertical = 2}
		edge = (UIEdgeInsets){top = 9.3, left = 3.2, bottom = 2.1, right = 4.5}
	}

###use `p LcPrintObj()` print any Object in LLDB

	(lldb) p LcPrintObj(model)
	(Model *){
		string = (NSString *)modelString
		number = (double)3.54
		URL = (NSURL *)http://www.baidu.com
		date = (NSDate *)2015-11-06 05:00:10 +0000
		array = (NSArray *)[
			(NSString *)a
			(NSString *)b
			(NSString *)c
		]
		set = (NSSet *)[
			(NSString *)set1
			(NSString *)set2
		]
		dictionary = {
			key:(NSString *)valur
		}
		point = (CGPoint){x = 3.8, y = 4.1}
		size = (CGSize){width = 8.3, height = 9.9}
		vector = (CGVector){dx = 0.4, dy = 7.4}
		rect = (CGRect){
			CGPoint = {x = 0, y = 0.4}
			CGSize  = {width = 8.3, height = 8.1}
		}
		nsRange = (NSRange){location = 3, length = 4}
		cfRange = (CFRange){location = 2, length = 6}
		transform = (CGAffineTransform){
			a = 1.3, b = 2.4, c = 4.5, d = 3
			tx = 6, ty = 6.3
		}
		transform3D = (CATransform3D){
			m11 = 1, m12 = 0, m13 = 0, m14 = 0
			m21 = 0, m22 = 1, m23 = 0, m24 = 0
			m31 = 0, m32 = 0, m33 = 1, m34 = 0
			m41 = 0, m42 = 0, m43 = 1, m44 = 0
		}
		offset = (UIOffset){horizontal = 5.2, vertical = 2}
		edge = (UIEdgeInsets){top = 9.3, left = 3.2, bottom = 2.1, right = 4.5}
	}


