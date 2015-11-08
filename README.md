# PrintValue

1. help you show value of object in lldb
2. direct print value in code without convert it to NSString by using NSLog().

----

##version 2.0
1. simplify API, make it use more convenient
	1. `p o()` instead of `p LcPrintObj()`
2. add some method
	1. `p oo()` in lldb to circle print super class's value
	2. `p v()` in lldb to circle print view's subview
	3. `p i()` in lldb to print object's inner, it show ivar, property, method of object
	4. `p ii()` in lldb to circle print super class of object's inner 
	5. `LcPrintViews()` in code to circle print view's subview.


##version 1.1
introduce print any var function from [DeveloperLx/LxDBAnything](https://github.com/DeveloperLx/LxDBAnything)。you can use `LcPrint()` instead of `LcPrintObj()` to print any var in code.  but if you want to print object in LLDB,  you must use `LcPrintObj()`, because `LcPrint()` is macro, which is not supported in LLDB console. and if you want to print basic var(not a NSObject instance) in LLDB, using `p var` direct print it.

##Installation
###Objective-C:

1. Download the PrintValue repository as a zip file or clone it
2. copy `LcPrint` sub-folder into your Xcode project
3. import `LcPrint+LLDB.h` to your .pch file to make it auto completion in lldb

if your project don't have .pch file. don't worry. it's still work without auto-completion

###Swift:

1. Download the PrintValue repository as a zip file or clone it
2. copy `LcPrint` sub-folder into your Xcode project
3. import `LcPrint+LLDB.h` to your bridge-header.h file 

if you want to use method in `LcPrint.h`, also import `LcPrint.h` to your bridge-header.h file 

##Usage
###LLDB

####use `p o()` print object 
this method will print an object's property (and ivar)

	(lldb) p o(model)
	(SonModel *){
		_string = (NSString *)____string
		date = (NSDate *)2015-11-08 13:02:33 +0000
		point = (CFRange)(x = 3.8, y = 4.1)
		array = (NSArray *)[
			(Model *){
				_URL = nil
				number = nil
				set = nil
				dictionary = nil
			}(Model *)
			(Model *){
				_URL = nil
				number = nil
				set = nil
				dictionary = nil
			}(Model *)
		]
	}(SonModel *)

####use `p oo()` print object deeply
this method will circle print object's super class

	(lldb) p oo(model)
	(SonModel *){
		(Model *){
			(FatherModel *){
				size = (CFRange)(width = 1.34, height = 6.24)
				vector = (CFRange)(dx = 0.4, dy = 7.4)
				rect = (CFRange)(
					CGPoint = (x = 0, y = 0.4)
					CGSize  = (width = 8.3, height = 8.1)
				)
				nsRange = (CFRange)(location = 3, length = 4)
				cfRange = (CFRange)(location = 2, length = 6)
				transform = (CFRange)(
					a = 1.3, b = 2.4, c = 4.5, d = 3
					tx = 6, ty = 6.3
				)
				transform3D = (CFRange)(
					m11 = 1, m12 = 0, m13 = 0, m14 = 0
					m21 = 0, m22 = 1, m23 = 0, m24 = 0
					m31 = 0, m32 = 0, m33 = 1, m34 = 0
					m41 = 0, m42 = 0, m43 = 1, m44 = 0
				)
				offset = (CFRange)(horizontal = 5.2, vertical = 2)
				edge = (CFRange)(top = 9.3, left = 3.2, bottom = 2.1, right = 4.5)
			}(FatherModel *)
			_URL = (NSURL *)www.google.com
			number = (double)3.54
			set = (NSSet *)[
				(NSString *)set1
				(NSString *)set2
			]
			dictionary = {
				key:(NSString *)valur
			}
		}(Model *)
		_string = (NSString *)____string
		date = (NSDate *)2015-11-08 13:07:42 +0000
		point = (CFRange)(x = 3.8, y = 4.1)
		array = nil
	}(SonModel *)

####use `p v()` circle print view's subviews
this method will circle print the view's subviews

	(lldb) p v(self.view)
	0 💙	<UIView: 0x7ff0ca723920; frame = (0 0; 375 667); autoresize = W+H; layer = <CALayer: 0x7ff0ca723ca0>>
	1 💙		<UIButton: 0x7ff0ca723d10; frame = (104 393; 46 30); opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x7ff0ca724270>>
	1 💙		<_UILayoutGuide: 0x7ff0ca7259f0; frame = (0 0; 0 0); hidden = YES; layer = <CALayer: 0x7ff0ca725df0>>
	1 💙		<_UILayoutGuide: 0x7ff0ca726b30; frame = (0 0; 0 0); hidden = YES; layer = <CALayer: 0x7ff0ca726cb0>>

####use `p i()` print object's inner
this method will print object's ivar, property, method

	(lldb) p i(model)
	(SonModel *){
		@Ivar{
			_string
			_date
			_array
			_point
		}
		@Property{
			date
			point
			array
		}
		@Method{
			-setIvar
			-sele
			-setArray:
			-.cxx_destruct
			-array
			-date
			-point
			-setDate:
			-setPoint:
		}
	}(SonModel *)

####use `p ii()` circle print object's inner
this method will circle print super class of object

	(lldb) p ii(model)
	(SonModel *){
		(Model *){
			@Ivar{
				_URL
				_number
				_set
				_dictionary
			}
			@Property{
				number
				set
				dictionary
			}
			@Method{
				-setSet:
				-setDictionary:
				-.cxx_destruct
				-set
				-dictionary
				-number
				-setNumber:
			}
		}(Model *)
		@Ivar{
			_string
			_date
			_array
			_point
		}
		@Property{
			date
			point
			array
		}
		@Method{
			-setIvar
			-sele
			-setArray:
			-.cxx_destruct
			-array
			-date
			-point
			-setDate:
			-setPoint:
		}
	}(SonModel *)


###Code
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
	
	ViewController.m, -[ViewController test], Line:35
	❤️(int)1 = (int)1
	ViewController.m, -[ViewController test], Line:36
	❤️(short)1 = (short)1
	ViewController.m, -[ViewController test], Line:37
	❤️(long)1 = (long)1
	ViewController.m, -[ViewController test], Line:38
	❤️(unsigned int)1 = (unsigned int)1
	ViewController.m, -[ViewController test], Line:39
	❤️(unsigned short)1 = (unsigned short)1
	ViewController.m, -[ViewController test], Line:40
	❤️(unsigned long)1 = (unsigned long)1
	ViewController.m, -[ViewController test], Line:41
	❤️(float)1.72 = (float)-2
	ViewController.m, -[ViewController test], Line:42
	❤️(double)1.432 = (double)1.432
	ViewController.m, -[ViewController test], Line:43
	❤️__objc_yes = (BOOL)YES
	ViewController.m, -[ViewController test], Line:44
	❤️(char)'c' = (char)'c'
	ViewController.m, -[ViewController test], Line:45
	❤️(unsigned char)'a' = (unsigned char)'a'
	ViewController.m, -[ViewController test], Line:46
	❤️[self class] = (Class)ViewController   

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
   	   	
    ViewController.m, -[ViewController test], Line:59
	❤️point = (CGPoint)(x = 3.8, y = 4.1)
	ViewController.m, -[ViewController test], Line:60
	❤️size = (CGSize)(width = 8.3, height = 9.9)
	ViewController.m, -[ViewController test], Line:61
	❤️vector = (CGVector)(dx = 0.4, dy = 7.4)
	ViewController.m, -[ViewController test], Line:62
	❤️range = (NSRange)(location = 3, length = 4)
	ViewController.m, -[ViewController test], Line:63
	❤️cfRange = (CFRange)(location = 2, length = 6)
	ViewController.m, -[ViewController test], Line:64
	❤️transform = (CGAffineTransform)(
		a = 1.3, b = 2.4, c = 4.5, d = 3
		tx = 6, ty = 6.3
	)
	ViewController.m, -[ViewController test], Line:65
	❤️transform3D = (CATransform3D)(
		m11 = 1, m12 = 0, m13 = 0, m14 = 0
		m21 = 0, m22 = 1, m23 = 0, m24 = 0
		m31 = 0, m32 = 0, m33 = 1, m34 = 0
		m41 = 0, m42 = 0, m43 = 1, m44 = 0
	)
	ViewController.m, -[ViewController test], Line:66
	❤️offset = (UIOffset)(horizontal = 5.2, vertical = 2)
	ViewController.m, -[ViewController test], Line:67
	❤️insets = (UIEdgeInsets)(top = 9.3, left = 3.2, bottom = 2.1, right = 4.5)
	ViewController.m, -[ViewController test], Line:68
	❤️rect = (CGRect)(
		CGPoint = (x = 0, y = 0.4)
		CGSize  = (width = 8.3, height = 8.1)
	)

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

	ViewController.m, -[ViewController test], Line:89
	❤️model = (Model *){
		size = (CFRange)(width = 8.3, height = 9.9)
		vector = (CFRange)(dx = 0.4, dy = 7.4)
		rect = (CFRange)(
			CGPoint = (x = 0, y = 0.4)
			CGSize  = (width = 8.3, height = 8.1)
		)
		nsRange = (CFRange)(location = 3, length = 4)
		cfRange = (CFRange)(location = 2, length = 6)
		transform = (CFRange)(
			a = 1.3, b = 2.4, c = 4.5, d = 3
			tx = 6, ty = 6.3
		)
		transform3D = (CFRange)(
			m11 = 1, m12 = 0, m13 = 0, m14 = 0
			m21 = 0, m22 = 1, m23 = 0, m24 = 0
			m31 = 0, m32 = 0, m33 = 1, m34 = 0
			m41 = 0, m42 = 0, m43 = 1, m44 = 0
		)
		offset = (CFRange)(horizontal = 5.2, vertical = 2)
		edge = (CFRange)(top = 9.3, left = 3.2, bottom = 2.1, right = 4.5)
		point = (CFRange)(x = 3.8, y = 4.1)
		array = (NSArray *)[
			(NSString *)a
			(NSString *)b
			(NSString *)c
		]
		string = (NSString *)modelString
		URL = (NSURL *)http://www.baidu.com
		date = (NSDate *)2015-11-08 13:53:26 +0000
		number = (double)3.54
		set = (NSSet *)[
			(NSString *)set1
			(NSString *)set2
		]
		dictionary = {
			key:(NSString *)valur
		}
	}(Model *)
###use `p LcPrintViews()` circle print view's subviews
it the same of `p v()` in lldb.

