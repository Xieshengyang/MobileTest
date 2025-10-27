# MobileTest
1.实现-个data manager充当booking的数据提供者
	1.1.包含service层，使用的mock data参考booking.json
	1.2.包含本地持久化缓存层
	1.3.假定service层获取的数据有时效性，针对时效性做代码处理
	1.4.支持刷新机制和提供对外统一接口获取数据
		1.4.1 对缓存数据,新数据做合理处理并无缝展示到UI层面上
	1.5.错误处理
2.创建列表页面展示数据,要求该页面每次出现(不一定是首次创建)的时候，调用dataprovider接口展示数据，并在console中打印出对应data
