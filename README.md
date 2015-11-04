# PrintValue

PrintValue is a library, which can print suitable value of any object, especially perform well in model. you can use it in NSLog and LLDB

----
##Usage
print model in LLDB:

	(lldb) po describe(model)
	(SonModel *){
		string = (NSString *)string
		number = (int)3
		URL = (NSURL *)https://www.baidu.com/
		date = (NSDate *)2015-11-04 08:49:37 +0000
		point = (CGPoint){0, 0}
		size = (CGSize){0, 0}
		vector = (CGVector){0, 0}
		rect = (CGRect){{0, 0}, {0, 0}}
		nsRange = (NSRange){0, 0}
		cfRange = (CFRange){0,0}
		transform = (CGAffineTransform)[0, 0, 0, 0, 0, 0]
		transform3D = (CATransform3D){
			m11 = 0, m12 = 0, m13 = 0, m14 = 0
			m21 = 0, m22 = 0, m23 = 0, m24 = 0
			m31 = 0, m32 = 0, m33 = 0, m34 = 0
			m41 = 0, m42 = 0, m43 = 0, m44 = 0
		}
		offset = (UIOffset){0, 0}
		edge = (UIEdgeInsets){0, 0, 0, 0}
	}
