# 约束
create table user(
    id int primary key auto_increment comment '主键',
    name varchar(10) not null unique comment '姓名',
    age int check ( age > 0 and age <= 120 ) comment '年龄',
    status char(1) default '1' comment '状态',
    gender char(1) comment '性别'
) comment '用户表';

insert into user(name, age, status, gender) values
    ('Tom1', 19, '1', '男'),
    ('Tom2', 33, '0', '男');

insert into user( name, age, status, gender) values ('Tom3', -109, '1', '男');

select
    *
from
    user a, user b
;

insert into people( name, age) values ('Tom3', 140);

# 准备数据
# 表的外部约束
create table dept(
    id int auto_increment comment 'ID' primary key,
    name varchar(50) not null comment '部门名称'
) comment '部门表';
insert into dept(id, name) values (1, '研发部'), (2, '市场部'), (3, '财务部'),(4,'销售部'),(5,'总经办');

create table emp(
    id int auto_increment  comment 'ID' primary key,
    name varchar(50) not null comment '姓名',
    age int comment '年龄',
    job varchar(20) comment '职位',
    salary int comment '薪资',
    entryDate date comment '入职时间',
    managerId int comment '直属领导ID',
    deptId int comment '部门ID'
)comment '员工表';
# 员工表数据
insert into emp (id, name, age, job, salary, entryDate, managerId, deptId) values
                (1, '金庸',66,'总裁', 20000, '2000-05-01', null, 5),
                (2,'张无忌', 20, '项目经理', 12500, '2005-12-05',1,1),
                (3,'杨逍', 33, '开发', 8400, '2000-11-03',2,1),
                (4,'韦一笑', 48, '开发', 11100, '2002-02-05',2,1),
                (5,'常遇春', 43, '开发', 10500, '2004-09-03',3,1),
                (6,'小昭', 19, '程序员鼓励师', 6400, '2004-10-03',2,1);

# 外键约束
alter table emp add constraint fk_emp_deptId foreign key (deptId) references dept(id);
alter table emp drop foreign key fk_emp_deptId;
alter table emp add constraint fk_emp_deptId foreign key (deptId) references dept(id) on update cascade on delete cascade;
alter table emp add constraint fk_emp_deptId foreign key (deptId) references dept(id) on update set null on delete set null;

# 多对多的关系  学生选课
create table student(
    id int auto_increment primary key comment 'ID',
    name varchar(50) not null comment '姓名',
    no varchar(20) not null comment '学号'
) comment '学生表';
insert into student(name, no) values ('Tom', '1001'), ('Jerry', '1002'), ('Jack', '1003');
create table course(
    id int auto_increment primary key comment 'ID',
    name varchar(50) not null comment '课程名称'
) comment '课程表';
insert into course values (null, 'Java'), (null, 'Python'), (null, 'C++');
create table student_course(
    id int auto_increment primary key comment 'ID',
    studentId int not null comment '学生ID',
    courseId int not null comment '课程ID',
    constraint fk_studentId foreign key (studentId) references student(id),
    constraint fk_courseId foreign key (courseId) references course(id)
) comment '学生选课表';
insert into student_course(studentId, courseId) values (1, 1), (1, 2), (1, 3), (2, 2),(2,3), (3,3);

# 一对一  表的拆分
create table tbUser(
    id int auto_increment primary key comment '主键ID',
    name varchar(50) not null comment '姓名',
    age int comment '年龄'
);
create table tbUserEdu(
    id int auto_increment primary key comment '主键ID',
    userId int unique not null comment '用户ID',
    school varchar(50) not null comment '学校',
    major varchar(50) not null comment '专业',
    constraint fk_userId foreign key (userId) references tbUser(id)
);
insert into tbUser(name, age) values ('Tom', 19), ('Jerry', 20), ('Jack', 21);
insert into tbUserEdu(userId, school, major) values (1, '清华大学', '计算机'), (2, '北京大学', '计算机'), (3, '北京航空航天大学', '计算机');
insert into emp values (null, 'Tommer', 19, '程序员', 10000, '2019-01-01', null, null);
# 多表查询 笛卡尔积存在冗杂信息
select emp.name, dept.name from emp, dept
where emp.deptId = dept.id; # 隐式
select * from emp inner join dept on emp.deptId = dept.id; # 显式
select e.*, d.name from emp e left outer join dept d on e.deptId = d.id; # 左外连接就算有人没部门也能查出来
select e.*, d.name from emp e right join dept d on e.deptId = d.id; # 右外连接就算有部门没人也能查出来

# 单表内连接
select a.name '员工', b.name '领导'
from emp a left join emp b
on a.managerId=b.id

select * from emp a, emp b;

# union 联合查询
select * from emp where salary > 10000
union all
select * from emp where age > 40;

# 合并后去重
select * from emp where salary > 10000
union
select * from emp where age > 40;
# union的限制是列数要相同 字段类型也要相同

# 子查询
# 查询 销售部 员工信息
select * from emp where deptId = (select id from dept where name = '销售部');
# 查询在 韦一笑 之后入职的员工信息
select * from emp where entryDate >= (select entryDate from emp where name = '韦一笑');
select a.* from emp a, emp b
where a.entryDate>b.entryDate and b.name = '韦一笑';
# 列子查询
select id from dept where name = '市场部' or name = '销售部';
select * from emp where deptId in (select id from dept where name = '市场部' or name = '销售部');

# 找到工资比所有财务人员工资都高的员工信息
select id from dept where name = '财务部';
select salary from emp where deptId = (select id from dept where name = '财务部');
select * from emp where salary > all(select salary from emp where deptId = (select id from dept where name = '财务部'));

# 找到比研发部中任意一个人工资高的员工信息
# 同上 all 换成 any 即可   some也可
select * from emp where salary > any(select salary from emp where deptId = (select id from dept where name = '研发部'));

# 行子查询
select salary, managerId from emp where name = '张无忌';
select * from emp where salary = 12500 and managerId = 1;
select * from emp where (salary, managerId) = (12500, 1);
select * from emp where (salary, managerId) = (select salary, managerId from emp where name = '张无忌');

# 表子查询(返回多行多列)
select salary, managerId from emp where name = '张无忌' or name = '小昭';
select * from emp where (salary, managerId) in (select salary, managerId from emp where name = '张无忌' or name = '小昭');

select * from emp where entryDate > '2006-11-11';
select e.*,d.*  from (select * from emp where entryDate > '2006-11-11') e left join dept d
on e.deptId = d.id;  # left join 没部门的也给统计上去了


# 练习
create table salGrade(
    grade int,
    lowSalary int,
    highSalary int
) comment '工资等级表';

insert into salGrade values (1,0,3000), (2,3001, 5000), (3,5001, 8000), (4,8001, 10000), (5,10001, 15000), (6,15001, 20000), (7,20001, 25000), (8,25001, 30000);

# 1 查询员工以及所属部门信息
select * from emp, dept where emp.deptId = dept.id;
select e.name, e.age, d.name from emp e left join dept d on e.deptId = d.id;  # 更好用

# 2 查询年龄大于30的员工以及所属部门信息
select * from emp e left join dept d on e.deptId = d.id where e.age > 30;

# 3 查询有员工的部门
select id, name from dept where id in (select distinct deptId from emp);
select distinct d.id, d.name from emp e inner join dept d where d.id = e.deptId;

# 4 查询所有员工工资等级(内连接 + 笛卡尔积筛选即可)
select s.grade '薪资等级', e.* from emp e cross join  salgrade s where e.salary >= s.lowSalary and e.salary <= s.highSalary;  # 效率更高
select s.grade '薪资等级', e.* from emp e cross join  salgrade s where e.salary between s.lowSalary and s.highSalary;  # 效率更高
# select * from emp, salgrade;

# 5 查询研发部所有员工的信息 以及 工资等级
select t2.grade '工资等级',t1.* from (select * from emp where emp.deptId = (select dept.id from dept where dept.name = '研发部')) t1, salgrade t2
where t1.salary between t2.lowSalary and t2.highSalary;

select t2.grade '工资等级',t1.* from (select * from emp where emp.deptId = (select dept.id from dept where dept.name = '研发部')) t1 cross join salgrade t2
where t1.salary between t2.lowSalary and t2.highSalary;

# 或者直接三个表连在一起玩
select e.*,
       d.name,
       s.grade '工资等级'
from emp e
         cross join
     dept d
         cross join
     salgrade s
where d.name = '研发部'
  and d.id = e.deptId
  and e.salary between s.lowSalary and s.highSalary;

# 6 查询研发部平均工资
select avg(e.salary)
from emp e
        cross join
     dept d
        cross join
     salgrade s
where d.name = '研发部'
  and d.id = e.deptId
  and e.salary between s.lowSalary and s.highSalary;

select avg(e.salary)
from emp e
        cross join
     dept d
where d.name = '研发部'
  and d.id = e.deptId;

# 7 查询工资比 杨逍 高的员工信息
select * from emp where salary > (select salary from emp where name = '杨逍');

# 8 查询比平均工资高的员工信息
select * from emp where salary > (select avg(salary) from emp);

# 9 查询工资高于本部门员工的信息
-- a 查询本部门平均薪资
select avg(salary) from emp where deptId = 1;
-- b
select *, (select avg(e1.salary) from emp e1 where e1.deptId = e2.deptId) '部门平均薪资' from emp e2 where e2.salary > (select avg(e1.salary) from emp e1 where e1.deptId = e2.deptId);

# 10 查询所有部门信息以及部门员工数量
select *, (select count(*) from emp where emp.deptId = dept.id) '员工数量' from dept;

# 11 查询所有学生选课情况, 展示出学生姓名 学号 选的课
select s.name '学生姓名',
       s.no '学生学号',
       c.name '课程'
from student s,
     student_course sc,
     course c
where s.id = sc.studentId
  and c.id = sc.courseId;

# 事务操作
create table account(
    id int primary key auto_increment,
    name varchar(20),
    money double
);
insert into account values (null, '张三', 1000), (null, '李四', 1000);

select @@autocommit;  # 1:自动 0:手动
set autocommit = 0;
set autocommit  = 1;

select * from account where name = '张三';
update account set money = money-1000 where name = '张三';
select * from account where;  # 一个干扰语句 发生故障
update account set money = money+1000 where name = '李四';

commit;
rollback;

# begin start transaction
begin;

# 事务隔离级别
select @@transaction_isolation;  # 查看事务隔离级别
# 设置事务隔离级别
# set [session| global] transaction isolation level [read uncommitted | read committed | repeatable read | serializable];
set session transaction isolation level read uncommitted;

create database blog;
use blog;
CREATE TABLE `blog_tag` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT '' COMMENT '标签名称',
  `created_on` int(10) unsigned DEFAULT '0' COMMENT '创建时间',
  `created_by` varchar(100) DEFAULT '' COMMENT '创建人',
  `modified_on` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  `modified_by` varchar(100) DEFAULT '' COMMENT '修改人',
  `deleted_on` int(10) unsigned DEFAULT '0',
  `state` tinyint(3) unsigned DEFAULT '1' COMMENT '状态 0为禁用、1为启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章标签管理';

CREATE TABLE `blog_article` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` int(10) unsigned DEFAULT '0' COMMENT '标签ID',
  `title` varchar(100) DEFAULT '' COMMENT '文章标题',
  `desc` varchar(255) DEFAULT '' COMMENT '简述',
  `content` text,
  `created_on` int(11) DEFAULT NULL,
  `created_by` varchar(100) DEFAULT '' COMMENT '创建人',
  `modified_on` int(10) unsigned DEFAULT '0' COMMENT '修改时间',
  `modified_by` varchar(255) DEFAULT '' COMMENT '修改人',
  `deleted_on` int(10) unsigned DEFAULT '0',
  `state` tinyint(3) unsigned DEFAULT '1' COMMENT '状态 0为禁用1为启用',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章管理';

CREATE TABLE `blog_auth` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT '' COMMENT '账号',
  `password` varchar(50) DEFAULT '' COMMENT '密码',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `blog`.`blog_auth` (`id`, `username`, `password`) VALUES (null, 'test', 'test123456');