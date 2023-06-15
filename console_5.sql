create table if not exists tb_user
(
    id     int         null comment '编号',
    name   varchar(50) null comment '姓名',
    age    int         null comment '年龄',
    gender varchar(1)  null comment '性别'
)
    comment '用户表';

create table emp (
    id int comment '编号',
    workNo varchar(10) comment '工号',
    name varchar(10) comment '姓名',
    gender char(1) comment '性别',
    age tinyint unsigned comment '年龄',
    idCard char(18) comment '身份证',
    entryDate date comment '入职时间'
) comment '员工表';

alter table emp add nickName varchar(20) comment '昵称';  # 添加字段

alter table emp change nickName userName varchar(30) comment '用户名';  # 修改字段

alter table emp drop userName;  # 删除字段

alter table emp rename to employee;

alter table employee add workAddress varchar(100) comment '工作地址';

# 为表中指定的字段插入数据
insert into employee(id, workNo, name, gender, age, idCard, entryDate)
values (1, '1', 'ItCast', '男', 10, '123456789012345678', '2018-01-01');

# 为表中所有插入
insert into employee values (2, '2', 'ItCast', '男', 10, '123456789012345678', '2018-01-01');

# update 数据
update employee set name = 'ItHeiMa' where id = 1;
update employee set name = 'XiaoDao', gender = '女' where id = 1;
update employee set entryDate = '2008-1-1' ;


# delete 数据 不能只删除某个字段, 可用update设置为null代替
delete from employee where gender = '女';
delete from employee;

insert into employee
values (1,'1', '小明', '女', 20,'123456789012345678', '2000-01-01'),
       (2, '2', '小红', '女', 20, '123456789012345678', '2000-01-01'),
       (3, '3', '小刚', '男', 20, '123456789012345678', '2000-01-01'),
       (4, '4', '小王', '男', 20, '123456789012345678', '2000-01-01'),
       (5, '5', '小李', '男', 20, '123456789012345678', '2000-01-01'),
       (6, '6', '小张', '男', 20, '123456789012345678', '2000-01-01'),
       (7, '7', '小赵', '男', 20, '123456789012345678', '2000-01-01'),
       (8, '8', '小钱', '男', 20, '123456789012345678', '2000-01-01'),
       (9, '9', '小孙', '男', 20, '123456789012345678', '2000-01-01'),
       (10, '10', '小周', '男', 20, '123456789012345678', '2000-01-01'),
       (11, '11', '小吴', '男', 20, '123456789012345678', '2000-01-01'),
       (12, '12', '小郑', '男', 20, '123456789012345678', '2000-01-01'),
       (13, '13', '小王', '男', 20, '123456789012345678', '2000-01-01'),
       (14, '14', '小冯', '男', 20, '123456789012345678', '2000-01-01'),
       (15, '15', '小陈', '男', 20, '123456789012345678', '2000-01-01'),
       (16, '16', '小褚', '男', 20, '123456789012345678', '2000-01-02');

insert into employee values (17, '17', 'A维', '男', 20, null, '2000-01-02');
select * from employee;

# 基本查询需求
select name,workNo,age from employee;
select * from employee;
select age as '年龄' from employee;
select distinct age '年龄' from employee;

# 条件查询
select * from employee where age = 20;
select * from employee where age < 20;

select * from employee where idCard is null;
select * from employee where idCard is not null;

select * from employee where age >= 15 and age <= 19;
select * from employee where age >= 15 && age <= 19;
select * from employee where age between 15 and 19;

select * from employee where age < 25 and gender = '女';
select * from employee where age = 18 or age = 20 or age = 40;
select * from employee where age in (18, 20 ,40);
show databases ;
use  itcast;
select * from employee where name like '__';  # 查询名字为两个字的员工信息
select * from employee where id like '__';
select * from employee where entryDate like '2000-01-02';
select * from employee where idCard like '%X';

# 聚合函数: 作用于某个或者所有字段
select count(*) from employee;  # 这张表的总数据量
select count(id) from employee; # 有null的会不计入


select avg(age) from employee;  # 平均年龄
select sum(age) from employee;  # 年龄总和
select max(age) from employee;  # 最大年龄
select min(age) from employee;  # 最小年龄
# 所有null的都不计入
select sum(age) from employee where age > 18;  # 年龄大于18的总和

# 分组查询  where 分组前筛选，且不能用聚合函数   having 分组后筛选，可用聚合函数
select gender, count(*) from employee group by gender;
select gender, avg(age) from employee group by gender;
select gender, count(*) from employee where age > 15 group by gender having count(*) > 2;

# 排序查询 order by
select * from employee order by age desc;  # 按年龄降序排列
select * from employee order by age asc;  # 按年龄升序排列  asc 可省略
select * from employee order by age asc , id desc;  # 先按年龄升序排列，年龄相同的按id降序排列

# 分页查询 limit
select * from employee limit 0, 10;
select * from employee limit 10, 10;



# 练习题
select * from employee where gender = '男' and age in (15, 20);
select * from employee where gender = '男' and (age between 15 and 60) and name like '___';
select gender, count(*) from employee where age <= 60 group by gender ;
select name, age from employee where age <= 30 order by age asc , id desc ;
select * from employee where gender = '男' and age between 20 and 40 order by age asc, id asc limit 3;

# 别名 以及 执行顺序
select e.name ename, e.age eage from employee e where e.age > 15 order by eage desc;

# 创建用户
create user 'itcast'@'localhost' identified by 'guo981103';
create user 'heima'@'%' identified by 'guo981103';
alter user 'heima'@'%' identified with mysql_native_password by '123456';
drop user 'itcast'@'localhost';

# DCL
show grants for 'heima'@'%';  # 查看权限
grant all on itcast.* to 'heima'@'%'; # 授权  给黑马 授权 itcast库的权限
revoke all on itcast.* from 'heima'@'%'; # 撤销权限

# 字符串函数
# concat、lower、upper、lpad、rpad、trim、substring
select concat('Hello', 'Mysql');
select lower('Hello');
select upper('Hello');
select lpad('01', 5 ,'A-'); # 左填充
select trim('   Hello Mysql    ');
select substring('Hello World',1,7);
# 练习
update employee set workNo = lpad(workNo, 5, 0);

# 数值函数
# ceil floor mod rand round
select rand();  # 0~1之间的随机数
select round(1.453, 2);  # 保留两位小数
select lpad(round(rand()*1000000,0), 6, '0'); # 生成6位验证码
select substring(rand(),3,6); # 生成6位验证码

# 日期函数
# curdate curtime now year month day date_format datediff(返回两个日期之间的天数)
select curdate();
select curtime();
select now();
select year(now());
select month(now());
select day(now());
select date_add(now(), interval 70 day);
select date_add(now(), interval 70 month );
select date_add(now(), interval 70 year);
select datediff('2019-01-01', '2019-08-07');  # 天数 第一个时间减去第二个时间
# 练习
select name, datediff(now(), entryDate) from employee order by datediff(now(), entryDate) desc limit 1;
select name, datediff(now(), entryDate) as entrydays from employee order by entrydays desc;

# 流程控制函数
select if (true, 'ok', 'error');
select ifnull(null, 'default');

# 练习
select
    name,
    case workAddress when '北京' then '一线城市' when '上海' then '一线城市' else '二线城市' end as '工作地址'
from employee;

# 练习
create table score (
    id int comment 'ID',
    name varchar(20) comment '姓名',
    math int comment '数学',
    english int comment '英语',
    chinese int comment '语文'
) comment '成绩表';
insert into score values (1, '张三', 80, 90, 70),
                         (2, '李四', 60, 70, 80),
                         (3, '王五', 90, 80, 70),
                         (4, '赵六', 70, 80, 90),
                         (5, '田七', 80, 70, 60),
                         (6, '李明', 55, 35, 89),
                         (7, '小红', 60, 70, 80),
                         (8, '小明', 90, 80, 70),
                         (9, '小李', 70, 8, 90),
                         (10, '小张', 8, 70, 60);
select name,
        case when math >= 90 then '优秀' when math >= 80 then '良好' when math >= 60 then '及格' else '不及格' end as '数学',
        case when english >= 90 then '优秀' when english >= 80 then '良好' when english >= 60 then '及格' else '不及格' end as '英语',
        case when chinese >= 90 then '优秀' when chinese >= 80 then '良好' when chinese >= 60 then '及格' else '不及格' end as '语文'
from score;





# test
use itheima;
select * from emp;
select deptId, salary from emp group by deptId l ;


select * from emp where deptId = 1 order by salary desc limit 3;

select