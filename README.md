# shell 编写的常用开发工具
### wget_img.sh | 图片下载工具
* 使用场景

 我们在抓取网站资源的时候，图片的展示是通过url形式，这个时候我要将图片保存到自己的本地数据库中就可以利用wget命令来高效下载了   
 
### tiny_img.sh | 图片压缩工具
* 使用场景   

 为了减少网络开销让用户获得更好的体验，我们网站上的图片要做相应的压缩来较小图片打大小

### splid_log.sh | 日志分割工具
* 使用场景

 nginx服务器开启日志模式的时候，会在服务端产生日志，这个时候就要定时切割备份日志，避免单个文件达到系统的上线

### diff_mysql.sh | 数据库对比工具
* 使用场景

 开发环境数据库因为改动和测试地址数据库会不一样，所以使用diff去对比结构  

### check_server.sh | 进程检测工具
* 使用场景

 有些进程是常驻在内存中长期提供服务的，比如定时系统，为了保证它能够实时运行要定期检查进程打状态 然后进行相应重启

### web_kpi | 网站kpi统计工具 
* 使用场景

 为了实现日志打实时统计，我们将一个小时内的日志统计结果保存到了redis不同的数据类型中

### data_analyse | 数据格式化工具
* 使用场景

 在多站点情况下，我们为了分析不同站点的不同类型数据（比如购物数据，用户注册数据），我们需要将数据按站点分类后保存到mongodb中，用于数据分析
